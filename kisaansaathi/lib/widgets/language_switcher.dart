import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  static const Map<String, String> languages = {
    'English': 'en',
    'Malayalam': 'ml',
    'Hindi': 'hi',
    'Punjabi': 'pa',
    'Bengali': 'bn',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Marathi': 'mr',
    'Gujarati': 'gu',
    'Kannada': 'kn',
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
                        final languageCode = languages[languageName]!;

                        return ListTile(
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
