import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/widgets/article_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = []; // Dynamic list for recent searches
  List<Document> _searchResults = []; // List to hold search results
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = []; // Clear results if query is empty
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchResults = []; // Clear previous results
      // Add the search term to the beginning of the list
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        // Optionally limit the number of recent searches, e.g., to 5
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.take(5).toList();
        }
      }
    });

    try {
      // Perform Firestore query
      // Note: Firestore's query capabilities for text search are limited.
      // This example performs a basic prefix search on the 'title' field.
      // For full-text search, consider using a dedicated search service like Algolia or Elasticsearch.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Document')
          .where('isActive', isEqualTo: true)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title',
              isLessThan: '$query\uf8ff') // \uf8ff is a high-range character
          .get();

      setState(() {
        _searchResults = querySnapshot.docs
            .map((doc) => Document.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      //print('Error performing search: $e');
      // Optionally show an error message to the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Dark background
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color:
                const Color(0xFF2D2D2D), // Slightly lighter dark for search bar
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: _performSearch, // Call _performSearch when submitting
            decoration: const InputDecoration(
              hintText: 'Search for news...',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list), // Filter icon
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showFilters) _buildFilterSection(),
            if (_isLoading) // Show loading indicator
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ) // Show loading indicator
            else if (_searchResults.isNotEmpty) // Show results if available
              _buildSearchResults()
            else // Show recent searches and trending if no search performed or no results
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle('Recent Searches'),
                  _buildRecentSearches(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Trending Now'),
                  _buildTrendingNow(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: const Color(0xFF2D2D2D), // Match search bar background
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter Results',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildFilterCategory(),
          const SizedBox(height: 10),
          _buildFilterTime(),
          const SizedBox(height: 10),
          _buildFilterSource(),
        ],
      ),
    );
  }

  Widget _buildFilterCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('All'),
            _buildFilterChip('Politics'),
            _buildFilterChip('Technology'),
            _buildFilterChip('Business'),
            // Add other categories here based on DocumentTags.types
          ],
        ),
      ],
    );
  }

  Widget _buildFilterTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('Any time'),
            _buildFilterChip('Past 24 hours'),
            _buildFilterChip('Past week'),
            // Add other time filters here
          ],
        ),
      ],
    );
  }

  Widget _buildFilterSource() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Source',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('All sources'),
            _buildFilterChip('World News'),
            _buildFilterChip('Tech Today'),
            // Add other sources here
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.white),
      backgroundColor: Colors.black54,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white54)),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      children:
          _recentSearches.map((search) => _buildSearchItem(search)).toList(),
    );
  }

  Widget _buildSearchItem(String search) {
    return ListTile(
      leading: const Icon(Icons.search, color: Colors.white54),
      title: Text(
        search,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, color: Colors.white54),
        onPressed: () {
          // Handle remove recent search
        },
      ),
      onTap: () {
        // Handle search item tap
        _searchController.text = search; // Populate search bar
        _performSearch(search); // Perform search
      },
    );
  }

  Widget _buildTrendingNow() {
    // Placeholder data
    final trendingTopics = [
      'election results',
      'crypto market',
      'covid update',
      'olympic games',
      'tech layoffs',
    ];
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trendingTopics.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.white12, height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
          title: Text(
            trendingTopics[index],
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () {
            // Handle trending topic tap
            _searchController.text =
                trendingTopics[index]; // Populate search bar
            _performSearch(trendingTopics[index]); // Perform search
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No results found.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return ArticleCard(document: _searchResults[index]);
      },
    );
  }
}
