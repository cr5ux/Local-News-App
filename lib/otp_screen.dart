
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localnewsapp/dataAccess/serverside_repo.dart';
import 'package:localnewsapp/homecontainer.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {

  String? phonenumber;
  OtpScreen({super.key,required this.phonenumber});

 
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
   
  final GlobalKey<FormState>  _formStateKey = GlobalKey<FormState>();

  bool isEnable=true;
  final access=ServerRepo();

  // ignore: prefer_typing_uninitialized_variables
  var otp;

  _submitOrder({required BuildContext context, required bool fullscreenDialog})
  async {
      setState(() {
            isEnable=false;
      });
      
    if(_formStateKey.currentState!.validate())
      {
        _formStateKey.currentState!.save();

      Response result=await access.sendOTPVerification(otp,widget.phonenumber);

      if(result.body.contains("failure"))
      {
          setState(() {
              isEnable=true;
        });
         // ignore: use_build_context_synchronously
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.body)));
      }
      else
      {
         // ignore: use_build_context_synchronously
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.body)));
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog,builder: (context)=>const HomeContainer(title:"Zena" ))); 
      }
      
        
      }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        backgroundColor: Colors.black,

        body:SafeArea(

          child:Center(
              
              child: Container(

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
                                          "OTP",
                                          style: TextStyle(fontSize: 48),
                                        ),

                                        const Text(
                                          "otp has been sent",
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        
                                        const Padding(padding: EdgeInsets.all(20.0)),
                                          
                                       

                                        TextFormField(
                                            decoration: const InputDecoration(
                                                      hintText: "OTP",
                                                      label: Text("OTP"),
                                                      icon: Icon(Icons.pin),
                                                      constraints: BoxConstraints(maxHeight: 80, maxWidth: 500)
                                              
                                            ),
                                            onSaved:(value)=>otp=value!,
                                        ),

                                        const Padding(padding: EdgeInsets.all(20.0)),

                                        SizedBox(
                                          
                                          width: 250.0,
                                          
                                          child:ElevatedButton(

                                                    onPressed:()=>isEnable? _submitOrder(context: context,
                                                                fullscreenDialog: false):null, 

                                                    style:const ButtonStyle(

                                                      backgroundColor:WidgetStatePropertyAll<Color>(Colors.black),
                                                      foregroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                                             
                                                    ),
                                                    child:isEnable?const Text("Log in",style:TextStyle(fontSize: 16.0),):const Center(child: CircularProgressIndicator())
                                                  ),
                                        ),

                                        const Padding(padding: EdgeInsets.all(10.0)),

                                    ],
                              ),
                          
                          )
                        ),
             )
          )
        )
        
      );
  }
  

}