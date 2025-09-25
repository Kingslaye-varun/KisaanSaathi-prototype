class Secrets {
  // Provide keys via --dart-define when building or running the app
  // Example:
  // flutter run --dart-define=WEATHER_API_KEY=... \
  //             --dart-define=GEMINI_API_KEY=... \
  //             --dart-define=GEMINI_API_KEY_2=... \
  //             --dart-define=AGRI_API_KEY=...

  static const String weatherApiKey = String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: '',
  );

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const String geminiApiKey2 = String.fromEnvironment(
    'GEMINI_API_KEY_2',
    defaultValue: '',
  );

  static const String agriApiKey = String.fromEnvironment(
    'AGRI_API_KEY',
    defaultValue: '',
  );
}


