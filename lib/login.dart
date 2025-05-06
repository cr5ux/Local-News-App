
import 'package:localnewsapp/homecontainer.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final GlobalKey<FormState>  _formStateKey = GlobalKey<FormState>();

  final LoginData _logindata = LoginData();

  // ignore: non_constant_identifier_names
  String? _validate_item_required(String value){
    
    return  value.isEmpty?'Item is Required':null;
  }
  // ignore: non_constant_identifier_names
  String? _validate_item_email(String value)
  {
      if(value.isEmpty)
      {
        return "Item is required";
      }
      else if(!(value.contains('@')&& value.contains('.')&&value.indexOf('@')>0&& value.indexOf('.')>0 ) )
      {
        return "Wrong Email format";
      }
      return null;
   
  
  }

  void submitOrder()
  {
    List<LoginData> ld= [
      LoginData(emailAddress:"ab@gmail.com" ,password:"12345678"),
      LoginData(emailAddress:"cd@gmail.com" , password:"12345678"),
      LoginData(emailAddress:"ef@gmail.com" , password:"12345678")

    ];
  
  
    bool isfound=false;
    if(_formStateKey.currentState!.validate())
    {
      _formStateKey.currentState!.save();
      for (var element in ld) {
          
           //print(element);
           if(_logindata.emailAddress==element.emailAddress && _logindata.password==element.password)
           {
               isfound=true;
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successful login!! \n Email is  ${_logindata.emailAddress}\n password  ${_logindata.password} ')));
              
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeContainer(title:'Zena'))); 
           }
          
        }

      if(!isfound)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('wrong Email or password \n Email is  ${_logindata.emailAddress}\n password  ${_logindata.password} ')));
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
                                                      hintText: "Email Address",
                                                      label: Text("Email"),
                                                      icon: Icon(Icons.person),
                                                      constraints: BoxConstraints(maxHeight: 80, maxWidth: 500)
                                              
                                            ),
                                            validator:(value)=> _validate_item_email(value!),
                                            keyboardType: TextInputType.emailAddress,
                                            onSaved:(value)=>_logindata.emailAddress=value
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

                                        const Padding(padding: EdgeInsets.all(20.0)),


                                        const Text(
                                          "Forget password?",
                              
                                        ),
                                        
                                        const Padding(padding: EdgeInsets.all(20.0)),

                                        SizedBox(
                                          
                                          width: 250.0,
                                          
                                          child:ElevatedButton(
                                                    onPressed: submitOrder, 
                                                    style:const ButtonStyle(
                                                      backgroundColor:WidgetStatePropertyAll<Color>(Colors.black),
                                                      foregroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                                             
                                                    ),
                                                    child:const Text("Log in",style:TextStyle(fontSize: 16.0),)
                                                  ),
                                        ),

                                        const Padding(padding: EdgeInsets.all(10.0)),


                                        const Text(
                                          "Don't have an account? sign Up",
                    
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


class LoginData
{
  String? emailAddress='';
  String? password='';


  LoginData({this.emailAddress, this.password});
  
}
