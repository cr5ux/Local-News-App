import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/authentication_repo.dart';

import 'package:string_validator/string_validator.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  
    final GlobalKey<FormState>  _formStateKey = GlobalKey<FormState>();
  String email="", message="";

 ResetPassword({super.key});



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
  Future<void> sendLink(context) async {

    if(_formStateKey.currentState!.validate())
    {
      _formStateKey.currentState!.save();
          
        final  access= AuthenticationRepo();

        message= await access.resetPassword(email);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        
        Future.delayed(const Duration(seconds:2));
        
        Navigator.pop(context);
    }

    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
       
        body:SafeArea(

            child:Center(child: Container(

                  padding: const EdgeInsets.all(50.0),
                  margin: const EdgeInsets.fromLTRB(15.0,15.0,15.0,15.0),
                 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white

                  ),

                  child: SingleChildScrollView(
                        child:Form(

                              key: _formStateKey,
                              autovalidateMode: AutovalidateMode.always,

                              child: Column(
                                
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [

                                        
                                        const Text(
                                          "Reset password",
                                          style: TextStyle(fontSize: 48),
                                        ),

                                        
                                        const Padding(padding: EdgeInsets.all(20.0)),


                                        TextFormField(
                                            decoration: const InputDecoration(
                                                      hintText: "Email Address",
                                                      label: Text("Address"),
                                                      icon: Icon(Icons.email),
                                                      constraints: BoxConstraints(maxHeight: 80, maxWidth: 500)
                                              
                                            ),
                                            validator:(value)=> validateEmail(value!),
                                            keyboardType: TextInputType.emailAddress,
                                            onSaved:(value)=>email=value!
                                        ),

                                        
                                        const Padding(padding: EdgeInsets.all(20.0)),

                                      SizedBox(
                                          
                                          width: 250.0,
                                          
                                          child:ElevatedButton(
                                                    onPressed:()=> sendLink(context),
                                                
                                                    style:const ButtonStyle(
                                                       backgroundColor:WidgetStatePropertyAll<Color>(Colors.black),
                                                       foregroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                                             
                                                    ),
                                                  
                                                child:  const Text(
                                                  "Send Link", 
                                                
                                                  )
                                              ),
                                        ),
                                    ],
                              ),
                          
                          )
                  ),
            ),
          ),
        )
    );
  }
}