import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/singleton/identification.dart';
import 'package:localnewsapp/widgets/article_card.dart';

class ReadLaterPage extends StatefulWidget {
  const ReadLaterPage({super.key});

  @override
  State<ReadLaterPage> createState() => _ReadLaterPageState();
}

class _ReadLaterPageState extends State<ReadLaterPage> {
  final DocumentRepo _documentRepo = DocumentRepo();
  final String _currentUser = Identification().userID;
  List<Document> _bookmarkedArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedArticles();
  }

  Future<void> _loadBookmarkedArticles() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final bookmarkedArticles =
          await _documentRepo.getDocumentBookmarksByAUser(_currentUser);

      setState(() {
        _bookmarkedArticles = bookmarkedArticles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load bookmarked articles'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Later'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadBookmarkedArticles,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _bookmarkedArticles.isEmpty
                ? const Center(
                    child: Text(
                      'No bookmarked articles yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _bookmarkedArticles.length,
                    itemBuilder: (context, index) {
                      return ArticleCard(
                        document: _bookmarkedArticles[index],
                      );
                    },
                  ),
      ),
    );
  }
}
