import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localnewsapp/singleton/identification.dart';

import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/serverside_repo.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formStateKey =GlobalKey<FormState>();

  Users user = Users(isAdmin: false, fullName: "",phonenumber:"", email: '', password: '');
  // LoginDTO logdto = LoginDTO();

  final ur = UsersRepo();
  // final auth = AuthenticationRepo();

  bool passwordvisible=true;
  bool confirmvisible = true;
  String confirmPassword="";

  bool isEnable=true;

  String? validatePassword(String value)
  {
    bool isAlphafound=false;
    bool ischarfound=false;
    bool isLowerFound=false;
    bool isNumberfound=false;
    AsciiEncoder asciiEncoder=const AsciiEncoder();

      if (value.isEmpty)
      {
        return "Password is required";
      }
      else if(value.isNotEmpty)
      {
          if(value.length<8)
          {
            return "Minimum of  8 characters required";
          }

          var splitvalue= value.split('');

          for (var i in splitvalue)
          {
           
              var val=asciiEncoder.convert(i);
              
              if(val[0]>=65 && val[0]<= 90 )
              {
                  isAlphafound=true;
              }
              if((val[0]>=33 && val[0]<= 47) || (val[0]>=58 && val[0]<=64))
              {
                ischarfound=true;
              }
              if(val[0]>=48 && val[0]<=57)
              {
                isNumberfound=true;
              }
              if(val[0]>=97 && val[0]<=122)
              {
                isLowerFound=true;
              }
          }

          if(!isAlphafound)
          {
            return "password must contain uppercase letter";
          }
          if(!ischarfound)
          {
            return "password must contain special characters";
          }
           if(!isNumberfound)
          {
            return "password must contain number";
          }
           if(!isLowerFound)
          {
            return "password must contain lowercase letter";
          }
      }
      
      return null;
      
  }

  void _onSubmit({required BuildContext context, bool fullscreenDialog = false}) async
  {
        setState(() {
            isEnable=false;
          });

    if(_formStateKey.currentState!.validate())
    {
      _formStateKey.currentState!.save();

 
      if(confirmPassword!=user.password)
      {
          setState(() {
            isEnable=true;
          });
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password and confirm password must be the same")));
      }
      else
      {
          user.userID=Identification().userID;
          
          final access= ServerRepo();

          user.password=await access.hashFunction(user.password);
         

              String result=await ur.updateUserPasswordInfo(user);

              if (result.startsWith("failure"))
              { 
                setState(() {
                  isEnable=true;
                });
                 
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

              }
              else
              {
               // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("successful")));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
              
   /*   }  */
            
            
        }
      

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          backgroundColor: AppColors.background,
           appBar: AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
          ),
          body: SafeArea(
            child:  Center(
              
              child: Container(

                  padding: const EdgeInsets.all(50.0),
                  margin: const EdgeInsets.fromLTRB(15.0,15.0,15.0,15.0),
                 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white

                  ),
                  child: SingleChildScrollView(

                      child: Form(

                        key: _formStateKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child:  Column(
                              children: [
                                    const Text(
                                      "Reset Password",
                                      style: TextStyle(fontSize: 36),
                                    ),
                                  

                                  const Padding(padding: EdgeInsets.all(10.0)),

                                 
                                  
                                  Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                      children: [
                                          TextFormField(
                                              decoration: const InputDecoration(
                                                hintText: "Password",
                                                label: Text("Password"),
                                                icon: Icon(Icons.password),
                                                constraints: BoxConstraints(maxHeight: 80, maxWidth: 500) 
                                              ),

                                              validator: (value) => validatePassword(value!),
                                              keyboardType: TextInputType.text,
                                              onSaved: (value) => user.password=value!,
                                              obscureText: passwordvisible,
                                        ),

                                        const Padding(padding: EdgeInsets.all(20.0)),
                                        
                                        IconButton(
                                          onPressed: ()
                                          {
                                            setState(() {
                                              passwordvisible?passwordvisible=false:passwordvisible=true;
                                            });
                                          }, 
                                          icon: passwordvisible?const Icon(Icons.visibility):const Icon(Icons.visibility_off)
                                      )
                                      ],

                                  ),

                                  const Padding(padding: EdgeInsets.all(20.0)),

                                  Stack(
                                     alignment: AlignmentDirectional.topEnd,
                                    children: [
                                        TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "Password",
                                              label: Text("Confirm Password"),
                                              icon: Icon(Icons.password),
                                              constraints: BoxConstraints(maxHeight: 80, maxWidth: 500) 
                                            ),

                                            validator: (value) =>validatePassword(value!),
                                            keyboardType: TextInputType.text,
                                            onSaved: (value) => confirmPassword=value!,
                                            obscureText: confirmvisible,
                                      ),

                                      const Padding(padding: EdgeInsets.all(20.0)),

                                      IconButton(
                                        onPressed: ()
                                        {
                                          setState(() {
                                            confirmvisible?confirmvisible=false:confirmvisible=true;
                                          });
                                        }, 
                                        icon:confirmvisible?const Icon(Icons.visibility): const Icon(Icons.visibility_off)
                                      )

                                    ]
                                  ),
                                  

                                  const Padding(padding: EdgeInsets.all(10.0)),

                                   SizedBox(
                                          
                                        width: 250.0,
                                        height: 56,
                                        child:ElevatedButton(
                                                  onPressed: isEnable?()=>_onSubmit(
                                                    context: context,
                                                    fullscreenDialog: false,
                                                  ):null, 
                                                  style:ElevatedButton.styleFrom(
                                                          backgroundColor: AppColors.primary,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          elevation: 4,
                                                      ),
                                                  child:isEnable?const Text("Register",style:TextStyle(fontSize: 16.0),): const Center(child: CircularProgressIndicator())
                                                ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10.0)),
                                  
                                    
                              ]
                          

                        )
           
                    ),

                  ),
              )

            )
        
          ),

    );

  }
}
