import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';


class Comment
{

  final String? commentID;
  final String message;
  final String registrationDate;
  final String userID;
  final String documentID;


  Comment({this.commentID, required this.message, required this.registrationDate, required this.userID, required this.documentID});
  

  factory Comment.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,

  )
  {
      final data = snapshot.data();

      return Comment(
        commentID: snapshot.id, 
        message: data?['message'],
        registrationDate: data?['registrationDate'], 
        userID: data?['userID'], 
        documentID: data?['documentID'], 
      
      );

  }

  Map<String, dynamic> toFirestore()
  {
    return{

       if (commentID != null) "id": commentID, 
        "message": message,
        "registrationDate": registrationDate, 
        "userID": userID, 
        "documentID": documentID, 


    };
  }

}