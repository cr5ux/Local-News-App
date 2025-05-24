import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  bool newsNotification = true;
  bool messageNotification = true;
  bool allowDataUpload = false;
  bool allowDataDownload = false;
  String navigationShortcut = 'Football';
  String readerMode = 'Auto';
  String dataSaved = '0 B saved';
  String pictureMode = 'Disabled';
  String installationId = 'e8.26.b7';
  String version = '11.6.2254.71255';
  bool usageStats = true;

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Features'),
          _buildSettingItem(
            title: 'News notification',
            trailing: _buildSwitch(
              newsNotification,
              (value) => setState(() => newsNotification = value),
            ),
          ),
          _buildSettingItem(
            title: 'News notification settings',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Message',
            trailing: _buildSwitch(
              messageNotification,
              (value) => setState(() => messageNotification = value),
            ),
          ),
          _buildSettingItem(
            title: 'Messaging settings',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'News bar',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Navigation shortcut',
            trailing: Text(
              navigationShortcut,
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Reader mode',
            trailing: Text(
              readerMode,
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Clear cache',
            onTap: () {},
          ),

          _buildSectionHeader('Data'),
          _buildSettingItem(
            title: 'Data Saving',
            trailing: Text(
              dataSaved,
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Pictureless Mode',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  pictureMode,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Allow cellular data upload',
            trailing: _buildSwitch(
              allowDataUpload,
              (value) => setState(() => allowDataUpload = value),
            ),
          ),
          _buildSettingItem(
            title: 'Allow cellular data download',
            trailing: _buildSwitch(
              allowDataDownload,
              (value) => setState(() => allowDataDownload = value),
            ),
          ),

          _buildSectionHeader('Terms'),
          _buildSettingItem(
            title: 'End-user license agreement',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Privacy statement',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Delete my data',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Terms of Service',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Third party licenses',
            onTap: () {},
          ),
          _buildSettingItem(
            title: 'Contact us',
            onTap: () {},
          ),

          _buildSectionHeader('Version Info'),
          _buildSettingItem(
            title: 'Installation ID',
            trailing: Text(
              installationId,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          _buildSettingItem(
            title: 'Version',
            trailing: Text(
              version,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          _buildSettingItem(
            title: 'Usage statistics',
            trailing: Text(
              usageStats ? 'Enabled' : 'Disabled',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Sign out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}