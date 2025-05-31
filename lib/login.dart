import 'package:localnewsapp/dataAccess/authentication_repo.dart';
import 'package:localnewsapp/homecontainer.dart';
import 'package:flutter/material.dart';
import 'package:localnewsapp/reset_password.dart';
import 'package:localnewsapp/signup.dart';
import 'package:string_validator/string_validator.dart';
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
  List<bool> isEmail = [true, false];
  bool passwordvisible = true;
  bool isEnable = true;
  bool isFormValid = false; // Add this

  final access = AuthenticationRepo();

  // ignore: non_constant_identifier_names
  String? validateitemrequired(String value) {
    return value.isEmpty ? 'item_required'.tr() : null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'item_required'.tr();
    } else if (!value.isEmail) {
      return 'input_email'.tr();
    }
    return null;
  }

  void _submitOrder(
      {required BuildContext context, bool fullscreenDialog = false}) async {
    String? result = "";
    setState(() {
      isEnable = false;
    });

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (isEmail[0]) {
        result = await access.loginwithEmailandPassword(
            _logindata.address, _logindata.password);

        if (!result.contains("Failure")) {
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: fullscreenDialog,
                  builder: (context) => const HomeContainer(title: 'Zena')));
        } else {
          setState(() {
            isEnable = true;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(result)));
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
                  'assets/bk.png',
                  fit: BoxFit.cover,
                ),
              ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
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
                          "login".tr(),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "signin".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.text.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "email".tr(),
                            labelText: "email".tr(),
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                            ),
                          ),
                          validator: (value) => validateEmail(value!),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _logindata.address = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "password".tr(),
                            labelText: "password".tr(),
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                            ),
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
                          validator: (value) => validateitemrequired(value!),
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
                                MaterialPageRoute(builder: (context) => ResetPassword()),
                              );
                            },
                            child: Text(
                              "forgot_password".tr(),
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56, // Increased height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            onPressed: (isEnable && isFormValid)
                                ? () => _submitOrder(context: context, fullscreenDialog: false)
                                : null,
                            child: isEnable
                                ? Text(
                                    "login".tr(),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  )
                                : const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "dont_have_account".tr(),
                              style: TextStyle(color: AppColors.text.withOpacity(0.7)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Signup()),
                                );
                              },
                              child: Text(
                                "signup".tr(),
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed: () {
                            context.setLocale(
                              context.locale.languageCode == 'en'
                                  ? const Locale('am')
                                  : const Locale('en'),
                            );
                          },
                          icon: const Icon(Icons.language_outlined, color: Colors.black),
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

class LoginData {
  String? address = '';
  String? password = '';

  LoginData({this.address, this.password});
}
