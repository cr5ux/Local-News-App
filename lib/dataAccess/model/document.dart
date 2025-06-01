import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  final String? documentID;
  final String documentName;
  final String title;
  final List<String> documentPath;
  final String? content;
  final String language;
  final List<String> indexTermsAM;
  final List<String> indexTermsEN;
  final String registrationDate;
  final bool isActive;
  final String authorID;
  final List<String> tags;
  final String documentType;
  final bool isDownloaded;

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      documentID: map['documentID'],
      documentName: map['documentName'] ?? '',
      title: map['title'] ?? '',
      documentPath: List<String>.from(map['documentPath'] ?? []),
      content: map['content'],
      language: map['language'] ?? '',
      indexTermsAM: List<String>.from(map['indexTermsAM'] ?? []),
      indexTermsEN: List<String>.from(map['indexTermsEN'] ?? []),
      registrationDate: map['registrationDate'] ?? '',
      isActive: map['isActive'] ?? false,
      authorID: map['authorID'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      documentType: map['documentType'] ?? '',
      isDownloaded: map['isDownloaded'] ?? false,
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
    this.isDownloaded = false,
  });

  factory Document.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Document(
      documentID: snapshot.id,
      documentName: data?['documentName'] ?? '',
      title: data?['title'] ?? '',
      documentPath: List<String>.from(data?['documentPath'] ?? []),
      content: data?['content'],
      language: data?['language'] ?? '',
      indexTermsAM: List<String>.from(data?['indexTermsAM'] ?? []),
      indexTermsEN: List<String>.from(data?['indexTermsEN'] ?? []),
      registrationDate: data?['registrationDate'] ?? '',
      isActive: data?['isActive'] ?? false,
      authorID: data?['authorID'] ?? '',
      tags: List<String>.from(data?['tags'] ?? []),
      documentType: data?['documentType'] ?? '',
      isDownloaded: data?['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (documentID != null) "id": documentID,
      "documentName": documentName,
      "title": title,
      "documentPath": documentPath,
      "content": content,
      "language": language,
      "indexTermsAM": indexTermsAM,
      "indexTermsEN": indexTermsEN,
      "registrationDate": registrationDate,
      "isActive": isActive,
      "authorID": authorID,
      "tags": tags,
      "documentType": documentType,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'documentID': documentID,
      'documentName': documentName,
      'title': title,
      'documentPath': documentPath.toList(),
      'content': content,
      'language': language,
      'indexTermsAM': indexTermsAM.toList(),
      'indexTermsEN': indexTermsEN.toList(),
      'registrationDate': registrationDate,
      'isActive': isActive,
      'authorID': authorID,
      'tags': tags.toList(),
      'documentType': documentType,
      'isDownloaded': isDownloaded,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Document.fromJson(String source) {
    final Map<String, dynamic> data = jsonDecode(source);
    return Document(
      documentID: data['documentID'],
      documentName: data['documentName'] ?? '',
      title: data['title'] ?? '',
      documentPath: List<String>.from(data['documentPath'] ?? []),
      content: data['content'],
      language: data['language'] ?? '',
      indexTermsAM: List<String>.from(data['indexTermsAM'] ?? []),
      indexTermsEN: List<String>.from(data['indexTermsEN'] ?? []),
      registrationDate: data['registrationDate'] ?? '',
      isActive: data['isActive'] ?? false,
      authorID: data['authorID'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      documentType: data['documentType'] ?? '',
      isDownloaded: data['isDownloaded'] ?? false,
    );
  }

  Document copyWith({
    String? documentID,
    String? documentName,
    String? title,
    List<String>? documentPath,
    String? content,
    String? language,
    List<String>? indexTermsAM,
    List<String>? indexTermsEN,
    String? registrationDate,
    bool? isActive,
    String? authorID,
    List<String>? tags,
    String? documentType,
    bool? isDownloaded,
  }) {
    return Document(
      documentID: documentID ?? this.documentID,
      documentName: documentName ?? this.documentName,
      title: title ?? this.title,
      documentPath: documentPath ?? List<String>.from(this.documentPath),
      content: content ?? this.content,
      language: language ?? this.language,
      indexTermsAM: indexTermsAM ?? List<String>.from(this.indexTermsAM),
      indexTermsEN: indexTermsEN ?? List<String>.from(this.indexTermsEN),
      registrationDate: registrationDate ?? this.registrationDate,
      isActive: isActive ?? this.isActive,
      authorID: authorID ?? this.authorID,
      tags: tags ?? List<String>.from(this.tags),
      documentType: documentType ?? this.documentType,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
