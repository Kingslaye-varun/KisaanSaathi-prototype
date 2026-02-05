import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../screens/chatbot_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/crop_recommendation.dart';
import '../screens/crop_yield_prediction_screen.dart';
import '../screens/fertilizer_recommendation.dart';
import '../screens/government_schemes.dart';
import '../screens/market_prices.dart';
import '../screens/news_screen.dart';
import '../screens/soil_health_advisor.dart';
import '../screens/nearby_store_screen.dart';
import '../screens/farmers_list_screen.dart';
import '../utils/image_helper.dart';
import '../widgets/language_switcher.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/daily_quote_dialog.dart';
import '../services/quote_service.dart';

class FarmerHomeScreenNew extends StatefulWidget {
  const FarmerHomeScreenNew({super.key});

  @override
  State<FarmerHomeScreenNew> createState() => _FarmerHomeScreenNewState();
}

class _FarmerHomeScreenNewState extends State<FarmerHomeScreenNew> {
  String _farmerName = '';
  String _profileImageUrl = '';

  // Tutorial keys
  final GlobalKey _weatherKey = GlobalKey();
  final GlobalKey _cropAdviceKey = GlobalKey();
  final GlobalKey _fertilizerKey = GlobalKey();
  final GlobalKey _yieldPredictionKey = GlobalKey();
  final GlobalKey _soilHealthKey = GlobalKey();
  final GlobalKey _marketKey = GlobalKey();
  final GlobalKey _aiAssistantKey = GlobalKey();
  final GlobalKey _tutorialButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
    // Show tutorial and quote after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialAndQuote();
    });
  }

  Future<void> _showTutorialAndQuote() async {
    // Wait for widgets to build and be laid out
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;

    // Show daily quote first
    try {
      await DailyQuoteDialog.show(context);
    } catch (e) {
      print('Error showing quote: $e');
    }
    
    if (!mounted) return;

    // Wait a bit more before tutorial
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    // Then show tutorial
    _showTutorial();
  }

  Future<void> _showTutorial() async {
    // Wait a bit for layout
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;

    // Show tutorial - only if all keys are valid
    try {
      if (_weatherKey.currentContext != null &&
          _cropAdviceKey.currentContext != null &&
          _yieldPredictionKey.currentContext != null &&
          _aiAssistantKey.currentContext != null) {
        await TutorialOverlay.show(
          context: context,
          screenName: 'farmer_home_${DateTime.now().millisecondsSinceEpoch}', // Always show
          steps: [
            TutorialStep(
              title: '🌤️ मौसम की जानकारी / Weather Forecast',
              description:
                  'अपने क्षेत्र का 7 दिन का मौसम पूर्वानुमान देखें। तापमान, बारिश, और हवा की जानकारी पाएं। फसल की बुवाई और कटाई की योजना बनाने में मदद करता है।\n\nView 7-day weather forecast for your area. Get temperature, rainfall, and wind information to plan your farming activities.',
              targetKey: _weatherKey,
            ),
            TutorialStep(
              title: '🌾 फसल सलाह / Crop Recommendation',
              description:
                  'AI-आधारित फसल सिफारिश प्राप्त करें। अपनी मिट्टी का प्रकार, मौसम, और क्षेत्र के आधार पर सबसे उपयुक्त फसल चुनें। अधिकतम उपज के लिए सुझाव पाएं।\n\nGet AI-powered crop recommendations based on your soil type, climate, and region for maximum yield.',
              targetKey: _cropAdviceKey,
            ),
            TutorialStep(
              title: '🧪 उर्वरक गाइड / Fertilizer Guide',
              description:
                  'अपनी फसल के लिए सही उर्वरक और मात्रा की जानकारी पाएं। NPK अनुपात, जैविक विकल्प, और उपयोग का सही समय जानें। मिट्टी की उर्वरता बढ़ाएं।\n\nGet the right fertilizer recommendations with NPK ratios, organic options, and application timing.',
              targetKey: _fertilizerKey,
            ),
            TutorialStep(
              title: '📊 उपज पूर्वानुमान / Yield Prediction',
              description:
                  'AI-आधारित मॉडल से अपनी फसल की उपज का पूर्वानुमान लगाएं। क्षेत्र, मौसम, उर्वरक और अन्य कारकों के आधार पर सटीक अनुमान पाएं। 97% सटीकता के साथ।\n\nPredict your crop yield using AI models. Get accurate estimates based on area, weather, fertilizer, and other factors with 97% accuracy.',
              targetKey: _yieldPredictionKey,
            ),
            TutorialStep(
              title: '🌱 मिट्टी स्वास्थ्य / Soil Health Advisor',
              description:
                  'अपनी मिट्टी की सेहत की जांच करें। pH स्तर, पोषक तत्व, और नमी की जानकारी पाएं। मिट्टी सुधार के उपाय और सुझाव प्राप्त करें।\n\nCheck your soil health including pH levels, nutrients, and moisture. Get improvement suggestions.',
              targetKey: _soilHealthKey,
            ),
            TutorialStep(
              title: '📈 बाजार भाव / Market Prices',
              description:
                  'आज के ताजा मंडी भाव देखें। विभिन्न फसलों की कीमतें, मांग-आपूर्ति की स्थिति, और मूल्य रुझान जानें। सही समय पर बेचकर अधिक लाभ कमाएं।\n\nCheck live market prices, demand-supply status, and price trends to sell at the best time.',
              targetKey: _marketKey,
            ),
            TutorialStep(
              title: '🤖 AI सहायक / AI Assistant',
              description:
                  'खेती से जुड़े किसी भी सवाल का तुरंत जवाब पाएं। फसल रोग, कीट नियंत्रण, सिंचाई, और अन्य समस्याओं का समाधान। 24/7 उपलब्ध आपका व्यक्तिगत कृषि सलाहकार।\n\nAsk any farming question and get instant answers. Your 24/7 personal agriculture advisor.',
              targetKey: _aiAssistantKey,
            ),
          ],
        );
        
        // After main tutorial, show hint about tutorial button
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        
        // Show tutorial button hint only once
        await _showTutorialButtonHint();
      }
    } catch (e) {
      print('Error showing tutorial: $e');
    }
  }

  Future<void> _showTutorialButtonHint() async {
    if (_tutorialButtonKey.currentContext == null) return;
    
    await TutorialOverlay.show(
      context: context,
      screenName: 'tutorial_button_hint',
      steps: [
        TutorialStep(
          title: '❓ ट्यूटोरियल बटन / Tutorial Button',
          description:
              'किसी भी समय इस बटन पर क्लिक करके ट्यूटोरियल दोबारा देख सकते हैं। यह आपको ऐप की सभी सुविधाओं को समझने में मदद करेगा।\n\nClick this button anytime to replay the tutorial. It will help you understand all app features.',
          targetKey: _tutorialButtonKey,
        ),
      ],
    );
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
        case 'soil_health':
          return 'Soil Health Advisor';
        default:
          return {
                'welcome_back': 'Welcome back,',
                'quick_actions': 'Quick Actions',
                'weather': 'Weather',
                'crop_advice': 'Crop Advice',
                'chat_farmers': 'Chat with Farmers',
                'view_all': 'View All',
                'latest_news': 'Latest News',
              }[key] ??
              key;
      }
    } catch (e) {
      return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'KisaanSaathi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          const LanguageSwitcher(),
          IconButton(
            key: _tutorialButtonKey,
            icon: const Icon(Icons.help_outline, size: 20),
            tooltip: 'Tutorial',
            onPressed: () async {
              // Wait a bit for any animations to complete
              await Future.delayed(const Duration(milliseconds: 100));
              
              if (!mounted) return;
              
              // Check if keys are available
              if (_weatherKey.currentContext == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait, loading tutorial...'),
                    duration: Duration(seconds: 1),
                  ),
                );
                return;
              }
              
              TutorialOverlay.show(
                context: context,
                screenName: 'farmer_home_replay_${DateTime.now().millisecondsSinceEpoch}',
                steps: [
                  TutorialStep(
                    title: '🌤️ मौसम की जानकारी / Weather Forecast',
                    description: 'अपने क्षेत्र का 7 दिन का मौसम पूर्वानुमान देखें। तापमान, बारिश, और हवा की जानकारी पाएं। फसल की बुवाई और कटाई की योजना बनाने में मदद करता है।\n\nView 7-day weather forecast for your area. Get temperature, rainfall, and wind information to plan your farming activities.',
                    targetKey: _weatherKey,
                  ),
                  TutorialStep(
                    title: '🌾 फसल सलाह / Crop Recommendation',
                    description: 'AI-आधारित फसल सिफारिश प्राप्त करें। अपनी मिट्टी का प्रकार, मौसम, और क्षेत्र के आधार पर सबसे उपयुक्त फसल चुनें। अधिकतम उपज के लिए सुझाव पाएं।\n\nGet AI-powered crop recommendations based on your soil type, climate, and region for maximum yield.',
                    targetKey: _cropAdviceKey,
                  ),
                  TutorialStep(
                    title: '🧪 उर्वरक गाइड / Fertilizer Guide',
                    description: 'अपनी फसल के लिए सही उर्वरक और मात्रा की जानकारी पाएं। NPK अनुपात, जैविक विकल्प, और उपयोग का सही समय जानें। मिट्टी की उर्वरता बढ़ाएं।\n\nGet the right fertilizer recommendations with NPK ratios, organic options, and application timing.',
                    targetKey: _fertilizerKey,
                  ),
                  TutorialStep(
                    title: '🌱 मिट्टी स्वास्थ्य / Soil Health Advisor',
                    description: 'अपनी मिट्टी की सेहत की जांच करें। pH स्तर, पोषक तत्व, और नमी की जानकारी पाएं। मिट्टी सुधार के उपाय और सुझाव प्राप्त करें।\n\nCheck your soil health including pH levels, nutrients, and moisture. Get improvement suggestions.',
                    targetKey: _soilHealthKey,
                  ),
                  TutorialStep(
                    title: '📈 बाजार भाव / Market Prices',
                    description: 'आज के ताजा मंडी भाव देखें। विभिन्न फसलों की कीमतें, मांग-आपूर्ति की स्थिति, और मूल्य रुझान जानें। सही समय पर बेचकर अधिक लाभ कमाएं।\n\nCheck live market prices, demand-supply status, and price trends to sell at the best time.',
                    targetKey: _marketKey,
                  ),
                  TutorialStep(
                    title: '🤖 AI सहायक / AI Assistant',
                    description: 'खेती से जुड़े किसी भी सवाल का तुरंत जवाब पाएं। फसल रोग, कीट नियंत्रण, सिंचाई, और अन्य समस्याओं का समाधान। 24/7 उपलब्ध आपका व्यक्तिगत कृषि सलाहकार।\n\nAsk any farming question and get instant answers. Your 24/7 personal agriculture advisor.',
                    targetKey: _aiAssistantKey,
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 20),
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
            // Daily Quote Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildQuoteCard(),
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
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.8,
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
                        key: _weatherKey,
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
                        key: _cropAdviceKey,
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
                        key: _fertilizerKey,
                      ),
                      _buildCard(
                        Icons.analytics_outlined,
                        'Yield Prediction',
                        Colors.green.shade700,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CropYieldPredictionScreen(),
                          ),
                        ),
                        key: _yieldPredictionKey,
                      ),
                      _buildCard(
                        Icons.eco_outlined,
                        _getText('soil_health'),
                        Colors.brown.shade600,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SoilHealthAdvisorScreen(),
                          ),
                        ),
                        key: _soilHealthKey,
                      ),
                      _buildCard(
                        Icons.trending_up,
                        _getText('market_prices'),
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MarketScreen(),
                          ),
                        ),
                        key: _marketKey,
                      ),
                      _buildCard(
                        Icons.ac_unit,
                        _getText('cold_storage'),
                        Colors.cyan,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NearbyStorageScreen(),
                          ),
                        ),
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
                        key: _aiAssistantKey,
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
                          MaterialPageRoute(builder: (context) => NewsScreen()),
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
    );
  }

  Widget _buildCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap, {
    Key? key,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    final quote = QuoteService.getRandomQuote();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.format_quote,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote['quote']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '- ${quote['author']}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
            onPressed: () {
              setState(() {
                // Refresh quote
              });
            },
          ),
        ],
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
