import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/widgets/category_card.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BROWSE BY CATEGORY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Document')
                    .where('isActive', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  // Calculate category counts
                  Map<String, int> categoryCounts = {};
                  for (var doc in snapshot.data!.docs) {
                    String category = (doc.data() as Map<String, dynamic>)['documentType'] ?? 'Uncategorized';
                    categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: categoryCounts.entries.map((entry) {
                      return CategoryCard(
                        categoryName: entry.key,
                        articleCount: entry.value,
                        onTap: () {
                       
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'TRENDING TOPICS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTrendingTopic('Climate Change'),
                    _buildTrendingTopic('COVID-19'),
                    _buildTrendingTopic('Inflation'),
                    _buildTrendingTopic('Technology'),
                    _buildTrendingTopic('Politics'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTopic(String topic) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(topic),
        backgroundColor: Colors.black87,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}