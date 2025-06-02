import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String? userID;
  String fullName;

  String? uniqueID;

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
       this.uniqueID,
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

      uniqueID: data?['uniqueID'],

      isAdmin: data?['isAdmin'],
      preferenceTags: data?['preferenceTags'],
      forbiddenTags: data?['forbiddenTags'],

      phonenumber: data?['phonenumber'],

      // otp: data?['otp'],
      sceretKey: data?['sceretKey'],

      email: data?['email'],
      password: data?['password'] ,

    );
  }

  Map<String, dynamic> toFirestore() {

    return {

      if (userID != null) "id": userID,

      "fullName": fullName,

      "uniqueID": uniqueID,

      "isAdmin": isAdmin,

      "preferenceTags": preferenceTags,
      "forbiddenTags": forbiddenTags,

      "phonenumber": phonenumber,
       
      // "otp":otp,
      "sceretKey":sceretKey,

      "email": email,
      "password": password,

    };
  }
}



  
    
    
    

 