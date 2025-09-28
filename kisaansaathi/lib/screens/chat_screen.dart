import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/chat_service.dart';
import '../services/notification_service.dart';


class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? chatPartner;
  final String? conversationId;

  const ChatScreen({
    super.key, 
    this.chatPartner,
    this.conversationId
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _currentFarmer;
  Map<String, dynamic>? _chatPartner;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentFarmer();
    
    // If chatPartner is provided from constructor, use it
    if (widget.chatPartner != null) {
      setState(() {
        _chatPartner = widget.chatPartner;
      });
    } else {
      // For testing farmer-to-farmer chat, create dummy farmer data if no chat partner
      _createDummyFarmerData();
    }
    
    // Load conversation if conversationId is provided
    if (widget.conversationId != null) {
      _loadConversation(widget.conversationId!);
    }
  }
  
  // Create dummy farmer data for testing
  void _createDummyFarmerData() {
    if (_currentFarmer == null) {
      _currentFarmer = {
        '_id': 'farmer1',
        'name': 'Rajesh Kumar',
        'userType': 'farmer',
        'location': 'Punjab',
        'crops': ['wheat', 'rice', 'vegetables'],
      };
    }
    
    if (_chatPartner == null) {
      _chatPartner = {
        '_id': 'farmer2',
        'name': 'Suresh Singh',
        'userType': 'farmer',
        'location': 'Haryana',
        'crops': ['tomatoes', 'potatoes', 'onions'],
      };
      
      // Load messages for this dummy farmer chat
      _loadMessages();
    }
  }
  
  // Load conversation using conversationId
  Future<void> _loadConversation(String conversationId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // Here you would typically fetch messages from your backend using the conversationId
      // For now, we'll just simulate loading with some delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Add some dummy messages for testing
      setState(() {
        _messages.clear();
        _messages.addAll([
          {
            'senderId': _currentFarmer?['_id'] ?? 'farmer1',
            'text': 'Hello, I received your notification!',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toString(),
          },
          {
            'senderId': _chatPartner?['_id'] ?? 'farmer2',
            'text': 'Great! Let\'s discuss our farming issues.',
            'timestamp': DateTime.now().toString(),
          },
        ]);
        _isLoading = false;
      });
      
      // Scroll to bottom after messages load
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading conversation: $e');
    }
  }

  Future<void> _loadCurrentFarmer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerString = prefs.getString('farmer');
      
      if (farmerString != null) {
        setState(() {
          _currentFarmer = jsonDecode(farmerString);
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get chat partner from route arguments if available
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        _chatPartner = args;
      });
      _loadMessages();
    }
  }

  

  Future<void> _loadMessages() async {
    // This would normally fetch messages from an API
    // For now, we'll use dummy data
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_chatPartner != null) {
      // Check if this is a farmer-to-farmer conversation
      final bool isFarmerToFarmer = _chatPartner!['userType'] == 'farmer';
      
      setState(() {
        if (isFarmerToFarmer) {
          // Farmer-to-farmer conversation messages
          _messages.addAll(_getFarmerToFarmerDummyMessages());
        } else {
          // Regular support conversation messages
          _messages.addAll(_getDummyMessages());
        }
        _isLoading = false;
      });
      
      // Scroll to bottom after messages load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }
  
  // Helper method to get dummy messages for testing
  List<Map<String, dynamic>> _getDummyMessages() {
    final now = DateTime.now();
    
    return [
      {
        'senderId': _chatPartner!['_id'],
        'text': 'Hello, how can I help you with your farming needs?',
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'senderId': _currentFarmer!['_id'],
        'text': 'I\'m looking for advice on organic pest control for my tomato plants.',
        'timestamp': now.subtract(const Duration(hours: 23)).toIso8601String(),
      },
      {
        'senderId': _chatPartner!['_id'],
        'text': 'I recommend using neem oil spray. It\'s effective and completely organic.',
        'timestamp': now.subtract(const Duration(hours: 22)).toIso8601String(),
      },
    ];
  }
  
  // Helper method to get farmer-to-farmer dummy messages for testing
  List<Map<String, dynamic>> _getFarmerToFarmerDummyMessages() {
    final now = DateTime.now();
    
    return [
      {
        'senderId': _chatPartner!['_id'],
        'text': 'Hi there! I saw you grow tomatoes too. How\'s your crop doing this season?',  
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'senderId': _currentFarmer!['_id'],
        'text': 'Having some issues with pests. Do you have any organic solutions?',
        'timestamp': now.subtract(const Duration(hours: 23)).toIso8601String(),
      },
      {
        'senderId': _chatPartner!['_id'],
        'text': 'I use neem oil mixed with a bit of soap. Works great for my farm!',
        'timestamp': now.subtract(const Duration(hours: 22)).toIso8601String(),
      },
    ];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final messageText = _messageController.text.trim();
    final bool isFarmerToFarmer = _chatPartner != null && _chatPartner!['userType'] == 'farmer';
    
    setState(() {
      _messages.add({
        'senderId': _currentFarmer!['_id'],
        'text': messageText,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
    
    _messageController.clear();
    _scrollToBottom();
    
    // Simulate reply after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          String replyText = isFarmerToFarmer
              ? 'Thanks for sharing! I\'ll try that solution on my farm too.'
              : 'Thanks for your message! I\'ll get back to you soon.';
              
          _messages.add({
            'senderId': _chatPartner!['_id'],
            'text': replyText,
            'timestamp': DateTime.now().toIso8601String(),
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _chatPartner != null
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: _chatPartner!['profileImage'] != null
                        ? NetworkImage(_chatPartner!['profileImage'])
                        : null,
                    backgroundColor: Colors.grey.shade200,
                    child: _chatPartner!['profileImage'] == null
                        ? const Icon(Icons.person, size: 16, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(_chatPartner!['name'] ?? 'Chat'),
                ],
              )
            : const Text('Chat'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chatPartner == null
              ? _buildChatList()
              : _buildChatMessages(),
    );
  }

  Widget _buildChatList() {
    // This would normally fetch chat partners from an API
    // For now, we'll use dummy data
    final dummyPartners = [
      {
        '_id': '1',
        'name': 'Farmer Support',
        'profileImage': null,
        'lastMessage': 'How can I help you today?',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        '_id': '2',
        'name': 'Local Retailer',
        'profileImage': null,
        'lastMessage': 'I\'m interested in buying your organic vegetables.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        '_id': '3',
        'name': 'Agricultural Expert',
        'profileImage': null,
        'lastMessage': 'The soil testing results are ready.',
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      },
    ];

    return ListView.builder(
      itemCount: dummyPartners.length,
      itemBuilder: (context, index) {
        final partner = dummyPartners[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: const Icon(Icons.person, color: Colors.green),
          ),
          title: Text(partner['name'] as String),
          subtitle: Text(partner['lastMessage'] as String),
          trailing: Text(
            _formatTimestamp(partner['timestamp'] as DateTime),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
                settings: RouteSettings(arguments: partner),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatMessages() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isMe = message['senderId'] == _currentFarmer!['_id'];
              
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMessageTimestamp(message['timestamp']),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                color: Colors.grey.shade600,
                onPressed: () {
                  // Implement attachment functionality
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.green.shade700,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatMessageTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}