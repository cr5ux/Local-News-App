import 'dart:core';


import 'package:localnewsapp/dataAccess/Model/reply.dart';
import 'package:localnewsapp/dataAccess/model/ls.dart';


class Comment
{

  final String commentID;
  final String message;
  final DateTime registrationDate;
  final String usersID;
  final String documentID;
  final List<LS> like;
  final List<Reply> reply;

  Comment({required this.commentID, required this.message, required this.registrationDate, required this.usersID, required this.documentID,required this.like, required this.reply});
  

}