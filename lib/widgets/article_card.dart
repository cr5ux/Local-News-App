import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/pages/article_detail_page.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart'; // Import DocumentRepo
import 'package:localnewsapp/dataAccess/model/ls.dart'; // Import LS model

class ArticleCard extends StatelessWidget {
  final Document document;

  const ArticleCard({super.key, required this.document});

  String _getContentPreview() {
    if (document.content == null || document.content!.isEmpty) {
      return 'No content available';
    }
    // Get first 150 characters and add ellipsis
    return document.content!.length > 150
        ? '${document.content!.substring(0, 150)}...'
        : document.content!;
  }

  // Placeholder for estimating read time (e.g., 200 words per minute)
  String _estimateReadTime() {
    if (document.content == null || document.content!.isEmpty) {
      return '';
    }
    const wordsPerMinute = 200;
    final wordCount = document.content!.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / wordsPerMinute).ceil();
    return '$minutes min read';
  }

  // Actual logic to get view count from DocumentRepo
  Future<int> _getViewCount(String documentId) async {
    final DocumentRepo documentRepo = DocumentRepo();
    try {
      final views = await documentRepo.getDocumentView(documentId);
      return views.length;
    } catch (e) {
      return 0; // Return 0 or handle error appropriately
    }
  }

  // Placeholder for time ago (using registrationDate for now)
  String _getTimeAgo() {
    try {
      // Assuming registrationDate is in a format DateTime.parse can handle
      final DateTime date = DateTime.parse(document.registrationDate);
      final Duration diff = DateTime.now().difference(date);

      if (diff.inDays > 365) {
        return '${(diff.inDays / 365).floor()} years ago';
      } else if (diff.inDays > 30) {
        return '${(diff.inDays / 30).floor()} months ago';
      } else if (diff.inDays > 7) {
        return '${(diff.inDays / 7).floor()} weeks ago';
      } else if (diff.inDays > 0) {
        return '${diff.inDays} days ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours} hours ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return document.registrationDate; // Fallback to raw date if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final DocumentRepo documentRepo =
        DocumentRepo(); // Instantiate DocumentRepo

    return GestureDetector(
      onTap: () async {
        // Made onTap async
        // Add view before navigating
        if (document.documentID != null) {
          try {
            // Placeholder user ID - replace with actual user ID
            // You would typically get the authenticated user's ID here
            const String currentUserId = 'placeholder_user_id';
            final LS view = LS(
                userID: currentUserId, date: DateTime.now().toIso8601String());
            await documentRepo.addAView(document.documentID!, view);
            // Optional: Log success
          } catch (e) {
            // Optionally show a snackbar or other feedback for the user
          }
        }

        // Navigate to article detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(document: document),
          ),
        );
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
            // Image Section with Category Overlay
            if (document.documentPath.isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    document.documentPath[0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200], // Placeholder background
                        child: const Center(
                            child: Text('Image not available',
                                style: TextStyle(color: Colors.black54))),
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
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners for badge
                      ),
                      child: Text(
                        document.documentType, // Use document type
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
                          document.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Spacing between title and icon
                      const Icon(Icons.bookmark_border,
                          color: Colors.grey), // Bookmark icon
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
                      Text(
                        document.authorID, // Use authorID as source
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
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
                      if (document.documentID != null)
                        FutureBuilder<int>(
                          future: _getViewCount(
                              document.documentID!), // Call async method
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
                              return const Text('Error',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red)); // Show error
                            }
                            // Display view count when available
                            return Text(
                              snapshot.data?.toString() ??
                                  '0', // Display count or 0 if null
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            );
                          },
                        )
                      else
                        const Text('N/A',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors
                                    .black54)), // Show N/A if documentID is null

                      const SizedBox(width: 12), // Spacing

                      // Date
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.black54), // Calendar icon
                      const SizedBox(width: 4), // Spacing
                      Expanded(
                        child: Text(
                          _getTimeAgo(), // Time ago
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.end,
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
