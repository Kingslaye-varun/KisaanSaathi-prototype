// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/farmer_service.dart';
import '../services/consumer_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _keepMeLoggedIn = true;
  String _selectedLanguage = 'English';
  String _userType = 'farmer'; // 'farmer' or 'consumer'

  final Map<String, Locale> _languageMap = {
    'English': const Locale('en'),
    'Hindi': const Locale('hi'),
    'Punjabi': const Locale('pa'),
    'Bengali': const Locale('bn'),
    'Tamil': const Locale('ta'),
    'Telugu': const Locale('te'),
    'Marathi': const Locale('mr'),
    'Gujarati': const Locale('gu'),
    'Malayalam': const Locale('ml'),
    'Kannada': const Locale('kn'),
  };

  final List<String> languages = [
    'English',
    'Hindi',
    'Punjabi',
    'Bengali',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Malayalam',
    'Kannada',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _checkIfLoggedIn();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final keepLoggedIn = prefs.getBool('keepMeLoggedIn') ?? false;
    final userType = prefs.getString('userType');

    if (keepLoggedIn && userType != null) {
      if (userType == 'consumer') {
        Navigator.pushReplacementNamed(context, '/consumer_home');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_userType == 'farmer') {
        await _loginAsFarmer();
      } else {
        await _loginAsConsumer();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginAsFarmer() async {
    final result = await FarmerService.getFarmerByPhone(_phoneController.text);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('keepMeLoggedIn', _keepMeLoggedIn);
      await prefs.setString('selectedLanguage', _selectedLanguage);
      await prefs.setString('userType', 'farmer');

      Locale newLocale = _languageMap[_selectedLanguage] ?? const Locale('en');
      KisaanSaathiApp.of(context).setLocale(newLocale);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pushNamed(
        context,
        '/signup',
        arguments: {'userType': 'farmer'},
      );
    }
  }

  Future<void> _loginAsConsumer() async {
    final result = await ConsumerService.getConsumerByPhone(
      _phoneController.text,
    );

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('keepMeLoggedIn', _keepMeLoggedIn);
      await prefs.setString('selectedLanguage', _selectedLanguage);
      await prefs.setString('userType', 'consumer');

      Locale newLocale = _languageMap[_selectedLanguage] ?? const Locale('en');
      KisaanSaathiApp.of(context).setLocale(newLocale);

      Navigator.pushReplacementNamed(context, '/consumer_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pushNamed(
        context,
        '/signup',
        arguments: {'userType': 'consumer'},
      );
    }
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup', arguments: {'userType': _userType});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/logo.jpg', height: 100, width: 100),
                  const SizedBox(height: 40),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Welcome back! Please enter your details",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // User Type Selection
                          Text(
                            "I am a",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildUserTypeCard(
                                  'farmer',
                                  'Farmer',
                                  Icons.agriculture,
                                  'Sell & Trade Products',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildUserTypeCard(
                                  'consumer',
                                  'Consumer',
                                  Icons.shopping_bag,
                                  'Buy Fresh Products',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Phone input field
                          Text(
                            localizations.phoneNumberLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintText: localizations.phoneHint,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    '+91 ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.length != 10) {
                                  return localizations.invalidPhoneNumber;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Keep me logged in checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _keepMeLoggedIn,
                                onChanged: (value) {
                                  setState(() {
                                    _keepMeLoggedIn = value ?? true;
                                  });
                                },
                                activeColor: Colors.green.shade700,
                              ),
                              Text(
                                "Keep me logged in",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Language dropdown
                          Text(
                            localizations.selectLanguageTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedLanguage,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey.shade700,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedLanguage = newValue;
                                    });
                                    Locale newLocale =
                                        _languageMap[newValue] ??
                                        const Locale('en');
                                    KisaanSaathiApp.of(
                                      context,
                                    ).setLocale(newLocale);
                                  }
                                },
                                items: languages.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sign up option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              TextButton(
                                onPressed: _navigateToSignup,
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(
    String type,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _userType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _userType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.green.shade700 : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.green.shade700
                    : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
