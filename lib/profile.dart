import 'package:flutter/material.dart';
import 'package:localnewsapp/singleton/identification.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/dataAccess/dto/user_basic.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/settings.dart';
import 'package:localnewsapp/pages/favorites_page.dart';
import 'package:localnewsapp/pages/offline_reading_page.dart';
import 'package:localnewsapp/activity.dart';
import 'package:localnewsapp/pages/read_later_page.dart';
import 'package:localnewsapp/pages/blocked_users_page.dart';
import 'package:localnewsapp/pages/language_settings_page.dart';
import 'package:localnewsapp/pages/feedback_page.dart';
import 'package:localnewsapp/providers/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UsersRepo _uR = UsersRepo();
  UsersBasic? _userInfo; // Nullable to indicate data hasn't loaded yet
  bool _isLoading = true; // State to track if data is currently being fetched

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Start fetching user data when the widget initializes
  }

  /// Fetches user data from the repository and updates the state.
  /// Handles loading status and potential errors.
  Future<void> _fetchUserData() async {
    try {
      final userInfo = await _uR.getAUserByID(Identification().userID);
      setState(() {
        _userInfo = userInfo;
        _isLoading = false; // Data successfully loaded
      });
    } catch (e) {
      debugPrint('Error loading user data: $e'); // Log the error for debugging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: ${e.toString()}'.tr())),
        );
      }
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
        _userInfo = null; // Set userInfo to null on error to indicate no data
      });
    }
  }

  /// Handles the refresh action, typically triggered by `RefreshIndicator`.
  /// Resets loading state and re-fetches user data.
  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true; // Show loading indicator during refresh
      _userInfo = null; // Clear existing data while refreshing
    });
    await _fetchUserData();
  }

  /// Helper widget to build a menu item with an icon, title, and tap action.
  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? subtitle,
    Widget? trailing,
    bool hasNotification = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasNotification) // Display a red dot for notifications
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          if (trailing != null) ...[ // Custom trailing widget
            const SizedBox(width: 8),
            trailing,
          ],
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right), // Standard right arrow icon
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Link the refresh action
        child: _isLoading // Show a loading indicator if data is being loaded
            ? const Center(child: CircularProgressIndicator())
            : _userInfo == null // If not loading but data is null (e.g., error occurred)
                ? Center(
                    child: Text('failed_to_load_profile_data'.tr())) // Display an error message
                : SingleChildScrollView( // Display the actual profile content
                    physics: const AlwaysScrollableScrollPhysics(), // Allows pull-to-refresh even if content is short
                    child: Column(
                      children: [
                        // Header section with user's email, settings icon, profile picture, and full name
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
                                    child: Text(
                                      _userInfo!.email, // Safe to use `!` because `_userInfo` is checked above
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: (_userInfo!.profileImagePath == null || _userInfo!.profileImagePath!.isEmpty)
                                        ? const Icon(Icons.person, size: 80) // Placeholder icon if no image
                                        : Image.network(
                                            _userInfo!.profileImagePath!, // Safe to use `!`
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              // Fallback if the image fails to load (e.g., network error, invalid URL)
                                              return const Icon(Icons.person, size: 80);
                                            },
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _userInfo!.fullName, // Safe to use `!`
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        const Divider(height: 1), // Separator

                        // Menu items section
                        _buildMenuItem(
                          Icons.edit,
                          'Change Profile Picture'.tr(),
                          onTap: () async {
                            // Ensure user info is available before proceeding with image selection
                            if (_userInfo == null) return;

                            ImagePicker picker = ImagePicker();
                            XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            if (image == null) {
                              return; // User cancelled image selection
                            }

                            final imageExtension = image.name.split('.').last.toLowerCase();

                            // Safely get the old image extension if a profile image exists
                            String oldExtension = '';
                            if (_userInfo!.profileImagePath != null && _userInfo!.profileImagePath!.isNotEmpty) {
                              oldExtension = _userInfo!.profileImagePath!.split('.').last.toLowerCase();
                            }

                            final imageBytes = await image.readAsBytes();
                            final userID = _userInfo!.userID;
                            final imagePath = '$userID.$imageExtension'; // New image path

                            // --- REMOVE OLD IMAGE (if exists) ---
                            try {
                              if (_userInfo!.profileImagePath != null && _userInfo!.profileImagePath!.isNotEmpty) {
                                await Supabase.instance.client.storage
                                    .from('document')
                                    .remove(["user_Profile_Image/$userID.$oldExtension"]);
                              }
                            } catch (e) {
                              debugPrint('Error removing old profile image: $e');
                              if (mounted) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${'profile_picture_remove_error'.tr()}: ${e.toString()}")),
                                );
                              }
                              // Continue attempting upload even if old image removal fails
                            }

                            // --- UPLOAD NEW IMAGE ---
                            try {
                              await Supabase.instance.client.storage
                                  .from('document/user_Profile_Image')
                                  .uploadBinary(
                                    imagePath,
                                    imageBytes,
                                    fileOptions: const FileOptions(
                                      upsert: true, // Overwrite if file with same name exists
                                      contentType: 'image/*', // Accepts various image types
                                    ),
                                  );
                            } catch (e) {
                              debugPrint('Error uploading new profile image: $e');
                              if (mounted) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${'profile_picture_upload_error'.tr()}: ${e.toString()}")),
                                );
                              }
                              return; // Stop if upload fails
                            }

                            // --- GET PUBLIC URL AND UPDATE USER PROFILE IN DATABASE ---
                            try {
                              String imageUrl = Supabase.instance.client.storage
                                  .from('document/user_Profile_Image')
                                  .getPublicUrl(imagePath);

                              await _uR.updateUserProfile(userID, imageUrl);

                              setState(() {
                                _userInfo!.profileImagePath = imageUrl; // Update the local state
                              });
                              if (mounted) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('profile_picture_updated_success'.tr())),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${'profile_picture_update_error'.tr()}: ${e.toString()}")),
                                );
                              }
                            }
                          },
                        ),

                        _buildMenuItem(Icons.local_activity, 'activities'.tr(),
                            onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Activity()),
                          );
                        }),
                        _buildMenuItem(Icons.star_border, 'favorites'.tr(),
                            onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FavoritesPage()),
                          );
                        }),
                        _buildMenuItem(Icons.offline_pin_outlined, 'offline_reading'.tr(),
                            subtitle: 'offline_reading_subtitle'.tr(), onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OfflineReadingPage()),
                          );
                        }),
                        _buildMenuItem(Icons.access_time, 'read_it_later'.tr(),
                            onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReadLaterPage()),
                          );
                        }),
                        _buildMenuItem(Icons.block, 'blocked_users'.tr(),
                            onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BlockedUsersPage()),
                          );
                        }),
                        _buildMenuItem(Icons.language, 'country_language'.tr(),
                            onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LanguageSettingsPage()),
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
                        _buildMenuItem(Icons.star_rate, 'rate_us'.tr(),
                            onTap: () async {
                          final Uri url = Uri.parse(
                              'https://play.google.com/store/apps/details?id=com.localnewsapp'); 
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                             if (mounted) {
                                // ignore: use_build_context_synchronously
                               ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('could_not_launch_store'.tr())),
                               );
                             }
                          }
                        }),
                        _buildMenuItem(
                          Icons.feedback_outlined, 'suggestions_feedback'.tr(),
                          hasNotification: true, // Example of showing a notification dot
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeedbackPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}