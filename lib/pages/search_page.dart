import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/widgets/article_card.dart';
import 'package:easy_localization/easy_localization.dart';

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
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchResults = [];
      _hasSearched = true;
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.take(5).toList();
        }
      }
    });

    try {
      // Fetch all active documents
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Document')
          .where('isActive', isEqualTo: true)
          .get();

      final lowerQuery = query.toLowerCase();
      final results = querySnapshot.docs
          .map((doc) => Document.fromMap(doc.data()))
          .where((doc) {
        final inTitle = doc.title.toLowerCase().contains(lowerQuery);
        final inContent =
            (doc.content ?? '').toLowerCase().contains(lowerQuery);
        final inTags =
            doc.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        return inTitle || inContent || inTags;
      }).toList();

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
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
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
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
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: _performSearch,
            decoration: InputDecoration(
              hintText: 'search_news'.tr(),
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
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
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            else if (_hasSearched && _searchResults.isNotEmpty)
              _buildSearchResults()
            else if (_hasSearched && _searchResults.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'no_results_found'.tr(),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle('recent_searches'.tr()),
                  _buildRecentSearches(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('trending_now'.tr()),
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
      color: const Color(0xFF2D2D2D),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('filter_results'.tr(),
              style: const TextStyle(
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
        Text('category'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('all'.tr()),
            _buildFilterChip('filters.politics'.tr()),
            _buildFilterChip('filters.technology'.tr()),
            _buildFilterChip('filters.business'.tr()),
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
        Text('time'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('any_time'.tr()),
            _buildFilterChip('past_24_hours'.tr()),
            _buildFilterChip('past_week'.tr()),
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
        Text('source'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('all_sources'.tr()),
            _buildFilterChip('world_news'.tr()),
            _buildFilterChip('tech_today'.tr()),
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'no_results_found'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
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
