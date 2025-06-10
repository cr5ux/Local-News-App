import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String? userID;
  String fullName;

  // String? uniqueID;

  String? profileImagePath;

  List<dynamic>? preferenceTags;
  List<dynamic>? forbiddenTags;

  bool isAdmin;

  String phonenumber;

  String? otpExpirationTime;
  String? sceretKey;

  String email;
  String password;

  Users({
      this.userID,
      this.profileImagePath,
      required this.isAdmin,
      required this.fullName,
      this.preferenceTags,
      this.forbiddenTags, this.sceretKey, required this.phonenumber,  required this.email, required this.password,this.otpExpirationTime });//, required this.birthday,

  factory Users.fromFirestore(


    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,


  ) {

    final data = snapshot.data();

    return Users(
      
      userID: snapshot.id,
      
      fullName: data?['fullName'],

      profileImagePath: data?['profileImagePath'],

      isAdmin: data?['isAdmin'],
      preferenceTags: data?['preferenceTags'],
      forbiddenTags: data?['forbiddenTags'],

      phonenumber: data?['phonenumber'],

      sceretKey: data?['sceretKey'],

      email: data?['email'],
      password: data?['password'] ,

    );
  }

  Map<String, dynamic> toFirestore() {

    return {

      if (userID != null) "id": userID,

      "fullName": fullName,

      "profileImagePath":profileImagePath,

      "isAdmin": isAdmin,

      "preferenceTags": preferenceTags,
      "forbiddenTags": forbiddenTags,

      "phonenumber": phonenumber,

      "sceretKey":sceretKey,

      "email": email,
      "password": password,

    };
  }
}



  
    
    
    

 