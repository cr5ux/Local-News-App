import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/dto/user_basic.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/pages/article_detail_page.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart'; // Import DocumentRepo
import 'package:localnewsapp/dataAccess/model/ls.dart'; // Import LS model
import 'package:localnewsapp/dataAccess/users_repo.dart'; // Import UsersRepo
import 'package:localnewsapp/singleton/identification.dart';
// import 'package:localnewsapp/dataAccess/model/users.dart'; // Import Users model
import 'package:video_thumbnail/video_thumbnail.dart'; // Import video_thumbnail
import 'dart:typed_data'; // Import Uint8List
// import 'package:localnewsapp/constants/categories.dart';
import 'package:easy_localization/easy_localization.dart'; // Import EasyLocalization for translations

class ArticleCard extends StatefulWidget {
  final Document document;

  const ArticleCard({super.key, required this.document});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isBookmarked = false;
  final DocumentRepo _documentRepo = DocumentRepo();
  final String _currentUser = Identification().userID;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    if (widget.document.documentID != null) {
      try {
        final bookmarks =
            await _documentRepo.getDocumentBookmarksByAUser(_currentUser);
        setState(() {
          _isBookmarked = bookmarks
              .any((doc) => doc.documentID == widget.document.documentID);
        });
      } catch (e) {
        // Handle error silently
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (widget.document.documentID != null) {
      try {
        if (_isBookmarked) {
          await _documentRepo.removeBookmark(
              widget.document.documentID!, _currentUser);
        } else {
          final ls = LS(
            userID: _currentUser,
            date: DateTime.now().toIso8601String(),
          );
          await _documentRepo.addABookmark(widget.document.documentID!, ls);
        }
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
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

  String _getContentPreview() {
    if (widget.document.content == null || widget.document.content!.isEmpty) {
      return 'no_content'.tr();
    }
    // Get first 150 characters and add ellipsis
    return widget.document.content!.length > 150
        ? '${widget.document.content!.substring(0, 150)}...'
        : widget.document.content!;
  }

  // Placeholder for estimating read time (e.g., 200 words per minute)
  String _estimateReadTime() {
    // print(widget.document.content); // Keep this for debugging content
    if (widget.document.content == null || widget.document.content!.isEmpty) {
      return '';
    }
    const wordsPerMinute = 200;
    final wordCount = widget.document.content!.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / wordsPerMinute).ceil();
    return '$minutes min read';
  }

  // Actual logic to get view count from DocumentRepo
  Future<int> _getViewCount(String documentId) async {
    try {
      final views = await _documentRepo.getDocumentView(documentId);
      return views.length;
    } catch (e) {
      return 0; // Return 0 or handle error appropriately
    }
  }

  // Logic to get author name from UsersRepo
  Future<String> _getAuthorName(String authorId) async {
    if (authorId.isEmpty) {
      return 'unknown_author'.tr();
    }
    final UsersRepo usersRepo = UsersRepo();
    try {
      UsersBasic? user = await usersRepo.getAUserByID(authorId);

      if (user.fullName.isNotEmpty) {
        return user.fullName;
      } else {
        return 'unknown_author'.tr();
      }
    } catch (e) {
      return 'unknown_author'.tr(); // Return a default name in case of error
    }
  }

  // Placeholder for time ago (using registrationDate for now)
  String _getTimeAgo() {
    try {
      final DateTime date = DateTime.parse(widget.document.registrationDate);
      final Duration diff = DateTime.now().difference(date);

      if (diff.inDays > 365) {
        return (diff.inDays / 365).floor().toString() + 'years_ago'.tr();
      } else if (diff.inDays > 30) {
        return (diff.inDays / 30).floor().toString() + 'months_ago'.tr();
      } else if (diff.inDays > 7) {
        return (diff.inDays / 7).floor().toString() + 'weeks_ago'.tr();
      } else if (diff.inDays > 0) {
        return diff.inDays.toString() + 'days_ago'.tr();
      } else if (diff.inHours > 0) {
        return diff.inHours.toString() + 'hours_ago'.tr();
      } else if (diff.inMinutes > 0) {
        return diff.inMinutes.toString() + 'minutes_ago'.tr();
      } else {
        return 'just_now'.tr();
      }
    } catch (e) {
      return widget
          .document.registrationDate; // Fallback to raw date if parsing fails
    }
  }

  // Helper to get the category image URL based on the first tag
  // String? _getCategoryImageUrl() {
  //   if (widget.document.tags.isNotEmpty) {
  //     final firstTag = widget.document.tags[0];
  //     return NewsCategories.categoryImages[firstTag];
  //   }
  //   return null; // Return null if no tags or tag not found in map
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to article detail page
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(document: widget.document),
          ),
        );
        // Add view after navigating (fire and forget)
        if (widget.document.documentID != null) {
          try {
            // Get current user ID
            final LS view = LS(
              userID: _currentUser,
              date: DateTime.now().toIso8601String(),
            );
            _documentRepo.addAView(widget.document.documentID!, view);
          } catch (e) {
            // Handle error silently
          }
        }
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias, // Clip content to rounded corners
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Video Preview Section with Category Overlay
            if (widget.document.documentPath.isNotEmpty ||
                (widget.document.documentType.toLowerCase() == 'text' &&
                    widget.document.tags.isNotEmpty &&
                     widget.document.coverImagePath != null)) //_getCategoryImageUrl()
              Stack(
                children: [
                  if (widget.document.documentType.toLowerCase() == 'video')
                    FutureBuilder<Uint8List?>(
                      future: VideoThumbnail.thumbnailData(
                        video: widget.document.documentPath[0],
                        imageFormat: ImageFormat.JPEG,
                        quality: 50,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.videocam_off,
                                size: 48,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    )
                  else if (widget.document.documentType.toLowerCase() ==
                          'text' &&
                      widget.document.tags.isNotEmpty)
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
                        return Container(
                          height: 200,
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
                  else if (widget.document.documentPath.isNotEmpty)
                    Image.network(
                      widget.document.documentPath[0],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child:
                              const Center(child: Text('Image not available')),
                        );
                      },
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.document.tags.isNotEmpty
                            ? widget.document.tags[0]
                            : widget.document.documentType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Add play button overlay for video type
                  if (widget.document.documentType.toLowerCase() == 'video')
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            // Text Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Bookmark Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.document.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: _isBookmarked ? Colors.blue : Colors.grey,
                        ),
                        onPressed: _toggleBookmark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Spacing below title

                  // Content Preview
                  Text(
                    _getContentPreview(), // Use content preview
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12), // Spacing below content preview

                  // Additional Info Row (Source, Read Time, Views, Date)
                  Row(
                    children: [
                      // Source/Author (using authorID as placeholder for now)
                      if (widget.document.authorID.isNotEmpty)
                        FutureBuilder<String>(
                          future: _getAuthorName(
                              widget.document.authorID), // Call async method
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth:
                                          2)); // Show loading indicator
                            }
                            if (snapshot.hasError) {
                              return Text('error'.tr(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red)); // Show error
                            }
                            // Display author name when available
                            return Text(
                              snapshot.data ??
                                  'unknown_author'
                                      .tr(), // Display name or default
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        )
                      else
                        Text('unknown_author'.tr(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500)),

                      const SizedBox(width: 12), // Spacing

                      // Read Time
                      const Icon(Icons.timer,
                          size: 14, color: Colors.black54), // Timer icon
                      const SizedBox(width: 4), // Spacing
                      Text(
                        _estimateReadTime(), // Estimated read time
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12), // Spacing

                      // Views
                      const Icon(Icons.visibility,
                          size: 14, color: Colors.black54), // Visibility icon
                      const SizedBox(width: 4), // Spacing
                      // Use FutureBuilder to display view count asynchronously
                      if (widget.document.documentID != null)
                        FutureBuilder<int>(
                          future: _getViewCount(
                              widget.document.documentID!), // Call async method

                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                      strokeWidth:
                                          2)); // Show loading indicator
                            }
                            if (snapshot.hasError) {
                              return Text('error'.tr(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red)); // Show error
                            }
                            // Display view count when available
                            return Text(
                              snapshot.data?.toString() ??
                                  'not_available'
                                      .tr(), // Display count or 0 if null
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        )
                      else
                        Text('not_available'.tr(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500)),

                      const SizedBox(width: 12), // Spacing

                      // Date
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.black54,
                      ), // Calendar icon
                      const SizedBox(width: 4), // Spacing
                      Expanded(
                        child: Text(
                          _getTimeAgo(), // Time ago
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          // Removed textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
