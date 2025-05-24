
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDTO{


  String? userID;
  String? email;
  String? phonenumber;
  String? password;

  LoginDTO({this.userID,  this.email, this.phonenumber, this.password});

  factory LoginDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
 
    return LoginDTO(
   
       userID: snapshot.id, 
       email: data?['email'], 
       phonenumber: data?['phonenumber'],
       password: data?['password'] 
      );
    
  }
    
  Map<String, dynamic> toFirestore() {
    return {
    
      if(userID != null)"id":userID,
      if(email !=null)"email": email,
      if(phonenumber !=null)"phonenumber":phonenumber,
      if(password !=null)"password": password,
      
    };
  }



}



  
    
    
