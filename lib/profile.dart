import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:localnewsapp/activity.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/settings.dart';
import 'package:localnewsapp/pages/favorites_page.dart';
import 'package:localnewsapp/pages/offline_reading_page.dart';
import 'package:localnewsapp/pages/read_later_page.dart';
import 'package:localnewsapp/pages/blocked_users_page.dart';
import 'package:localnewsapp/pages/language_settings_page.dart';
import 'package:localnewsapp/pages/feedback_page.dart';
import 'package:localnewsapp/providers/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  Users userInfo = Users(uniqueID: "", isAdmin: false, fullName: "");

  // int reputation = 0;
  // int followings = 0;
  // int followers = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uR = UsersRepo();
    userInfo = await uR.getAUserByuniqueID(user!.uid);
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${user!.email}'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()),
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
                        FutureBuilder(
                            future: _loadUserData(),
                            builder: (context, snapshot) {
                              return Text(
                                userInfo.fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            })
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Menu items
              _buildMenuItem(Icons.local_activity, 'activities'.tr(),
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Activity()),
                );
              }),
              _buildMenuItem(Icons.star_border, 'favorites'.tr(), onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritesPage()),
                );
              }),
              _buildMenuItem(Icons.offline_pin_outlined, 'offline_reading'.tr(),
                  subtitle: 'offline_reading_subtitle'.tr(), onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OfflineReadingPage()),
                );
              }),
              _buildMenuItem(Icons.access_time, 'read_it_later'.tr(),
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReadLaterPage()),
                );
              }),
              _buildMenuItem(Icons.block, 'blocked_users'.tr(), onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BlockedUsersPage()),
                );
              }),
              _buildMenuItem(Icons.language, 'country_language'.tr(),
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageSettingsPage()),
                );
              }),
              _buildMenuItem(Icons.dark_mode, 'dark_mode'.tr(),
                  trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ), onTap: () {}),
              _buildMenuItem(Icons.star_rate, 'rate_us'.tr(), onTap: () async {
                final Uri url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.localnewsapp');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              }),
              _buildMenuItem(
                  Icons.feedback_outlined, 'suggestions_feedback'.tr(),
                  hasNotification: true, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackPage()),
                );
              }),

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
