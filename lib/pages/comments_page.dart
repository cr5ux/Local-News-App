import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/comment_repo.dart'; // Import CommentRepo
import 'package:localnewsapp/dataAccess/dto/user_basic.dart';
import 'package:localnewsapp/dataAccess/model/comment.dart'; // Import Comment model
import 'package:localnewsapp/dataAccess/users_repo.dart';
// import 'package:localnewsapp/dataAccess/model/users.dart'; // Import Users model
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class CommentsPage extends StatefulWidget {
  final String documentID;

  const CommentsPage({super.key, required this.documentID});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final CommentRepo _commentRepo = CommentRepo();
  List<Comment> _comments = [];
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser; // Get current user

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    try {
      final comments =
          await _commentRepo.getCommentByDocumentID(widget.documentID);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error appropriately, maybe show a message
      setState(() {
        _isLoading = false;
        // Optionally set an error state or display an error message
      });
    }
  }

  Future<String> _getAuthorName(String authorId) async {
    final UsersRepo usersRepo = UsersRepo();
    try {
      final UsersBasic user = await usersRepo.getAUserByID(authorId);
      return user.fullName;
      // Use fullName field
    } catch (e) {
      return 'Unknown Author'; // Return a default name in case of error
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty){
      return; // Don't add empty comments
    }

    if (currentUser == null) {
      return;
    }

    final newComment = Comment(
      commentID: '', // Firestore will generate this
      documentID: widget.documentID,
      userID: currentUser!.uid, // Use the logged-in user's ID
      message: _commentController.text.trim(),
      registrationDate: DateTime.now().toIso8601String(),
    );

    try {
      await _commentRepo.addAComment(newComment);
      _commentController.clear();
      // Re-fetch comments to update the list
      _fetchComments();
    } catch (e) {
      // Handle error appropriately
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
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: currentUser?.photoURL != null
                                  ? NetworkImage(currentUser!.photoURL!)
                                  : null,
                              backgroundColor: Colors.grey[300],
                              child: currentUser?.photoURL == null
                                  ? const Icon(Icons.person,
                                      color: Colors.black54)
                                  : null,
                            ),
                            title: FutureBuilder<String>(
                              // Use FutureBuilder to get author name asynchronously
                              future: _getAuthorName(
                                  comment.userID), // Call the async method
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                      'Loading...'); // Show loading text
                                } else if (snapshot.hasError) {
                                  return const Text('Error'); // Show error text
                                } else if (snapshot.hasData) {
                                  return Text(snapshot.data ??
                                      'Unknown Author'); // Display the author's name, or fallback
                                } else {
                                  return const Text(
                                      'Unknown Author'); // Fallback
                                }
                              },
                            ),
                            subtitle: Text(comment.message),
                            trailing: Text(comment
                                .registrationDate), // Placeholder for time ago
                          );
                        },
                      ),
          ),
          // Comment input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: currentUser?.photoURL != null
                      ? NetworkImage(currentUser!.photoURL!)
                      : null,
                  backgroundColor: Colors.grey[400],
                  child: currentUser?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.black54)
                      : null,
                ),
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
                          horizontal: 16.0, vertical: 8.0),
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
