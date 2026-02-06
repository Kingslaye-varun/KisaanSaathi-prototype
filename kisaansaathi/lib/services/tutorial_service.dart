import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _tutorialCompletedKey = 'tutorial_completed';
  static const String _homeScreenTutorialKey = 'home_screen_tutorial_completed';

  // Check if user has completed the onboarding tutorial
  static Future<bool> hasCompletedTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tutorialCompletedKey) ?? false;
  }

  // Mark tutorial as completed
  static Future<void> completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialCompletedKey, true);
  }

  // Reset tutorial (for testing or "Show Tutorial Again")
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialCompletedKey, false);
    await prefs.setBool(_homeScreenTutorialKey, false);
  }

  // Check if home screen tutorial has been shown
  static Future<bool> hasCompletedHomeScreenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_homeScreenTutorialKey) ?? false;
  }

  // Mark home screen tutorial as completed
  static Future<void> completeHomeScreenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_homeScreenTutorialKey, true);
  }
}
