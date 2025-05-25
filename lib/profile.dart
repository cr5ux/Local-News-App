import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;

  int reputation = 0;
  int followings = 0;
  int followers = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          reputation = userData.data()?['reputation'] ?? 0;
          followings = userData.data()?['followings'] ?? 0;
          followers = userData.data()?['followers'] ?? 0;
        });
      }
    }
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {
    String? subtitle,
    Widget? trailing,
    bool hasNotification = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasNotification)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          if (trailing != null) ...[  
            const SizedBox(width: 8),
            trailing,
          ],
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  // Widget _buildNavItem(IconData icon, String label, bool isSelected) {
  //   final color = isSelected ? Colors.red : Colors.grey;
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(icon, color: color),
  //       const SizedBox(height: 4),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           color: color,
  //           fontSize: 12,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with profile info
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('My profile'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user?.photoURL != null 
                            ? NetworkImage(user!.photoURL!) 
                            : null,
                          child: user?.photoURL == null 
                            ? const Icon(Icons.person, size: 30)
                            : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          user?.displayName ?? 'User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('Reputation', reputation.toString()),
                        _buildStatColumn('Followings', followings.toString()),
                        _buildStatColumn('Followers', followers.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              
              // Menu items
              _buildMenuItem(Icons.inbox, 'Inbox', onTap: () {}),
              _buildMenuItem(Icons.star_border, 'Favorites', onTap: () {}),
              _buildMenuItem(
                Icons.offline_pin_outlined, 
                'Offline reading',
                subtitle: 'Read news without the internet', 
                onTap: () {}
              ),
              _buildMenuItem(Icons.access_time, 'Read it later', onTap: () {}),
              _buildMenuItem(Icons.block, 'Blocked users', onTap: () {}),
              _buildMenuItem(Icons.language, 'Country & language', onTap: () {}),
              _buildMenuItem(
                Icons.dark_mode, 
                'Dark mode',
                trailing: const Text('Automatic'),
                onTap: () {}
              ),
              _buildMenuItem(Icons.star_rate, 'Rate us', onTap: () {}),
              _buildMenuItem(
                Icons.feedback_outlined, 
                'Suggestions&Feedback',
                hasNotification: true, 
                onTap: () {}
              ),
              
              // Bottom navigation
              // const SizedBox(height: 16),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 8),
              //   decoration: BoxDecoration(
              //     border: Border(
              //       top: BorderSide(color: Colors.grey.shade300),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       _buildNavItem(Icons.home, 'Home', false),
              //       _buildNavItem(Icons.sports_soccer, 'Football', false),
              //       _buildNavItem(Icons.play_circle_outline, 'Video', false),
              //       _buildNavItem(Icons.video_collection_outlined, 'Clips', false),
              //       _buildNavItem(Icons.person, 'Me', true),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}