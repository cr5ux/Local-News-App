
import 'package:cloud_firestore/cloud_firestore.dart';

class Document
{
  final String? documentID;
  final String documentName;
  final String title;
  final String documentPath;
  final String language;
  final List<dynamic> indexTermsAM;
  final List<dynamic> indexTermsEN;
  final String registrationDate;
  final bool isActive;
  final String authorID;
  final List<dynamic> tags;
  final String documentType;


  Document({this.documentID, required this.documentName, required this.title, required this.documentPath, required this.language, required this.indexTermsAM, required this.indexTermsEN, required this.registrationDate, required this.isActive, required this.authorID, required this.tags, required this.documentType });


  factory Document.fromFirestore(
        DocumentSnapshot<Map<String, dynamic>> snapshot,
        SnapshotOptions? options,
  )
  {
    final data=snapshot.data();

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
        documentType: data?['documentType']
        
      );

  }


  Map<String, dynamic> toFirestore()
  {
    return
    {
        "id": documentID, 
        "documentName": documentName, 
        "title": title, 
        "documentPath": documentPath, 
        "language":language, 
        "indexTermsAM": indexTermsAM,
        "indexTermsEN": indexTermsEN,
        "registrationDate": registrationDate, 
        "isActive": isActive, 
        "authorID": authorID,
        "tags": tags, 
        "documentType":documentType

    };
    
  }



}