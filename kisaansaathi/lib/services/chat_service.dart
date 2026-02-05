import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static final String baseUrl = '${dotenv.env['NODE_API_URL']}/api/chat';

  // Get all conversations for a user
  static Future<Map<String, dynamic>> getConversations(String userId) async {
    print('🔵 Fetching conversations for user: $userId');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Loaded ${data['conversations']?.length ?? 0} conversations');
        return {'success': true, 'conversations': data['conversations'] ?? []};
      } else {
        print('❌ Failed to load conversations: ${response.body}');
        return {
          'success': false,
          'message': 'Failed to load conversations',
          'conversations': [],
        };
      }
    } catch (e) {
      print('❌ Error fetching conversations: $e');
      return {'success': false, 'message': e.toString(), 'conversations': []};
    }
  }

  // Get messages between two users
  static Future<Map<String, dynamic>> getMessages(
    String userId1,
    String userId2,
  ) async {
    print('🔵 Fetching messages between $userId1 and $userId2');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/messages/$userId1/$userId2'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Loaded ${data['messages']?.length ?? 0} messages');
        return {'success': true, 'messages': data['messages'] ?? []};
      } else {
        print('❌ Failed to load messages: ${response.body}');
        return {
          'success': false,
          'message': 'Failed to load messages',
          'messages': [],
        };
      }
    } catch (e) {
      print('❌ Error fetching messages: $e');
      return {'success': false, 'message': e.toString(), 'messages': []};
    }
  }

  // Send a message
  static Future<Map<String, dynamic>> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    print('🔵 Sending message from $senderId to $receiverId');
    print('📝 Content: $content');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'sender': senderId,
          'receiver': receiverId,
          'content': content,
        }),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Message sent successfully');
        return {'success': true, 'message': data['message']};
      } else {
        print('❌ Failed to send message: ${response.body}');
        return {'success': false, 'message': 'Failed to send message'};
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
