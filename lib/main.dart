import 'package:flutter/material.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:localnewsapp/login.dart';
import 'package:localnewsapp/providers/theme_provider.dart';
import 'package:localnewsapp/providers/offline_reading_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  await Supabase.initialize(
    url: 'https://wrjezauosaqittnvpzsf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyamV6YXVvc2FxaXR0bnZwenNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3Mjg3MDMsImV4cCI6MjA2MzMwNDcwM30.zjGIB2PwYZpI_oqPACQYV0Bp4pujAdoKs0WtI1aM_w4',
  );

  final prefs = await SharedPreferences.getInstance();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('am')],
      path: 'assets/translations',
      fallbackLocale: const Locale('am'),
      child: MainApp(prefs: prefs),
    ),
  );
}

class MainApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MainApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OfflineReadingProvider(prefs)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Builder(
            builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  primary: AppColors.primary,
                ),
                progressIndicatorTheme: const ProgressIndicatorThemeData(
                  color: AppColors.primary, 
                ),
                useMaterial3: true, 
                // tabBarTheme: const TabBarTheme(
                //   dividerColor: Colors.transparent, 
                // )
              ),
              
              home: const Login(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          );
        },
      ),
    );
  }
}
