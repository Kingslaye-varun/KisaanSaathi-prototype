import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisaansaathi/services/api_service.dart';
import 'package:kisaansaathi/services/conversation_history_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kisaansaathi/screens/krishibhavan.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kisaansaathi/l10n/app_localizations.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, String>> _conversationHistory = [];
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isLoading = false;
  bool _autoSpeakEnabled = true;
  String? _currentlySpeakingMessageId;

  // Disease detection variables
  File? _imageFile;
  bool _isDetectingDisease = false;
  Map<String, dynamic>? _diseaseDetectionResult;

  // Language settings
  String _selectedLanguage = 'English';
  String _languageCode = 'en-US';

  // Language code mapping
  final Map<String, String> _languageCodes = {
    'English': 'en-US',
    'Kannada': 'kn-IN',
    'Malayalam': 'ml-IN',
    'Hindi': 'hi-IN',
    'Punjabi': 'pa-IN',
    'Bengali': 'bn-IN',
    'Tamil': 'ta-IN',
    'Telugu': 'te-IN',
    'Marathi': 'mr-IN',
    'Gujarati': 'gu-IN',
  };

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference().then((_) {
      _initializeSpeech();
      _initializeTts();
      _loadConversationHistory();
    });
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selectedLanguage') ?? 'English';

      setState(() {
        _selectedLanguage = savedLanguage;
        _languageCode = _languageCodes[savedLanguage] ?? 'en-US';
      });
    } catch (e) {
      debugPrint('Error loading language preference: $e');
      setState(() {
        _selectedLanguage = 'English';
        _languageCode = 'en-US';
      });
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onError: (error) => debugPrint('Speech error: $error'),
        onStatus: (status) => debugPrint('Speech status: $status'),
      );
      if (!available) {
        debugPrint('Speech recognition not available');
      }
    } catch (e) {
      debugPrint('Error initializing speech: $e');
    }
  }

  Future<void> _initializeTts() async {
    try {
      await _flutterTts.setLanguage(_languageCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      });

      _flutterTts.setErrorHandler((error) {
        debugPrint('TTS error: $error');
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      });
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  Future<void> _loadConversationHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await ConversationHistoryService.loadConversation();

      if (history.isEmpty) {
        _addWelcomeMessage();
      } else {
        setState(() {
          _conversationHistory = history;
          _isLoading = false;
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Error loading conversation history: $e');
      setState(() {
        _isLoading = false;
      });
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    final Map<String, String> welcomeMessages = {
      'English':
          'Namaskaram! I am KisaanSaathi AI Assistant. How can I help you today? I can assist with: Crop recommendations, Weather information, Pest control advice, Government schemes, Market prices, Plant disease detection from images, and General farming queries',
      'Hindi':
          'नमस्कारम्! मैं किसानसाथी AI सहायक हूँ। आज मैं आपकी कैसे मदद कर सकता हूँ? मैं इन विषयों पर सहायता कर सकता हूँ: फसल सिफारिशें, मौसम की जानकारी, कीट नियंत्रण सलाह, सरकारी योजनाएँ, बाजार मूल्य, छवियों से पौधों की बीमारियों का पता लगाना, और सामान्य कृषि प्रश्न',
      'Punjabi':
          'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਕਿਸਾਨਸਾਥੀ AI ਸਹਾਇਕ ਹਾਂ। ਅੱਜ ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ? ਮੈਂ ਇਹਨਾਂ ਵਿਸ਼ਿਆਂ ਵਿੱਚ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ: ਫਸਲ ਸਿਫਾਰਸ਼ਾਂ, ਮੌਸਮ ਦੀ ਜਾਣਕਾਰੀ, ਕੀੜੇ ਨਿਯੰਤਰਣ ਸਲਾਹ, ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ, ਮੰਡੀ ਮੁੱਲ, ਤਸਵੀਰਾਂ ਤੋਂ ਪੌਦਿਆਂ ਦੀਆਂ ਬੀਮਾਰੀਆਂ ਦਾ ਪਤਾ ਲਗਾਉਣਾ, ਅਤੇ ਆਮ ਖੇਤੀਬਾੜੀ ਸਵਾਲ',
      'Bengali':
          'নমস্কার! আমি কিষাণসাথী AI সহকারী। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি? আমি এই বিষয়গুলিতে সাহায্য করতে পারি: ফসলের সুপারিশ, আবহাওয়া তথ্য, কীটপতঙ্গ নিয়ন্ত্রণ পরামর্শ, সরকারি প্রকল্প, বাজার দাম, ছবি থেকে গাছের রোগ সনাক্তকরণ, এবং সাধারণ কৃষি প্রশ্ন',
      'Tamil':
          'வணக்கம்! நான் கிசான்சாதி AI உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்? நான் இந்த விஷயங்களில் உதவ முடியும்: பயிர் பரிந்துரைகள், வானிலை தகவல், பூச்சி கட்டுப்பாடு ஆலோசனை, அரசு திட்டங்கள், சந்தை விலைகள், படங்களிலிருந்து தாவர நோய்களைக் கண்டறிதல், மற்றும் பொதுவான விவசாய கேள்விகள்',
      'Telugu':
          'నమస్కారం! నేను కిసాన్సాథి AI సహాయకుడిని. నేడు నేను మీకు ఎలా సహాయం చేయగలను? నేను ఈ విషయాలలో సహాయం చేయగలను: పంట సిఫార్సులు, వాతావరణ సమాచారం, పురుగు నియంత్రణ సలహా, ప్రభుత్వ పథకాలు, మార్కెట్ ధరలు, చిత్రాల నుండి మొక్కల వ్యాధులను గుర్తించడం, మరియు సాధారణ వ్యవసాయ ప్రశ్నలు',
      'Marathi':
          'नमस्कार! मी किसानसाथी AI सहाय्यक आहे. आज मी तुम्हाला कशी मदत करू शकतो? मी या विषयांवर मदत करू शकतो: पीक शिफारशी, हवामान माहिती, कीटक नियंत्रण सल्ला, सरकारी योजना, बाजार किंमती, प्रतिमांवरून वनस्पती रोग ओळखणे, आणि सामान्य शेती प्रश्न',
      'Gujarati':
          'નમસ્કારમ્! હું કિસાનસાથી AI સહાયક છું. આજે હું તમને કેવી રીતે મદદ કરી શકું? હું આ વિષયોમાં મદદ કરી શકું છું: પાક ભલામણો, હવામાન માહિતી, જંતુ નિયંત્રણ સલાહ, સરકારી યોજનાઓ, બજાર ભાવો, ચિત્રોમાંથી છોડ રોગ શોધ, અને સામાન્ય ખેતી પ્રશ્નો',
      'Malayalam':
          'നമസ്കാരം! ഞാൻ കിസാൻസാഥി AI സഹായി. ഇന്ന് ഞാൻ നിങ്ങളെ എങ്ങനെ സഹായിക്കാം? ഞാൻ ഈ വിഷയങ്ങളിൽ സഹായം നൽകാം: വിള ശുപാർശകൾ, കാലാവസ്ഥാ വിവരം, കീട നിയന്ത്രണ ഉപദേശം, സർക്കാർ പദ്ധതികൾ, മാർക്കറ്റ് വിലകൾ, ചിത്രങ്ങളിൽ നിന്ന് സസ്യരോഗങ്ങൾ കണ്ടെത്തൽ, പൊതുവായ കൃഷി ചോദ്യങ്ങൾ',
      'Kannada':
          'ನಮಸ್ಕಾರ! ನಾನು ಕಿಸಾನ್ಸಾಥಿ AI ಸಹಾಯಕ. ಇಂದು ನಾನು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು? ನಾನು ಈ ವಿಷಯಗಳಲ್ಲಿ ಸಹಾಯ ಮಾಡಬಹುದು: ಬೆಳೆ ಶಿಫಾರಸುಗಳು, ಹವಾಮಾನ ಮಾಹಿತಿ, ಕೀಟ ನಿಯಂತ್ರಣ ಸಲಹೆ, ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು, ಮಾರುಕಟ್ಟೆ ಬೆಲೆಗಳು, ಚಿತ್ರಗಳಿಂದ ಸಸ್ಯರೋಗಗಳನ್ನು ಪತ್ತೆಹಚ್ಚುವುದು, ಮತ್ತು ಸಾಮಾನ್ಯ ಕೃಷಿ ಪ್ರಶ್ನೆಗಳು',
    };

    final welcomeMessage =
        welcomeMessages[_selectedLanguage] ?? welcomeMessages['English']!;

    final welcomeEntry = {
      'id': 'welcome-${DateTime.now().millisecondsSinceEpoch}',
      'text': welcomeMessage,
      'isUser': 'false',
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _conversationHistory.add(welcomeEntry);
      _isLoading = false;
    });

    ConversationHistoryService.saveConversation(_conversationHistory);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_autoSpeakEnabled) {
        _speak(welcomeMessage, welcomeEntry['id']!);
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _processTextForSpeech(String text) {
    text = text.replaceAll('•', '');
    text = text.replaceAll('*', '');
    text = text.replaceAll('-', '');
    text = text.replaceAll('\n\n', '. ');
    text = text.replaceAll('\n', '. ');
    return text;
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = {
      'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
      'text': message,
      'isUser': 'true',
      'timestamp': DateTime.now().toIso8601String(),
    };

    _messageController.clear();

    setState(() {
      _conversationHistory.add(userMessage);
      _isLoading = true;
    });

    await ConversationHistoryService.saveConversation(_conversationHistory);
    _scrollToBottom();

    try {
      if (_isSpeaking) {
        await _flutterTts.stop();
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      }

      Position? currentPosition;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
          }
        }
      } catch (e) {
        debugPrint('Error getting location: $e');
      }

      Map<String, dynamic>? weatherData;
      if (currentPosition != null) {
        try {
          weatherData = await _apiService.getCurrentWeather(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          );
        } catch (e) {
          debugPrint('Error getting weather data: $e');
        }
      }

      final response = await _apiService.getChatbotResponse(
        message,
        language: _selectedLanguage.toLowerCase(),
        conversationHistory: _conversationHistory,
        latitude: currentPosition?.latitude,
        longitude: currentPosition?.longitude,
        weatherData: weatherData,
      );

      final botMessageId = 'bot-${DateTime.now().millisecondsSinceEpoch}';
      final botMessage = {
        'id': botMessageId,
        'text': response,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _conversationHistory.add(botMessage);
        _isLoading = false;
      });

      await ConversationHistoryService.saveConversation(_conversationHistory);
      _scrollToBottom();

      if (_autoSpeakEnabled) {
        _speak(_processTextForSpeech(response), botMessageId);
      }
    } catch (e) {
      debugPrint('Error sending message: $e');

      final Map<String, String> errorMessages = {
        'English': 'Sorry, I encountered an error. Please try again.',
        'Hindi': 'क्षमा करें, मुझे एक त्रुटि मिली। कृपया पुनः प्रयास करें।',
        'Punjabi':
            'ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਇੱਕ ਗਲਤੀ ਮਿਲੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
        'Bengali':
            'দুঃখিত, আমি একটি ত্রুটি পেয়েছি। অনুগ্রহ করে আবার চেষ্টা করুন।',
        'Tamil':
            'மன்னிக்கவும், எனக்கு ஒரு பிழை ஏற்பட்டது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.',
        'Telugu':
            'క్షమించండి, నాకు ఒక లోపం ఎదురైంది. దయచేసి మళ్లీ ప్రయత్నించండి.',
        'Marathi': 'क्षमस्व, मला एक त्रुटी आढळली. कृपया पुन्हा प्रयत्न करा.',
        'Gujarati': 'માફ કરશો, મને એક ભૂલ મળી. કૃપા કરીને ફરી પ્રયાસ કરો.',
        'Kannada':
            'ಕ್ಷಮಿಸಿ, ನನಗೆ ಒಂದು ದೋಷ ಕಂಡುಬಂದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ.',
        'Malayalam':
            'ക്ഷമിക്കണം, എനിക്ക് ഒരു പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
      };

      final errorMessage =
          errorMessages[_selectedLanguage] ?? errorMessages['English']!;
      final errorId = 'error-${DateTime.now().millisecondsSinceEpoch}';

      final errorEntry = {
        'id': errorId,
        'text': errorMessage,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _conversationHistory.add(errorEntry);
        _isLoading = false;
      });

      await ConversationHistoryService.saveConversation(_conversationHistory);

      if (_autoSpeakEnabled) {
        _speak(errorMessage, errorId);
      }
    }
  }

  // Disease Detection Methods using Gemini API
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _diseaseDetectionResult = null;
        });
        _detectDiseaseWithGemini();
      }
    } catch (e) {
      _showErrorSnackbar('Error picking image: $e');
    }
  }

  Future<void> _detectDiseaseWithGemini() async {
    if (_imageFile == null) {
      _showErrorSnackbar('No image selected. Please select an image first.');
      return;
    }

    setState(() {
      _isDetectingDisease = true;
      _diseaseDetectionResult = null;
    });

    try {
      // Show a message that we're processing the image
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analyzing plant image with AI... Please wait.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Convert image to base64
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Get location context if available
      String locationContext = '';
      try {
        Position? position = await _getCurrentLocation();
        if (position != null) {
          String locationName = await _getLocationName(
            position.latitude,
            position.longitude,
          );
          locationContext =
              'Location: $locationName (Lat: ${position.latitude}, Lon: ${position.longitude})';
        }
      } catch (e) {
        debugPrint('Error getting location: $e');
      }

      // Get language-specific prompt
      final Map<String, String> languagePrompts = {
        'English': 'Please respond in English.',
        'Hindi': 'कृपया हिंदी में जवाब दें।',
        'Malayalam': 'ദയവായി മലയാളത്തിൽ ഉത്തരം നൽകുക.',
        'Tamil': 'தயவுசெய்து தமிழில் பதிலளிக்கவும்.',
        'Telugu': 'దయచేసి తెలుగులో సమాధానం ఇవ్వండి.',
        'Kannada': 'ಕನ್ನಡದಲ್ಲಿ ಉತ್ತರ ನೀಡಿ.',
        'Punjabi': 'ਕਿਰਪਾ ਕਰਕੇ ਪੰਜਾਬੀ ਵਿੱਚ ਜਵਾਬ ਦਿਓ।',
        'Bengali': 'অনুগ্রহ করে বাংলায় উত্তর দিন।',
        'Marathi': 'कृपया मराठीत उत्तर द्या.',
        'Gujarati': 'કૃપા કરીને ગુજરાતીમાં જવાબ આપો.',
      };

      final languagePrompt =
          languagePrompts[_selectedLanguage] ?? languagePrompts['English']!;

      // Call Gemini API with vision (using gemini-2.5-pro for better instruction following)
      final geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$geminiApiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      '''You are an expert plant pathologist and agricultural advisor. Analyze this plant image and provide a DETAILED disease diagnosis.

$locationContext

CRITICAL INSTRUCTIONS:
1. Carefully examine the plant image for any signs of disease, pest damage, or nutrient deficiency
2. If healthy, state "Healthy Plant" and explain why it looks healthy
3. If diseased, you MUST provide ALL of the following:
   - Specific disease/problem name
   - Confidence level (percentage)
   - Detailed cause and symptoms (2-3 sentences minimum)
   - At least 3-5 practical remedies with specific details
   - Prevention tips (2-3 sentences)

$languagePrompt

FORMATTING RULES:
- Response should be 200-250 words (comprehensive but concise)
- Use simple language, avoid technical jargon
- Do NOT use special symbols like asterisks, bullets, hashtags
- Use plain text with simple numbering (1, 2, 3)
- Separate sections with line breaks

FORMAT EXACTLY LIKE THIS:
Disease: [Specific disease name or Healthy Plant]
Confidence: [XX percent]

Cause: [Detailed explanation of what causes this disease and visible symptoms - write 2-3 sentences]

Remedies:
1. [First remedy with specific details]
2. [Second remedy with application method]
3. [Third remedy with dosage if applicable]
4. [Fourth remedy - organic option]
5. [Fifth remedy - preventive measure]

Prevention: [Detailed prevention tips - write 2-3 sentences about how to avoid this in future]

Be thorough, practical, and actionable. Provide complete information.''',
                },
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  },
                },
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.4,
            'topK': 32,
            'topP': 0.8,
            'maxOutputTokens': 800, // ~250 words
            'candidateCount': 1,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final analysisText =
            data['candidates'][0]['content']['parts'][0]['text'] ??
            'Unable to analyze the image.';

        // Debug: Print the full response
        debugPrint(
          '🔍 GEMINI RESPONSE LENGTH: ${analysisText.length} characters',
        );
        debugPrint('🔍 GEMINI RESPONSE: $analysisText');

        setState(() {
          _diseaseDetectionResult = {
            'analysis': analysisText,
            'timestamp': DateTime.now().toIso8601String(),
          };
          _isDetectingDisease = false;
        });

        // Add result to conversation
        _addDiseaseDetectionResultToChat(analysisText);
      } else {
        throw Exception(
          'Gemini API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      setState(() {
        _isDetectingDisease = false;
      });

      _showErrorSnackbar('Error analyzing plant image: $e');
      debugPrint('Disease detection error: $e');
    }
  }

  void _addDiseaseDetectionResultToChat(String analysisText) {
    try {
      // Create a formatted message for the chat
      String diseaseMessage =
          '''
🌱 **Plant Disease Analysis**

$analysisText
''';

      final diseaseEntry = {
        'id': 'disease-${DateTime.now().millisecondsSinceEpoch}',
        'text': diseaseMessage,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
        'isDiseaseResult': 'true',
      };

      setState(() {
        _conversationHistory.add(diseaseEntry);
      });

      ConversationHistoryService.saveConversation(_conversationHistory);
      _scrollToBottom();

      if (_autoSpeakEnabled) {
        _speak(_processTextForSpeech(analysisText), diseaseEntry['id']!);
      }
    } catch (e) {
      debugPrint('Error adding disease result to chat: $e');
      _showErrorSnackbar('Error displaying disease detection result');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: Text(AppLocalizations.of(context).takePhoto),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: Text(AppLocalizations.of(context).chooseFromGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Location helper methods for disease detection
  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  Future<String> _getLocationName(double latitude, double longitude) async {
    try {
      // Using OpenStreetMap Nominatim API for reverse geocoding
      final url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1';

      final response = await http
          .get(Uri.parse(url), headers: {'User-Agent': 'KisaanSaathi/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];

        // Try to get district, state, or city
        String locationName = '';
        if (address['state_district'] != null) {
          locationName = address['state_district'];
        } else if (address['city'] != null) {
          locationName = address['city'];
        } else if (address['town'] != null) {
          locationName = address['town'];
        } else if (address['village'] != null) {
          locationName = address['village'];
        }

        if (address['state'] != null) {
          locationName += locationName.isNotEmpty
              ? ', ${address['state']}'
              : address['state'];
        }

        return locationName.isNotEmpty ? locationName : 'Unknown Location';
      }
    } catch (e) {
      debugPrint('Error getting location name: $e');
    }
    return 'Unknown Location';
  }

  Future<void> _startListening() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
        _currentlySpeakingMessageId = null;
      });
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    try {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _messageController.text = result.recognizedWords;
            if (result.finalResult) {
              _isListening = false;
              if (_messageController.text.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  _sendMessage(_messageController.text);
                });
              }
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId:
            '${_languageCode.split('-')[0]}_${_languageCode.split('-')[1]}',
      );
    } catch (e) {
      setState(() => _isListening = false);
      debugPrint('Error listening: $e');
    }
  }

  Future<void> _speak(String text, String messageId) async {
    if (!_autoSpeakEnabled && messageId != _currentlySpeakingMessageId) return;

    if (_isSpeaking) {
      if (_currentlySpeakingMessageId == messageId) {
        await _flutterTts.stop();
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      } else {
        await _flutterTts.stop();
        await Future.delayed(const Duration(milliseconds: 300));
        await _flutterTts.setLanguage(_languageCode);
        setState(() {
          _currentlySpeakingMessageId = messageId;
        });
        await _flutterTts.speak(text);
      }
      return;
    }

    await _flutterTts.setLanguage(_languageCode);
    setState(() {
      _isSpeaking = true;
      _currentlySpeakingMessageId = messageId;
    });
    await _flutterTts.speak(text);
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Chat History',
          style: TextStyle(color: Colors.green.shade800),
        ),
        content: Text('Are you sure you want to clear all chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ConversationHistoryService.clearConversation();
              setState(() {
                _conversationHistory = [];
                _imageFile = null;
                _diseaseDetectionResult = null;
              });
              _addWelcomeMessage();
            },
            child: Text('Clear', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() async {
    String? newLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Language',
            style: TextStyle(color: Colors.green.shade800),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languageCodes.length,
              itemBuilder: (context, index) {
                String language = _languageCodes.keys.elementAt(index);
                return ListTile(
                  title: Text(language),
                  trailing: language == _selectedLanguage
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(language);
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (newLanguage != null && newLanguage != _selectedLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
        _languageCode = _languageCodes[newLanguage] ?? 'en-US';
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', newLanguage);
      await _flutterTts.setLanguage(_languageCode);

      final Map<String, String> languageChangedMessages = {
        'English': 'Language changed to English',
        'Hindi': 'भाषा हिंदी में बदल दी गई है',
        'Kannada': 'ಭಾಷೆಯನ್ನು ಕನ್ನಡಕ್ಕೆ ಬದಲಾಯಿಸಲಾಗಿದೆ',
        'Malayalam': 'ഭാഷ മലയാളത്തിലേക്ക് മാറ്റി',
        'Punjabi': 'ਭਾਸ਼ਾ ਪੰਜਾਬੀ ਵਿੱਚ ਬਦਲ ਦਿੱਤੀ ਗਈ ਹੈ',
        'Bengali': 'ভাষা বাংলায় পরিবর্তন করা হয়েছে',
        'Tamil': 'மொழி தமிழாக மாற்றப்பட்டது',
        'Telugu': 'భాష తెలుగులోకి మార్చబడింది',
        'Marathi': 'भाषा मराठीत बदलली आहे',
        'Gujarati': 'ભાષા ગુજરાતીમાં બદલાઈ ગઈ છે',
      };

      final message =
          languageChangedMessages[newLanguage] ??
          'Language changed to $newLanguage';
      final messageId = 'lang-change-${DateTime.now().millisecondsSinceEpoch}';

      final languageChangeEntry = {
        'id': messageId,
        'text': message,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _conversationHistory.add(languageChangeEntry);
      });

      if (_autoSpeakEnabled) {
        _speak(message, messageId);
      }
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildImageSelectionArea() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image_search, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).plantDiseaseDetection,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_imageFile == null)
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.shade300,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 50,
                      color: Colors.green.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).tapToSelectPlantImage,
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (_isDetectingDisease)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context).detectingDisease,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _showImageSourceDialog,
                        child: Text(AppLocalizations.of(context).changeImage),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isDetectingDisease
                            ? null
                            : _detectDiseaseWithGemini,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                        ),
                        child: _isDetectingDisease
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('Detect'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (_diseaseDetectionResult != null) ...[
            const SizedBox(height: 12),
            _buildDiseaseResultCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildDiseaseResultCard() {
    final result = _diseaseDetectionResult!;

    // New format just has 'analysis' text
    if (result.containsKey('analysis')) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Analysis Complete',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              result['analysis'].toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }

    // Old format fallback (shouldn't happen anymore)
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: const Text('Result format not recognized'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset('assets/logo.jpg', height: 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'KisaanSaathi Assistant',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: _showLanguageSelector,
            tooltip: 'Change language',
          ),
          IconButton(
            icon: Icon(
              _autoSpeakEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _autoSpeakEnabled = !_autoSpeakEnabled;
                if (!_autoSpeakEnabled && _isSpeaking) {
                  _flutterTts.stop();
                  _isSpeaking = false;
                  _currentlySpeakingMessageId = null;
                }
              });
            },
            tooltip: _autoSpeakEnabled ? 'Disable voice' : 'Enable voice',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearHistory,
            tooltip: 'Clear Chat History',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Column(
          children: [
            // Krishi Bhavan Officers Contact Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KrishiBhavanScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.contact_phone, color: Colors.white),
                label: Text(
                  'Contact Krishi Bhavan Officers',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language, color: Colors.green.shade800, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _selectedLanguage,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    _isSpeaking
                        ? Icons.record_voice_over
                        : (_isListening ? Icons.mic : Icons.mic_none),
                    color: _isSpeaking || _isListening
                        ? Colors.green.shade800
                        : Colors.grey.shade600,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isSpeaking
                        ? 'Speaking...'
                        : (_isListening ? 'Listening...' : 'Voice Assistant'),
                    style: TextStyle(
                      color: _isSpeaking || _isListening
                          ? Colors.green.shade800
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_isDetectingDisease) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.image_search,
                      color: Colors.green.shade800,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Detecting Disease...',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: _isLoading && _conversationHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 16),
                          Text(
                            'Loading your farming assistant...',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          _conversationHistory.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _conversationHistory.length) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Thinking...',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final message = _conversationHistory[index];
                        final isUser = message['isUser'] == 'true';
                        final messageId = message['id'] ?? 'msg-$index';
                        final isSystemMessage =
                            messageId.startsWith('lang-change-') ||
                            messageId.startsWith('welcome');
                        final isDiseaseResult =
                            message['isDiseaseResult'] == 'true';
                        final isCurrentlySpeaking =
                            messageId == _currentlySpeakingMessageId;
                        final timestamp = message['timestamp'] != null
                            ? _formatTimestamp(message['timestamp']!)
                            : '';

                        if (isSystemMessage) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                if (timestamp.isNotEmpty)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      timestamp,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }

                        if (isDiseaseResult) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green.shade200,
                                  child: Icon(
                                    Icons.agriculture,
                                    color: Colors.green.shade800,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.green.shade300,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message['text'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (isCurrentlySpeaking)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.volume_up,
                                                    size: 14,
                                                    color:
                                                        Colors.green.shade800,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Speaking',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Colors.green.shade800,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                              ),
                                            Text(
                                              timestamp,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: isUser
                              ? null
                              : () => _speak(
                                  _processTextForSpeech(message['text'] ?? ''),
                                  messageId,
                                ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isUser)
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade200,
                                    child: Icon(
                                      Icons.agriculture,
                                      color: Colors.green.shade800,
                                      size: 20,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Colors.green.shade200
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isUser
                                            ? Colors.green.shade300
                                            : Colors.grey.shade300,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message['text'] ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (!isUser && isCurrentlySpeaking)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.volume_up,
                                                    size: 14,
                                                    color:
                                                        Colors.green.shade800,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Speaking',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Colors.green.shade800,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                              ),
                                            Text(
                                              timestamp,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (isUser)
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade700,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_imageFile != null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: SingleChildScrollView(child: _buildImageSelectionArea()),
              ),
            if (_isLoading && _conversationHistory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Thinking...',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.green.shade700,
                      ),
                      onPressed: _showImageSourceDialog,
                      tooltip: 'Detect Plant Disease',
                    ),
                    IconButton(
                      onPressed: _startListening,
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening
                            ? Colors.red
                            : Colors.green.shade700,
                        size: 28,
                      ),
                      tooltip: _isListening
                          ? 'Stop listening'
                          : 'Start voice input',
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).typeMessage,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _sendMessage(value);
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          _sendMessage(_messageController.text);
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.green.shade700,
                        size: 28,
                      ),
                      tooltip: 'Send message',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}
