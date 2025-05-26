import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country & Language'),
      ),
      body: const Center(
        child: Text('Language settings content will be implemented here'),
      ),
    );
  }
}
