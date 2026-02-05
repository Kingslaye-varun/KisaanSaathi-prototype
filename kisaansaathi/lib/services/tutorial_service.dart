import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _tutorialPrefix = 'tutorial_completed_';
  static const String _lastQuoteDate = 'last_quote_date';

  // Check if tutorial has been completed for a specific screen
  static Future<bool> isTutorialCompleted(String screenName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_tutorialPrefix$screenName') ?? false;
  }

  // Mark tutorial as completed for a specific screen
  static Future<void> markTutorialCompleted(String screenName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_tutorialPrefix$screenName', true);
  }

  // Reset tutorial for a specific screen
  static Future<void> resetTutorial(String screenName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_tutorialPrefix$screenName');
  }

  // Reset all tutorials
  static Future<void> resetAllTutorials() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith(_tutorialPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  // Check if quote should be shown today
  static Future<bool> shouldShowQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastQuoteDate);
    final today = DateTime.now().toIso8601String().split('T')[0];
    return lastDate != today;
  }

  // Mark quote as shown for today
  static Future<void> markQuoteShown() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString(_lastQuoteDate, today);
  }
}
