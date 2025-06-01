
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localnewsapp/business/identification.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';

class AuthenticationRepo{

  final db = FirebaseFirestore.instance;

/*
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
*/

Future<String?> deleteUser() async{

  try{
    await FirebaseAuth.instance.currentUser!.delete();

  } on FirebaseAuthException catch (e) 
  {
      return "failure ${e.code}";
  } catch(e)
  {
      return "failure ${e.toString()}";
  }
  return null;


}



//
Future<String?> adduser(email, password)async
{

      String value="";
      try {


        
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email:email,
              password: password
            ).then(
            (data) async
            {

                value=data.user!.uid;

            });
                
            

          //  await user.user!.sendEmailVerification().then(
          //   (data)
          //   {
          //       if(!user.user!.emailVerified)
          //       {
          //         user.user!.delete().then(
          //         (data)
          //         {
          //           value= "failure account not created email not verified";
          //         }
          //       );

          //       }   
          //   }
          //   ).catchError(
          //   (data)
          //   {
          //       user.user!.delete().then(
          //         (data)
          //         {
          //           value= "failure account not created email not verified";
          //         }
          //       );
          //   });
            

          return value;
      } 
      on FirebaseAuthException catch (e) 
      {
       
          return "failure ${e.code}";
      } 
      catch (e) {
          
          return "failure ${e.toString()}";
     }


}


Future<String> loginwithEmailandPassword(email, password) async {

    final uR=UsersRepo();
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        ).then(
            (data) async {
              Users user= await uR.getAUserByuniqueID(data.user!.uid);
              Identification().userID=user.userID!;
              Identification().isAdmin=user.isAdmin;
              return user;
            }
          );
    

    } on FirebaseAuthException catch (e) {

      return "Failure ${e.code}";
    } 
    
    catch (e) {
      return "Failure ${e.toString()}";
    }
    return "";
    
  }

Future<String> resetPassword(email) async {

    try {
     
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email
        );

        return "Password Reset Link sent";
    

    } on FirebaseAuthException catch (e) {

      return "Failure ${e.code}";
    } 
    
    catch (e) {
      return "Failure ${e.toString()}";
    }
    
  }





}
