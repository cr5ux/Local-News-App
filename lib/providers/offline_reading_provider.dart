import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/offline_articles_repo.dart';

class OfflineReadingProvider with ChangeNotifier {
  static const String _autoDownloadKey = 'auto_download_wifi';
  final SharedPreferences _prefs;
  final DocumentRepo _documentRepo = DocumentRepo();
  late final OfflineArticlesRepo _offlineRepo;
  List<Document> _downloadedArticles = [];
  bool _isDownloading = false;

  OfflineReadingProvider(this._prefs) {
    _offlineRepo = OfflineArticlesRepo(_prefs, _documentRepo);
    _loadDownloadedArticles();
  }

  void _loadDownloadedArticles() {
    _downloadedArticles = _offlineRepo.getDownloadedArticles();
    notifyListeners();
  }

  bool get isAutoDownloadEnabled => _prefs.getBool(_autoDownloadKey) ?? false;
  bool get isDownloading => _isDownloading;
  List<Document> get downloadedArticles => _downloadedArticles;

  Future<void> toggleAutoDownload(bool value) async {
    await _prefs.setBool(_autoDownloadKey, value);
    notifyListeners();
  }

  Future<void> downloadLatestArticles() async {
    if (_isDownloading) return;

    _isDownloading = true;
    notifyListeners();

    try {
      await _offlineRepo.downloadArticles();
      _loadDownloadedArticles();
    } catch (e) {
      // Handle error
      debugPrint('Error downloading articles: $e');
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAllDownloads() async {
    try {
      await _offlineRepo.deleteAllDownloads();
      _downloadedArticles = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting downloads: $e');
    }
  }
}
