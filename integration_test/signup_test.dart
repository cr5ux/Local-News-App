import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:localnewsapp/firebase_options.dart';
import 'package:localnewsapp/login.dart';

// import 'package:localnewsapp/main.dart' as app;

import 'package:localnewsapp/signup.dart';




void main()
{
  
   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  //  app.main();
     
  
   group('Duplicate Email Registration',
    ()
    {
        
        testWidgets("test with a duplicate email",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               


                
                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                expect(find.byType(TextFormField).at(4), findsOneWidget);
                expect(find.byType(ElevatedButton).at(0), findsOneWidget);




                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'armatemsamuel@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(1));
                await tester.press(find.byType(ElevatedButton).at(1));

                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.byType(ScaffoldMessenger), findsOneWidget);

               
             


            }
         
         );


/*
        testWidgets("test with a valid email",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );

                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle(const Duration(seconds: 20));
               
     

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);
                expect(find.byType(ElevatedButton).at(0), findsOneWidget);
                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'nevermind@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.press(find.byType(ElevatedButton).at(0),warnIfMissed: true);

                Future.delayed(const Duration(seconds: 8));
               expect(find.byType(ScaffoldMessenger), findsOneWidget);

               await tester.pumpAndSettle();
             


            }
         
         );
*/

    },
    
    
    
    
   );


   group('Password and confirm Passowrd similarity',
    ()
    {
        testWidgets("Password and confirm Passowrd not similar",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);
                expect(find.byType(ElevatedButton).at(0), findsOneWidget);
              
                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1224');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'Abc@1236');

                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(0));
                await tester.press(find.byType(ElevatedButton).at(0));


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.byType(ScaffoldMessenger), findsAny);

               
             


            }
         
         );

/*
      // testWidgets("Password and confirm Passowrd not similar",
      //       (tester) async{


      //           await Firebase.initializeApp(
      //             options: DefaultFirebaseOptions.currentPlatform,
      //           );
                
      //           await tester.pumpWidget(const MaterialApp(home:Signup()));

      //           await tester.pumpAndSettle();

               
      //           expect(find.byType(Signup),findsOneWidget);

      //           expect(find.byType(TextFormField).at(0)), findsOneWidget);
      //           expect(find.byType(TextFormField).at(1), findsOneWidget);
      //           expect(find.byType(TextFormField).at(2), findsOneWidget); 
      //           expect(find.byType(TextFormField).at(3), findsOneWidget);
       expect(find.byType(TextFormField).at(4), findsOneWidget);

                
      //           Future.delayed(const Duration(seconds: 8));
      //           await tester.enterText(find.byType(TextFormField).at(0)), 'TestuserOne');

      //           Future.delayed(const Duration(seconds: 8));
      //           await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

      //           Future.delayed(const Duration(seconds: 8));
      //           await tester.enterText(find.byType(TextFormField).at(2), 'Abc@1234');

      //           Future.delayed(const Duration(seconds: 8));
      //           await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1234');


      //           await tester.pumpAndSettle();
      //           Future.delayed(const Duration(seconds: 8));
      //           expect(find.text("Password and confirm password must be the same"), findsNothing);

               
             


      //       }
         
      //    );
*/

    }
    
    );

  
   group('Password Requirement',
    ()
    {
        
      testWidgets("Doesn't contain Uppercase",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'abcbc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'abcbc@1236');


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("password must contain uppercase letter"), findsAny);

               
             


            }
         
         );


      testWidgets("Does not contain Lower case",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'ABC/1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'ABC/1234');


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("password must contain lowercase letter"), findsAny);

               
             


            }
         
         );


      testWidgets("Does not contain special character",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), '1234Abda');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), '1234Abda');

                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("password must contain special characters"), findsAny);

               
             


            }
         
         );
        
      testWidgets("Does not contain number",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'abc@EIGH');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'abc@EIGH');



                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("password must contain number"), findsAny);

            }
         
         );

      testWidgets("Less than 8 characters",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'xyzx@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), '12@8rtG');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), '12@8rtG');


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("Minimum of  8 characters required"),findsAny);

            }
         
         );


    }
    
    );


   group('Empty password field validation',
    ()
    {
        
        testWidgets("Empty password field",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'armatemsamuel@gmail.com');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), '');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), '');


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("Password is required"), findsAny);

               
             


            }
         
         );


   


    }
    
    );

 
   group('Email requirements',
    (){
        testWidgets("Empty email field",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                 expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), '');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'Abc@1234');


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("Item is Required"), findsOneWidget);

               
             


            }
         
         );

        testWidgets("incorrect email format without @",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'jdaksfhlkdshfk.fcsd');

                 Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'Abc@1234');

                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("Input needs to be email address"), findsOneWidget);

               
             


            }
         
         );

        testWidgets("incorrect email format without .",
            (tester) async{


                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                
                await tester.pumpWidget(const MaterialApp(home:Signup()));

                await tester.pumpAndSettle();

               
                expect(find.byType(Signup),findsOneWidget);

                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(TextFormField).at(2), findsOneWidget); 
                expect(find.byType(TextFormField).at(3), findsOneWidget);
                expect(find.byType(TextFormField).at(4), findsOneWidget);

                
                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), 'TestuserOne');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'jdaksfhlkdshfk@fcsd');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(2), '+251748596327');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(3), 'Abc@1234');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(4), 'Abc@1234');


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 8));
                expect(find.text("Input needs to be email address"), findsOneWidget);

               
             


            }
         
         );
    });

    group('Login?',(){
       testWidgets("go to login page",
            (tester) async{

              

                await tester.pumpWidget(const MaterialApp(home:Signup()));
                await tester.pumpAndSettle();

           
                expect(find.byType(ElevatedButton).at(1), findsOneWidget);
                

                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(1));
                await tester.tap(find.byType(ElevatedButton).at(1));



                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 4));
                expect(find.byType(Login),findsOneWidget);

               
            }
      );


  });


}