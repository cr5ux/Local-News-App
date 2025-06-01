import 'package:cloud_firestore/cloud_firestore.dart';

class UsersBasic {

  String? userID;
  String fullName;

  List<dynamic>? preferenceTags;
  List<dynamic>? forbiddenTags;

  bool isAdmin;

  String phonenumber;


  String email;


  UsersBasic({
      this.userID,
      required this.isAdmin,
      required this.fullName,
      this.preferenceTags,
      this.forbiddenTags, required this.phonenumber,  required this.email});

  factory UsersBasic.fromFirestore(


    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,


  ) {

    final data = snapshot.data();

    return UsersBasic(
      
      userID: snapshot.id,
      
      fullName: data?['fullName'],


      isAdmin: data?['isAdmin'],
      preferenceTags: data?['preferenceTags'],
      forbiddenTags: data?['forbiddenTags'],

      phonenumber: data?['phonenumber'],

 

      email: data?['email']

    );
  }

  Map<String, dynamic> toFirestore() {

    return {

      if (userID != null) "id": userID,

      "fullName": fullName,


      "isAdmin": isAdmin,

      "preferenceTags": preferenceTags,
      "forbiddenTags": forbiddenTags,

      "phonenumber": phonenumber,
       
  

      "email": email

    };
  }
}



  
    
    
    

 