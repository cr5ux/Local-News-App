// import 'package:localnewsapp/homecontainer.dart';
// import 'package:localnewsapp/dataAccess/authentication_repo.dart';
// import 'package:localnewsapp/homecontainer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localnewsapp/dataAccess/serverside_repo.dart';
import 'package:localnewsapp/forget_password.dart';
import 'package:localnewsapp/otp_screen.dart';
// import 'package:localnewsapp/reset_password.dart';
import 'package:localnewsapp/signup.dart';
import 'package:string_validator/string_validator.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:localnewsapp/constants/app_colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final LoginData _logindata = LoginData();

  bool isEmail = true;

  bool passwordvisible = true;
  bool isEnable = true;

  final access = ServerRepo();

  // List<bool> isEmail=[true,false];
  // final  access= AuthenticationRepo();

  // String? validateitemrequired(String value) {
  //   if (value.isEmail) {
  //     validateEmail(value);
  //     setState(() {
  //       isEmail = true;
  //     });
  //   } else if (value.isNumeric) {
  //     setState(() {
  //       isEmail = false;
  //     });
  //     return value.isEmpty ? 'Item is Required' : null;
  //   }
  //   return null;
  // }

String? validateitemrequired(String value) {
  if (value.isEmail) {
    validateEmail(value);
    isEmail = true; // Update state without calling setState
  } else if (value.isNumeric) {
    isEmail = false; // Update state without calling setState
    return value.isEmpty ? 'Item is Required' : null;
  }
  return null;
}

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Item is Required';
    }
    // else if(!value.isEmail)
    // {
    //   return "Input needs to be email address";
    // }
    return null;
  }

  void _submitOrder({required BuildContext context, bool fullscreenDialog = false}) async {
    Response result;

    setState(() {
      isEnable = true;
    });

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      /*
      if(isEmail)
      {
          result= await access.loginwithEmailandPassword( _logindata.address,  _logindata.password);
          
          if(!result.contains("Failure"))
          {
                // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog,builder: (context)=>const HomeContainer(title:'Zena')));
          }
          else
          {
            
            setState(() {
                isEnable=true;
            });
             // ignore: use_build_context_synchronously
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
          }
          
      }
      // else if(!isEmail)
      // {
        
      // }
      */

      result = await access.sendLoginRequest(_logindata.address, _logindata.password);

      if (result.body.contains("failure") || result.body.isEmpty) {
        setState(() {
          isEnable = true;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.body)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.body)));
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(fullscreenDialog: fullscreenDialog, builder: (context) => OtpScreen(phonenumber: _logindata.address)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 2000;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500, // Limit width to a phone size
              maxHeight: 1000, // Limit height to a phone size
            ),
            child: Stack(
              children: [
                if (isMobile)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/bk.png',
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
                              "Log in",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Sign in to your account",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "+251947586952",
                                label: const Text("Phonenumber"),
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
                              ),
                              validator: (value) => validateEmail(value!),
                              keyboardType: TextInputType.emailAddress,
                               onChanged: (value) {
                                setState(() {
                                  isEmail = value.isEmail;
                                });
                              },
                              onSaved: (value) => _logindata.address = value,
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
                                  ),
                                  validator: (value) => validateitemrequired(value!),
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) => _logindata.password = value!,
                                  obscureText: passwordvisible,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordvisible = !passwordvisible;
                                    });
                                  },
                                  icon: passwordvisible
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                              ],
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                                },
                                child: const Text(
                                  "Forget password?",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isEnable && _formStateKey.currentState?.validate() == true
                                    ? () => _submitOrder(context: context, fullscreenDialog: false)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                                child: isEnable ? const Text("Send OTP", style: TextStyle(fontSize: 18.0)) : const Center(child: CircularProgressIndicator()),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                                },
                                child: const Text(
                                  "Don't have an account? Sign Up",
                                  style: TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }
}

class LoginData {
  String? address = '';
  String? password = '';

  LoginData({this.address, this.password});
}
