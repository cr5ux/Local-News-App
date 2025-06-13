import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/widgets/article_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Sorting and filtering states
  String _selectedSort = 'date'; // 'date', 'likes', 'views'
  String _selectedTimeFilter = 'any_time'; // 'any_time', '24h', 'week', 'month'
  final List<String> _selectedTags = [];

  // Available tags from your categories
  final List<String> _availableTags = [
    'politics',
    'technology',
    'business',
    'sports',
    'entertainment',
    'health',
    'science',
    'environment'
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
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

      // Update recent searches
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.take(5).toList();
        }
        _saveRecentSearches();
      }
    });

    try {
      // Fetch all active documents
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Document')
          .where('isActive', isEqualTo: true)
          .get();

      final lowerQuery = query.toLowerCase();
      var results = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['documentID'] = doc.id;
        return Document.fromMap(data);
      }).where((doc) {
        final inTitle = doc.title.toLowerCase().contains(lowerQuery);
        final inContent =
            (doc.content ?? '').toLowerCase().contains(lowerQuery);
        final inTags =
            doc.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        return inTitle || inContent || inTags;
      }).toList();

      // Apply time filter
      if (_selectedTimeFilter != 'any_time') {
        final now = DateTime.now();
        results = results.where((doc) {
          final docDate = DateTime.parse(doc.registrationDate);
          final difference = now.difference(docDate);

          switch (_selectedTimeFilter) {
            case '24h':
              return difference.inHours <= 24;
            case 'week':
              return difference.inDays <= 7;
            case 'month':
              return difference.inDays <= 30;
            default:
              return true;
          }
        }).toList();
      }

      // Apply tag filter
      if (_selectedTags.isNotEmpty) {
        results = results.where((doc) {
          return doc.tags.any((tag) => _selectedTags.contains(tag));
        }).toList();
      }

      // Apply sorting
      switch (_selectedSort) {
        case 'date':
          results.sort((a, b) => DateTime.parse(b.registrationDate)
              .compareTo(DateTime.parse(a.registrationDate)));
          break;
        case 'likes':
          // Sort by likes count
          final likesCounts = await Future.wait(
            results.map((doc) async {
              final likes = await FirebaseFirestore.instance
                  .collection('Document')
                  .doc(doc.documentID)
                  .collection('Like')
                  .count()
                  .get();
              return {'doc': doc, 'count': likes.count ?? 0};
            }),
          );
          likesCounts
              .sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
          results = likesCounts.map((item) => item['doc'] as Document).toList();
          break;
        case 'views':
          // Sort by views count
          final viewsCounts = await Future.wait(
            results.map((doc) async {
              final views = await FirebaseFirestore.instance
                  .collection('Document')
                  .doc(doc.documentID)
                  .collection('View')
                  .count()
                  .get();
              return {'doc': doc, 'count': views.count ?? 0};
            }),
          );
          viewsCounts
              .sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
          results = viewsCounts.map((item) => item['doc'] as Document).toList();
          break;
      }

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to perform search'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(
          'sort_by'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('date', 'newest_first'.tr()),
            _buildSortOption('likes', 'most_liked'.tr()),
            _buildSortOption('views', 'most_viewed'.tr()),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String label) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedSort,
        onChanged: (newValue) {
          setState(() {
            _selectedSort = newValue!;
          });
          Navigator.pop(context);
          if (_searchController.text.isNotEmpty) {
            _performSearch(_searchController.text);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortDialog();
            },
          ),
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
          _buildFilterTime(),
          const SizedBox(height: 10),
          _buildFilterTags(),
        ],
      ),
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
            _buildFilterChip(
              'any_time'.tr(),
              _selectedTimeFilter == 'any_time',
              () {
                setState(() {
                  _selectedTimeFilter = 'any_time';
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
            ),
            _buildFilterChip(
              'past_24_hours'.tr(),
              _selectedTimeFilter == '24h',
              () {
                setState(() {
                  _selectedTimeFilter = '24h';
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
            ),
            _buildFilterChip(
              'past_week'.tr(),
              _selectedTimeFilter == 'week',
              () {
                setState(() {
                  _selectedTimeFilter = 'week';
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
            ),
            _buildFilterChip(
              'past_month'.tr(),
              _selectedTimeFilter == 'month',
              () {
                setState(() {
                  _selectedTimeFilter = 'month';
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('tags'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            return _buildFilterChip(
              tag.tr(),
              _selectedTags.contains(tag),
              () {
                setState(() {
                  if (_selectedTags.contains(tag)) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.white,
      ),
      backgroundColor: isSelected ? Colors.white : Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.white : Colors.white54,
        ),
      ),
      onSelected: (_) => onTap(),
      selected: isSelected,
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
          setState(() {
            _recentSearches.remove(search);
            _saveRecentSearches();
          });
        },
      ),
      onTap: () {
        _searchController.text = search;
        _performSearch(search);
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
