


import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication{


  final String authID;
  final String userID;
  final List<String> location;
  final DateTime loginTime;
  final DateTime logOutTime;


  Authentication({required this.authID, required this.userID, required this.location, required this.logOutTime, required this.loginTime});

  factory Authentication.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
 
    return Authentication(
   
       authID: data?['authID'], 
       userID: data?['userID'],
       location: data?['location'],
       logOutTime: data?['logOutTime'],
       loginTime: data?['loginTime'],
       

    
      );
    
  }
    
  Map<String, dynamic> toFirestore() {
    return {
    
      "authID":authID,
      "userID":userID,
      "location":location,
      "logOutTime":logOutTime,
      "loginTime":logOutTime,

    };
  }



}



  
    
    
