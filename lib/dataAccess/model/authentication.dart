import 'package:cloud_firestore/cloud_firestore.dart';


class Authentication{


  final String? authID;
  final String userID;
  final List<String> location;
  final String loginTime;
  final String? logOutTime;


  Authentication({this.authID, required this.userID, required this.location, this.logOutTime, required this.loginTime});

  factory Authentication.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
 
    return Authentication(
   
       authID: snapshot.id, 
       userID: data?['userID'],
       location: data?['location'],
       logOutTime: data?['logOutTime'],
       loginTime: data?['loginTime'],
       
      );
    
  }
    
  Map<String, dynamic> toFirestore() {
    return {
    
      if(authID != null)"id":authID,
      "userID":userID,
      "location":location,
      "logOutTime":logOutTime,
      "loginTime":logOutTime,

    };
  }



}



  
    
    
