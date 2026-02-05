import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  static const Map<String, Map<String, String>> languages = {
    'English': {'code': 'en', 'flag': '🇬🇧'},
    'Malayalam': {'code': 'ml', 'flag': '🇮🇳'},
    'Hindi': {'code': 'hi', 'flag': '🇮🇳'},
    'Punjabi': {'code': 'pa', 'flag': '🇮🇳'},
    'Bengali': {'code': 'bn', 'flag': '🇮🇳'},
    'Tamil': {'code': 'ta', 'flag': '🇮🇳'},
    'Telugu': {'code': 'te', 'flag': '🇮🇳'},
    'Marathi': {'code': 'mr', 'flag': '🇮🇳'},
    'Gujarati': {'code': 'gu', 'flag': '🇮🇳'},
    'Kannada': {'code': 'kn', 'flag': '🇮🇳'},
  };

  Future<void> _changeLanguage(
    BuildContext context,
    String languageName,
    String languageCode,
  ) async {
    print('🌍 Changing language to: $languageName ($languageCode)');

    // Save language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageName);

    // Update app locale
    final locale = Locale(languageCode);
    KisaanSaathiApp.of(context).setLocale(locale);

    // Show confirmation
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $languageName'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }

    print('✅ Language changed successfully');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: 'Change Language',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final languageName = languages.keys.elementAt(index);
                        final languageData = languages[languageName]!;
                        final languageCode = languageData['code']!;
                        final flag = languageData['flag']!;

                        return ListTile(
                          leading: Text(
                            flag,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(
                            languageName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _changeLanguage(
                              context,
                              languageName,
                              languageCode,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
