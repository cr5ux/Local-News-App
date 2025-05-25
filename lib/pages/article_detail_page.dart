import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:video_player/video_player.dart';
import 'package:localnewsapp/pages/comments_page.dart';
import 'package:localnewsapp/dataAccess/comment_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/ls.dart';

class ArticleDetailPage extends StatefulWidget {
  final Document document;

  const ArticleDetailPage({super.key, required this.document});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late VideoPlayerController _controller;
  bool _isVideo = false;
  int _commentCount = 0;
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.document.documentType.toLowerCase() == 'video';
    if (_isVideo && widget.document.documentPath.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.document.documentPath[0]),
      )..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
    _fetchCommentCount();
    _checkLikeStatus();
    _fetchLikeCount();
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _checkLikeStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && widget.document.documentID != null) {
      try {
        final liked = await DocumentRepo()
            .hasUserLikedDocument(widget.document.documentID!, currentUser.uid);
        setState(() {
          _isLiked = liked;
        });
      } catch (e) {
        // Optionally handle error display
      }
    }
  }

  Future<void> _fetchCommentCount() async {
    if (widget.document.documentID != null) {
      try {
        final comments = await CommentRepo()
            .getCommentByDocumentID(widget.document.documentID!);
        setState(() {
          _commentCount = comments.length;
        });
      } catch (e) {
        setState(() {
          _commentCount = 0;
        });
      }
    }
  }

  Future<void> _fetchLikeCount() async {
    if (widget.document.documentID != null) {
      try {
        final likes =
            await DocumentRepo().getDocumentLikes(widget.document.documentID!);
        setState(() {
          _likeCount = likes.length;
        });
      } catch (e) {
        setState(() {
          _likeCount = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Bookmark icon
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              // Implement bookmark functionality here
            },
          ),
          // Share icon
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Implement share functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isVideo && widget.document.documentPath.isNotEmpty)
              // Video Player
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      // Placeholder while video is loading/initializing
                      height: 250,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    )
            else
              // Placeholder image from Unsplash if no documentPath for non-video
              Image.network(
                'https://source.unsplash.com/random/800x400', // Placeholder Unsplash image
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(child: Text('Image not available')),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.document.documentType,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.document.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.document.registrationDate,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  if (widget.document.content != null)
                    Text(
                      widget.document.content!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: widget.document.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.grey[200],
                              labelStyle:
                                  const TextStyle(color: Colors.black54),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // Add the divider and interaction section here
            const Divider(height: 1), // Divider
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Like section (Icon and Count)
                  TextButton.icon(
                    onPressed: () async {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) {
                        return;
                      }

                      if (widget.document.documentID != null) {
                        try {
                          if (_isLiked) {
                            // If already liked, unlike it
                            await DocumentRepo().updateDocumentLike(
                                widget.document.documentID!, currentUser.uid);
                            setState(() {
                              _isLiked = false;
                              _likeCount--;
                            });
                          } else {
                            // If not liked, like it
                            final ls = LS(
                                userID: currentUser.uid,
                                date: DateTime.now().toIso8601String());
                            await DocumentRepo()
                                .addALike(widget.document.documentID!, ls);
                            setState(() {
                              _isLiked = true;
                              _likeCount++;
                            });
                          }
                          _fetchLikeCount(); // Update like count after like/unlike
                        } catch (e) {
                          // Optionally show a snackbar or other feedback
                        }
                      }
                    },
                    icon: Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                        color: _isLiked
                            ? Colors.blue
                            : Colors.black), // Change color when liked
                    label: Text(
                      '$_likeCount', // Display like count
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54), // Adjust color
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54, // Text and icon color
                    ),
                  ),
                  const Spacer(), // Push comments to the right
                  // Comments section
                  TextButton.icon(
                    // Use TextButton.icon for icon and text together
                    onPressed: () {
                      // Navigate to CommentsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(
                              documentID: widget
                                  .document.documentID!), // Pass documentID
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: Colors.black54), // Comment icon
                    label: Text(
                      '$_commentCount Comments',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54), // Adjust color as needed
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54, // Text and icon color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isVideo && _controller.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
