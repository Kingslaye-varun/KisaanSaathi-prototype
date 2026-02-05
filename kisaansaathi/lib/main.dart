import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request all necessary permissions
  await requestPermissions();

  // Get saved language preference
  final prefs = await SharedPreferences.getInstance();
  final String savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
  final locale = _getLocaleFromLanguage(savedLanguage);

  runApp(KisaanSetuApp(initialLocale: locale));
}

// Helper function to convert language name to locale
Locale _getLocaleFromLanguage(String language) {
  Map<String, Locale> localeMap = {
    'English': Locale('en'),
    'Malayalam': Locale('ml'),  // Added Malayalam
    'Hindi': Locale('hi'),
    'Punjabi': Locale('pa'),
    'Bengali': Locale('bn'),
    'Tamil': Locale('ta'),
    'Telugu': Locale('te'),
    'Marathi': Locale('mr'),
    'Gujarati': Locale('gu'),
    'Kannada': Locale('kn'),  // Added Kannada
  };

  return localeMap[language] ?? Locale('en');
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses =
      await [
        Permission.location,
        Permission.microphone,
        Permission.camera,
        Permission.photos,
        Permission.storage,
      ].request();

  if (statuses[Permission.location]!.isDenied) {
    if (kDebugMode) {
      print("Location permission denied.");
    }
  }
  if (statuses[Permission.camera]!.isDenied) {
    if (kDebugMode) {
      print("Camera permission denied.");
    }
  }
  if (statuses[Permission.photos]!.isDenied) {
    if (kDebugMode) {
      print("Photo library access denied.");
    }
  }
  if (statuses[Permission.storage]!.isDenied) {
    if (kDebugMode) {
      print("Storage access denied.");
    }
  }
  if (statuses[Permission.microphone]!.isDenied) {
    if (kDebugMode) {
      print("Microphone access denied.");
    }
  }
}

class KisaanSetuApp extends StatefulWidget {
  final Locale initialLocale;

  const KisaanSetuApp({super.key, this.initialLocale = const Locale('en')});

  @override
  _KisaanSetuAppState createState() => _KisaanSetuAppState();

  // Static method to access state from anywhere
  static _KisaanSetuAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_KisaanSetuAppState>()!;
}

class _KisaanSetuAppState extends State<KisaanSetuApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  // Method to change the app's locale
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisaanSetu',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Localization configuration
      locale: _locale,
      localizationsDelegates: [
        AppLocalizationsDelegate(), // New delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ml'), // Malayalam
        Locale('hi'), // Hindi
        Locale('pa'), // Punjabi
        Locale('bn'), // Bengali
        Locale('ta'), // Tamil
        Locale('te'), // Telugu
        Locale('mr'), // Marathi
        Locale('gu'), // Gujarati
        Locale('kn'), // Kannada
      ],

      // Existing routes
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
      },
    );
  }
}
<<<<<<< Updated upstream
=======

class MainAppScaffold extends StatefulWidget {
  final int initialIndex;

  const MainAppScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const FarmerHomeScreenNew(),
    const CommunityScreen(
      isEmbedded: true,
    ), // Embedded in MainAppScaffold - no duplicate Scaffold
    const AgriStoreScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    if (kDebugMode) {
      print("📱 MainAppScaffold initialized with index: $_currentIndex");
    }
  }

  Future<bool> _onWillPop() async {
    // If not on home screen, navigate to home screen first
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false; // Don't exit the app
    }

    // If on home screen, show exit confirmation dialog
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to quit?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("🔄 Building MainAppScaffold with index: $_currentIndex");
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Agri Store',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) {
            if (kDebugMode) {
              print("🎯 Navigation bar tapped: $index");
            }
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
>>>>>>> Stashed changes
