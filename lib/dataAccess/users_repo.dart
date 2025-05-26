import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
// import 'package:localnewsapp/dataAccess/dto/login_dto.dart';

class UsersRepo {
  final db = FirebaseFirestore.instance;

//Read
  Future<List<Users>> getAllUsers() async {
    List<Users> users = [];
    try {
      final userRef = db.collection("Users").withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.get().then((userSnap) {
        for (var snap in userSnap.docs) {
          users.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return users;
  }

  Future<Users> getAUserByID(userID) async {
    // ignore: prefer_typing_uninitialized_variables
    var user;
    try {
      final userRef = db.collection("Users").doc(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.get().then((userSnap) {
        user = userSnap.data();
      });
    } catch (e) {
      rethrow;
    }

    return user;
  }

  Future<List<dynamic>?> getUserPreferenceTags(userID) async {
    // ignore: prefer_typing_uninitialized_variables
    var user;

    try {
      final userRef = db.collection("Users").where(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.get().then((userSnap) {
        for (var snap in userSnap.docs) {
          user = snap.data();
        }
      });
    } catch (e) {
      rethrow;
    }
    return user.preferenceTags;
  }

  Future<List<dynamic>?> getUserForbiddenTags(userID) async {
    // ignore: prefer_typing_uninitialized_variables
    var user;

    try {
      final userRef = db.collection("Users").where(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.get().then((userSnap) {
        for (var snap in userSnap.docs) {
          user = snap.data();
        }
      });
    } catch (e) {
      rethrow;
    }

    return user.forbiddenTags;
  }

  Future<Users> getAUserByuniqueID(uniqueID) async {
    // ignore: prefer_typing_uninitialized_variables
    var user;
    try {
      final userRef = db
          .collection("Users")
          .where("uniqueID", isEqualTo: uniqueID)
          .withConverter(
              fromFirestore: Users.fromFirestore,
              toFirestore: (Users user, _) => user.toFirestore());

      await userRef.get().then((userSnap) {
        for (var snap in userSnap.docs) {
          user = snap.data();
        }
      });
    } catch (e) {
      rethrow;
    }

    return user;
  }

/*
Future<Users> getAUserByEmail(email) async
 {
    
    // ignore: prefer_typing_uninitialized_variables
    var user;
      try{
          final userRef= db.collection("Users").where("email",isEqualTo:email).withConverter(fromFirestore: Users.fromFirestore, toFirestore: (Users user, _)=>user.toFirestore());
      
          await userRef.get().then(
              (userSnap)
              {
                for (var snap in userSnap.docs)
                {
                   user=snap.data();
                }
              }
          
            );

          }
      catch(e)
      {
          rethrow;   
      }

      
      return user;



} 

Future<Users> getAUserByPhonenumber(phonenumber) async
 {
    
    // ignore: prefer_typing_uninitialized_variables
    var user;
      try{
          final userRef= db.collection("Users").where("phonenumber",isEqualTo:phonenumber).withConverter(fromFirestore: Users.fromFirestore, toFirestore: (Users user, _)=>user.toFirestore());
      
          await userRef.get().then(
              (userSnap)
              {
                for (var snap in userSnap.docs)
                {
                   user=snap.data();
                }
              }
          
            );

          }
      catch(e)
      {
          rethrow;   
      }
 
      return user;
} 


Future<LoginDTO> getAUserLogin(userID) async
 {
    
    // ignore: prefer_typing_uninitialized_variables
    var logindto;
      try{
          final userRef= db.collection("Users").where(userID).withConverter(fromFirestore: LoginDTO.fromFirestore, toFirestore: (LoginDTO login, _)=>login.toFirestore());
      
          await userRef.get().then(
              (userSnap)
              {
                for (var snap in userSnap.docs)
                {
                   logindto=snap.data();
               
                }
              }
          
            );

          }
      catch(e)
      {
          rethrow;   
      }

      return logindto;
} 

Future<LoginDTO> getAUserLoginByEmail(email) async
 {
    
    // ignore: prefer_typing_uninitialized_variables
    var logindto;
      try{
          final userRef= db.collection("Users").where("email",isEqualTo: email).withConverter(fromFirestore: LoginDTO.fromFirestore, toFirestore: (LoginDTO login, _)=>login.toFirestore());
      
          await userRef.get().then(
              (userSnap)
              {
                for (var snap in userSnap.docs)
                {
                   logindto=snap.data();
               
                }
              }
          
            );

          }
      catch(e)
      {
          rethrow;   
      }

      return logindto;
} 

Future<LoginDTO> getAUserLoginByPhonenumber(phonenumber) async
 {
    
    // ignore: prefer_typing_uninitialized_variables
    var logindto;
      try{
          final userRef= db.collection("Users").where("phonenumber",isEqualTo: phonenumber).withConverter(fromFirestore: LoginDTO.fromFirestore, toFirestore: (LoginDTO login, _)=>login.toFirestore());
      
          await userRef.get().then(
              (userSnap)
              {
                for (var snap in userSnap.docs)
                {
                   logindto=snap.data();
               
                }
              }
          
            );

          }
      catch(e)
      {
          rethrow;   
      }

      return logindto;
} 

*/

//Add

  Future<String> addUser(user) async {
    String message = "";
    try {
      final userRef = db.collection("Users").withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      var m = await userRef.add(user);

      message = "$m registration sucessfull";

      return message;
    } catch (e) {
      return "failure $e.toString()";
    }
  }

  Future<String> addPreferenceTags(userID, preferenceTags) async {
    String message = "";
    try {
      final userRef = db.collection("Users").doc(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.update({"preferenceTags": preferenceTags});

      message = "registration sucessfull";

      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addForbiddenTags(userID, forbiddenTags) async {
    String message = "";
    try {
      final userRef = db.collection("Users").doc(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.update({"forbiddenTags": forbiddenTags});

      message = "registration sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }

//update

  Future<String> updateUserInfo(Users user) async {
    String message = "";
    try {
      final userRef = db.collection("Users").doc(user.userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.update({"fullName": user.fullName});

      message = "registration sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updatePreferenceTags(userID, preferenceTags) async {
    String message = "";
    try {
      final userRef = db.collection("Users").doc(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.update({"preferenceTags": preferenceTags});

      message = "update sucessfull";

      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateForbiddenTags(userID, forbiddenTags) async {
    String message = "";
    try {
      final userRef = db.collection("Users").doc(userID).withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => user.toFirestore());

      await userRef.update({"forbiddenTags": forbiddenTags});

      message = "udate sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }
}
