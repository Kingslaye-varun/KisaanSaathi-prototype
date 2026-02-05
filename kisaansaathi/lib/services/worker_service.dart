import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/worker.dart';

class WorkerService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/workers';

  // Register a new worker
  static Future<ServiceResult> registerWorker({
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

      // Add text fields
      request.fields['name'] = name;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['language'] = language;

      // Add profile image if provided
      if (profileImage != null && await profileImage.exists()) {
        try {
          request.files.add(
            await http.MultipartFile.fromPath('profileImage', profileImage.path),
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error adding profile image: $e');
          }
          // Continue without image
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Worker registration response: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final worker = Worker.fromJson(data['worker']);

        // Save worker data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('workerId', worker.id);
        await prefs.setString('workerName', worker.name);
        await prefs.setString('phoneNumber', worker.phoneNumber);
        await prefs.setString('userType', 'worker');
        if (worker.profileImageUrl != null) {
          await prefs.setString('profileImageUrl', worker.profileImageUrl!);
        }

        return ServiceResult(
          success: true,
          message: 'Worker registered successfully',
          data: worker,
        );
      } else {
        final error = jsonDecode(response.body);
        return ServiceResult(
          success: false,
          message: error['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in registerWorker: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to register worker: $e',
      );
    }
  }

  // Get worker by phone number
  static Future<ServiceResult> getWorkerByPhone(String phoneNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/phone/$phoneNumber'),
      );

      if (kDebugMode) {
        print('Get worker response: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final worker = Worker.fromJson(data['worker']);

        // Save worker data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('workerId', worker.id);
        await prefs.setString('workerName', worker.name);
        await prefs.setString('phoneNumber', worker.phoneNumber);
        await prefs.setString('userType', 'worker');
        if (worker.profileImageUrl != null) {
          await prefs.setString('profileImageUrl', worker.profileImageUrl!);
        }

        return ServiceResult(
          success: true,
          message: 'Worker found',
          data: worker,
        );
      } else {
        return ServiceResult(
          success: false,
          message: 'Worker not found. Please sign up.',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getWorkerByPhone: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to fetch worker: $e',
      );
    }
  }

  // Get worker by ID
  static Future<ServiceResult> getWorkerById(String workerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$workerId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final worker = Worker.fromJson(data['worker']);

        return ServiceResult(
          success: true,
          message: 'Worker found',
          data: worker,
        );
      } else {
        return ServiceResult(
          success: false,
          message: 'Worker not found',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getWorkerById: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to fetch worker: $e',
      );
    }
  }
}

class ServiceResult {
  final bool success;
  final String message;
  final dynamic data;

  ServiceResult({
    required this.success,
    required this.message,
    this.data,
  });
}
