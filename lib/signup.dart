import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localnewsapp/singleton/identification.dart';
// import 'package:localnewsapp/business/identification.dart';
// import 'package:localnewsapp/dataAccess/authentication_repo.dart';
// import 'package:localnewsapp/dataAccess/dto/login_dto.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/login.dart';
import 'package:localnewsapp/splash_screen.dart';
// import 'package:string_validator/string_validator.dart';
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
      return 'item_required'.tr();
    }
    // else if(!value.isEmail) // isEmail from string_validator might not be available directly. Use a RegExp or other package.
    else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
    {
      return "input_email".tr();
    }
    return null;
    
  }
  String? validatePhone(String value){
    
    if(value.isEmpty)
    {
      return 'item_required'.tr();
    }
    else
    {
      String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
      RegExp regExp = RegExp(pattern);

      if(!regExp.hasMatch(value))
      {
            return "input_phone".tr(); // Consider using .tr()
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
              
            
              
                Identification().userID=result;
                
                Identification().isAdmin=user.isAdmin;
                
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog,builder: (context)=>const SplashScreen())); 
            }
            
  /* }  */
            
            
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

  // Define a common InputDecoration style for text fields
  InputDecoration modernInputDecoration({
    required String labelText,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      label: Text(labelText),
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade700),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    );
  }


  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(

        child: Center(
          child: Container(

            

            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0), // This seems to be for an outer container, not the text fields
                  color: AppColors.background,

            ),
            constraints: BoxConstraints(
            
              maxWidth: 500, // Limit width to a phone size
              maxHeight: height, // Limit height to a phone size
            ),
            child: Stack(
              children: [
                if (isMobile) // Assuming bk2.png is a background for the whole screen section
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
                      Text(
                        "signup".tr(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "create_account".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 32), // Increased spacing before first field

                      TextFormField(
                        decoration: modernInputDecoration(
                          labelText: "full_name".tr(),
                          hintText: "full_name".tr(),
                          prefixIcon: const Icon(Icons.person, color: AppColors.primary,),
                        ),
                        validator: (value) => validateFullName(value!),
                        keyboardType: TextInputType.name,
                        onSaved: (value) => user.fullName = value!,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: modernInputDecoration(
                          labelText: "email".tr(),
                          hintText: "email".tr(),
                          prefixIcon: const Icon(Icons.email, color: AppColors.primary,),
                        ),
                        validator: (value) => validateEmail(value!),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => user.email = value!,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: modernInputDecoration(
                          labelText: "phone_number".tr(),
                          hintText: "enter_phone_number".tr(),
                          prefixIcon: const Icon(Icons.phone, color: AppColors.primary,),
                        ),
                        validator: (value) => validatePhone(value!),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => user.phonenumber = value!,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: modernInputDecoration(
                          labelText: "password".tr(),
                          hintText: "enter_password".tr(),
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary,), // Changed icon for visual variety
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordvisible ? Icons.visibility : Icons.visibility_off, 
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordvisible = !passwordvisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) => validatePassword(value!),
                        onChanged: (value) { // Keep onChanged if needed for immediate updates to user.password
                           setState(() {
                             user.password = value; 
                           });
                        },
                        onSaved: (value) => user.password = value!, // onSaved is also important
                        obscureText: passwordvisible,
                        keyboardType: TextInputType.text,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: modernInputDecoration(
                          labelText: "confirm_password".tr(),
                          hintText: "re_enter_your_password".tr(),
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary,), // Changed icon
                           suffixIcon: IconButton(
                            icon: Icon(
                              confirmvisible ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                confirmvisible = !confirmvisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) { // Also validate confirm password
                          if (value == null || value.isEmpty) {
                            return "password_required".tr();
                          }
                          if (value != user.password) {
                            return "passwords_do_not_match".tr(); // Add localization
                          }
                          return validatePassword(value); // Also apply general password rules
                        },
                        onChanged: (value) {
                           setState(() {
                             confirmPassword = value; 
                           });
                        },
                        onSaved: (value) => confirmPassword = value!,
                        obscureText: confirmvisible,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 32), // Increased spacing before button

                      SizedBox(

                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isEnable && (_formStateKey.currentState?.validate() ?? false)
                              ? () => _onSubmit(context: context, fullscreenDialog: false)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary, // Changed to primary color
                            foregroundColor: Colors.white,        // Changed to white for better contrast
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // Consistent rounding
                            ),
                            elevation: 4,
                            textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)
                          ),
                          child: isEnable
                              ? Text("register".tr()) // Removed style, inherits from button's textStyle
                              : const Center(child: CircularProgressIndicator(color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton( // This could be an OutlinedButton or TextButton for secondary action
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(color: AppColors.primary, width: 1.5) // Added border
                            ),
                            elevation: 2,
                            textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                          },
                          child: Text(
                            "do_have_account".tr(),
                            // style: TextStyle(color: Colors.black), // Removed, inherits from foregroundColor
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