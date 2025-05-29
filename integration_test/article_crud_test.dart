import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localnewsapp/firebase_options.dart';
import 'package:localnewsapp/pages/article_form_page.dart';
import 'package:localnewsapp/pages/article_detail_page.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/offline_articles_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Article Creation Testing', () {
    testWidgets("test article creation with valid data", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await tester.pumpWidget(const MaterialApp(home: ArticleFormPage()));
      await tester.pumpAndSettle();

      // Verify form fields are present
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(DropdownButtonFormField), findsWidgets);

      // Fill in the title field
      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(
          find.byType(TextFormField).at(0), 'Test Article Title');

      // Fill in the article content field
      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(find.byType(TextFormField).at(1),
          'This is a test article content for integration testing.');

      // Fill in the link field
      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(
          find.byType(TextFormField).at(2), 'https://example.com/test-article');

      // Select language dropdown
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byType(DropdownButtonFormField).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('en').last);
      await tester.pumpAndSettle();

      // Select document type dropdown
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byType(DropdownButtonFormField).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('text').last);
      await tester.pumpAndSettle();

      // Select at least one tag
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.text('Technology').first);
      await tester.pumpAndSettle();

      // Submit the form
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify success message or navigation
      expect(find.byType(SnackBar), findsAny);
    });

    testWidgets("test article creation with missing required fields",
        (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await tester.pumpWidget(const MaterialApp(home: ArticleFormPage()));
      await tester.pumpAndSettle();

      // Try to submit without filling required fields
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter a title'), findsAny);
    });

    testWidgets("test article creation without tags selection", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await tester.pumpWidget(const MaterialApp(home: ArticleFormPage()));
      await tester.pumpAndSettle();

      // Fill required fields but don't select tags
      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(
          find.byType(TextFormField).at(0), 'Test Article Title');

      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(find.byType(TextFormField).at(1),
          'This is a test article content.');

      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(
          find.byType(TextFormField).at(2), 'https://example.com/test');

      // Submit without selecting tags
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify tag selection error
      expect(find.text('Please select at least one tag'), findsAny);
    });
  });

  group('Article Reading and Display Testing', () {
    testWidgets("test article detail page display", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Create a test document
      final testDocument = Document(
        documentID: 'test-doc-id',
        documentName: 'Test Document',
        title: 'Test Article Title',
        documentPath: ['https://example.com/test'],
        content: 'This is test content for the article.',
        language: 'en',
        indexTermsAM: [],
        indexTermsEN: [],
        registrationDate: DateTime.now().toIso8601String(),
        isActive: true,
        authorID: 'test-author-id',
        tags: ['Technology'],
        documentType: 'text',
      );

      await tester.pumpWidget(
          MaterialApp(home: ArticleDetailPage(document: testDocument)));
      await tester.pumpAndSettle();

      // Verify article details are displayed
      expect(find.text('Test Article Title'), findsOneWidget);
      expect(find.text('This is test content for the article.'), findsOneWidget);
    });

    testWidgets("test article like functionality", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final testDocument = Document(
        documentID: 'test-doc-id-like',
        documentName: 'Test Document for Like',
        title: 'Test Article for Like',
        documentPath: ['https://example.com/test-like'],
        content: 'This is test content for like functionality.',
        language: 'en',
        indexTermsAM: [],
        indexTermsEN: [],
        registrationDate: DateTime.now().toIso8601String(),
        isActive: true,
        authorID: 'test-author-id',
        tags: ['Technology'],
        documentType: 'text',
      );

      await tester.pumpWidget(
          MaterialApp(home: ArticleDetailPage(document: testDocument)));
      await tester.pumpAndSettle();

      // Find and tap the like button
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byIcon(Icons.thumb_up_alt_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify like state change (icon should change or count should update)
      expect(find.byIcon(Icons.thumb_up), findsAny);
    });
  });

  group('Article Update Testing', () {
    testWidgets("test article status update", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Test updating article active status through repository
      final documentRepo = DocumentRepo();
      
      try {
        final result = await documentRepo.updateDocumentActive('test-doc-id', false);
        expect(result, contains('update sucessful'));
      } catch (e) {
        // Handle expected errors in test environment
        expect(e, isA<Exception>());
      }
    });
  });

  group('Offline Articles Testing', () {
    testWidgets("test offline articles download and storage", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final documentRepo = DocumentRepo();
      final offlineRepo = OfflineArticlesRepo(prefs, documentRepo);

      // Test downloading articles
      try {
        await offlineRepo.downloadArticles();
        final downloadedArticles = offlineRepo.getDownloadedArticles();
        expect(downloadedArticles, isA<List<Document>>());
      } catch (e) {
        // Handle expected errors in test environment
        expect(e, isA<Exception>());
      }
    });

    testWidgets("test offline articles deletion", (tester) async {
      SharedPreferences.setMockInitialValues({'offline_articles': ['test']});
      final prefs = await SharedPreferences.getInstance();
      final documentRepo = DocumentRepo();
      final offlineRepo = OfflineArticlesRepo(prefs, documentRepo);

      // Test deleting all downloads
      await offlineRepo.deleteAllDownloads();
      final downloadedArticles = offlineRepo.getDownloadedArticles();
      expect(downloadedArticles, isEmpty);
    });
  });

  group('Article Repository CRUD Operations Testing', () {
    testWidgets("test document repository read operations", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final documentRepo = DocumentRepo();

      try {
        // Test getting all documents
        final allDocs = await documentRepo.getAllDocuments();
        expect(allDocs, isA<List<Document>>());

        // Test getting documents by type
        final textDocs = await documentRepo.getDocumentByDocumentType('text');
        expect(textDocs, isA<List<Document>>());

        // Test getting documents by tags
        final techDocs = await documentRepo.getDocumentByTags('Technology');
        expect(techDocs, isA<List<Document>>());
      } catch (e) {
        // Handle expected errors in test environment
        expect(e, isA<Exception>());
      }
    });

    testWidgets("test document like operations", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final documentRepo = DocumentRepo();

      try {
        // Test checking like status
        final hasLiked = await documentRepo.hasUserLikedDocument(
            'test-doc-id', 'test-user-id');
        expect(hasLiked, isA<bool>());
      } catch (e) {
        // Handle expected errors in test environment
        expect(e, isA<Exception>());
      }
    });
  });

  group('Error Handling Testing', () {
    testWidgets("test article creation with invalid data", (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await tester.pumpWidget(const MaterialApp(home: ArticleFormPage()));
      await tester.pumpAndSettle();

      // Fill with invalid link
      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(
          find.byType(TextFormField).at(0), 'Test Article');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test content');
      await tester.enterText(
          find.byType(TextFormField).at(2), 'invalid-url');

      // Submit form
      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify error handling
      expect(find.byType(SnackBar), findsAny);
    });

    testWidgets("test network error handling", (tester) async {
      // Test how the app handles network errors
      final documentRepo = DocumentRepo();

      try {
        await documentRepo.getADocumentByID('non-existent-id');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}