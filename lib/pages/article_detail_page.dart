import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:video_player/video_player.dart';

class ArticleDetailPage extends StatefulWidget {
  final Document document;

  const ArticleDetailPage({super.key, required this.document});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late VideoPlayerController _controller;
  bool _isVideo = false;

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
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
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
            else if (!_isVideo && widget.document.documentPath.isNotEmpty)
              // Image from documentPath
              Image.network(
                'https://source.unsplash.com/random/800x400',
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
            else if (!_isVideo && widget.document.documentPath.isEmpty)
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
