import 'package:flutter/material.dart';
import 'package:localnewsapp/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://wrjezauosaqittnvpzsf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyamV6YXVvc2FxaXR0bnZwenNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3Mjg3MDMsImV4cCI6MjA2MzMwNDcwM30.zjGIB2PwYZpI_oqPACQYV0Bp4pujAdoKs0WtI1aM_w4',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
       home:Login()// HomeContainer(title: 'Home',),
    );

  }
}

