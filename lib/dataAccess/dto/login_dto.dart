
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDTO{


  final String userID;
  final String email;
  final String password;

  LoginDTO({required this.userID, required this.email, required this.password});

  factory LoginDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
 
    return LoginDTO(
   
       userID: snapshot.id, 
       email: data?['email'], 
       password: data?['password'] 
      );
    
  }
    
  Map<String, dynamic> toFirestore() {
    return {
    
      "authUserID":userID,
      "email": email,
      "password": password,
    };
  }



}



  
    
    
