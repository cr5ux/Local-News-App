import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/widgets/article_card.dart';

class Home extends StatelessWidget {
  final DocumentRepo _documentRepo = DocumentRepo();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Document>>(
      future: _documentRepo.getAllDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No articles available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ArticleCard(document: snapshot.data![index]);
          },
        );
      },
    );
  }
}
