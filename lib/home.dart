import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/widgets/article_card.dart';
import 'package:localnewsapp/constants/categories.dart';
import 'package:easy_localization/easy_localization.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DocumentRepo _documentRepo = DocumentRepo();
  String selectedFilter = 'Recent';
  late Future<List<Document>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _documentRepo.getAllDocuments();
  }

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Recent') {
        _articlesFuture = _documentRepo.getAllDocuments();
      } else {
        _articlesFuture = _documentRepo.getDocumentByTags(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filters = ['Recent', ...NewsCategories.allCategories];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("welcome".tr(),
              style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                "discover".tr(),
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = selectedFilter == filter;
                    return ChoiceChip(
                      label: Text('filters.${filter.toLowerCase()}'.tr()),
                      selected: isSelected,
                      onSelected: (_) => _onFilterSelected(filter),
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: Colors.grey.shade200,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Document>>(
            future: _articlesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: [31m${snapshot.error}[0m'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No articles available'));
              }

              final articles = snapshot.data!;
              // If 'Recent', sort by registrationDate descending
              final sortedArticles = selectedFilter == 'Recent'
                  ? (List<Document>.from(articles)
                    ..sort((a, b) =>
                        b.registrationDate.compareTo(a.registrationDate)))
                  : articles;

              return ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                itemCount: sortedArticles.length,
                itemBuilder: (context, index) {
                  return ArticleCard(document: sortedArticles[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
