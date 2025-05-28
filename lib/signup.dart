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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
              child: Container(
        padding: const EdgeInsets.all(50.0),
        margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0), color: Colors.white),
        child: SingleChildScrollView(
          child: Form(
              key: _formStateKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(children: [
                 Text(
                  "signup".tr(),
                  style: const TextStyle(fontSize: 36),
                ),
                Text(
                  "create_account".tr(),
                  style: const TextStyle(fontSize: 18),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "full_name".tr(),
                    label: Text("full_name".tr()),
                    icon: const Icon(Icons.person),
                    constraints: const BoxConstraints(maxHeight: 80, maxWidth: 500),
                  ),
                  validator: (value) => validateFullName(value!),
                  keyboardType: TextInputType.name,
                  onSaved: (value) => user.fullName = value!,
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "email".tr(),
                      label: Text("email".tr()),
                      icon: const Icon(Icons.email),
                      constraints:
                          const BoxConstraints(maxHeight: 80, maxWidth: 500)),
                  validator: (value) => validateEmail(value!),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => logdto.email = value!,
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "password".tr(),
                          label: Text("password".tr()),
                          icon: const Icon(Icons.password),
                          constraints:
                              const BoxConstraints(maxHeight: 80, maxWidth: 500)),
                      validator: (value) => validatePassword(value!),
                      keyboardType: TextInputType.text,
                      onSaved: (value) => logdto.password = value!,
                      obscureText: passwordvisible,
                    ),
                    const Padding(padding: EdgeInsets.all(20.0)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            passwordvisible
                                ? passwordvisible = false
                                : passwordvisible = true;
                          });
                        },
                        icon: passwordvisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off))
                  ],
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
                Stack(alignment: AlignmentDirectional.topEnd, children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "confirm_password".tr(),
                        label: Text("confirm_password".tr()),
                        icon: const Icon(Icons.password),
                        constraints:
                            const BoxConstraints(maxHeight: 80, maxWidth: 500)),
                    validator: (value) => validatePassword(value!),
                    keyboardType: TextInputType.text,
                    onSaved: (value) => confirmPassword = value!,
                    obscureText: confirmvisible,
                  ),
                  const Padding(padding: EdgeInsets.all(20.0)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          confirmvisible
                              ? confirmvisible = false
                              : confirmvisible = true;
                        });
                      },
                      icon: confirmvisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off))
                ]),
                const Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: 250.0,
                  child: ElevatedButton(
                      onPressed: isEnable
                          ? () => _onSubmit(
                                context: context,
                                fullscreenDialog: false,
                              )
                          : null,
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.black),
                        foregroundColor:
                            WidgetStatePropertyAll<Color>(Colors.white),
                      ),
                      child: isEnable
                          ? Text(
                              "register".tr(),
                              style: const TextStyle(fontSize: 16.0),
                            )
                          : const Center(child: CircularProgressIndicator())),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.white),
                    shadowColor:
                        WidgetStatePropertyAll<Color>(Colors.transparent),
                    overlayColor:
                        WidgetStatePropertyAll<Color>(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Text(
                    "do_have_account".tr(),
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ])),
        ),
      ))),
    );
  }
}
