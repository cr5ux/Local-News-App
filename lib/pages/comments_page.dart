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
      final comments =
          await _commentRepo.getCommentByDocumentID(widget.documentID);
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
                          final isOwnComment = currentUser == comment.userID;
                          final replyCount =
                              _replies[comment.commentID]?.length ?? 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFEEEEEE), width: 0.5)),
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar
                                FutureBuilder<UsersBasic>(
                                  future:
                                      UsersRepo().getAUserByID(comment.userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey);
                                    }
                                    final user = snapshot.data;
                                    return CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage:
                                          user?.profileImagePath != null
                                              ? NetworkImage(
                                                  user!.profileImagePath!)
                                              : null,
                                      child: user?.profileImagePath == null
                                          ? const Icon(Icons.person,
                                              color: Colors.black)
                                          : null,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                // Main content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Username
                                          FutureBuilder<UsersBasic>(
                                            future: UsersRepo()
                                                .getAUserByID(comment.userID),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Container(
                                                    width: 60,
                                                    height: 12,
                                                    color: Colors.grey[300]);
                                              }
                                              final user = snapshot.data;
                                              return Text(
                                                user?.fullName ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          // Time
                                          Text(
                                            _formatTimeAgo(
                                                comment.registrationDate),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          const Spacer(),
                                          // Like icon and count
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => _handleLike(
                                                    comment.commentID!),
                                                child: const Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.black,
                                                    size: 20),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text('0',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13)),
                                            ],
                                          ),
                                          // Delete icon for own comment
                                          if (isOwnComment)
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  size: 20, color: Colors.red),
                                              onPressed: () => _deleteComment(
                                                  comment.commentID!),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      // Comment text
                                      Text(
                                        comment.message,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      const SizedBox(height: 8),
                                      // Reply and view replies
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedCommentId =
                                                    _selectedCommentId ==
                                                            comment.commentID
                                                        ? null
                                                        : comment.commentID;
                                                _replyController.clear();
                                              });
                                            },
                                            child: Text(
                                              'Reply',
                                              style: TextStyle(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          if (replyCount > 0) ...[
                                            const SizedBox(width: 16),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedCommentId =
                                                      _selectedCommentId ==
                                                              comment.commentID
                                                          ? null
                                                          : comment.commentID;
                                                });
                                              },
                                              child: Text(
                                                'View $replyCount more repl${replyCount == 1 ? 'y' : 'ies'}',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      // Replies section
                                      if (_selectedCommentId ==
                                          comment.commentID)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 0.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    _replies[_selectedCommentId]
                                                            ?.length ??
                                                        0,
                                                itemBuilder: (context, index) {
                                                  final reply = _replies[
                                                          _selectedCommentId]![
                                                      index];
                                                  return ListTile(
                                                    title:
                                                        FutureBuilder<String>(
                                                      future: _getAuthorName(
                                                          reply.userID),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Text(
                                                              'Loading...');
                                                        }
                                                        return Text(snapshot
                                                                .data ??
                                                            'Unknown Author');
                                                      },
                                                    ),
                                                    subtitle:
                                                        Text(reply.message),
                                                    trailing: currentUser ==
                                                            reply.userID
                                                        ? IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              size: 20,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await _commentRepo
                                                                  .deleteReply(
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller:
                                                            _replyController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Write a reply...',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.grey[200],
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16.0,
                                                            vertical: 8.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.send),
                                                      onPressed: () async {
                                                        if (_replyController
                                                            .text
                                                            .trim()
                                                            .isEmpty) {
                                                          return;
                                                        }

                                                        final reply = Reply(
                                                          replyID: '',
                                                          userID: currentUser,
                                                          message:
                                                              _replyController
                                                                  .text
                                                                  .trim(),
                                                          date: DateTime.now()
                                                              .toIso8601String(),
                                                        );

                                                        try {
                                                          await _commentRepo
                                                              .addAReply(
                                                            _selectedCommentId!,
                                                            reply,
                                                          );
                                                          _replyController
                                                              .clear();
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
                                  ),
                                ),
                              ],
                            ),
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

  String _formatTimeAgo(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
