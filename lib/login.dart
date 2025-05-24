
import 'package:localnewsapp/dataAccess/authentication_repo.dart';
import 'package:localnewsapp/homecontainer.dart';
import 'package:flutter/material.dart';
import 'package:localnewsapp/reset_password.dart';
import 'package:localnewsapp/signup.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final GlobalKey<FormState>  _formStateKey = GlobalKey<FormState>();

  final LoginData _logindata = LoginData();

  List<bool> isEmail=[true,false];
  



  final  access= AuthenticationRepo();

  // ignore: non_constant_identifier_names
  String? _validate_item_required(String value){
    
    return  value.isEmpty?'Item is Required':null;
  }
 
  void _submitOrder({required BuildContext context, bool fullscreenDialog = false}) async
  {
    String? result ="";
    if(_formStateKey.currentState!.validate())
    {
      _formStateKey.currentState!.save();
      

      if(isEmail[0])
      {
          result= await access.loginwithEmailandPassword( _logindata.address,  _logindata.password);
          
          if(!result.contains("Failure"))
          {
                // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog,builder: (context)=>const HomeContainer(title:'Zena')));
          }
          else
          {
             // ignore: use_build_context_synchronously
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
          }
          
      }
    

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
                                          "Log in",
                                          style: TextStyle(fontSize: 48),
                                        ),

                                        const Text(
                                          "Sign in to your account",
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        
                                        const Padding(padding: EdgeInsets.all(20.0)),


                                        TextFormField(
                                            decoration: const InputDecoration(
                                                      hintText: "Email Address or Phonenumber",
                                                      label: Text("Address"),
                                                      icon: Icon(Icons.email),
                                                      constraints: BoxConstraints(maxHeight: 80, maxWidth: 500)
                                              
                                            ),
                                            validator:(value)=> _validate_item_required(value!),
                                            keyboardType: TextInputType.emailAddress,
                                            onSaved:(value)=>_logindata.address=value
                                        ),

                                        const Padding(padding: EdgeInsets.all(20.0)),

                                        TextFormField(
                                           decoration:  const InputDecoration(
                                                    hintText: "Password",
                                                    label: Text("Password"),
                                                    icon: Icon(Icons.lock),
                                                    constraints: BoxConstraints(maxHeight: 80, maxWidth: 500),

                                            ),
                                            validator:(value)=>_validate_item_required(value!),
                                            obscureText: true,
                                            onSaved:(value)=> _logindata.password=value
                                             
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
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword())); 

                                          }, 
                                          child:  const Text(
                                                  "Forget password?", 
                                                  style: TextStyle(color: Colors.black),
                                        
                                                  ),
                                        ),
                                        
                                        const Padding(padding: EdgeInsets.all(10.0)),

                                        SizedBox(
                                          
                                          width: 250.0,
                                          
                                          child:ElevatedButton(
                                                    onPressed:()=> _submitOrder(context: context,
                                                                fullscreenDialog: false), 
                                                    style:const ButtonStyle(
                                                      backgroundColor:WidgetStatePropertyAll<Color>(Colors.black),
                                                      foregroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                                             
                                                    ),
                                                    child:const Text("Log in",style:TextStyle(fontSize: 16.0),)
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
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Signup())); 

                                          }, 
                                          child:  const Text(
                                                  "Don't have an account? sign Up", 
                                                  style: TextStyle(color: Colors.black),
                                        
                                                  ),
                                        )
                                       
                                        

                                      
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


class LoginData
{
  String? address='';
  String? password='';


  LoginData({this.address, this.password});
  
}

