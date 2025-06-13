import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  final List<Map<String, dynamic>> _countries = [
    {
      'name': 'Ethiopia',
      'code': 'ET',
      'languages': [
        'am', // Amharic
        'om', // Oromo
        'ti', // Tigrinya
        'so', // Somali
        'sid', // Sidamo
        'aa', // Afar
        'ha', // Hadiya
        'wal', // Wolaytta
        'gur', // Gurage
        'en'  // English
      ],
      'languageInfo': {
        'am': 'አማርኛ (Amharic) - Official working language of the federal government',
        'om': 'Afaan Oromoo (Oromo) - Regional official language in Oromia',
        'ti': 'ትግርኛ (Tigrinya) - Regional official language in Tigray',
        'so': 'Somali - Regional official language in Somali Region',
        'sid': 'Sidamo - Major regional language',
        'aa': 'Afar - Major regional language',
        'ha': 'Hadiya - Major regional language',
        'wal': 'Wolaytta - Major regional language',
        'gur': 'Gurage - Major regional language',
        'en': 'English - Widely used in business and education'
      }
    },
    
  ];

  String? _selectedCountry;
  String? _selectedLanguage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    setState(() => _isLoading = true);
    try {
      final usersRepo = UsersRepo();
      final user = await usersRepo.getAUserByID('current_user_id'); // Replace with actual user ID
      setState(() {
        _selectedCountry = user?.countryCode;
        _selectedLanguage = user?.languageCode;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading preferences: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePreferences() async {
    if (_selectedCountry == null || _selectedLanguage == null) return;

    setState(() => _isLoading = true);
    try {
      final usersRepo = UsersRepo();
      await usersRepo.updateUserInfo(Users(
        userID: 'current_user_id', // Replace with actual user ID
        countryCode: _selectedCountry,
        languageCode: _selectedLanguage,
        fullName: '', // Add required fields
        isAdmin: false,
        phonenumber: '',
        email: '',
        password: '',
        profileImagePath: null,
        preferenceTags: null,
        forbiddenTags: null,
        otpExpirationTime: null,
        sceretKey: null
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving preferences: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country & Language'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _savePreferences,
            tooltip: 'Save preferences',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCountrySelector(),
                  const SizedBox(height: 24),
                  const Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLanguageSelector(),
                ],
              ),
            ),
    );
  }

  Widget _buildCountrySelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._countries.map((country) => ListTile(
              title: Text(country['name']),
              leading: _buildFlag(country['code']),
              trailing: Radio<String>(
                value: country['code'],
                groupValue: _selectedCountry,
                onChanged: (String? value) {
                  setState(() => _selectedCountry = value);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    if (_selectedCountry == null) return const SizedBox.shrink();

    final selectedCountry = _countries.firstWhere(
      (country) => country['code'] == _selectedCountry,
      orElse: () => _countries.first,
    );

    final languages = selectedCountry['languages'] as List<String>;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...languages.map((languageCode) => Card(
              child: ListTile(
                leading: Radio<String>(
                  value: languageCode,
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                ),
                title: Text(_getLanguageName(languageCode)),
                subtitle: Text(_getLanguageDescription(languageCode)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFlag(String countryCode) {
    return Container(
      width: 32,
      height: 24,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/flags/$countryCode.png'), // Add flag assets
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'am': return 'አማርኛ (Amharic)';
      case 'om': return 'Afaan Oromoo (Oromo)';
      case 'ti': return 'ትግርኛ (Tigrinya)';
      case 'so': return 'Somali';
      case 'sid': return 'Sidamo';
      case 'aa': return 'Afar';
      case 'ha': return 'Hadiya';
      case 'wal': return 'Wolaytta';
      case 'gur': return 'Gurage';
      case 'en': return 'English';
      default: return code.toUpperCase();
    }
  }

  String _getLanguageDescription(String code) {
    final country = _countries.firstWhere(
      (country) => country['languages'].contains(code),
      orElse: () => _countries.first,
    );
    return country['languageInfo']?[code] ?? '';
  }
}
