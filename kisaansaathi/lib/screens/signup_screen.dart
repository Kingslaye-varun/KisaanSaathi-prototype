// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/farmer_service.dart';
import '../services/consumer_service.dart';
import '../services/worker_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _farmerIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedLanguage = 'English';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  String _userType = 'farmer'; // Will be set from route arguments

  final Map<String, Locale> _languageMap = {
    'English': const Locale('en'),
    'Malayalam': const Locale('ml'),
    'Tamil': const Locale('ta'),
    'Telugu': const Locale('te'),
    'Kannada': const Locale('kn'),
    'Hindi': const Locale('hi'),
    'Punjabi': const Locale('pa'),
    'Bengali': const Locale('bn'),
    'Marathi': const Locale('mr'),
    'Gujarati': const Locale('gu'),
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get user type from route arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['userType'] != null) {
      setState(() {
        _userType = args['userType'];
      });
    }
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context).galleryOption),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context).cameraOption),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a profile image'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      if (_userType == 'farmer') {
        await _registerAsFarmer();
      } else if (_userType == 'consumer') {
        await _registerAsConsumer();
      } else {
        await _registerAsWorker();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _registerAsFarmer() async {
    final result = await FarmerService.registerFarmer(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      language: _selectedLanguage,
      profileImage: _profileImage,
      farmerId: _farmerIdController.text.trim().isNotEmpty
          ? _farmerIdController.text.trim()
          : null,
    );

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

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
    }
  }

  Future<void> _registerAsConsumer() async {
    final result = await ConsumerService.registerConsumer(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      language: _selectedLanguage,
      profileImage: _profileImage,
    );

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

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
    }
  }

  Future<void> _registerAsWorker() async {
    final result = await WorkerService.registerWorker(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      language: _selectedLanguage,
      profileImage: _profileImage,
    );

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Locale newLocale = _languageMap[_selectedLanguage] ?? const Locale('en');
      KisaanSaathiApp.of(context).setLocale(newLocale);

      Navigator.pushReplacementNamed(context, '/worker_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _skipToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', _selectedLanguage);

    Locale newLocale = _languageMap[_selectedLanguage] ?? const Locale('en');
    KisaanSaathiApp.of(context).setLocale(newLocale);

    if (_userType == 'consumer') {
      Navigator.pushReplacementNamed(context, '/consumer_home');
    } else if (_userType == 'worker') {
      Navigator.pushReplacementNamed(context, '/worker_home');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final languages = _languageMap.keys.map((langName) {
      return localizations.languageNames[_languageMap[langName]!
              .languageCode] ??
          langName;
    }).toList();

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            onPressed: _skipToHome,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                            child: Text(localizations.skipLoginText),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      _userType == 'farmer'
                          ? 'Farmer Registration'
                          : _userType == 'consumer'
                              ? 'Consumer Registration'
                              : 'Worker Registration',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Welcome! Please enter your details",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Language selection
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
                                  _languageMap[newValue] ?? const Locale('en');
                              KisaanSaathiApp.of(context).setLocale(newLocale);
                            }
                          },
                          items: languages.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: _languageMap.keys
                                  .toList()[languages.indexOf(value)],
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
                    const SizedBox(height: 24),

                    // Profile image selection
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.grey[800],
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add Profile Photo",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name input
                    Text(
                      "Name",
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: "Enter your full name",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Phone input
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
                    const SizedBox(height: 24),

                    // Farmer ID field (only for farmers)
                    if (_userType == 'farmer') ...[
                      Text(
                        "Farmer Unique ID (Optional)",
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
                          controller: _farmerIdController,
                          decoration: const InputDecoration(
                            hintText: "Enter your KL-format Farmer ID",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            helperText: "Enter to get verified farmer status",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            if (!RegExp(r'^KL\d{12}$').hasMatch(value)) {
                              return "Invalid format. Must be KL followed by 12 digits";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Register button
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _saveUserData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                localizations.continueButtonText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        localizations.voiceAssistantLanguageNote,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
