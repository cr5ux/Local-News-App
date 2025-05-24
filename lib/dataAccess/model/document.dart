import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  final String? documentID;
  final String documentName;
  final String title;
  final List<dynamic> documentPath;
  final String? content;
  final String language;
  final List<dynamic> indexTermsAM;
  final List<dynamic> indexTermsEN;
  String registrationDate;
  final bool isActive;
  final String authorID;
  final List<dynamic> tags;
  final String documentType;

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      documentID: map['documentID'],
      documentName:
          map['documentName'] ?? '', // Provide a default value if null
      title: map['title'] ?? '', // Provide a default value if null
      documentPath: List<dynamic>.from(map['documentPath'] ??
          []), // Handle potential null and ensure list type
      content: map['content'],
      language: map['language'] ?? '', // Provide a default value if null
      indexTermsAM: List<dynamic>.from(map['indexTermsAM'] ??
          []), // Handle potential null and ensure list type
      indexTermsEN: List<dynamic>.from(map['indexTermsEN'] ??
          []), // Handle potential null and ensure list type
      registrationDate:
          map['registrationDate'] ?? '', // Provide a default value if null
      isActive: map['isActive'] ?? false, // Provide a default value if null
      authorID: map['authorID'] ?? '', // Provide a default value if null
      tags: List<dynamic>.from(
          map['tags'] ?? []), // Handle potential null and ensure list type
      documentType:
          map['documentType'] ?? '', // Provide a default value if null
    );
  }

  Document({
    this.documentID,
    required this.documentName,
    required this.title,
    required this.documentPath,
    this.content,
    required this.language,
    required this.indexTermsAM,
    required this.indexTermsEN,
    required this.registrationDate,
    required this.isActive,
    required this.authorID,
    required this.tags,
    required this.documentType,
  });

  factory Document.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Document(
        documentID: snapshot.id,
        documentName: data?['documentName'],
        title: data?['title'],
        documentPath: data?['documentPath'],
        language: data?['language'],
        indexTermsAM: data?['indexTermsAM'],
        indexTermsEN: data?['indexTermsEN'],
        registrationDate: data?['registrationDate'],
        isActive: data?['isActive'],
        authorID: data?['authorID'],
        tags: data?['tags'],
        documentType: data?['documentType']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (documentID != null) "id": documentID,
      "documentName": documentName,
      "title": title,
      "documentPath": documentPath,
      "language": language,
      "indexTermsAM": indexTermsAM,
      "indexTermsEN": indexTermsEN,
      "registrationDate": registrationDate,
      "isActive": isActive,
      "authorID": authorID,
      "tags": tags,
      "documentType": documentType
    };
  }
}
