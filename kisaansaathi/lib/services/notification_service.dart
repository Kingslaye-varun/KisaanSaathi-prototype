import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() {
    return _instance;
  }
  
  NotificationService._internal() {
    // Start periodic check for new notifications
    _startPeriodicCheck();
  }
  
  final String baseUrl = 'https://kisaansaathi-api.example.com/api';
  final bool _isOfflineMode = true; // Set to false when backend is ready
  
  // Stream controller for unread notification count
  final StreamController<int> _unreadCountController = StreamController<int>.broadcast();
  Stream<int> get unreadCountStream => _unreadCountController.stream;
  
  // Current user ID
  String? _currentUserId;
  
  // Set current user ID
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    _checkUnreadCount();
  }
  
  // Start periodic check for new notifications
  void _startPeriodicCheck() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_currentUserId != null) {
        _checkUnreadCount();
      }
    });
  }
  
  // Check unread count and update stream
  Future<void> _checkUnreadCount() async {
    if (_currentUserId == null) return;
    
    try {
      final count = await getUnreadCount(_currentUserId!);
      _unreadCountController.add(count);
    } catch (e) {
      print('Error checking unread count: $e');
    }
  }

  // Get all notifications for a user
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    if (_isOfflineMode) {
      // Return mock data in offline mode
      return _getDummyNotifications(userId);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/notifications/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          return List<Map<String, dynamic>>.from(responseData['data']['notifications']);
        } else {
          print('Failed to get notifications: ${response.body}');
          return _getDummyNotifications(userId);
        }
      } else {
        print('Failed to get notifications: ${response.body}');
        return _getDummyNotifications(userId);
      }
    } catch (e) {
      print('Error getting notifications: $e');
      return _getDummyNotifications(userId);
    }
  }

  // Create a new notification
  Future<bool> createNotification({
    required String userId,
    required String senderId,
    required String senderName,
    required String message,
    required String conversationId,
    String? senderType,
  }) async {
    if (_isOfflineMode) {
      // Simulate success in offline mode
      return true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'senderId': senderId,
          'senderName': senderName,
          'message': message,
          'conversationId': conversationId,
          'senderType': senderType ?? 'farmer',
          'read': false,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating notification: $e');
      return true; // Return true to simulate success even if API call fails
    }
  }

  // Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    if (_isOfflineMode) {
      // Simulate success in offline mode
      return true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'read': true,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking notification as read: $e');
      return true; // Return true to simulate success even if API call fails
    }
  }

  // Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    if (_isOfflineMode) {
      // Return mock data in offline mode
      return 3; // Mock unread count
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/notifications/$userId/unread'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          return responseData['data']['count'];
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting unread count: $e');
      return 3; // Return mock count if API call fails
    }
  }

  // Helper method to get dummy notifications for testing
  List<Map<String, dynamic>> _getDummyNotifications(String userId) {
    final now = DateTime.now();
    
    return [
      {
        '_id': 'notif_1',
        'userId': userId,
        'senderId': 'farmer2',
        'senderName': 'Suresh Singh',
        'message': 'Hi there! I saw you grow tomatoes too. How\'s your crop doing this season?',
        'conversationId': 'mock_conversation_${userId}_farmer2',
        'senderType': 'farmer',
        'read': false,
        'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        '_id': 'notif_2',
        'userId': userId,
        'senderId': 'officer1',
        'senderName': 'Rajiv Kumar',
        'message': 'Hello, I\'m following up on your query about the PM-KISAN scheme.',
        'conversationId': 'mock_conversation_${userId}_officer1',
        'senderType': 'officer',
        'read': true,
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        '_id': 'notif_3',
        'userId': userId,
        'senderId': 'farmer3',
        'senderName': 'Anita Desai',
        'message': 'Do you have any tips for organic pest control?',
        'conversationId': 'mock_conversation_${userId}_farmer3',
        'senderType': 'farmer',
        'read': false,
        'timestamp': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        '_id': 'notif_4',
        'userId': userId,
        'senderId': 'officer2',
        'senderName': 'Priya Sharma',
        'message': 'Your soil testing results are ready. Would you like to discuss them?',
        'conversationId': 'mock_conversation_${userId}_officer2',
        'senderType': 'officer',
        'read': false,
        'timestamp': now.subtract(const Duration(hours: 8)).toIso8601String(),
      },
      {
        '_id': 'notif_5',
        'userId': userId,
        'senderId': 'farmer4',
        'senderName': 'Ramesh Patel',
        'message': 'I\'m interested in learning about your irrigation techniques.',
        'conversationId': 'mock_conversation_${userId}_farmer4',
        'senderType': 'farmer',
        'read': true,
        'timestamp': now.subtract(const Duration(days: 2)).toIso8601String(),
      },
    ];
  }
}