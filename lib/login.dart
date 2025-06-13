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
// import 'package:string_validator/string_validator.dart';
import 'package:easy_localization/easy_localization.dart';
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
      isEnable = false;
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

      result = await access.sendLoginRequest(
          _logindata.address, _logindata.password);

      if (result.body.contains("failure") || result.body.isEmpty) {
        setState(() {
          isEnable = true;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.body)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.body)));
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                fullscreenDialog: fullscreenDialog,
                builder: (context) =>
                    OtpScreen(phonenumber: _logindata.address)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 501;
    final double height = MediaQuery.of(context).size.height;

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
                      'assets/bk.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 32.0),
                      child: Form(
                        key: _formStateKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/logo.png', height: 80),
                            const SizedBox(height: 24),
                            Text(
                              "login".tr(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "signin".tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.setLocale(context.locale.languageCode == 'en'
                                    ? const Locale('am')
                                    : const Locale('en'));
                              },
                              child: Text(
                                context.locale.languageCode == 'en' ? 'አማ' : 'En',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              decoration: modernInputDecoration(
                                labelText: "phone_number".tr(),
                                hintText: "+251912345678", 
                                prefixIcon: const Icon(Icons.phone, color: AppColors.primary,),
                              ),
                              validator: (value) => validateitemrequired(value!), // Use the corrected validator
                              keyboardType: TextInputType.phone, // Correct keyboard type
                              onSaved: (value) => _logindata.address = value,
                              // Removed the 'onChanged' that was setting 'isEmail'
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              decoration: modernInputDecoration(
                                labelText: "password".tr(),
                                hintText: "enter_your_password".tr(),
                                prefixIcon: const Icon(Icons.lock_outline), // Consistent icon
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordvisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, // Using outlined icons
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordvisible = !passwordvisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                      validateitemrequired(value!), // Use a clear password validator
                              keyboardType: TextInputType.text,
                              onSaved: (value) => _logindata.password = value!,
                              obscureText: passwordvisible,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                child: Text(
                                  "forgot_password".tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isEnable &&
                                        _formStateKey.currentState
                                                ?.validate() ==
                                            true
                                    ? () => _submitOrder(
                                        context: context,
                                        fullscreenDialog: false)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                                child: isEnable
                                    ? Text("send_otp".tr(),
                                        style: const TextStyle(fontSize: 18.0))
                                    : const Center(
                                        child: CircularProgressIndicator()),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Signup()));
                                },
                                child: Text(
                                  "dont_have_account".tr(),
                                  style: const TextStyle(color: Colors.white),
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
