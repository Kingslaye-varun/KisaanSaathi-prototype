// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'l10n/app_localizations.dart';
// import 'screens/login_screen.dart';
// import 'screens/signup_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/chatbot_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/chat_screen.dart';
// import 'screens/community_screen.dart';
// import 'screens/agristore_screen.dart';
// import 'screens/farmer_profile_view.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Request all necessary permissions
//   await requestPermissions();

//   // Get saved language preference and check login status
//   final prefs = await SharedPreferences.getInstance();
//   final String savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
//   final locale = _getLocaleFromLanguage(savedLanguage);

//   // Force clear any stale login data on app start
//   await prefs.reload();
  
//   // Check if user is logged in - prioritize token existence for authentication
//   final String? token = prefs.getString('token');
//   final String? farmerData = prefs.getString('farmerData');
//   final String? farmerId = prefs.getString('farmerId');

//   // Consider user logged in if either token or farmerId exists
//   final bool isLoggedIn = token != null || farmerId != null;
//   final String initialRoute = isLoggedIn ? '/home' : '/login';

//   if (isLoggedIn) {
//     print("User is logged in, starting with home screen");
//   } else {
//     print("User is not logged in, starting with login screen");
//     // Clear any stale data
//     await prefs.remove('token');
//     await prefs.remove('farmerData');
//     await prefs.remove('farmerId');
//     await prefs.remove('farmerName');
//     await prefs.remove('phoneNumber');
//     await prefs.remove('profileImageUrl');
//   }

//   runApp(KisaanSetuApp(initialLocale: locale, initialRoute: initialRoute));
// }

// // Helper function to convert language name to locale
// Locale _getLocaleFromLanguage(String language) {
//   Map<String, Locale> localeMap = {
//     'English': const Locale('en'),
//     'Malayalam': const Locale('ml'), // Added Malayalam
//     'Hindi': const Locale('hi'),
//     'Punjabi': const Locale('pa'),
//     'Bengali': const Locale('bn'),
//     'Tamil': const Locale('ta'),
//     'Telugu': const Locale('te'),
//     'Marathi': const Locale('mr'),
//     'Gujarati': const Locale('gu'),
//     'Kannada': const Locale('kn'), // Added Kannada
//   };

//   return localeMap[language] ?? const Locale('en');
// }

// Future<void> requestPermissions() async {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.location,
//     Permission.microphone,
//     Permission.camera,
//     Permission.photos,
//     Permission.storage,
//   ].request();

//   if (statuses[Permission.location]!.isDenied) {
//     if (kDebugMode) {
//       print("Location permission denied.");
//     }
//   }
//   if (statuses[Permission.camera]!.isDenied) {
//     if (kDebugMode) {
//       print("Camera permission denied.");
//     }
//   }
//   if (statuses[Permission.photos]!.isDenied) {
//     if (kDebugMode) {
//       print("Photo library access denied.");
//     }
//   }
//   if (statuses[Permission.storage]!.isDenied) {
//     if (kDebugMode) {
//       print("Storage access denied.");
//     }
//   }
//   if (statuses[Permission.microphone]!.isDenied) {
//     if (kDebugMode) {
//       print("Microphone access denied.");
//     }
//   }
// }



// class KisaanSetuApp extends StatefulWidget {
//   final Locale initialLocale;
//   final String initialRoute;

//   const KisaanSetuApp({
//     super.key,
//     this.initialLocale = const Locale('en'),
//     this.initialRoute = '/login',
//   });

//   @override
//   _KisaanSetuAppState createState() => _KisaanSetuAppState();

//   // Static method to access state from anywhere
//   static _KisaanSetuAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_KisaanSetuAppState>()!;
// }

// class _KisaanSetuAppState extends State<KisaanSetuApp> {
//   late Locale _locale;

//   @override
//   void initState() {
//     super.initState();
//     _locale = widget.initialLocale;
//   }

//   // Method to change the app's locale
//   void setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'KisaanSetu',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         cardTheme: const CardThemeData(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.green,
//           foregroundColor: Colors.white,
//         ),
//       ),

//       // Localization configuration
//       locale: _locale,
//       localizationsDelegates: const [
//         AppLocalizationsDelegate(), // New delegate
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en'), // English
//         Locale('ml'), // Malayalam
//         Locale('hi'), // Hindi
//         Locale('pa'), // Punjabi
//         Locale('bn'), // Bengali
//         Locale('ta'), // Tamil
//         Locale('te'), // Telugu
//         Locale('mr'), // Marathi
//         Locale('gu'), // Gujarati
//         Locale('kn'), // Kannada
//       ],

//       // App routes
//       initialRoute: widget.initialRoute,
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/home': (context) => const MainAppScaffold(initialIndex: 0),
//         '/chatbot': (context) => const ChatbotScreen(),
//         '/profile': (context) => const MainAppScaffold(initialIndex: 3),
//         '/chat': (context) => const ChatScreen(),
//         '/community': (context) => const MainAppScaffold(initialIndex: 1),
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/farmer_profile') {
//           final args = settings.arguments as Map<String, dynamic>;
//           return MaterialPageRoute(
//             builder: (context) => FarmerProfileView(farmerId: args['farmerId']),
//           );
//         }
//         return null;
//       },
//     );
//   }
// }

// class MainAppScaffold extends StatefulWidget {
//   final int initialIndex;

//   const MainAppScaffold({Key? key, this.initialIndex = 0}) : super(key: key);

//   @override
//   State<MainAppScaffold> createState() => _MainAppScaffoldState();
// }

// class _MainAppScaffoldState extends State<MainAppScaffold> {
//   late int _currentIndex;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const CommunityScreen(),
//     const AgriStoreScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Agri Store',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/community_screen.dart';
import 'screens/agristore_screen.dart';
import 'screens/farmer_profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add this to verify code version
  if (kDebugMode) {
    print("🔄 App started - Version: 1.0.1 - ${DateTime.now()}");
  }

  // Request all necessary permissions
  await requestPermissions();

  // Get saved language preference and check login status
  final prefs = await SharedPreferences.getInstance();
  final String savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
  final locale = _getLocaleFromLanguage(savedLanguage);

  // Force clear any stale login data on app start
  await prefs.reload();
  
  // Check if user is logged in - prioritize token existence for authentication
  final String? token = prefs.getString('token');
  final String? farmerData = prefs.getString('farmerData');
  final String? farmerId = prefs.getString('farmerId');

  // Consider user logged in if either token or farmerId exists
  final bool isLoggedIn = token != null || farmerId != null;
  final String initialRoute = isLoggedIn ? '/home' : '/login';

  if (kDebugMode) {
    if (isLoggedIn) {
      print("✅ User is logged in, starting with home screen");
      print("📱 Token exists: ${token != null}");
      print("👤 Farmer ID exists: ${farmerId != null}");
    } else {
      print("❌ User is not logged in, starting with login screen");
    }
  }

  if (isLoggedIn) {
    print("User is logged in, starting with home screen");
  } else {
    print("User is not logged in, starting with login screen");
    // Clear any stale data
    await prefs.remove('token');
    await prefs.remove('farmerData');
    await prefs.remove('farmerId');
    await prefs.remove('farmerName');
    await prefs.remove('phoneNumber');
    await prefs.remove('profileImageUrl');
  }

  runApp(KisaanSetuApp(initialLocale: locale, initialRoute: initialRoute));
}

// Helper function to convert language name to locale
Locale _getLocaleFromLanguage(String language) {
  Map<String, Locale> localeMap = {
    'English': const Locale('en'),
    'Malayalam': const Locale('ml'), // Added Malayalam
    'Hindi': const Locale('hi'),
    'Punjabi': const Locale('pa'),
    'Bengali': const Locale('bn'),
    'Tamil': const Locale('ta'),
    'Telugu': const Locale('te'),
    'Marathi': const Locale('mr'),
    'Gujarati': const Locale('gu'),
    'Kannada': const Locale('kn'), // Added Kannada
  };

  return localeMap[language] ?? const Locale('en');
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.microphone,
    Permission.camera,
    Permission.photos,
    Permission.storage,
  ].request();

  if (statuses[Permission.location]!.isDenied) {
    if (kDebugMode) {
      print("📍 Location permission denied.");
    }
  }
  if (statuses[Permission.camera]!.isDenied) {
    if (kDebugMode) {
      print("📷 Camera permission denied.");
    }
  }
  if (statuses[Permission.photos]!.isDenied) {
    if (kDebugMode) {
      print("🖼️ Photo library access denied.");
    }
  }
  if (statuses[Permission.storage]!.isDenied) {
    if (kDebugMode) {
      print("💾 Storage access denied.");
    }
  }
  if (statuses[Permission.microphone]!.isDenied) {
    if (kDebugMode) {
      print("🎤 Microphone access denied.");
    }
  }
}

class KisaanSetuApp extends StatefulWidget {
  final Locale initialLocale;
  final String initialRoute;

  const KisaanSetuApp({
    super.key,
    this.initialLocale = const Locale('en'),
    this.initialRoute = '/login',
  });

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
    if (kDebugMode) {
      print("🌍 App locale set to: ${_locale.languageCode}");
      print("🚀 Initial route: ${widget.initialRoute}");
    }
  }

  // Method to change the app's locale
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      if (kDebugMode) {
        print("🔄 Locale changed to: ${locale.languageCode}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisaanSetu v1.0.1',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
         cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),

      // Localization configuration
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(), // New delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
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

      // App routes
      initialRoute: widget.initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainAppScaffold(initialIndex: 0),
        '/chatbot': (context) => const ChatbotScreen(),
        '/profile': (context) => const MainAppScaffold(initialIndex: 3),
        '/chat': (context) => const ChatScreen(),
        '/community': (context) => const MainAppScaffold(initialIndex: 1),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/farmer_profile') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FarmerProfileView(farmerId: args['farmerId']),
          );
        }
        return null;
      },
      
      // Add a fallback home to verify the app is running
      home: Builder(
        builder: (context) {
          if (kDebugMode) {
            print("🏠 Building home for route: ${widget.initialRoute}");
          }
          
          // Temporary: Add a version indicator overlay in debug mode
          return Stack(
            children: [
              _buildAppContent(),
              if (kDebugMode)
                Positioned(
                  top: 30,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'v1.0.1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppContent() {
    // This will be overridden by the initialRoute, but serves as a fallback
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.agriculture, size: 64, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'KisaanSetu App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Version 1.0.1',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Text(
              'Last Updated: ${DateTime.now()}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, widget.initialRoute);
              },
              child: const Text('Continue to App'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainAppScaffold extends StatefulWidget {
  final int initialIndex;

  const MainAppScaffold({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CommunityScreen(),
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

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("🔄 Building MainAppScaffold with index: $_currentIndex");
    }
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
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
    );
  }
}