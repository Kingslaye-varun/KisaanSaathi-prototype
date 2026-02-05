import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chat_service.dart';
import '../screens/consumer_chat_detail_screen.dart';
import 'package:intl/intl.dart';

class ConsumerChatListScreen extends StatefulWidget {
  const ConsumerChatListScreen({super.key});

  @override
  State<ConsumerChatListScreen> createState() => _ConsumerChatListScreenState();
}

class _ConsumerChatListScreenState extends State<ConsumerChatListScreen> {
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;
  String _currentUserId = '';
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print('🔵 Loading consumer chat list...');
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentUserId = prefs.getString('consumerId') ?? '';
      _currentUserName = prefs.getString('consumerName') ?? 'Consumer';
    });

    print('✅ Current user: $_currentUserName (ID: $_currentUserId)');

    await _loadConversations();
  }

  Future<void> _loadConversations() async {
    print('💬 Fetching conversations...');
    setState(() => _isLoading = true);

    try {
      final result = await ChatService.getConversations(_currentUserId);

      if (result['success']) {
        setState(() {
          _conversations = List<Map<String, dynamic>>.from(
            result['conversations'] ?? [],
          );
          _isLoading = false;
        });
        print('✅ Loaded ${_conversations.length} conversations');
      } else {
        print('❌ Failed to load conversations: ${result['message']}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading conversations: $e');
      setState(() => _isLoading = false);
    }
  }

  void _openChat(Map<String, dynamic> conversation) {
    print('💬 Opening chat with: ${conversation['otherUser']['name']}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsumerChatDetailScreen(
          otherUserId: conversation['otherUser']['_id'],
          otherUserName: conversation['otherUser']['name'],
          otherUserImage: conversation['otherUser']['profileImage']?['url'],
          otherUserType: conversation['otherUser']['userType'] ?? 'farmer',
        ),
      ),
    ).then((_) {
      // Refresh conversations when returning
      _loadConversations();
    });
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';

    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return DateFormat('HH:mm').format(date);
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return DateFormat('EEEE').format(date);
      } else {
        return DateFormat('dd/MM/yyyy').format(date);
      }
    } catch (e) {
      print('❌ Error formatting time: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.green.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConversations,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadConversations,
              child: ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final conversation = _conversations[index];
                  return _buildChatTile(conversation);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with farmers from the community',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> conversation) {
    final otherUser = conversation['otherUser'];
    final lastMessage = conversation['lastMessage'];
    final unreadCount = conversation['unreadCount'] ?? 0;

    return InkWell(
      onTap: () => _openChat(conversation),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            // Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: otherUser['profileImage']?['url'] != null
                      ? NetworkImage(otherUser['profileImage']['url'])
                      : null,
                  child: otherUser['profileImage']?['url'] == null
                      ? Text(
                          otherUser['name'][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                // Online indicator (optional - can add later)
              ],
            ),
            const SizedBox(width: 12),

            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name
                      Expanded(
                        child: Text(
                          otherUser['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Time
                      Text(
                        _formatTime(lastMessage?['createdAt']),
                        style: TextStyle(
                          fontSize: 12,
                          color: unreadCount > 0
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Last Message
                      Expanded(
                        child: Text(
                          lastMessage?['content'] ?? 'No messages yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: unreadCount > 0
                                ? Colors.black87
                                : Colors.grey.shade600,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread Badge
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
