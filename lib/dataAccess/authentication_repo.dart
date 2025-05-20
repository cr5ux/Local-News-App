

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/dataAccess/model/authentication.dart';

class AuthenticationRepo{

  final db = FirebaseFirestore.instance;


//add 
Future<String> addlogin(authentication) async
{
   
      try{

          final userRef= db.collection("Authentication").withConverter(fromFirestore: Authentication.fromFirestore, toFirestore: (Authentication auth, _)=>auth.toFirestore());
      
          var m=await userRef.add(authentication);
    

          return m.id;

          }
      catch(e)
      {
          
          rethrow; 
        
      }
      
}
//add logouttime

Future<void> addlogout(authenticationID,logOutTime) async
{
       try{
        
          final authRef= db.collection("Authentication").doc(authenticationID).withConverter(fromFirestore: Authentication.fromFirestore, toFirestore: (Authentication auth, _)=>auth.toFirestore());
      
          await authRef.update({"logOutTime":logOutTime});
        

          }
      catch(e)
      {
          
          rethrow; 
        
      }
}


}