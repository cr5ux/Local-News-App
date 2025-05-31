import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localnewsapp/business/identification.dart';
import 'package:localnewsapp/dataAccess/authentication_repo.dart';
import 'package:localnewsapp/dataAccess/dto/login_dto.dart';
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
  State<Signup> createState() => SignupState();
}

class SignupState extends State<Signup> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Users user = Users(uniqueID: "", isAdmin: false, fullName: "");
  LoginDTO logdto = LoginDTO();

  final ur = UsersRepo();
  final auth = AuthenticationRepo();

  bool passwordvisible = true;
  bool confirmvisible = true;
  String confirmPassword = "";

  bool isEnable = true;
  bool isFormValid = false; // Add this

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Item is Required';
    } else if (!value.isEmail) {
      return "input_email".tr();
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
    setState(() {
      isEnable = false;
    });

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (confirmPassword != logdto.password) {
        setState(() {
          isEnable = true;
        });
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text("password_and_confirm".tr())));
      } else {
        String? value = await auth.adduser(logdto.email, logdto.password);
        if (value != null && value.startsWith("failure")) {
          setState(() {
            isEnable = true;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value)));

          auth.deleteUser();
        } else if (value != null) {
          user.uniqueID = value;
          user.isAdmin = false;

          String result = await ur.addUser(user);

          if (result.startsWith("failure")) {
            setState(() {
              isEnable = true;
            });

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(result)));

            auth.deleteUser();
          } else {
            user = await ur.getAUserByuniqueID(user.uniqueID);

            Identification().userID = user.userID!;

            Identification().isAdmin = user.isAdmin;

            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: fullscreenDialog,
                    builder: (context) => const SplashScreen()));
          }
        }
      }
    }
  }

  void _onFormChanged() {
    setState(() {
      isFormValid = _formStateKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                    onChanged: _onFormChanged, // Add this
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 800),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Image.asset(
                              'assets/logo.png',
                              height: 80,
                            ),
                          ),
                        ),
                        Text(
                          "signup".tr(),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "create_account".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.text.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 32),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 900),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "full_name".tr(),
                              labelText: "full_name".tr(),
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
                            ),
                            validator: (value) => validateFullName(value!),
                            keyboardType: TextInputType.name,
                            onSaved: (value) => user.fullName = value!,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 950),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "email".tr(),
                              labelText: "email".tr(),
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
                            ),
                            validator: (value) => validateEmail(value!),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => logdto.email = value!,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 1000),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "password".tr(),
                                  labelText: "password".tr(),
                                  prefixIcon: const Icon(Icons.lock_outline),
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
                                validator: (value) => validatePassword(value!),
                                keyboardType: TextInputType.text,
                                onSaved: (value) => logdto.password = value!,
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
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 1050),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "confirm_password".tr(),
                                  labelText: "confirm_password".tr(),
                                  prefixIcon: const Icon(Icons.lock_outline),
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
                                validator: (value) => validatePassword(value!),
                                keyboardType: TextInputType.text,
                                onSaved: (value) => confirmPassword = value!,
                                obscureText: confirmvisible,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    confirmvisible = !confirmvisible;
                                  });
                                },
                                icon: confirmvisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56, // Increased height
                          child: ElevatedButton(
                            onPressed: (isEnable && isFormValid)
                                ? () => _onSubmit(
                                      context: context,
                                      fullscreenDialog: false,
                                    )
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
                                ? Text(
                                    "register".tr(),
                                    style: const TextStyle(fontSize: 20.0),
                                  )
                                : const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const Login()));
                          },
                          child: Text(
                            "do_have_account".tr(),
                            style: TextStyle(color: AppColors.primary),
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
    );
  }
}
