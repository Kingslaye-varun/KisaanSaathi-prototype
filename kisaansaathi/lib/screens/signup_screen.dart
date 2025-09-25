// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/farmer_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedLanguage = 'English';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Map language names to their locale codes
  final Map<String, Locale> _languageMap = {
    'English': Locale('en'),
    'Malayalam': Locale('ml'),
    'Tamil': Locale('ta'),
    'Telugu': Locale('te'),
    'Kannada': Locale('kn'),
    'Hindi': Locale('hi'),
    'Punjabi': Locale('pa'),
    'Bengali': Locale('bn'),
    'Marathi': Locale('mr'),
    'Gujarati': Locale('gu'),
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  // Load any previously saved language preference
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  // Pick image from gallery or camera
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

  // Show image picker options
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

  // Save user data to MongoDB
  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if profile image is selected
      if (_profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a profile image'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Register farmer in MongoDB
      final result = await FarmerService.registerFarmer(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        language: _selectedLanguage,
        profileImage: _profileImage,
      );

      if (result.success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Update app locale immediately
        Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
        KisaanSetuApp.of(context).setLocale(newLocale);

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  void _skipToHome() async {
    // Even when skipping, save the selected language
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', _selectedLanguage);

    // Update app locale immediately
    Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
    KisaanSetuApp.of(context).setLocale(newLocale);

    // Navigate to home screen without authentication
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    // Get current localization
    final localizations = AppLocalizations.of(context);

    // Get list of languages with their localized names
    final languages = _languageMap.keys.map((langName) {
      // Use localized name if available, otherwise use original name
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
                    // Header with skip option
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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

                    // Title
                    Text(
                      localizations.loginTitle,
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

                    // Language selection first
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
                                  _languageMap[newValue] ?? Locale('en');
                              KisaanSetuApp.of(context).setLocale(newLocale);
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

                    // Name input field
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
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Enter your full name",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
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
                    const SizedBox(height: 32),

                    // Continue button
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

                    // Note about language
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
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../l10n/app_localizations.dart';
// import '../main.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   String _selectedLanguage = 'English';
  
//   final Map<String, Locale> _languageMap = {
//     'English': Locale('en'),
//     'Hindi': Locale('hi'),
//     'Punjabi': Locale('pa'),
//     'Bengali': Locale('bn'),
//     'Tamil': Locale('ta'),
//     'Telugu': Locale('te'),
//     'Marathi': Locale('mr'),
//     'Gujarati': Locale('gu'),
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedLanguage();
//   }

//   Future<void> _loadSavedLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
//     });
//   }

//   Future<void> _saveUserData() async {
//     if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(AppLocalizations.of(context).invalidPhoneNumber))
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('phoneNumber', _phoneController.text.trim());
//       await prefs.setString('selectedLanguage', _selectedLanguage);
//       Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
//       KisaanSetuApp.of(context).setLocale(newLocale);
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'))
//       );
//     }

//     setState(() => _isLoading = false);
//   }

//   void _continueToHome() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedLanguage', _selectedLanguage);
//     Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
//     KisaanSetuApp.of(context).setLocale(newLocale);
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context);
//     final languages = _languageMap.keys.map((langName) {
//       return localizations.languageNames[_languageMap[langName]!.languageCode] ?? langName;
//     }).toList();

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.green.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               children: [
//                 // Header (now empty since we moved the button)
//                 const SizedBox(height: 16),
                
//                 // Welcome content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title
//                         Text(
//                           localizations.loginTitle,
//                           style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green.shade900,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Welcome back! Please enter your details",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                         const SizedBox(height: 40),
                        
//                         // Phone input field
//                         Text(
//                           localizations.phoneNumberLabel,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.1),
//                                 spreadRadius: 1,
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: TextFormField(
//                             controller: _phoneController,
//                             decoration: InputDecoration(
//                               hintText: localizations.phoneHint,
//                               border: InputBorder.none,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 16,
//                               ),
//                               prefixIcon: Padding(
//                                 padding: const EdgeInsets.only(left: 16),
//                                 child: Text(
//                                   '+91 ',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                               ),
//                               prefixIconConstraints: const BoxConstraints(
//                                 minWidth: 0,
//                                 minHeight: 0,
//                               ),
//                             ),
//                             keyboardType: TextInputType.phone,
//                             maxLength: 10,
//                             validator: (value) {
//                               if (value == null || value.length != 10) {
//                                 return localizations.invalidPhoneNumber;
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 24),
                        
//                         // Language dropdown
//                         Text(
//                           localizations.selectLanguageTitle,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.1),
//                                 spreadRadius: 1,
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               value: _selectedLanguage,
//                               isExpanded: true,
//                               icon: Icon(Icons.arrow_drop_down,
//                                   color: Colors.grey.shade700),
//                               onChanged: (String? newValue) {
//                                 if (newValue != null) {
//                                   setState(() {
//                                     _selectedLanguage = newValue;
//                                   });
//                                   Locale newLocale = _languageMap[newValue] ?? Locale('en');
//                                   KisaanSetuApp.of(context).setLocale(newLocale);
//                                 }
//                               },
//                               items: languages.map<DropdownMenuItem<String>>((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: _languageMap.keys.toList()[languages.indexOf(value)],
//                                   child: Text(
//                                     value,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey.shade800,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),
                        
//                         // Continue button (formerly skip login)
//                         SizedBox(
//                           width: double.infinity,
//                           height: 52,
//                           child: ElevatedButton(
//                             onPressed: _continueToHome,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green.shade700,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Text(
//                               "Continue", // Renamed from skip login
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const SizedBox(height: 24),
                        
//                         // Footer note
//                         Text(
//                           localizations.voiceAssistantLanguageNote,
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: 12,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }