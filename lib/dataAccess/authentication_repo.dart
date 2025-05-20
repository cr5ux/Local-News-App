
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

Future<String?> loginwithEmailandPassword(email, password) async {

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';


    } on FirebaseAuthException catch (e) {


      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } 
    
    catch (e) {
      return e.toString();
    }
  }



}