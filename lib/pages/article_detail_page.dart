import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/singleton/identification.dart';
import 'package:video_player/video_player.dart';
import 'package:localnewsapp/pages/comments_page.dart';
import 'package:localnewsapp/dataAccess/comment_repo.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/ls.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:localnewsapp/constants/categories.dart';
import 'package:share_plus/share_plus.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';

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
  bool _isBookmarked = false;
  int _likeCount = 0;
  final currentUser = Identification().userID;
  List<Document> _relatedArticles = [];
  String _authorName = '';
  String? _authorProfilePic;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.document.documentType.toLowerCase() == 'video';
    if (_isVideo && widget.document.documentPath.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.document.documentPath[0]),
      )..initialize().then((_) {
          setState(() {});
        });
    }
    _fetchCommentCount();
    _checkLikeStatus();
    _checkBookmarkStatus();
    _fetchLikeCount();
    _fetchRelatedArticles();
    _fetchAuthorInfo();
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _checkLikeStatus() async {
    if (widget.document.documentID != null) {
      try {
        final liked = await DocumentRepo()
            .hasUserLikedDocument(widget.document.documentID!, currentUser);
        setState(() {
          _isLiked = liked;
        });
      } catch (e) {
        // Optionally handle error display
      }
    }
  }

  Future<void> _checkBookmarkStatus() async {
    if (widget.document.documentID != null) {
      try {
        final bookmarks =
            await DocumentRepo().getDocumentBookmarksByAUser(currentUser);
        setState(() {
          _isBookmarked = bookmarks
              .any((doc) => doc.documentID == widget.document.documentID);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to check bookmark status'),
              duration: Duration(seconds: 2),
            ),
          );
        }
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
        if (mounted) {
          setState(() {
            _likeCount = likes.length;
          });
        }
      } catch (e) {
        // Don't update the state if there's an error fetching likes
        // This ensures we keep the previous count until we can successfully fetch
      }
    }
  }

  Future<void> _fetchRelatedArticles() async {
    if (widget.document.tags.isEmpty) return;

    try {
      final allArticles = await DocumentRepo().getAllDocuments();
      final relatedArticles = allArticles.where((article) {
        // Exclude current article and check for matching tags
        return article.documentID != widget.document.documentID &&
            article.tags.any((tag) => widget.document.tags.contains(tag));
      }).toList();

      // Sort by number of matching tags and take top 3
      relatedArticles.sort((a, b) {
        final aMatches =
            a.tags.where((tag) => widget.document.tags.contains(tag)).length;
        final bMatches =
            b.tags.where((tag) => widget.document.tags.contains(tag)).length;
        return bMatches.compareTo(aMatches);
      });

      setState(() {
        _relatedArticles = relatedArticles.take(3).toList();
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _fetchAuthorInfo() async {
    try {
      final user = await UsersRepo().getAUserByID(widget.document.authorID);
      if (mounted) {
        setState(() {
          _authorName = user.fullName;
          _authorProfilePic = user.profileImagePath;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Widget _buildRelatedArticles() {
    if (_relatedArticles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Related Articles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _relatedArticles.length,
            itemBuilder: (context, index) {
              final article = _relatedArticles[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(document: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.coverImagePath != null)
                          Image.network(
                            article.coverImagePath!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article.tags.join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper to get the category image URL based on the first tag
  // String? _getCategoryImageUrl() {
  //   if (widget.document.tags.isNotEmpty) {
  //     final firstTag = widget.document.tags[0];
  //     return NewsCategories.categoryImages[firstTag];
  //   }
  //   return null; // Return null if no tags or tag not found in map
  // }

  // New method for sharing the article
  Future<void> _shareArticle(BuildContext context) async {
    String shareText = widget.document.title;
    if (widget.document.content != null &&
        widget.document.content!.isNotEmpty) {
      shareText += '\n\n${widget.document.content!}';
    }

    String? articleUrl;
    if (widget.document.documentPath.isNotEmpty &&
        Uri.tryParse(widget.document.documentPath[0])?.isAbsolute == true) {
      articleUrl = widget.document.documentPath[0];
      shareText += '\n\nRead more at: $articleUrl';
    }

    final box = context.findRenderObject() as RenderBox?;

    // Perform the share operation
    final result = await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: widget.document.title,
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      ),
    );

    // Check the share status
    if (result.status == ShareResultStatus.success) {
      if (widget.document.documentID != null) {
        try {
          final ls = LS(
            userID: currentUser,
            date: DateTime.now().toIso8601String(),
          );
          await DocumentRepo().addAShare(widget.document.documentID!, ls);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('share_success_message'.tr())),
          );
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('share_db_error'.tr())),
          );
        }
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (widget.document.documentID != null) {
      try {
        if (_isBookmarked) {
          // If already bookmarked, remove bookmark
          await DocumentRepo()
              .removeBookmark(widget.document.documentID!, currentUser);
          setState(() {
            _isBookmarked = false;
          });
        } else {
          // If not bookmarked, add bookmark
          final ls = LS(
            userID: currentUser,
            date: DateTime.now().toIso8601String(),
          );
          await DocumentRepo().addABookmark(widget.document.documentID!, ls);
          setState(() {
            _isBookmarked = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update bookmark status'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logow.png', // Replace with your logo asset
              height: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              _shareArticle(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Display Section (Video Player or Image)
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
            else if (widget.document.documentType.toLowerCase() == 'text' &&
                widget.document.tags
                    .isNotEmpty) // Handle text type with category image
              Builder(
                builder: (context) {
                  // final imageUrl = _getCategoryImageUrl();
                  if (widget.document.coverImagePath != null) {
                    return Image.network(
                      widget.document.coverImagePath!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.article_outlined,
                              size: 48,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  // Fallback if image URL is null (tag not found in map)
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              )
            else if (widget.document.documentPath
                .isNotEmpty) // Handle cases with documentPath but not video
              Image.network(
                widget.document.documentPath[0],
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
              )
            else
              // Default fallback if no video, no text with category image, and no documentPath
              Container(
                height: 250,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.article_outlined,
                    size: 48,
                    color: Colors.black54,
                  ),
                ),
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
                  // Author information
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _authorProfilePic != null
                            ? NetworkImage(_authorProfilePic!)
                            : null,
                        child: _authorProfilePic == null
                            ? const Icon(Icons.person,
                                size: 20, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _authorName.isNotEmpty ? _authorName : 'Unknown Author',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Display formatted date
                  Text(
                    DateFormat('EEE, MMM d, yyyy').format(
                        DateTime.parse(widget.document.registrationDate)),
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
                      if (widget.document.documentID != null) {
                        try {
                          if (_isLiked) {
                            // If already liked, unlike it
                            await DocumentRepo().updateDocumentLike(
                                widget.document.documentID!, currentUser);
                            setState(() {
                              _isLiked = false;
                              _likeCount--;
                            });
                          } else {
                            // If not liked, like it
                            final ls = LS(
                                userID: currentUser,
                                date: DateTime.now().toIso8601String());
                            await DocumentRepo()
                                .addALike(widget.document.documentID!, ls);
                            setState(() {
                              _isLiked = true;
                              _likeCount++;
                            });
                          }
                        } catch (e) {
                          // Show error feedback
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to update like status'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
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
            // Divider after like and comment section
            const Divider(height: 1),
            // Read More Section
            if (widget.document.documentPath.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'reference'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Iterate through document paths and create links
                    for (var path in widget.document.documentPath)
                      GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse(path.toString());
                          if (!await launchUrl(url)) {
                            // Handle error, perhaps show a snackbar
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not launch $url')),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            path.toString(), // Display the path as text
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue, // Link color
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            _buildRelatedArticles(),
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
