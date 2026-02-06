import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../screens/chatbot_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/crop_recommendation.dart';
import '../screens/fertilizer_recommendation.dart';
import '../screens/government_schemes.dart';
import '../screens/news_screen.dart';
import '../screens/soil_health_advisor.dart';
import '../screens/farmers_list_screen.dart';
import '../utils/image_helper.dart';
import '../widgets/language_switcher.dart';
import '../widgets/tutorial_overlay.dart';
import '../services/tutorial_service.dart';

class FarmerHomeScreenNew extends StatefulWidget {
  const FarmerHomeScreenNew({super.key});

  @override
  State<FarmerHomeScreenNew> createState() => _FarmerHomeScreenNewState();
}

class _FarmerHomeScreenNewState extends State<FarmerHomeScreenNew> {
  String _farmerName = '';
  String _profileImageUrl = '';
  bool _showTutorial = false;
  final List<GlobalKey> _tutorialKeys = List.generate(5, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
    _checkAndShowTutorial();
  }

  Future<void> _checkAndShowTutorial() async {
    final hasCompleted = await TutorialService.hasCompletedHomeScreenTutorial();
    if (!hasCompleted) {
      // Delay to ensure widgets are built
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _showTutorial = true;
        });
      }
    }
  }

  Future<void> _loadFarmerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _farmerName = prefs.getString('farmerName') ?? 'Farmer';
      _profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    });
  }

  String _getText(String key) {
    try {
      final loc = AppLocalizations.of(context);
      switch (key) {
        case 'fertilizer':
          return loc.fertilizerGuide;
        case 'market_prices':
          return loc.marketPrices;
        case 'cold_storage':
          return loc.coldStorage;
        case 'ai_assistant':
          return loc.aiAssistant;
        case 'govt_schemes':
          return loc.governmentSchemes;
        case 'welcome_back':
          return loc.welcomeBack;
        case 'quick_actions':
          return loc.quickActions;
        case 'weather':
          return loc.weather;
        case 'crop_advice':
          return loc.cropAdvice;
        case 'chat_farmers':
          return loc.chatWithFarmers;
        case 'view_all':
          return loc.viewAll;
        case 'latest_news':
          return loc.latestNews;
        default:
          return key;
      }
    } catch (e) {
      print('! Localization error: $e');
      return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Row(
              children: const [
                Icon(Icons.agriculture, size: 24),
                SizedBox(width: 8),
                Text(
                  'KisaanSaathi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              const LanguageSwitcher(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ImageHelper.getProfileImage(
                  imageUrl: _profileImageUrl,
                  name: _farmerName,
                  radius: 18,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.green.shade700, Colors.green.shade500],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getText('welcome_back'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _farmerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getText('quick_actions'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildCard(
                            Icons.wb_sunny_outlined,
                            _getText('weather'),
                            Colors.orange,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WeatherScreen(),
                              ),
                            ),
                            key: _tutorialKeys[0],
                          ),
                          _buildCard(
                            Icons.grass_outlined,
                            _getText('crop_advice'),
                            Colors.green,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CropRecommendationScreen(),
                              ),
                            ),
                            key: _tutorialKeys[1],
                          ),
                          _buildCard(
                            Icons.science_outlined,
                            _getText('fertilizer'),
                            Colors.brown,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FertilizerRecommendationScreen(),
                              ),
                            ),
                            key: _tutorialKeys[2],
                          ),
                          _buildCard(
                            Icons.smart_toy,
                            _getText('ai_assistant'),
                            Colors.deepPurple,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatbotScreen(),
                              ),
                            ),
                            key: _tutorialKeys[3],
                          ),
                          _buildCard(
                            Icons.chat,
                            _getText('chat_farmers'),
                            Colors.teal,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FarmersListScreen(),
                              ),
                            ),
                            key: _tutorialKeys[4],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getText('govt_schemes'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GovernmentSchemesScreen(),
                              ),
                            ),
                            child: Text(_getText('view_all')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSchemeCard(
                        'PM-KISAN',
                        'Direct income support to farmers',
                        Icons.account_balance_wallet,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getText('latest_news'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsScreen(),
                              ),
                            ),
                            child: Text(_getText('view_all')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildNewsCard(
                        'New farming techniques boost crop yield',
                        '2 hours ago',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        // Tutorial overlay
        if (_showTutorial) _buildTutorialOverlay(),
      ],
    );
  }

  Widget _buildTutorialOverlay() {
    final loc = AppLocalizations.of(context);

    // Get positions of tutorial targets
    List<TutorialStep> steps = [];

    for (int i = 0; i < _tutorialKeys.length; i++) {
      final RenderBox? renderBox =
          _tutorialKeys[i].currentContext?.findRenderObject() as RenderBox?;
      Rect? targetRect;

      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        targetRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          renderBox.size.width,
          renderBox.size.height,
        );
      }

      String title = '';
      String description = '';

      switch (i) {
        case 0:
          title = _getTutorialText(loc, 'weather_title');
          description = _getTutorialText(loc, 'weather_desc');
          break;
        case 1:
          title = _getTutorialText(loc, 'crop_title');
          description = _getTutorialText(loc, 'crop_desc');
          break;
        case 2:
          title = _getTutorialText(loc, 'fertilizer_title');
          description = _getTutorialText(loc, 'fertilizer_desc');
          break;
        case 3:
          title = _getTutorialText(loc, 'ai_title');
          description = _getTutorialText(loc, 'ai_desc');
          break;
        case 4:
          title = _getTutorialText(loc, 'chat_title');
          description = _getTutorialText(loc, 'chat_desc');
          break;
      }

      steps.add(
        TutorialStep(
          title: title,
          description: description,
          targetRect: targetRect,
        ),
      );
    }

    return TutorialOverlay(
      steps: steps,
      onComplete: () {
        setState(() {
          _showTutorial = false;
        });
      },
    );
  }

  String _getTutorialText(AppLocalizations loc, String key) {
    switch (key) {
      case 'weather_title':
        return loc.locale.languageCode == 'hi'
            ? 'मौसम की जानकारी'
            : loc.locale.languageCode == 'ml'
            ? 'കാലാവസ്ഥാ വിവരങ്ങൾ'
            : loc.locale.languageCode == 'kn'
            ? 'ಹವಾಮಾನ ಮಾಹಿತಿ'
            : 'Weather Information';
      case 'weather_desc':
        return loc.locale.languageCode == 'hi'
            ? 'अपने क्षेत्र का वास्तविक समय मौसम देखें और खेती की योजना बनाएं।'
            : loc.locale.languageCode == 'ml'
            ? 'നിങ്ങളുടെ പ്രദേശത്തെ തത്സമയ കാലാവസ്ഥ കാണുകയും കൃഷി ആസൂത്രണം ചെയ്യുകയും ചെയ്യുക.'
            : 'View real-time weather for your area and plan your farming.';
      case 'crop_title':
        return loc.locale.languageCode == 'hi'
            ? 'फसल सलाह'
            : loc.locale.languageCode == 'ml'
            ? 'വിള ഉപദേശം'
            : 'Crop Advice';
      case 'crop_desc':
        return loc.locale.languageCode == 'hi'
            ? 'अपनी मिट्टी और जलवायु के लिए सर्वोत्तम फसलों की सिफारिशें प्राप्त करें।'
            : loc.locale.languageCode == 'ml'
            ? 'നിങ്ങളുടെ മണ്ണിനും കാലാവസ്ഥയ്ക്കും അനുയോജ്യമായ മികച്ച വിളകൾക്കുള്ള ശുപാർശകൾ നേടുക.'
            : 'Get recommendations for best crops for your soil and climate.';
      case 'fertilizer_title':
        return loc.locale.languageCode == 'hi'
            ? 'उर्वरक गाइड'
            : loc.locale.languageCode == 'ml'
            ? 'വളം ഗൈഡ്'
            : 'Fertilizer Guide';
      case 'fertilizer_desc':
        return loc.locale.languageCode == 'hi'
            ? 'अपनी फसल के लिए सही उर्वरक और मात्रा जानें।'
            : loc.locale.languageCode == 'ml'
            ? 'നിങ്ങളുടെ വിളയ്ക്ക് ശരിയായ വളവും അളവും അറിയുക.'
            : 'Learn the right fertilizer and quantity for your crop.';
      case 'ai_title':
        return loc.locale.languageCode == 'hi'
            ? 'AI सहायक'
            : loc.locale.languageCode == 'ml'
            ? 'AI അസിസ്റ്റന്റ്'
            : 'AI Assistant';
      case 'ai_desc':
        return loc.locale.languageCode == 'hi'
            ? 'किसी भी खेती के सवाल पूछें या पौधों की बीमारियों का पता लगाएं।'
            : loc.locale.languageCode == 'ml'
            ? 'ഏതെങ്കിലും കൃഷി ചോദ്യങ്ങൾ ചോദിക്കുകയോ സസ്യ രോഗങ്ങൾ കണ്ടെത്തുകയോ ചെയ്യുക.'
            : 'Ask any farming questions or detect plant diseases.';
      case 'chat_title':
        return loc.locale.languageCode == 'hi'
            ? 'किसानों से बात करें'
            : loc.locale.languageCode == 'ml'
            ? 'കർഷകരുമായി സംസാരിക്കുക'
            : 'Chat with Farmers';
      case 'chat_desc':
        return loc.locale.languageCode == 'hi'
            ? 'अन्य किसानों से जुड़ें और अनुभव साझा करें।'
            : loc.locale.languageCode == 'ml'
            ? 'മറ്റ് കർഷകരുമായി ബന്ധപ്പെടുകയും അനുഭവങ്ങൾ പങ്കിടുകയും ചെയ്യുക.'
            : 'Connect with other farmers and share experiences.';
      default:
        return key;
    }
  }

  Widget _buildCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap, {
    GlobalKey? key,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.article, color: Colors.grey.shade400, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
