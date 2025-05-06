
import 'package:localnewsapp/dataAccess/model/ls.dart';

class Document
{
  final String documentID;
  final String documentName;
  final String title;
  final String documentPath;
  final String language;
  final List<String> indexTerms;
  final DateTime registrationDate;
  final bool isActive;
  final String authorID;
  final List<String> tags;
  final List<LS> like;
  final List<LS> share;
  final String documentType;


  Document({required this.documentID, required this.documentName, required this.title, required this.documentPath, required this.language, required this.indexTerms, required this.registrationDate, required this.isActive, required this.authorID, required this.tags, required this.like, required this.share, required this.documentType });


}