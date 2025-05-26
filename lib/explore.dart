import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/widgets/category_card.dart';
import 'package:localnewsapp/constants/categories.dart'; // Import NewsCategories
import 'package:localnewsapp/pages/category_article_page.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Document')
                      .where('isActive', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.black87),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      );
                    }

                    // Calculate category counts
                    Map<String, int> categoryCounts = {};
                    // Initialize counts for all categories to 0
                    for (var category in NewsCategories.allCategories) {
                      // Use NewsCategories
                      categoryCounts[category] = 0;
                    }

                    // Count documents based on tags matching categories
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final List<dynamic> tags =
                          data['tags'] ?? []; // Use 'tags' field

                      for (var tag in tags) {
                        if (NewsCategories.allCategories.contains(tag)) {
                          // Use NewsCategories
                          categoryCounts[tag] = (categoryCounts[tag] ?? 0) + 1;
                        }
                      }
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: NewsCategories.allCategories.map((category) {
                        return CategoryCard(
                          categoryName: category,
                          articleCount: categoryCounts[category] ?? 0,
                          backgroundImage:
                              NewsCategories.categoryImages[category],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryArticlePage(categoryName: category),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
