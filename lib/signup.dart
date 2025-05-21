
import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/authentication_repo.dart';
import 'package:localnewsapp/dataAccess/dto/login_dto.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/login.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State <Signup> createState() =>  SignupState();
}

class  SignupState extends State <Signup> {

  final GlobalKey<FormState> _formStateKey =GlobalKey<FormState>();

  Users user = Users(uniqueID: "", phonenumber: "", isAdmin: false, fullName: "");
  LoginDTO logdto = LoginDTO();

  final ur = UsersRepo();
  final auth = AuthenticationRepo();

  String? validateitemrequired(String value){
    
    return  value.isEmpty?'Item is Required':null;
  }
  void _onSubmit({required BuildContext context, bool fullscreenDialog = false}) async
  {
    if(_formStateKey.currentState!.validate())
    {
      _formStateKey.currentState!.save();

       String? value = await auth.adduser(logdto.email, logdto.password);
        if (value != null && value.startsWith("failure"))
        {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
        }
        else if (value != null)
        {
            user.uniqueID = value;
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
                                      style: TextStyle(fontSize: 48),
                                    ),

                                  const Padding(padding: EdgeInsets.all(20.0)),

                                  TextFormField(

                                      decoration:  const InputDecoration(
                                          hintText:"Full Name" ,
                                          label: Text("Full Name"),
                                          icon: Icon(Icons.person),
                                          constraints: BoxConstraints(maxHeight: 80, maxWidth: 500),

                                      ),
                                      validator: (value)=>validateitemrequired(value!),
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

                                      validator: (value) => validateitemrequired(value!),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (value) => logdto.email=value!,
                                  ),

                                  const Padding(padding: EdgeInsets.all(20.0)),

                                  TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Phone Number",
                                        label: Text("Phone Number"),
                                        icon: Icon(Icons.numbers),
                                        constraints: BoxConstraints(maxHeight: 80, maxWidth: 500) 
                                      ),

                                      validator: (value) => validateitemrequired(value!),
                                      keyboardType: TextInputType.phone,
                                      onSaved: (value) => user.phonenumber=value!,
                                  ),

                                  const Padding(padding: EdgeInsets.all(20.0)),

                                  TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        label: Text("Password"),
                                        icon: Icon(Icons.password),
                                        constraints: BoxConstraints(maxHeight: 80, maxWidth: 500) 
                                      ),

                                      validator: (value) =>validateitemrequired(value!),
                                      keyboardType: TextInputType.phone,
                                      onSaved: (value) => logdto.password=value!,
                                      obscureText: true,
                                  ),

                                  const Padding(padding: EdgeInsets.all(20.0)),

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