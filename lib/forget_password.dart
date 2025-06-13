// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:localnewsapp/constants/app_colors.dart';
// // import 'package:localnewsapp/dataAccess/authentication_repo.dart';
// import 'package:localnewsapp/dataAccess/serverside_repo.dart';

// import 'package:string_validator/string_validator.dart';
// import 'package:easy_localization/easy_localization.dart';

// // ignore: must_be_immutable
// class ForgetPassword extends StatelessWidget {
  
//     final GlobalKey<FormState>  _formStateKey = GlobalKey<FormState>();
//   String email="", message="";


//   ForgetPassword({super.key});


//  String? validateEmail(String value){
    
//     if(value.isEmpty)
//     {
//       return 'item_required'.tr();
//     }
//     else if(!value.isEmail)
//     {
//       return "input_email".tr();
//     }
//     return null;
   
//   }
//   Future<void> sendLink(context) async {

//     if(_formStateKey.currentState!.validate())
//     {
//       _formStateKey.currentState!.save();
          
//         // final  access= AuthenticationRepo();

//         // message= await access.resetPassword(email);

//         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        
//         // Future.delayed(const Duration(seconds:2));
        
//         // Navigator.pop(context);


//         final access= ServerRepo();

//         Response message= await access.sendPasswordResetRequest(email);
        
//         if(message.body.contains("New password was sent to ur email"))
//         {
//              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.body)));
        
//               Future.delayed(const Duration(seconds:2));
              
//               Navigator.pop(context);
//         }
//         else
//         {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.body))); 
//         }
//     }

    
//   }
//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 501;
//     final double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//         centerTitle: true,
//         title: Image.asset(
//           'assets/logow.png', // Logo in the center
//           height: 40,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50.0),
//               color: AppColors.background,
//             ),
//             constraints: BoxConstraints(
//               maxWidth: 500, // Limit width to a phone size
//               maxHeight: height, // Limit height to a phone size
//             ),
//             child: Stack(
//               children: [
//                 if (isMobile)
//                   Positioned.fill(
//                     child: Image.asset(
//                       'assets/bk4.png', // Background image
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 Center(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
//                       child: Form(
//                         key: _formStateKey,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               "Reset Password",
//                               style: TextStyle(
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 hintText: "Enter your email",
//                                 label: const Text("Email"),
//                                 prefixIcon: const Icon(Icons.email),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: const BorderSide(color: Colors.white, width: 2),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: const BorderSide(color: Colors.white, width: 2),
//                                 ),
//                                 constraints: const BoxConstraints(maxHeight: 80, maxWidth: 500),
//                               ),
//                               validator:(value)=> validateEmail(value!),
//                               keyboardType: TextInputType.emailAddress,
//                                onSaved:(value)=>email=value!
//                             ),
//                             const SizedBox(height: 24),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: ElevatedButton(
//                                 onPressed:()=>sendLink(context),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.primary,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   elevation: 4,
//                                 ),
//                                 child: const Text(
//                                    "Reset Password".tr(), 
//                                   style: TextStyle(fontSize: 18.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/dataAccess/serverside_repo.dart';
import 'package:string_validator/string_validator.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatelessWidget {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String email = "", message = "";

  ForgetPassword({super.key});

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'item_required'.tr();
    } else if (!value.isEmail) {
      return "input_email".tr();
    }
    return null;
  }

  Future<void> sendLink(context) async {
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      final access = ServerRepo();

      Response message = await access.sendPasswordResetRequest(email);

      if (message.body.contains("New password was sent to your email")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.body)));

        Future.delayed(const Duration(seconds: 2));

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.body)));
      }
    }
  }
@override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 501;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/logow.png', // Logo in the center
          height: 40,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                      'assets/bk4.png', // Background image
                      fit: BoxFit.cover,
                    ),
                  ),
                   Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formStateKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "reset_password".tr(),
                          style: const TextStyle(fontSize: 36),
                        ),

                       const SizedBox(height: 20),

                       Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

                              child: TextFormField(
                                
                                decoration: InputDecoration(
                                  hintText: "email".tr(),
                                  label: Text("email".tr()),
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
                                onSaved: (value) => email = value!,
                              
                              ),
                        ),
                                                    const SizedBox(height: 20),
                        SizedBox(
                          width: 250.0,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => sendLink(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "reset_password".tr(),
                            ),
                          ),
                        ),
                      ],
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




