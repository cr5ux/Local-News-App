
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:localnewsapp/business/identification.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';


class ServerRepo
{

   Future<http.Response> sendLoginRequest(phonenumber, password)async {
        
        Uri uri=Uri.https('local-news-app-server.vercel.app','/authentication/login_Request');
        // Uri uri=Uri.http('localhost:3030','/authentication/login_Request');

        password=hashFunction(password);


        
          var response= await http.post(uri, 

                    headers: {
                                "Content-Type":"application/json"

                            },

                    body:jsonEncode(
                      { 
                          "phonenumber":phonenumber,
                          "password":password ,
                      }
                        
                    )
                );



                return response;

   }

  
   Future<http.Response> sendOTPVerification(otp,phonenumber)async {

      Uri uri=Uri.https('local-news-app-server.vercel.app','/authentication/otp_verification');
      

      var time="${DateTime.now().toLocal()}";
    
      var response= await http.post(uri, 

                headers: {
                            "Content-Type":"application/json"

                        },

                body:jsonEncode(
                  { 
                      "otp":otp,
                      "phonenumber":phonenumber,
                      "otpExpirationTime":time
                  }
                    
                )
            );

        
    if(!response.body.contains("failure"))
    {
         Identification().userID=response.body;
            

            final ur=UsersRepo();
            var result =await ur.getAUserByID(Identification().userID);
            
            Identification().isAdmin=result.isAdmin;
          
    }
            
          
          return response;

   }
   
   hashFunction(plainText)
   {
      var key = utf8.encode(plainText);
     var bytes = utf8.encode("foobar");

     var hmacSha256 = Hmac(sha256, key); 
     var digest = hmacSha256.convert(bytes);

     return digest.toString();

   }


  Future<http.Response> sendPasswordResetRequest(email)async {
        

    Uri uri=Uri.https('local-news-app-server.vercel.app','/authentication/password_Forget_Reset_Request');
    
      var response= await http.post(uri, 

                headers: {
                            "Content-Type":"application/json"

                        },

                body:jsonEncode(
                  { 
                      "email":email,
                  }
                    
                )
            );



            return response;

   }
















}