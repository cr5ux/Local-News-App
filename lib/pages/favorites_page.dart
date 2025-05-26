import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DocumentRepo _documentRepo = DocumentRepo();
  List<Document> _favoriteArticles = [];
  List<Document> _favoriteVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement actual favorites loading logic
      // For now, we'll just simulate empty states
      _favoriteArticles = [];
      _favoriteVideos = [];
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.article_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Empty',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Favorites'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Videos'),
          ],
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Articles tab
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favoriteArticles.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _favoriteArticles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_favoriteArticles[index].title),
                        );
                      },
                    ),
          // Videos tab
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favoriteVideos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _favoriteVideos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_favoriteVideos[index].title),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
