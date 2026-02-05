import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/work_request.dart';

class WorkRequestService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/work-requests';

  // Create a new work request (Farmer posts a job)
  static Future<ServiceResult> createWorkRequest({
    required String farmerId,
    required String farmerName,
    required String farmerPhone,
    required String workType,
    required double paymentAmount,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'farmerId': farmerId,
          'farmerName': farmerName,
          'farmerPhone': farmerPhone,
          'workType': workType,
          'paymentAmount': paymentAmount,
          'description': description,
        }),
      );

      if (kDebugMode) {
        print('Create work request response: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final workRequest = WorkRequest.fromJson(data['workRequest']);

        return ServiceResult(
          success: true,
          message: 'Work request created successfully',
          data: workRequest,
        );
      } else {
        final error = jsonDecode(response.body);
        return ServiceResult(
          success: false,
          message: error['message'] ?? 'Failed to create work request',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in createWorkRequest: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to create work request: $e',
      );
    }
  }

  // Get all open work requests (for workers)
  static Future<ServiceResult> getOpenWorkRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/open'),
      );

      if (kDebugMode) {
        print('Get open work requests response: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> requestsJson = data['workRequests'];
        final List<WorkRequest> workRequests = requestsJson
            .map((json) => WorkRequest.fromJson(json))
            .toList();

        return ServiceResult(
          success: true,
          message: 'Work requests fetched successfully',
          data: workRequests,
        );
      } else {
        return ServiceResult(
          success: false,
          message: 'Failed to fetch work requests',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getOpenWorkRequests: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to fetch work requests: $e',
      );
    }
  }

  // Get work requests by farmer ID
  static Future<ServiceResult> getFarmerWorkRequests(String farmerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/farmer/$farmerId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> requestsJson = data['workRequests'];
        final List<WorkRequest> workRequests = requestsJson
            .map((json) => WorkRequest.fromJson(json))
            .toList();

        return ServiceResult(
          success: true,
          message: 'Work requests fetched successfully',
          data: workRequests,
        );
      } else {
        return ServiceResult(
          success: false,
          message: 'Failed to fetch work requests',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getFarmerWorkRequests: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to fetch work requests: $e',
      );
    }
  }

  // Get work requests accepted by a worker
  static Future<ServiceResult> getWorkerJobs(String workerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/worker/$workerId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> requestsJson = data['workRequests'];
        final List<WorkRequest> workRequests = requestsJson
            .map((json) => WorkRequest.fromJson(json))
            .toList();

        return ServiceResult(
          success: true,
          message: 'Worker jobs fetched successfully',
          data: workRequests,
        );
      } else {
        return ServiceResult(
          success: false,
          message: 'Failed to fetch worker jobs',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getWorkerJobs: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to fetch worker jobs: $e',
      );
    }
  }

  // Accept a work request (Worker accepts a job)
  static Future<ServiceResult> acceptWorkRequest({
    required String requestId,
    required String workerId,
    required String workerName,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/accept/$requestId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'workerId': workerId,
          'workerName': workerName,
        }),
      );

      if (kDebugMode) {
        print('Accept work request response: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final workRequest = WorkRequest.fromJson(data['workRequest']);

        return ServiceResult(
          success: true,
          message: 'Work request accepted successfully',
          data: workRequest,
        );
      } else {
        final error = jsonDecode(response.body);
        return ServiceResult(
          success: false,
          message: error['message'] ?? 'Failed to accept work request',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in acceptWorkRequest: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to accept work request: $e',
      );
    }
  }

  // Delete a work request (Farmer cancels a job)
  static Future<ServiceResult> deleteWorkRequest(String requestId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$requestId'),
      );

      if (response.statusCode == 200) {
        return ServiceResult(
          success: true,
          message: 'Work request deleted successfully',
        );
      } else {
        return ServiceResult(
          success: false,
          message: 'Failed to delete work request',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in deleteWorkRequest: $e');
      }
      return ServiceResult(
        success: false,
        message: 'Failed to delete work request: $e',
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
