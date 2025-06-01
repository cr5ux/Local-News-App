import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: const Center(
        child: Text('Blocked users content will be implemented here'),
      ),
    );
  }
}
