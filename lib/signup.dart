
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/authentication_repo.dart';
import 'package:localnewsapp/dataAccess/dto/login_dto.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/login.dart';
import 'package:string_validator/string_validator.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State <Signup> createState() =>  SignupState();
}

class  SignupState extends State <Signup> {

  final GlobalKey<FormState> _formStateKey =GlobalKey<FormState>();

  Users user = Users(uniqueID: "", isAdmin: false, fullName: "");
  LoginDTO logdto = LoginDTO();

  final ur = UsersRepo();
  final auth = AuthenticationRepo();

  bool passwordvisible=true;
  bool confirmvisible = true;
  String confirmPassword="";


  String? validateEmail(String value){
    
    if(value.isEmpty)
    {
      return 'Item is Required';
    }
    else if(!value.isEmail)
    {
      return "Input needs to be email address";
    }
    return null;
   
  }

  String? validateFullName(String value)
  {
    return value.isEmpty?"Item is required":"";
  }
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
      if(confirmPassword!=logdto.password)
      {
        return "password and confirm password must be the same";
      }
      return null;
      
  }

  void _onSubmit({required BuildContext context, bool fullscreenDialog = false}) async
  {
    if(_formStateKey.currentState!.validate())
    {
      _formStateKey.currentState!.save();

       String? value= await auth.adduser(logdto.email, logdto.password);
        if (value!.startsWith("failure"))
        {
              // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
        }
        else
        {
            user.uniqueID=value;
            user.isAdmin=false;
            String result=await ur.addUser(user);
            if (result.startsWith("failure"))
            { 
               // ignore: use_build_context_synchronously
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
            }
            else
            {
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog,builder: (context)=>const Login())); 
            }
        }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          backgroundColor: Colors.black,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child:  Column(
                              children: [
                                    const Text(
                                      "Sign Up",
                                      style: TextStyle(fontSize: 36),
                                    ),
                                     const Text(
                                      "create your account",
                                      style: TextStyle(fontSize: 18),
                                    ),

                                  const Padding(padding: EdgeInsets.all(10.0)),

                                  TextFormField(

                                      decoration:  const InputDecoration(
                                          hintText:"Full Name" ,
                                          label: Text("Full Name"),
                                          icon: Icon(Icons.person),
                                          constraints: BoxConstraints(maxHeight: 80, maxWidth: 500),

                                      ),
                                      validator: (value)=>validateFullName(value!),
                                      keyboardType: TextInputType.name,
                                      onSaved: (value)=>user.fullName= value!,
                                  ),

                                  const Padding(padding: EdgeInsets.all(20.0)),
                                     
                                  TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        label: Text("Email"),
                                        icon: Icon(Icons.email),
                                        constraints: BoxConstraints(maxHeight: 80, maxWidth: 500) 
                                      ),

                                      validator: (value) => validateEmail(value!),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (value) => logdto.email=value!,
                                  ),

                                  const Padding(padding: EdgeInsets.all(20.0)),
 
                                  Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                      children: [
                                          TextFormField(
                                              decoration: const InputDecoration(
                                                hintText: "Password",
                                                label: Text("Password"),
                                                icon: Icon(Icons.numbers),
                                                constraints: BoxConstraints(maxHeight: 80, maxWidth: 500) 
                                              ),

                                              validator: (value) => validatePassword(value!),
                                              keyboardType: TextInputType.text,
                                              onSaved: (value) => logdto.password=value!,
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
                                        
                                        child:ElevatedButton(
                                                  onPressed: ()=>_onSubmit(
                                                    context: context,
                                                    fullscreenDialog: false,
                                                  ), 
                                                  style:const ButtonStyle(
                                                    backgroundColor:WidgetStatePropertyAll<Color>(Colors.black),
                                                    foregroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                                            
                                                  ),
                                                  child:const Text("Register",style:TextStyle(fontSize: 16.0),)
                                                ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10.0)),
                                  
                                    ElevatedButton(
                                          style:const ButtonStyle(

                                              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                                              shadowColor: WidgetStatePropertyAll<Color>(Colors.transparent),
                                              overlayColor: WidgetStatePropertyAll<Color>(Colors.transparent),

                                            ),
                                          onPressed: ()
                                          {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login())); 

                                          }, 
                                          child:  const Text(
                                                    "Do have an account? Login", 
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                        )
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