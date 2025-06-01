import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localnewsapp/business/identification.dart';
// import 'package:localnewsapp/business/identification.dart';
// import 'package:localnewsapp/dataAccess/authentication_repo.dart';
// import 'package:localnewsapp/dataAccess/dto/login_dto.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/login.dart';
import 'package:localnewsapp/splash_screen.dart';
import 'package:string_validator/string_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:localnewsapp/constants/app_colors.dart';


class Signup extends StatefulWidget {

  const Signup({super.key});

  @override
  State <Signup> createState() =>  SignupState();


}

class SignupState extends State<Signup> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Users user = Users(isAdmin: false, fullName: "",phonenumber:"", email: '', password: '');
  // LoginDTO logdto = LoginDTO();

  final ur = UsersRepo();
  // final auth = AuthenticationRepo();

  bool passwordvisible = true;
  bool confirmvisible = true;
  String confirmPassword = "";

  bool isEnable = true;
  bool isFormValid = false; // Add this

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
  String? validatePhone(String value){
    
    if(value.isEmpty)
    {
      return 'Item is Required';
    }
    else
    {
      String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
      RegExp regExp = RegExp(pattern);

      if(!regExp.hasMatch(value))
      {
           return "Input needs to be phonenumber";
      }
     
    }
    return null;
   
  }

  String? validateFullName(String value) {
    return value.isEmpty ? "item_required".tr() : null;
  }

String? validatePassword(String value) {
  bool isAlphafound = false;
  bool ischarfound = false;
  bool isLowerFound = false;
  bool isNumberfound = false;
  AsciiEncoder asciiEncoder = const AsciiEncoder();

  if (value.isEmpty) {
    return "password_required".tr();
  } else if (value.isNotEmpty) {
    if (value.length < 8) {
      return "min_8_char".tr();
    }

    var splitvalue = value.split('');

    for (var i in splitvalue) {
      var val = asciiEncoder.convert(i);

      if (val[0] >= 65 && val[0] <= 90) {
        isAlphafound = true;
      }
      if ((val[0] >= 33 && val[0] <= 47) || (val[0] >= 58 && val[0] <= 64)) {
        ischarfound = true;
      }
      if (val[0] >= 48 && val[0] <= 57) {
        isNumberfound = true;
      }
      if (val[0] >= 97 && val[0] <= 122) {
        isLowerFound = true;
      }
    }

    if (!isAlphafound) {
      return "password_uppercase".tr();
    }
    if (!ischarfound) {
      return "password_special".tr();
    }
    if (!isNumberfound) {
      return "password_number".tr();
    }
    if (!isLowerFound) {
      return "password_lowercase".tr();
    }
  }

  return null;
}

  void _onSubmit(
      {required BuildContext context, bool fullscreenDialog = false}) async {
    // setState(() {
    //   isEnable = false;
    // });

    if (_formStateKey.currentState!.validate()) {

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
         /*
        String? value = await auth.adduser(logdto.email, logdto.password);
          if (value != null && value.startsWith("failure"))
          {
           
              setState(() {
                isEnable=true;
              });
                // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
              
              auth.deleteUser();
          }
          else if (value != null)
          { */

             
            

              String result=await ur.addUser(user);

              if (result.startsWith("failure"))
              { 
                setState(() {
                  isEnable=true;
                });
                 
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

              ///  auth.deleteUser();
              }
              else
              {
                // user= await ur.getAUserByuniqueID(user.uniqueID);
             
                  Identification().userID=result;
                  
                  Identification().isAdmin=user.isAdmin;
                  
                // ignore: use_build_context_synchronously
                Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog,builder: (context)=>const SplashScreen())); 
              }
              
   /*   }  */
            
            
        }
      

    }
  }

  // void _onFormChanged() {
  //   setState(() {
  //     isFormValid = _formStateKey.currentState?.validate() ?? false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {

  final isMobile = MediaQuery.of(context).size.width < 501;
  final double height=MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(

        child: Center(
          child: Container(

           

            decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: AppColors.background,

              ),
            constraints: BoxConstraints(
            
              maxWidth: 500, // Limit width to a phone size
              maxHeight: height, // Limit height to a phone size
            ),
            child: Stack(
              children: [
                if (isMobile)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/bk2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                
          Center(
            child: SingleChildScrollView(

              child: Padding(

                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),

                child: Form(

                  key: _formStateKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    
                    children: [

                      Image.asset('assets/logo.png', height: 80),

                      const SizedBox(height: 24),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                     const Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          label: const Text("Full Name"),
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          constraints:const BoxConstraints(maxHeight: 80, maxWidth: 500)
                        ),
                        validator: (value) => validateFullName(value!),
                        keyboardType: TextInputType.name,
                        onSaved: (value) => user.fullName = value!,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          label: const Text("Email"),
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          constraints:const BoxConstraints(maxHeight: 80, maxWidth: 500)
                        ),
                        validator: (value) => validateEmail(value!),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => user.email = value!,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(

                        decoration: InputDecoration(

                          hintText: "Phone Number",
                          label: const Text("Phone Number"),
                          prefixIcon: const Icon(Icons.phone),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          constraints:const BoxConstraints(maxHeight: 80, maxWidth: 500)
                        ),
                        validator: (value) => validatePhone(value!),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => user.phonenumber = value!,
                      ),

                      const SizedBox(height: 20),

                      Stack(

                        alignment: AlignmentDirectional.topEnd,
                        
                        children: [
                          TextFormField(

                            decoration: InputDecoration(
                              hintText: "Password",
                              label: const Text("Password"),
                              prefixIcon: const Icon(Icons.password),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                              constraints:const BoxConstraints(maxHeight: 80, maxWidth: 500)
                            ),
                            validator: (value) => validatePassword(value!),
                            onChanged: (value) {
                              setState(() {
                                user.password = value; // Dynamically update the password
                              });
                            },
                            keyboardType: TextInputType.text,
                            onSaved: (value) => user.password = value!,
                            obscureText: passwordvisible,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                passwordvisible = !passwordvisible; // Toggle visibility
                              });
                            },
                            icon: passwordvisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              label: const Text("Confirm Password"),
                              prefixIcon: const Icon(Icons.password),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                              constraints:const BoxConstraints(maxHeight: 80, maxWidth: 500)
                            ),
                            validator: (value) => validatePassword(value!),
                            onChanged: (value) {
                              setState(() {
                                confirmPassword = value; // Dynamically update the confirm password
                              });
                            },
                            keyboardType: TextInputType.text,
                            onSaved: (value) => confirmPassword = value!,
                            obscureText: confirmvisible,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                confirmvisible = !confirmvisible; // Toggle visibility
                              });
                            },
                            icon: confirmvisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      SizedBox(

                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isEnable && _formStateKey.currentState?.validate() == true
                              ? () => _onSubmit(context: context, fullscreenDialog: false)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: isEnable
                              ? const Text("Register", style: TextStyle(fontSize: 18.0))
                              : const Center(child: CircularProgressIndicator()),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                          },
                          child: const Text(
                            "Do have an account? Login",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
        )
    )
  );
  }
}
