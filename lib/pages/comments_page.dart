import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localnewsapp/dataAccess/comment_repo.dart';
import 'package:localnewsapp/dataAccess/dto/user_basic.dart';
import 'package:localnewsapp/dataAccess/model/comment.dart';
import 'package:localnewsapp/dataAccess/model/ls.dart';
import 'package:localnewsapp/dataAccess/model/reply.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/singleton/identification.dart';

class CommentsPage extends StatefulWidget {
  final String documentID;

  const CommentsPage({super.key, required this.documentID});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final CommentRepo _commentRepo = CommentRepo();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  final String currentUser = Identification().userID;

  List<Comment> _comments = [];
  Map<String, List<Reply>> _replies = {};
  String? _selectedCommentId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  // Fetch comments and their replies from Firestore
  Future<void> _fetchComments() async {
    try {
      final comments = await _commentRepo.getCommentByDocumentID(widget.documentID);
      final repliesMap = <String, List<Reply>>{};

      for (var comment in comments) {
        final replies = await _commentRepo.getACommentReply(comment.commentID);
        repliesMap[comment.commentID!] = replies;
      }

      setState(() {
        _comments = comments;
        _replies = repliesMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load comments')),
        );
      }
    }
  }

  // Get author name by user ID
  Future<String> _getAuthorName(String authorId) async {
    final UsersRepo usersRepo = UsersRepo();
    try {
      final UsersBasic user = await usersRepo.getAUserByID(authorId);
      return user.fullName;
    } catch (e) {
      return 'Unknown Author';
    }
  }

  // Add a new comment
  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = Comment(
      documentID: widget.documentID,
      userID: currentUser,
      message: _commentController.text.trim(),
      registrationDate: DateTime.now().toIso8601String(),
    );

    try {
      await _commentRepo.addAComment(newComment);
      _commentController.clear();
      _fetchComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add comment')),
        );
      }
    }
  }

  // Delete a comment
  Future<void> _deleteComment(String commentID) async {
    try {
      await _commentRepo.deleteComment(commentID);
      _fetchComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete comment')),
        );
      }
    }
  }

  // Add a like to a comment
  Future<void> _handleLike(String commentID) async {
    try {
      final like = LS(
        userID: currentUser,
        date: DateTime.now().toIso8601String(),
      );
      await _commentRepo.addALike(commentID, like);
      _fetchComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add like')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments (${_comments.length})'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? const Center(child: Text('No comments yet.'))
                    : ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return Column(
                            children: [
                              ListTile(
                                title: FutureBuilder<String>(
                                  future: _getAuthorName(comment.userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading...');
                                    } else if (snapshot.hasError) {
                                      return const Text('Error');
                                    }
                                    return Text(snapshot.data ?? 'Unknown Author');
                                  },
                                ),
                                subtitle: Text(comment.message),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_replies[comment.commentID]?.length ?? 0}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.reply, size: 20),
                                          onPressed: () {
                                            setState(() {
                                              _selectedCommentId = _selectedCommentId ==
                                                      comment.commentID
                                                  ? null
                                                  : comment.commentID;
                                              _replyController.clear();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.favorite_border, size: 20),
                                      onPressed: () => _handleLike(comment.commentID!),
                                    ),
                                    if (currentUser == comment.userID)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteComment(comment.commentID!),
                                      ),
                                  ],
                                ),
                                leading: Text(
                                  DateFormat('MMM dd, yyyy').format(
                                    DateTime.parse(comment.registrationDate),
                                  ),
                                ),
                              ),
                              if (_selectedCommentId == comment.commentID)
                                Padding(
                                  padding: const EdgeInsets.only(left: 56.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _replies[_selectedCommentId]?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final reply =
                                              _replies[_selectedCommentId]![index];
                                          return ListTile(
                                            title: FutureBuilder<String>(
                                              future: _getAuthorName(reply.userID),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text('Loading...');
                                                }
                                                return Text(
                                                    snapshot.data ?? 'Unknown Author');
                                              },
                                            ),
                                            subtitle: Text(reply.message),
                                            trailing: currentUser == reply.userID
                                                ? IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      await _commentRepo.deleteReply(
                                                        _selectedCommentId!,
                                                        reply.replyID!,
                                                      );
                                                      _fetchComments();
                                                    },
                                                  )
                                                : null,
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: _replyController,
                                                decoration: InputDecoration(
                                                  hintText: 'Write a reply...',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(20.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.send),
                                              onPressed: () async {
                                                if (_replyController.text.trim().isEmpty) {
                                                  return;
                                                }

                                                final reply = Reply(
                                                  replyID: '',
                                                  userID: currentUser,
                                                  message:
                                                      _replyController.text.trim(),
                                                  date:
                                                      DateTime.now().toIso8601String(),
                                                );

                                                try {
                                                  await _commentRepo.addAReply(
                                                    _selectedCommentId!,
                                                    reply,
                                                  );
                                                  _replyController.clear();
                                                  _fetchComments();
                                                } catch (e) {
                                                  if (mounted) {
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Failed to add reply'),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
          ),
          // Comment input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _addComment,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}