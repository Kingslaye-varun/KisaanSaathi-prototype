import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secrets {
  // Load environment variables from .env file
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

  // Gemini API Keys
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiApiKey2 => dotenv.env['GEMINI_API_KEY_2'] ?? '';
  static String get geminiApiKey3 => dotenv.env['GEMINI_API_KEY_3'] ?? '';
  static String get geminiApiKeySoil => dotenv.env['GEMINI_API_KEY_SOIL'] ?? '';

  // Weather API Key
  static String get weatherApiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  // News API Key
  static String get newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';

  // Agriculture API Key (using weather key as fallback for now)
  static String get agriApiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  // MongoDB URI
  static String get mongodbUri => dotenv.env['MONGODB_URI'] ?? '';

  // Cloudinary Config
  static String get cloudinaryCloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get cloudinaryApiKey => dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static String get cloudinaryApiSecret => dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

  // Backend URLs
  static String get nodeApiUrl => dotenv.env['NODE_API_URL'] ?? '';
  static String get flaskApiUrl => dotenv.env['FLASK_API_URL'] ?? '';

  // ElevenLabs Config
  static String get elevenLabsApiKey => dotenv.env['ELEVENLABS_API_KEY'] ?? '';
  static String get agentId => dotenv.env['AGENT_ID'] ?? '';
  static String get voiceId => dotenv.env['VOICE_ID'] ?? '';

  // Port
  static String get port => dotenv.env['PORT'] ?? '5000';
  static String get flaskEnv => dotenv.env['FLASK_ENV'] ?? 'development';
}