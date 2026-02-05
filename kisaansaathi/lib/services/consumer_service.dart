import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConsumerService {
  static final String baseUrl = '${dotenv.env['NODE_API_URL']}/api/consumers';
  static const Duration timeoutDuration = Duration(seconds: 60);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static http.Client get _client => http.Client();

  static Future<http.Response> _makeRequest(
    Future<http.Response> Function() request, {
    Duration timeout = timeoutDuration,
  }) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException {
      throw TimeoutException(
        'Request timed out after ${timeout.inSeconds} seconds',
      );
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

  // Register a new consumer
  static Future<ServiceResponse> registerConsumer({
    required String name,
    required String phoneNumber,
    required String language,
    File? profileImage,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/register'),
      );

      request.fields['name'] = name;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['language'] = language;

      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profileImage', profileImage.path),
        );
      }

      var streamedResponse = await _makeRequest(() async {
        return await http.Response.fromStream(await request.send());
      });

      if (streamedResponse.body.trim().startsWith('<!DOCTYPE html>') ||
          streamedResponse.body.trim().startsWith('<html>')) {
        return ServiceResponse.error(
          message:
              'Server returned HTML instead of JSON. The server might be down.',
          statusCode: streamedResponse.statusCode,
        );
      }

      try {
        final responseData = json.decode(streamedResponse.body);

        if (streamedResponse.statusCode == 201 ||
            streamedResponse.statusCode == 200) {
          await _saveConsumerToPrefs(
            responseData['data'],
            token: responseData['token'],
          );

          return ServiceResponse.success(
            data: responseData['data'],
            message: responseData['message'],
            token: responseData['token'],
          );
        } else {
          return ServiceResponse.error(
            message: responseData['message'] ?? 'Failed to register consumer',
            statusCode: streamedResponse.statusCode,
          );
        }
      } catch (e) {
        return ServiceResponse.error(
          message: 'Failed to parse server response: ${e.toString()}',
          statusCode: streamedResponse.statusCode,
        );
      }
    } on TimeoutException catch (e) {
      return ServiceResponse.error(message: e.message ?? 'Request timed out');
    } catch (e) {
      return ServiceResponse.error(message: e.toString());
    }
  }

  // Get consumer by phone number
  static Future<ServiceResponse> getConsumerByPhone(String phoneNumber) async {
    try {
      final response = await _makeRequest(
        () => _client.get(
          Uri.parse('$baseUrl/$phoneNumber'),
          headers: defaultHeaders,
        ),
      );

      if (response.body.trim().startsWith('<!DOCTYPE html>') ||
          response.body.trim().startsWith('<html>')) {
        return ServiceResponse.error(
          message: 'Server returned HTML instead of JSON.',
          statusCode: response.statusCode,
        );
      }

      try {
        final responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          await _saveConsumerToPrefs(responseData['data']);

          return ServiceResponse.success(
            data: responseData['data'],
            message: 'Consumer retrieved successfully',
          );
        } else {
          String message;
          switch (response.statusCode) {
            case 404:
              message = 'Consumer not found. Please register.';
              break;
            case 401:
              message = 'Authentication error. Please login again.';
              break;
            default:
              message = responseData['message'] ?? 'Failed to get consumer';
          }

          return ServiceResponse.error(
            message: message,
            statusCode: response.statusCode,
          );
        }
      } catch (e) {
        return ServiceResponse.error(
          message: 'Failed to parse server response: ${e.toString()}',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (e) {
      return ServiceResponse.error(message: e.message ?? 'Request timed out');
    } catch (e) {
      return ServiceResponse.error(message: e.toString());
    }
  }

  // Save consumer data to shared preferences
  static Future<void> _saveConsumerToPrefs(
    Map<String, dynamic> consumer, {
    String? token,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('userType', 'consumer');
      await prefs.setString('consumerId', consumer['_id'] ?? '');
      await prefs.setString('consumerName', consumer['name'] ?? '');
      await prefs.setString('phoneNumber', consumer['phoneNumber'] ?? '');
      await prefs.setString('selectedLanguage', consumer['language'] ?? 'en');

      if (consumer['profileImage'] != null &&
          consumer['profileImage']['url'] != null) {
        await prefs.setString(
          'profileImageUrl',
          consumer['profileImage']['url'],
        );
      }

      await prefs.setString('consumerData', json.encode(consumer));
      await prefs.setBool('keepMeLoggedIn', true);

      if (token != null && token.isNotEmpty) {
        await prefs.setString('token', token);
      }
    } catch (e) {
      throw Exception('Failed to save consumer data: ${e.toString()}');
    }
  }

  // Get current consumer from shared preferences
  static Future<Map<String, dynamic>?> getCurrentConsumer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final consumerJson = prefs.getString('consumerData');

      if (consumerJson != null) {
        return json.decode(consumerJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get consumer data: ${e.toString()}');
    }
  }

  // Check if user is logged in as consumer
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('consumerId') != null &&
          prefs.getBool('keepMeLoggedIn') == true;
    } catch (e) {
      return false;
    }
  }

  // Clear consumer data (logout)
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final language = prefs.getString('selectedLanguage');

      await prefs.remove('userType');
      await prefs.remove('consumerId');
      await prefs.remove('consumerName');
      await prefs.remove('phoneNumber');
      await prefs.remove('profileImageUrl');
      await prefs.remove('consumerData');
      await prefs.remove('token');
      await prefs.setBool('keepMeLoggedIn', false);

      if (language != null) {
        await prefs.setString('selectedLanguage', language);
      }
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }
}

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
}
