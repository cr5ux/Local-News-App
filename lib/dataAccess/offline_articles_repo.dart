import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';

class OfflineArticlesRepo {
  static const String _articlesKey = 'offline_articles';
  final SharedPreferences _prefs;
  final DocumentRepo _documentRepo;

  OfflineArticlesRepo(this._prefs, this._documentRepo);

  List<Document> getDownloadedArticles() {
    final articlesJson = _prefs.getStringList(_articlesKey) ?? [];
    return articlesJson.map((json) => Document.fromJson(json)).toList();
  }

  Future<void> downloadArticles() async {
    // Get latest articles from Firestore
    final articles = await _documentRepo.getAllDocuments();
    
    // Mark articles as downloaded and save them
    final downloadedArticles = articles.map((article) {
      return article.copyWith(isDownloaded: true);
    }).toList();

    // Save to SharedPreferences
    final articlesJson = downloadedArticles.map((article) => article.toJson()).toList();
    await _prefs.setStringList(_articlesKey, articlesJson);
  }

  Future<void> deleteAllDownloads() async {
    await _prefs.remove(_articlesKey);
  }
}
