
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localnewsapp/business/identification.dart';
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

//
Future<String?> adduser(email, password)async
{

      String value="";
      try {
           await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email:email,
              password: password
            ).then(
              (data){
                value=data.user!.uid;
              }
            );

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
              String id=await uR.getAUserByuniqueID(data.user!.uid);
              Identification().userID=id;
              return id;
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
