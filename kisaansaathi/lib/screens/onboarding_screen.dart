import 'package:flutter/material.dart';
import 'package:kisaansaathi/l10n/app_localizations.dart';
import 'package:kisaansaathi/services/tutorial_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipTutorial() async {
    await TutorialService.completeTutorial();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skipTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final List<OnboardingPage> pages = [
      OnboardingPage(
        icon: Icons.agriculture,
        iconColor: Colors.green,
        title: _getText(localizations, 'welcome_title'),
        description: _getText(localizations, 'welcome_desc'),
      ),
      OnboardingPage(
        icon: Icons.wb_sunny,
        iconColor: Colors.orange,
        title: _getText(localizations, 'weather_title'),
        description: _getText(localizations, 'weather_desc'),
      ),
      OnboardingPage(
        icon: Icons.smart_toy,
        iconColor: Colors.deepPurple,
        title: _getText(localizations, 'ai_title'),
        description: _getText(localizations, 'ai_desc'),
      ),
      OnboardingPage(
        icon: Icons.people,
        iconColor: Colors.blue,
        title: _getText(localizations, 'community_title'),
        description: _getText(localizations, 'community_desc'),
      ),
      OnboardingPage(
        icon: Icons.check_circle,
        iconColor: Colors.green,
        title: _getText(localizations, 'ready_title'),
        description: _getText(localizations, 'ready_desc'),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipTutorial,
                child: Text(
                  _getText(localizations, 'skip'),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),

            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => _buildDot(index),
              ),
            ),

            const SizedBox(height: 20),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == 4
                        ? _getText(localizations, 'get_started')
                        : _getText(localizations, 'next'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 60, color: page.iconColor),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.green.shade700
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  String _getText(AppLocalizations loc, String key) {
    switch (key) {
      case 'welcome_title':
        return loc.locale.languageCode == 'hi'
            ? 'किसानसाथी में आपका स्वागत है!'
            : loc.locale.languageCode == 'ml'
            ? 'കിസാൻസാഥിയിലേക്ക് സ്വാഗതം!'
            : loc.locale.languageCode == 'kn'
            ? 'ಕಿಸಾನ್ಸಾಥಿಗೆ ಸ್ವಾಗತ!'
            : loc.locale.languageCode == 'ta'
            ? 'கிசான்சாதிக்கு வரவேற்கிறோம்!'
            : loc.locale.languageCode == 'te'
            ? 'కిసాన్సాథికి స్వాగతం!'
            : 'Welcome to KisaanSaathi!';
      case 'welcome_desc':
        return loc.locale.languageCode == 'hi'
            ? 'आपका स्मार्ट खेती साथी। मौसम, फसल सलाह, AI सहायता और बहुत कुछ।'
            : loc.locale.languageCode == 'ml'
            ? 'നിങ്ങളുടെ സ്മാർട്ട് കൃഷി സഹായി. കാലാവസ്ഥ, വിള ഉപദേശം, AI സഹായം എന്നിവയും അതിലേറെയും.'
            : loc.locale.languageCode == 'kn'
            ? 'ನಿಮ್ಮ ಸ್ಮಾರ್ಟ್ ಕೃಷಿ ಸಹಾಯಕ. ಹವಾಮಾನ, ಬೆಳೆ ಸಲಹೆ, AI ಸಹಾಯ ಮತ್ತು ಹೆಚ್ಚಿನವು.'
            : 'Your smart farming companion. Weather, crop advice, AI help and more.';
      case 'weather_title':
        return loc.locale.languageCode == 'hi'
            ? 'मौसम और फसल सलाह'
            : loc.locale.languageCode == 'ml'
            ? 'കാലാവസ്ഥയും വിള ഉപദേശവും'
            : loc.locale.languageCode == 'kn'
            ? 'ಹವಾಮಾನ ಮತ್ತು ಬೆಳೆ ಸಲಹೆ'
            : 'Weather & Crop Advice';
      case 'weather_desc':
        return loc.locale.languageCode == 'hi'
            ? 'वास्तविक समय मौसम अपडेट प्राप्त करें और अपनी मिट्टी और जलवायु के लिए सर्वोत्तम फसलों की खोज करें।'
            : loc.locale.languageCode == 'ml'
            ? 'തത്സമയ കാലാവസ്ഥാ അപ്ഡേറ്റുകൾ നേടുകയും നിങ്ങളുടെ മണ്ണിനും കാലാവസ്ഥയ്ക്കും അനുയോജ്യമായ മികച്ച വിളകൾ കണ്ടെത്തുകയും ചെയ്യുക.'
            : 'Get real-time weather updates and discover best crops for your soil and climate.';
      case 'ai_title':
        return loc.locale.languageCode == 'hi'
            ? 'AI सहायक और रोग पहचान'
            : loc.locale.languageCode == 'ml'
            ? 'AI അസിസ്റ്റന്റും രോഗ കണ്ടെത്തലും'
            : loc.locale.languageCode == 'kn'
            ? 'AI ಸಹಾಯಕ ಮತ್ತು ರೋಗ ಪತ್ತೆ'
            : 'AI Assistant & Disease Detection';
      case 'ai_desc':
        return loc.locale.languageCode == 'hi'
            ? 'किसी भी खेती के सवाल पूछें और पौधों की बीमारियों का पता लगाने के लिए तस्वीरें अपलोड करें।'
            : loc.locale.languageCode == 'ml'
            ? 'ഏതെങ്കിലും കൃഷി ചോദ്യങ്ങൾ ചോദിക്കുകയും സസ്യ രോഗങ്ങൾ കണ്ടെത്താൻ ഫോട്ടോകൾ അപ്‌ലോഡ് ചെയ്യുകയും ചെയ്യുക.'
            : 'Ask any farming questions and upload photos to detect plant diseases.';
      case 'community_title':
        return loc.locale.languageCode == 'hi'
            ? 'किसान समुदाय'
            : loc.locale.languageCode == 'ml'
            ? 'കർഷക സമൂഹം'
            : loc.locale.languageCode == 'kn'
            ? 'ರೈತ ಸಮುದಾಯ'
            : 'Farmer Community';
      case 'community_desc':
        return loc.locale.languageCode == 'hi'
            ? 'अन्य किसानों से जुड़ें, अनुभव साझा करें और सलाह प्राप्त करें।'
            : loc.locale.languageCode == 'ml'
            ? 'മറ്റ് കർഷകരുമായി ബന്ധപ്പെടുക, അനുഭവങ്ങൾ പങ്കിടുക, ഉപദേശം നേടുക.'
            : 'Connect with other farmers, share experiences and get advice.';
      case 'ready_title':
        return loc.locale.languageCode == 'hi'
            ? 'शुरू करने के लिए तैयार!'
            : loc.locale.languageCode == 'ml'
            ? 'ആരംഭിക്കാൻ തയ്യാറാണോ!'
            : loc.locale.languageCode == 'kn'
            ? 'ಪ್ರಾರಂಭಿಸಲು ಸಿದ್ಧರಾಗಿದ್ದೀರಾ!'
            : 'Ready to Start!';
      case 'ready_desc':
        return loc.locale.languageCode == 'hi'
            ? 'आइए अपनी खेती की यात्रा शुरू करें। किसानसाथी आपके साथ हर कदम पर है।'
            : loc.locale.languageCode == 'ml'
            ? 'നമുക്ക് നിങ്ങളുടെ കൃഷി യാത്ര ആരംഭിക്കാം. കിസാൻസാഥി ഓരോ ഘട്ടത്തിലും നിങ്ങളോടൊപ്പമുണ്ട്.'
            : "Let's start your farming journey. KisaanSaathi is with you every step.";
      case 'skip':
        return loc.locale.languageCode == 'hi'
            ? 'छोड़ें'
            : loc.locale.languageCode == 'ml'
            ? 'ഒഴിവാക്കുക'
            : loc.locale.languageCode == 'kn'
            ? 'ಬಿಟ್ಟುಬಿಡಿ'
            : 'Skip';
      case 'next':
        return loc.locale.languageCode == 'hi'
            ? 'अगला'
            : loc.locale.languageCode == 'ml'
            ? 'അടുത്തത്'
            : loc.locale.languageCode == 'kn'
            ? 'ಮುಂದೆ'
            : 'Next';
      case 'get_started':
        return loc.locale.languageCode == 'hi'
            ? 'शुरू करें'
            : loc.locale.languageCode == 'ml'
            ? 'ആരംഭിക്കുക'
            : loc.locale.languageCode == 'kn'
            ? 'ಪ್ರಾರಂಭಿಸಿ'
            : 'Get Started';
      default:
        return key;
    }
  }
}

class OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}
