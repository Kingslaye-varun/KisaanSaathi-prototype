import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerService {
  // Configuration constants
  static const String baseUrl = 'http://10.99.111.81:5000/api/farmers';
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  // HTTP client with timeout configuration
  static http.Client get _client => http.Client();

  // Helper method for making HTTP requests with timeout and error handling
  static Future<http.Response> _makeRequest(
    Future<http.Response> Function() request, {
    Duration timeout = timeoutDuration,
  }) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException {
      throw TimeoutException('Request timed out after ${timeout.inSeconds} seconds');
    } on SocketException {
      throw Exception('Network error: Please check your internet connection');
    } on HttpException {
      throw Exception('HTTP error: Unable to connect to the server');
    } on FormatException {
      throw Exception('Invalid response format from server');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  // Register a new farmer
  static Future<ServiceResponse> registerFarmer({
    required String name,
    required String phoneNumber,
    required String language,
    File? profileImage,
    String? farmerId,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/register'));
      
      // Add text fields
      request.fields['name'] = name;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['language'] = language;
      
      // Add farmerId if provided
      if (farmerId != null && farmerId.isNotEmpty) {
        request.fields['farmerId'] = farmerId;
      }
      
      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.path,
        ));
      }
      
      // Send request with timeout
      var streamedResponse = await _makeRequest(() async {
        return await http.Response.fromStream(await request.send());
      });

      final responseData = json.decode(streamedResponse.body);
      
      if (streamedResponse.statusCode == 201 || streamedResponse.statusCode == 200) {
        await _saveFarmerToPrefs(responseData['data'], token: responseData['token']);
        
        return ServiceResponse.success(
          data: responseData['data'],
          message: responseData['message'],
          token: responseData['token'],
        );
      } else {
        return ServiceResponse.error(
          message: responseData['message'] ?? 'Failed to register farmer',
          statusCode: streamedResponse.statusCode,
        );
      }
    } on TimeoutException catch (e) {
      return ServiceResponse.error(message: e.message ?? 'Request timed out');
    } catch (e) {
      return ServiceResponse.error(message: e.toString());
    }
  }

  // Get farmer by phone number
  static Future<ServiceResponse> getFarmerByPhone(String phoneNumber) async {
    try {
      final response = await _makeRequest(() => _client.get(
        Uri.parse('$baseUrl/$phoneNumber'),
        headers: defaultHeaders,
      ));

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        await _saveFarmerToPrefs(responseData['data']);
        
        return ServiceResponse.success(
          data: responseData['data'],
          message: 'Farmer retrieved successfully',
        );
      } else {
        String message;
        switch (response.statusCode) {
          case 404:
            message = 'Farmer not found. Please check your phone number or register.';
            break;
          case 401:
            message = 'Authentication error. Please login again.';
            break;
          default:
            message = responseData['message'] ?? 'Failed to get farmer: HTTP ${response.statusCode}';
        }
        
        return ServiceResponse.error(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (e) {
      return ServiceResponse.error(message: e.message ?? 'Request timed out');
    } catch (e) {
      return ServiceResponse.error(message: e.toString());
    }
  }

  // Update farmer profile
  static Future<ServiceResponse> updateFarmerProfile({
    required String phoneNumber,
    String? name,
    String? language,
    File? profileImage,
    String? farmerId,
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$phoneNumber'));
      
      // Add text fields if provided
      if (name != null) request.fields['name'] = name;
      if (language != null) request.fields['language'] = language;
      if (farmerId != null && farmerId.isNotEmpty) request.fields['farmerId'] = farmerId;
      
      // Add profile image if available
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage', 
          profileImage.path,
        ));
      }
      
      // Send the request with timeout
      var streamedResponse = await _makeRequest(() async {
        return await http.Response.fromStream(await request.send());
      });

      final responseData = json.decode(streamedResponse.body);
      
      if (streamedResponse.statusCode == 200) {
        await _saveFarmerToPrefs(responseData['data']);
        
        return ServiceResponse.success(
          data: responseData['data'],
          message: responseData['message'] ?? 'Profile updated successfully',
        );
      } else {
        return ServiceResponse.error(
          message: responseData['message'] ?? 'Profile update failed',
          statusCode: streamedResponse.statusCode,
        );
      }
    } on TimeoutException catch (e) {
      return ServiceResponse.error(message: e.message ?? 'Request timed out');
    } catch (e) {
      return ServiceResponse.error(message: e.toString());
    }
  }

  // Update farmer by ID
  static Future<ServiceResponse> updateFarmerById({
    required String farmerId,
    required String name,
    required String phoneNumber,
    File? profileImage,
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$farmerId'));
      
      // Add text fields
      request.fields['name'] = name;
      request.fields['phoneNumber'] = phoneNumber;
      
      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.path,
        ));
      }
      
      // Send request with timeout
      var streamedResponse = await _makeRequest(() async {
        return await http.Response.fromStream(await request.send());
      });

      final responseData = json.decode(streamedResponse.body);
      
      if (streamedResponse.statusCode == 200) {
        await _saveFarmerToPrefs(responseData['data']);
        
        return ServiceResponse.success(
          data: responseData['data'],
          message: 'Farmer updated successfully',
        );
      } else {
        return ServiceResponse.error(
          message: responseData['message'] ?? 'Failed to update farmer',
          statusCode: streamedResponse.statusCode,
        );
      }
    } on TimeoutException catch (e) {
      return ServiceResponse.error(message: e.message ?? 'Request timed out');
    } catch (e) {
      return ServiceResponse.error(message: e.toString());
    }
  }

  // Save farmer data to shared preferences
  static Future<void> _saveFarmerToPrefs(Map<String, dynamic> farmer, {String? token}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save individual fields
      await prefs.setString('farmerId', farmer['_id'] ?? '');
      await prefs.setString('farmerName', farmer['name'] ?? '');
      await prefs.setString('phoneNumber', farmer['phoneNumber'] ?? '');
      await prefs.setString('selectedLanguage', farmer['language'] ?? 'en');
      
      // Save profile image URL if available
      if (farmer['profileImage'] != null && farmer['profileImage']['url'] != null) {
        await prefs.setString('profileImageUrl', farmer['profileImage']['url']);
      }
      
      // Save the entire farmer object as JSON
      await prefs.setString('farmerData', json.encode(farmer));
      await prefs.setBool('keepMeLoggedIn', true);
      
      // Save token if provided
      if (token != null && token.isNotEmpty) {
        await prefs.setString('token', token);
      }
    } catch (e) {
      throw Exception('Failed to save farmer data: ${e.toString()}');
    }
  }

  // Get current farmer from shared preferences
  static Future<Map<String, dynamic>?> getCurrentFarmer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerJson = prefs.getString('farmerData');
      
      if (farmerJson != null) {
        return json.decode(farmerJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get farmer data: ${e.toString()}');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('farmerId') != null && 
             prefs.getBool('keepMeLoggedIn') == true;
    } catch (e) {
      return false;
    }
  }

  // Clear farmer data (logout)
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Keep language preference
      final language = prefs.getString('selectedLanguage');
      
      // Clear all farmer-related data
      await prefs.remove('farmerId');
      await prefs.remove('farmerName');
      await prefs.remove('phoneNumber');
      await prefs.remove('profileImageUrl');
      await prefs.remove('farmerData');
      await prefs.remove('token');
      await prefs.setBool('keepMeLoggedIn', false);
      
      // Restore language preference
      if (language != null) {
        await prefs.setString('selectedLanguage', language);
      }
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  // Get stored token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      return null;
    }
  }

  static Future getFarmerById(String farmerId) async {}
}

// Unified response class for better type safety
class ServiceResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final String? token;
  final int? statusCode;

  ServiceResponse({
    required this.success,
    required this.message,
    this.data,
    this.token,
    this.statusCode,
  });

  factory ServiceResponse.success({
    Map<String, dynamic>? data,
    String message = 'Success',
    String? token,
  }) {
    return ServiceResponse(
      success: true,
      message: message,
      data: data,
      token: token,
    );
  }

  factory ServiceResponse.error({
    String message = 'An error occurred',
    int? statusCode,
  }) {
    return ServiceResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    return 'ServiceResponse{success: $success, message: $message, data: $data, token: $token, statusCode: $statusCode}';
  }
}