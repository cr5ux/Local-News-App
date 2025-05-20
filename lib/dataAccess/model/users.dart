import 'package:cloud_firestore/cloud_firestore.dart';

class Users{

   String? userID;
   String fullName;
 
   String  uniqueID;

   String phonenumber;

   List<dynamic>? preferenceTags;
   List<dynamic>? forbiddenTags;

  bool isAdmin ;
   //  String birthday;
  // final String email;
  // final String password;

  Users({this.userID,required this.uniqueID,required this.phonenumber, required this.isAdmin, required this.fullName,  this.preferenceTags, this.forbiddenTags});//, required this.birthday, required this.email, required this.password});

  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    
 
    return Users(
       userID: snapshot.id, 
       fullName: data?['fullName'], 

       uniqueID: data?['uniqueID'],

     
      isAdmin: data?['isAdmin'],
       preferenceTags: data?['preferenceTags'],
       forbiddenTags: data?['forbiddenTags'], 
  
      phonenumber: data?['phonenumber'],

      //  email: data?['email'], 
      //  password: data?['password'] ,



     
      );
    
  }
    
  Map<String, dynamic> toFirestore() {
    return {
      if(userID != null)"id":userID,
      "fullName": fullName,
      
      "uniqueID":uniqueID,
      
      "isAdmin":isAdmin,
      "preferenceTags":preferenceTags,
      "forbiddenTags":forbiddenTags,


     "phonenumber": phonenumber ,

     
      // "email": email,
      // "password": password,
    };
  }



}



  
    
    
    
    
    
  
      // regions:
      //     data?['regions'] is Iterable ? List.from(data?['regions']) : null,
 