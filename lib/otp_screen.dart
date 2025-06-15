import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localnewsapp/dataAccess/serverside_repo.dart';
import 'package:localnewsapp/homecontainer.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/login.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  String? phonenumber;
  OtpScreen({super.key, required this.phonenumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  bool isEnable = true;
  final access = ServerRepo();

  // ignore: prefer_typing_uninitialized_variables
  var otp;

  void _submitOrder(
      {required BuildContext context, required bool fullscreenDialog}) async {
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      setState(() {
        isEnable = false; // Disable the button while processing
      });

      Response result =
          await access.sendOTPVerification(otp, widget.phonenumber);

      if (result.body.contains("failure otp has expired")) {
        setState(() {
          isEnable = true; // Re-enable the button on failure
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.body)));
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                fullscreenDialog: fullscreenDialog,
                builder: (context) => const Login()));
      } else if (result.body.contains("failure")) {
        setState(() {
          isEnable = true; // Re-enable the button on failure
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.body)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.body)));
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            fullscreenDialog: fullscreenDialog,
            builder: (context) => const HomeContainer(title: "Zena"),
          ),
          (route) => false, // This removes all previous routes
        );
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
                      'assets/bk3.png',
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/logo.png', height: 80),
                            const SizedBox(height: 24),
                            const Text(
                              "OTP",
                              style: TextStyle(
                                fontSize: 36,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "OTP has been sent",
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.primary),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "OTP",
                                label: const Text("OTP"),
                                prefixIcon: const Icon(Icons.pin),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "OTP is required";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  otp =
                                      value; // Dynamically update the OTP value
                                  isEnable =
                                      _formStateKey.currentState?.validate() ??
                                          false; // Re-evaluate form validity
                                });
                              },
                              onSaved: (value) => otp = value!,
                            ),
                            const SizedBox(height: 24),
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
                                    ? const Text("Log in",
                                        style: TextStyle(fontSize: 18.0))
                                    : const Center(
                                        child: CircularProgressIndicator()),
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
