import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../screens/chatbot_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/crop_recommendation.dart';
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

class FarmerHomeScreenWithTutorial extends StatefulWidget {
  const FarmerHomeScreenWithTutorial({super.key});

  @override
  State<FarmerHomeScreenWithTutorial> createState() =>
      _FarmerHomeScreenWithTutorialState();
}

class _FarmerHomeScreenWithTutorialState
    extends State<FarmerHomeScreenWithTutorial> {
  String _farmerName = '';
  String _profileImageUrl = '';

  // Tutorial keys
  final GlobalKey _weatherKey = GlobalKey();
  final GlobalKey _cropAdviceKey = GlobalKey();
  final GlobalKey _aiAssistantKey = GlobalKey();
  final GlobalKey _fertilizerKey = GlobalKey();
  final GlobalKey _marketKey = GlobalKey();
  final GlobalKey _schemesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
    _showTutorialAndQuote();
  }

  Future<void> _loadFarmerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _farmerName = prefs.getString('farmerName') ?? 'Farmer';
      _profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    });
  }

  Future<void> _showTutorialAndQuote() async {
    // Wait for widgets to build
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Show daily quote first
    await DailyQuoteDialog.show(context);

    if (!mounted) return;

    // Then show tutorial
    await TutorialOverlay.show(
      context: context,
      screenName: 'farmer_home',
      steps: [
        TutorialStep(
          title: 'मौसम की जानकारी / Weather Info',
          description:
              'यहाँ आप अपने क्षेत्र का मौसम देख सकते हैं। फसल की योजना बनाने में मदद करता है।\n\nCheck your local weather forecast to plan your farming activities.',
          targetKey: _weatherKey,
        ),
        TutorialStep(
          title: 'फसल सलाह / Crop Advice',
          description:
              'मिट्टी और मौसम के आधार पर सबसे अच्छी फसल की सिफारिश पाएं।\n\nGet AI-powered crop recommendations based on your soil and climate.',
          targetKey: _cropAdviceKey,
        ),
        TutorialStep(
          title: 'AI सहायक / AI Assistant',
          description:
              'खेती से जुड़े किसी भी सवाल का जवाब पाएं। 24/7 उपलब्ध।\n\nAsk any farming question and get instant answers from our AI assistant.',
          targetKey: _aiAssistantKey,
        ),
        TutorialStep(
          title: 'उर्वरक गाइड / Fertilizer Guide',
          description:
              'सही उर्वरक और मात्रा की जानकारी पाएं।\n\nGet recommendations for the right fertilizers for your crops.',
          targetKey: _fertilizerKey,
        ),
        TutorialStep(
          title: 'बाजार भाव / Market Prices',
          description:
              'आज के ताजा बाजार भाव देखें और सही समय पर बेचें।\n\nCheck current market prices to sell at the best time.',
          targetKey: _marketKey,
        ),
        TutorialStep(
          title: 'सरकारी योजनाएं / Government Schemes',
          description:
              'किसानों के लिए सरकारी योजनाओं की जानकारी और आवेदन करें।\n\nExplore and apply for government schemes for farmers.',
          targetKey: _schemesKey,
        ),
      ],
    );
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
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Replay tutorial
              TutorialOverlay.show(
                context: context,
                screenName: 'farmer_home_replay',
                steps: [
                  TutorialStep(
                    title: 'मौसम की जानकारी / Weather Info',
                    description:
                        'यहाँ आप अपने क्षेत्र का मौसम देख सकते हैं।\n\nCheck your local weather forecast.',
                    targetKey: _weatherKey,
                  ),
                  TutorialStep(
                    title: 'फसल सलाह / Crop Advice',
                    description:
                        'मिट्टी और मौसम के आधार पर सबसे अच्छी फसल की सिफारिश पाएं।\n\nGet crop recommendations.',
                    targetKey: _cropAdviceKey,
                  ),
                  TutorialStep(
                    title: 'AI सहायक / AI Assistant',
                    description:
                        'खेती से जुड़े किसी भी सवाल का जवाब पाएं।\n\nAsk farming questions.',
                    targetKey: _aiAssistantKey,
                  ),
                  TutorialStep(
                    title: 'उर्वरक गाइड / Fertilizer Guide',
                    description:
                        'सही उर्वरक की जानकारी पाएं।\n\nGet fertilizer recommendations.',
                    targetKey: _fertilizerKey,
                  ),
                  TutorialStep(
                    title: 'बाजार भाव / Market Prices',
                    description:
                        'आज के ताजा बाजार भाव देखें।\n\nCheck market prices.',
                    targetKey: _marketKey,
                  ),
                  TutorialStep(
                    title: 'सरकारी योजनाएं / Government Schemes',
                    description:
                        'सरकारी योजनाओं की जानकारी पाएं।\n\nExplore government schemes.',
                    targetKey: _schemesKey,
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getText('welcome_back'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _farmerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.all(16),
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _buildActionCard(
                        key: _weatherKey,
                        icon: Icons.wb_sunny,
                        title: _getText('weather'),
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WeatherScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        key: _cropAdviceKey,
                        icon: Icons.grass,
                        title: _getText('crop_advice'),
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CropRecommendationScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        key: _aiAssistantKey,
                        icon: Icons.chat_bubble_outline,
                        title: _getText('ai_assistant'),
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatbotScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        key: _fertilizerKey,
                        icon: Icons.science,
                        title: _getText('fertilizer'),
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FertilizerRecommendationScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        key: _marketKey,
                        icon: Icons.trending_up,
                        title: _getText('market_prices'),
                        color: Colors.teal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarketPricesScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        key: _schemesKey,
                        icon: Icons.account_balance,
                        title: _getText('govt_schemes'),
                        color: Colors.indigo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GovernmentSchemesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required GlobalKey key,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      key: key,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
