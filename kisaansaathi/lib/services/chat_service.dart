import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kisaansaathi/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  // Using a mock API for development
  final String baseUrl = 'https://mockapi.kisaansaathi.com/api';
  final bool _isOfflineMode = true; // Set to true to use offline mode
  final NotificationService _notificationService = NotificationService();
  
  // Initialize the service
  ChatService() {
    // Set a dummy current user ID for testing
    _notificationService.setCurrentUserId('farmer_123');
  }

  // Get or create a conversation between two users
  Future<Map<String, dynamic>> getOrCreateConversation(String userId1, String userId2, {String? chatType}) async {
    if (_isOfflineMode) {
      // Return a mock conversation in offline mode
      return {
        'success': true,
        'data': {
          '_id': '${userId1}_${userId2}_${DateTime.now().millisecondsSinceEpoch}',
          'participants': [userId1, userId2],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'chatType': chatType ?? 'regular',
        },
      };
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found',
        };
      }

      final Map<String, dynamic> requestBody = {
        'participants': [userId1, userId2],
      };
      
      // Add chatType if provided
      if (chatType != null) {
        requestBody['chatType'] = chatType;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/conversations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // Fall back to offline mode if API fails
        return {
          'success': true,
          'data': {
            '_id': '${userId1}_${userId2}_${DateTime.now().millisecondsSinceEpoch}',
            'participants': [userId1, userId2],
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'chatType': chatType ?? 'regular',
          },
        };
      }
    } catch (e) {
      // Return a mock conversation in case of error
      return {
        'success': true,
        'data': {
          '_id': '${userId1}_${userId2}_${DateTime.now().millisecondsSinceEpoch}',
          'participants': [userId1, userId2],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'chatType': chatType ?? 'regular',
        }
      };
    }
  }
  
  // Helper method to create notifications for message recipients
   Future<void> _createNotificationForRecipient(String conversationId, String senderId, String text, String userType, String? chatType) async {
     try {
       // Extract recipient ID from conversation ID
       final parts = conversationId.split('_');
       if (parts.length >= 3) {
         final userId1 = parts[1];
         final userId2 = parts[2];
         
         // Determine recipient ID (the user who is not the sender)
         final recipientId = senderId == userId1 ? userId2 : userId1;
         
         // Get sender name (using mock data for now)
         String senderName = "Unknown User";
         if (userType == 'farmer') {
           senderName = "Farmer User";
         } else if (userType == 'officer') {
           senderName = "Agriculture Officer";
         }
         
         // Create notification
         await _notificationService.createNotification(
           userId: recipientId,
           senderId: senderId,
           senderName: senderName,
           message: text,
           conversationId: conversationId,
           senderType: userType,
         );
       }
     } catch (e) {
       // Silently handle errors in notification creation
       print('Error creating notification: $e');
     }
   }

  // Get messages for a conversation
  Future<Map<String, dynamic>> getMessages(String conversationId, {String? chatType}) async {
    if (_isOfflineMode) {
      // Extract user IDs from conversation ID (format: userId1_userId2_timestamp)
      final parts = conversationId.split('_');
      if (parts.length >= 2) {
        final userId1 = parts[0];
        final userId2 = parts[1];
        
        // If chatType is specified as 'farmer_to_farmer', use farmer-to-farmer messages
        if (chatType == 'farmer_to_farmer') {
          return {
            'success': true,
            'data': {
              'messages': getFarmerToFarmerMessages(userId1, userId2),
            }
          };
        }
        
        return {
          'success': true,
          'data': {
            'messages': getDummyMessages(userId1, userId2, 'farmer', 'farmer'),
          }
        };
      }
      
      return {
        'success': true,
        'data': {
          'messages': [],
        }
      };
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      // Add chatType parameter to the URL if provided
      final Uri uri = chatType != null
          ? Uri.parse('$baseUrl/conversations/$conversationId/messages?chatType=$chatType')
          : Uri.parse('$baseUrl/conversations/$conversationId/messages');
      
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Fall back to offline mode if API fails
        final parts = conversationId.split('_');
        if (parts.length >= 2) {
          final userId1 = parts[0];
          final userId2 = parts[1];
          
          // Use farmer-to-farmer messages if chatType is specified
          if (chatType == 'farmer_to_farmer') {
            return {
              'success': true,
              'data': {
                'messages': getFarmerToFarmerMessages(userId1, userId2),
              }
            };
          }
          
          return {
            'success': true,
            'data': {
              'messages': getDummyMessages(userId1, userId2, 'farmer', 'farmer'),
            }
          };
        }
        
        return {
          'success': true,
          'data': {
            'messages': [],
          }
        };
      }
    } catch (e) {
      // Fall back to offline mode if there's an error
      final parts = conversationId.split('_');
      if (parts.length >= 2) {
        final userId1 = parts[0];
        final userId2 = parts[1];
        
        // Use farmer-to-farmer messages if chatType is specified
        if (chatType == 'farmer_to_farmer') {
          return {
            'success': true,
            'data': {
              'messages': getFarmerToFarmerMessages(userId1, userId2),
            }
          };
        }
        
        return {
          'success': true,
          'data': {
            'messages': getDummyMessages(userId1, userId2, 'farmer', 'farmer'),
          }
        };
      }
      
      return {
        'success': true,
        'data': {
          'messages': [],
        }
      };
    }
  }

  // Send a message in a conversation
  Future<Map<String, dynamic>> sendMessage(String conversationId, String senderId, String text, String userType, {String? chatType}) async {
    // Create a notification for the recipient
    _createNotificationForRecipient(conversationId, senderId, text, userType, chatType);
    
    if (_isOfflineMode) {
      // Return success in offline mode
      return {
        'success': true,
        'data': {
          '_id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
          'conversationId': conversationId,
          'senderId': senderId,
          'text': text,
          'userType': userType,
          'chatType': chatType ?? 'regular',
          'timestamp': DateTime.now().toIso8601String(),
        }
      };
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      final Map<String, dynamic> requestBody = {
        'senderId': senderId,
        'text': text,
        'userType': userType,
      };
      
      // Add chatType if provided
      if (chatType != null) {
        requestBody['chatType'] = chatType;
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/conversations/$conversationId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Fall back to offline mode if API fails
        return {
          'success': true,
          'data': {
            '_id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
            'conversationId': conversationId,
            'senderId': senderId,
            'text': text,
            'userType': userType,
            'chatType': chatType ?? 'regular',
            'timestamp': DateTime.now().toIso8601String(),
          }
        };
      }
    } catch (e) {
      // Fall back to offline mode if there's an error
      return {
        'success': true,
        'data': {
          '_id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
          'conversationId': conversationId,
          'senderId': senderId,
          'text': text,
          'userType': userType,
          'chatType': chatType ?? 'regular',
          'timestamp': DateTime.now().toIso8601String(),
        }
      };
    }
  }

  // Get all conversations for a user
  Future<Map<String, dynamic>> getUserConversations(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch conversations: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching conversations: $e',
      };
    }
  }

  // For demo purposes - get dummy messages
  List<Map<String, dynamic>> getDummyMessages(String senderId, String receiverId, String senderType, String receiverType) {
    final now = DateTime.now();
    
    return [
      {
        '_id': '1',
        'conversationId': '${senderId}_${receiverId}',
        'senderId': receiverId,
        'text': 'Hello, I saw your profile and wanted to connect with a fellow farmer!',
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
        'userType': receiverType,
      },
      {
        '_id': '2',
        'conversationId': '${senderId}_${receiverId}',
        'senderId': senderId,
        'text': 'Hi there! I\'m looking for advice on organic pest control for my tomato plants.',
        'timestamp': now.subtract(const Duration(hours: 23)).toIso8601String(),
        'userType': senderType,
      },
      {
        '_id': '3',
        'conversationId': '${senderId}_${receiverId}',
        'senderId': receiverId,
        'text': 'I recommend using neem oil spray. It\'s effective and completely organic. I\'ve been using it on my farm for years.',
        'timestamp': now.subtract(const Duration(hours: 22)).toIso8601String(),
        'userType': receiverType,
      },
      {
        '_id': '4',
        'conversationId': '${senderId}_${receiverId}',
        'senderId': senderId,
        'text': 'That sounds great! How often should I apply it?',
        'timestamp': now.subtract(const Duration(hours: 21)).toIso8601String(),
        'userType': senderType,
      },
      {
        '_id': '5',
        'conversationId': '${senderId}_${receiverId}',
        'senderId': receiverId,
        'text': 'Apply it once a week, preferably in the evening. Make sure to dilute it properly - about 2-3 ml per liter of water.',
        'timestamp': now.subtract(const Duration(hours: 20)).toIso8601String(),
        'userType': receiverType,
      },
    ];
  }
  
  // Helper method to generate farmer-to-farmer conversation messages
  List<Map<String, dynamic>> getFarmerToFarmerMessages(String farmerId1, String farmerId2) {
    final now = DateTime.now();
    
    return [
      {
        '_id': '1',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId2,
        'text': 'Hello fellow farmer! How are your crops doing this season?',
        'timestamp': now.subtract(const Duration(days: 2, hours: 3)).toIso8601String(),
        'userType': 'farmer',
      },
      {
        '_id': '2',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId1,
        'text': 'Hi there! My rice crop is doing well, but I\'m having some issues with pests in my vegetable garden.',
        'timestamp': now.subtract(const Duration(days: 2, hours: 2, minutes: 45)).toIso8601String(),
        'userType': 'farmer',
      },
      {
        '_id': '3',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId2,
        'text': 'I had similar issues last season. Have you tried neem oil spray? It worked wonders for me and it\'s organic.',
        'timestamp': now.subtract(const Duration(days: 2, hours: 2, minutes: 30)).toIso8601String(),
        'userType': 'farmer',
      },
      {
        '_id': '4',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId1,
        'text': 'I haven\'t tried neem oil yet. How do you prepare it and how often should I apply it?',
        'timestamp': now.subtract(const Duration(days: 2, hours: 2)).toIso8601String(),
        'userType': 'farmer',
      },
      {
        '_id': '5',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId2,
        'text': 'Mix 2-3 tablespoons of neem oil with a liter of water and a drop of dish soap. Spray it once a week, preferably in the evening. It keeps most pests away and is safe for beneficial insects too!',
        'timestamp': now.subtract(const Duration(days: 2, hours: 1, minutes: 45)).toIso8601String(),
        'userType': 'farmer',
      },
      {
        '_id': '6',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId1,
        'text': 'That sounds perfect! I\'ll try it this weekend. By the way, what variety of rice are you growing this season?',
        'timestamp': now.subtract(const Duration(days: 2, hours: 1, minutes: 30)).toIso8601String(),
        'userType': 'farmer',
      },
      {
        '_id': '7',
        'conversationId': '${farmerId1}_${farmerId2}',
        'senderId': farmerId2,
        'text': 'I\'m growing Basmati this year. The market price has been good, and it requires less water than some other varieties.',
        'timestamp': now.subtract(const Duration(days: 2, hours: 1)).toIso8601String(),
        'userType': 'farmer',
      },
    ];
  }
}