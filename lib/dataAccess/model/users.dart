import 'package:cloud_firestore/cloud_firestore.dart';

class Users{

  final String? userID;
  final String fullName;
  final String birthday;
  final List<dynamic> address; 
  final String phonenumber;

 final List<dynamic> preferenceTags;
  final List<dynamic> forbiddenTags;

  final String email;
  final String password;

  Users({this.userID, required this.fullName, required this.birthday, required this.address, required this.phonenumber,  required this.preferenceTags, required this.forbiddenTags, required this.email, required this.password});

  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    
 
    return Users(
       userID: snapshot.id, 
       fullName: data?['fullName'], 
       birthday: data?['birthday'], 
       address: data?['address'],
       phonenumber: data?['phonenumber'],

       preferenceTags: data?['preferenceTags'],
       forbiddenTags: data?['forbiddenTags'], 
  
       email: data?['email'], 
       password: data?['password'] ,



     
      );
    
  }
    
  Map<String, dynamic> toFirestore() {
    return {
      if(userID != null)"id":userID,
      "fullName": fullName,
      "birthday": birthday,
      "address": address,
      "phonenumber": phonenumber ,
      "preferenceTags":preferenceTags,
      "forbiddenTags":forbiddenTags,
 
      "email": email,
      "password": password,
    };
  }



}



  
    
    
    
    
    
  
      // regions:
      //     data?['regions'] is Iterable ? List.from(data?['regions']) : null,
 