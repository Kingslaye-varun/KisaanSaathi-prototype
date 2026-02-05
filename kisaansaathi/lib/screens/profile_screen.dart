// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/farmer_service.dart';
// import '../utils/farmer_id_utils.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
  
//   bool _isLoading = false;
//   String? _profileImageUrl;
//   File? _imageFile;
//   Map<String, dynamic>? _farmerData;
  
//   @override
//   void initState() {
//     super.initState();
//     _loadFarmerData();
//   }
  
//   Future<void> _loadFarmerData() async {
//     setState(() {
//       _isLoading = true;
//     });
    
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       // FIXED: Use consistent key
//       final farmerString = prefs.getString('farmer') ?? prefs.getString('farmerData');
//       final token = prefs.getString('token');
      
//       if (farmerString != null) {
//         final farmer = jsonDecode(farmerString);
        
//         // Refresh farmer data from server if we have a token
//         if (token != null && farmer['phoneNumber'] != null) {
//           try {
//             final result = await FarmerService.getFarmerByPhone(farmer['phoneNumber']);
//             if (result.success && result.data != null) {
//               final data = result.data!;
//               setState(() {
//                 _farmerData = data;
//                 _nameController.text = data['name'] ?? '';
//                 _phoneController.text = data['phoneNumber'] ?? '';
//                 // FIXED: Handle profileImage object structure
//                 _profileImageUrl = data['profileImage'] != null 
//                     ? (data['profileImage'] is Map 
//                         ? data['profileImage']['url'] 
//                         : data['profileImage'].toString())
//                     : null;
//               });
//               return;
//             }
//           } catch (serverError) {
//             print('Error refreshing from server: $serverError');
//             // Continue with local data if server refresh fails
//           }
//         }
        
//         // Use local data if server refresh fails or isn't possible
//         setState(() {
//           _farmerData = farmer;
//           _nameController.text = farmer['name'] ?? '';
//           _phoneController.text = farmer['phoneNumber'] ?? '';
//           // FIXED: Handle both object and string formats
//           _profileImageUrl = farmer['profileImage'] != null 
//               ? (farmer['profileImage'] is Map 
//                   ? farmer['profileImage']['url'] 
//                   : farmer['profileImage'].toString())
//               : null;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading profile: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
  
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
  
//   Future<void> _updateProfile() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
    
//     setState(() {
//       _isLoading = true;
//     });
    
//     try {
//       final result = await FarmerService.updateFarmerProfile(
//         phoneNumber: _farmerData!['phoneNumber'],
//         name: _nameController.text,
//         profileImage: _imageFile,
//       );
      
//       if (result.success && result.data != null) {
//         final data = result.data!;
//         // FIXED: Update local storage with consistent key
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('farmer', jsonEncode(data));
//         // Remove old key if it exists
//         await prefs.remove('farmerData');
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
//         );
        
//         setState(() {
//           _farmerData = data;
//           // FIXED: Handle profileImage object structure
//           _profileImageUrl = data['profileImage'] != null 
//               ? (data['profileImage'] is Map 
//                   ? data['profileImage']['url'] 
//                   : data['profileImage'].toString())
//               : null;
//           _imageFile = null;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result.message)),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating profile: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
  
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('keepMeLoggedIn', false);
//     // FIXED: Clear all possible keys
//     await prefs.remove('farmer');
//     await prefs.remove('farmerData');
//     await prefs.remove('token');
//     await prefs.remove('farmerId');
//     await prefs.remove('farmerName');
//     await prefs.remove('phoneNumber');
//     await prefs.remove('profileImageUrl');
    
//     if (mounted) {
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.green,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.green))
//           : _farmerData == null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'No profile data found',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _loadFarmerData,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Profile header with background
//                   Container(
//                     width: double.infinity,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30),
//                       ),
//                     ),
//                   ),
                  
//                   // Profile image (positioned to overlap the header)
//                   Transform.translate(
//                     offset: const Offset(0, -75),
//                     child: GestureDetector(
//                       onTap: _pickImage,
//                       child: Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 4),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 10,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: CircleAvatar(
//                               radius: 75,
//                               backgroundColor: Colors.grey.shade200,
//                               backgroundImage: _imageFile != null
//                                   ? FileImage(_imageFile!)
//                                   : _profileImageUrl != null
//                                       ? NetworkImage(_profileImageUrl!)
//                                       : null,
//                               child: (_imageFile == null && _profileImageUrl == null)
//                                   ? Icon(
//                                       Icons.person,
//                                       size: 60,
//                                       color: Colors.grey.shade400,
//                                     )
//                                   : null,
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: Colors.white, width: 2),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 5,
//                                     spreadRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
                  
//                   // Form content
//                   Transform.translate(
//                     offset: const Offset(0, -60),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Verified Farmer Badge (if applicable)
//                             if (_farmerData != null && 
//                                 (_farmerData!['isVerified'] == true || 
//                                 (_farmerData!['farmerId'] != null && _farmerData!['farmerId'].toString().isNotEmpty)))
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                                 margin: const EdgeInsets.only(bottom: 16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.green.shade200),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.verified, color: Colors.green.shade700),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'Verified Farmer ✅',
//                                       style: TextStyle(
//                                         color: Colors.green.shade700,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
                              
//                             // Farmer ID (masked if present)
//                             if (_farmerData != null && 
//                                 _farmerData!['farmerId'] != null && 
//                                 _farmerData!['farmerId'].toString().isNotEmpty)
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                                 margin: const EdgeInsets.only(bottom: 16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade200),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Farmer ID',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       FarmerIdUtils.maskFarmerId(_farmerData!['farmerId'].toString()),
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
                      
//                       // Name field
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             labelText: 'Full Name',
//                             hintText: 'Enter your full name',
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: const BorderSide(color: Colors.green, width: 2),
//                             ),
//                             prefixIcon: const Icon(Icons.person, color: Colors.green),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
                      
//                       // Phone field
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _phoneController,
//                           decoration: InputDecoration(
//                             labelText: 'Phone Number',
//                             hintText: 'Your phone number',
//                             filled: true,
//                             fillColor: Colors.grey.shade100,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             prefixIcon: const Icon(Icons.phone, color: Colors.green),
//                             prefixText: '+91 ',
//                             contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your phone number';
//                             }
//                             if (value.length != 10) {
//                               return 'Phone number must be 10 digits';
//                             }
//                             return null;
//                           },
//                           keyboardType: TextInputType.phone,
//                           readOnly: true, // Phone number cannot be changed
//                         ),
//                       ),
//                       const SizedBox(height: 40),
                      
//                       // Update button
//                       Container(
//                         width: double.infinity,
//                         height: 55,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.green.withOpacity(0.3),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _updateProfile,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             elevation: 0,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: _isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Update Profile',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 0.5,
//                                   ),
//                                 ),
//                         ),
//                       ),
                      
//                       const SizedBox(height: 20),
                      
//                       // Additional farmer info if available
//                       if (_farmerData != null && _farmerData!.containsKey('crops'))
//                         Card(
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Your Crops',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green.shade800,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Wrap(
//                                   spacing: 8,
//                                   children: List<Widget>.from(
//                                     (_farmerData!['crops'] as List).map(
//                                       (crop) => Chip(
//                                         label: Text(crop),
//                                         backgroundColor: Colors.green.shade100,
//                                         labelStyle: TextStyle(
//                                           color: Colors.green.shade800,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//                 ],
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/farmer_service.dart';
import '../utils/farmer_id_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isLoading = false;
  String? _profileImageUrl;
  File? _imageFile;
  Map<String, dynamic>? _farmerData;
  
  @override
  void initState() {
    super.initState();
    _loadFarmerData();
  }
  
  Future<void> _loadFarmerData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      // FIXED: Use consistent key
      final farmerString = prefs.getString('farmer') ?? prefs.getString('farmerData');
      final token = prefs.getString('token');
      
      if (farmerString != null) {
        final farmer = jsonDecode(farmerString);
        
        // Refresh farmer data from server if we have a token
        if (token != null && farmer['phoneNumber'] != null) {
          try {
            final result = await FarmerService.getFarmerByPhone(farmer['phoneNumber']);
            if (result.success && result.data != null) {
              final data = result.data!;
              setState(() {
                _farmerData = data;
                _nameController.text = data['name'] ?? '';
                _phoneController.text = data['phoneNumber'] ?? '';
                // FIXED: Handle profileImage object structure
                _profileImageUrl = data['profileImage'] != null 
                    ? (data['profileImage'] is Map 
                        ? data['profileImage']['url'] 
                        : data['profileImage'].toString())
                    : null;
              });
              return;
            }
          } catch (serverError) {
            print('Error refreshing from server: $serverError');
            // Continue with local data if server refresh fails
          }
        }
        
        // Use local data if server refresh fails or isn't possible
        setState(() {
          _farmerData = farmer;
          _nameController.text = farmer['name'] ?? '';
          _phoneController.text = farmer['phoneNumber'] ?? '';
          // FIXED: Handle both object and string formats
          _profileImageUrl = farmer['profileImage'] != null 
              ? (farmer['profileImage'] is Map 
                  ? farmer['profileImage']['url'] 
                  : farmer['profileImage'].toString())
              : null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await FarmerService.updateFarmerProfile(
        phoneNumber: _farmerData!['phoneNumber'],
        name: _nameController.text,
        profileImage: _imageFile,
      );
      
      if (result.success && result.data != null) {
        final data = result.data!;
        // FIXED: Update local storage with consistent key
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('farmer', jsonEncode(data));
        // Remove old key if it exists
        await prefs.remove('farmerData');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
        );
        
        setState(() {
          _farmerData = data;
          // FIXED: Handle profileImage object structure
          _profileImageUrl = data['profileImage'] != null 
              ? (data['profileImage'] is Map 
                  ? data['profileImage']['url'] 
                  : data['profileImage'].toString())
              : null;
          _imageFile = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepMeLoggedIn', false);
    // FIXED: Clear all possible keys
    await prefs.remove('farmer');
    await prefs.remove('farmerData');
    await prefs.remove('token');
    await prefs.remove('farmerId');
    await prefs.remove('farmerName');
    await prefs.remove('phoneNumber');
    await prefs.remove('profileImageUrl');
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _farmerData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'No profile data found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFarmerData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile header with background
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      
                      // Profile image (positioned to overlap the header)
                      Transform.translate(
                        offset: const Offset(0, -75),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : _profileImageUrl != null
                                          ? NetworkImage(_profileImageUrl!)
                                          : null,
                                  child: (_imageFile == null && _profileImageUrl == null)
                                      ? Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey.shade400,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Form content
                      Transform.translate(
                        offset: const Offset(0, -60),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Verified Farmer Badge (if applicable)
                                if (_farmerData != null && 
                                    (_farmerData!['isVerified'] == true || 
                                    (_farmerData!['farmerId'] != null && _farmerData!['farmerId'].toString().isNotEmpty)))
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.green.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.verified, color: Colors.green.shade700),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Verified Farmer ✅',
                                          style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                // Farmer ID (masked if present)
                                if (_farmerData != null && 
                                    _farmerData!['farmerId'] != null && 
                                    _farmerData!['farmerId'].toString().isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Farmer ID',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          FarmerIdUtils.maskFarmerId(_farmerData!['farmerId'].toString()),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                // Name field
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      hintText: 'Enter your full name',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: Colors.green, width: 2),
                                      ),
                                      prefixIcon: const Icon(Icons.person, color: Colors.green),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Phone field
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      hintText: 'Your phone number',
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      prefixIcon: const Icon(Icons.phone, color: Colors.green),
                                      prefixText: '+91 ',
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      }
                                      if (value.length != 10) {
                                        return 'Phone number must be 10 digits';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    readOnly: true, // Phone number cannot be changed
                                  ),
                                ),
                                const SizedBox(height: 40),
                                
                                // Update button
                                Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _updateProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : const Text(
                                            'Update Profile',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Additional farmer info if available
                                if (_farmerData != null && _farmerData!.containsKey('crops'))
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Your Crops',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade800,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            children: List<Widget>.from(
                                              (_farmerData!['crops'] as List).map(
                                                (crop) => Chip(
                                                  label: Text(crop.toString()),
                                                  backgroundColor: Colors.green.shade100,
                                                  labelStyle: TextStyle(
                                                    color: Colors.green.shade800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}