// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/farmer_service.dart';
import '../utils/farmer_id_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _keepMeLoggedIn = true;
  String _selectedLanguage = 'English';
  
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
    final farmerData = prefs.getString('farmer');
    
    if (keepLoggedIn && farmerData != null) {
      // User is already logged in, navigate to home
      Navigator.pushReplacementNamed(context, '/home');
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
      final result = await FarmerService.getFarmerByPhone(_phoneController.text);
      
      if (result.success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Check if farmer is verified (has farmerId)
        final farmerData = result.data;
        final bool isVerified = farmerData != null && 
            farmerData['farmerId'] != null && 
            farmerData['farmerId'].toString().isNotEmpty;
        
        // Save login preference
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keepMeLoggedIn', _keepMeLoggedIn);
        await prefs.setString('selectedLanguage', _selectedLanguage);
        await prefs.setBool('isVerifiedFarmer', isVerified);
        
        // Update app locale
        Locale newLocale = _languageMap[_selectedLanguage] ?? const Locale('en');
        KisaanSetuApp.of(context).setLocale(newLocale);
        
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Farmer not found, navigate to signup
        Navigator.pushReplacementNamed(context, '/signup');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header with logo
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/logo.jpg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 40),
                  
                  // Welcome content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
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
                            "Welcome back! Please enter your phone number",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
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
                                  color: Colors.grey.withOpacity(0.1),
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
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
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
                                  color: Colors.grey.withOpacity(0.1),
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
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.grey.shade700),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedLanguage = newValue;
                                    });
                                    Locale newLocale = _languageMap[newValue] ?? const Locale('en');
                                    KisaanSetuApp.of(context).setLocale(newLocale);
                                  }
                                },
                                items: languages.map<DropdownMenuItem<String>>((String value) {
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
                                  ? const CircularProgressIndicator(color: Colors.white)
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
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
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
}