 
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:localnewsapp/login.dart';
import 'package:localnewsapp/otp_screen.dart';


// import 'package:localnewsapp/homecontainer.dart';

import 'package:localnewsapp/reset_password.dart';

import 'package:localnewsapp/main.dart' as app;
import 'package:localnewsapp/signup.dart';




void main()
{
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('Login Credential testing',
     ()  {


        
      testWidgets("test login with invalid credential",
            (tester) async{

              

                 await tester.pumpWidget(const MaterialApp(home:Login()));
               
                 await tester.pumpAndSettle(const Duration(seconds: 15));
           
                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                expect(find.byType(ElevatedButton).at(1), findsOneWidget);
                
                
                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(0), '+25124415315');

                Future.delayed(const Duration(seconds: 8));
                await tester.enterText(find.byType(TextFormField).at(1), 'Abc21235');


                
                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(1));
                await tester.tap(find.byType(ElevatedButton).at(1));


                await tester.pumpAndSettle();
              

                Future.delayed(const Duration(seconds: 10));
                expect(find.byType(ScaffoldMessenger), findsOneWidget);

                

            }
      );

      testWidgets("test login with valid credential",
            (tester) async{

             
                
               
                await tester.pumpWidget(const MaterialApp(home:Login()));
                
                await tester.pumpAndSettle();

           
                expect(find.byType(TextFormField).at(0), findsOneWidget);
                expect(find.byType(TextFormField).at(1), findsOneWidget);
                 expect(find.byType(ElevatedButton).at(1), findsOneWidget);
                
                
                Future.delayed(const Duration(seconds: 4));
                await tester.enterText(find.byType(TextFormField).at(0), '+251924415315');

                Future.delayed(const Duration(seconds: 4));
                await tester.enterText(find.byType(TextFormField).at(1), 'Abc@1234');


                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(1));
                await tester.tap(find.byType(ElevatedButton).at(1));
              

                await tester.pumpAndSettle();

                Future.delayed(const Duration(seconds: 4));
                
                Future.delayed(const Duration(seconds: 10));
                expect(find.byType(OtpScreen), findsOneWidget);

               
            }
      );
});
 
 group('FOrget password?',(){
       testWidgets("go to reset page",
            (tester) async{

              

                await tester.pumpWidget(const MaterialApp(home:Login()));
                await tester.pumpAndSettle();

           
                expect(find.byType(ElevatedButton).at(0), findsOneWidget);
                

                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(0));
                await tester.tap(find.byType(ElevatedButton).at(0));



                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 4));
                expect(find.byType(ResetPassword),findsOneWidget);

               
            }
      );


});



 group('signup?',(){
       testWidgets("go to signup page",
            (tester) async{

              
               

                await tester.pumpWidget(const MaterialApp(home:Login()));
                await tester.pumpAndSettle();

           
                expect(find.byType(ElevatedButton).at(2), findsOneWidget);
                

                Future.delayed(const Duration(seconds: 8));
                await tester.ensureVisible(find.byType(ElevatedButton).at(2));
                await tester.tap(find.byType(ElevatedButton).at(2));


                await tester.pumpAndSettle();
                Future.delayed(const Duration(seconds: 4));
                expect(find.byType(Signup),findsOneWidget);

               
            }
      );


});

}


