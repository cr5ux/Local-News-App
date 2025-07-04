import 'package:cloud_firestore/cloud_firestore.dart';

class UsersBasic {

  String? userID;
  String fullName;
  String? profileImagePath ;

  List<dynamic>? preferenceTags;
  List<dynamic>? forbiddenTags;

  bool isAdmin;

  String phonenumber;


  String email;

  String? countryCode;
  String? languageCode;

  UsersBasic({
      this.userID,
      required this.profileImagePath,
      required this.isAdmin,
      required this.fullName,
      this.preferenceTags,
      this.forbiddenTags, required this.phonenumber,  required this.email,
      this.countryCode,
      this.languageCode});

    factory UsersBasic.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,


  ) {

    final data = snapshot.data();

    return UsersBasic(
      
      userID: snapshot.id,
      
      fullName: data?['fullName'],

      profileImagePath: data?['profileImagePath'],
      
      isAdmin: data?['isAdmin'],
      preferenceTags: data?['preferenceTags'],
      forbiddenTags: data?['forbiddenTags'],

      phonenumber: data?['phonenumber'],

 

      email: data?['email'],
      
      countryCode: data?['countryCode'],
      languageCode: data?['languageCode']
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
       
  

      "email": email,
      
      if (countryCode != null) "countryCode": countryCode,
      if (languageCode != null) "languageCode": languageCode
    };
  }
}