// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class ChatScreen extends StatefulWidget {
//   final Map<String, dynamic>? chatPartner;
//   final String? conversationId;

//   const ChatScreen({
//     super.key,
//     this.chatPartner,
//     this.conversationId
//   });

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Map<String, dynamic>> _messages = [];
//   Map<String, dynamic>? _currentFarmer;
//   Map<String, dynamic>? _chatPartner;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentFarmer();

//     // If chatPartner is provided from constructor, use it
//     if (widget.chatPartner != null) {
//       setState(() {
//         _chatPartner = widget.chatPartner;
//       });
//     } else {
//       // For testing farmer-to-farmer chat, create dummy farmer data if no chat partner
//       _createDummyFarmerData();
//     }

//     // Load conversation if conversationId is provided
//     if (widget.conversationId != null) {
//       _loadConversation(widget.conversationId!);
//     }
//   }

//   // Create dummy farmer data for testing
//   void _createDummyFarmerData() {
//     if (_currentFarmer == null) {
//       _currentFarmer = {
//         '_id': 'farmer1',
//         'name': 'Rajesh Kumar',
//         'userType': 'farmer',
//         'location': 'Punjab',
//         'crops': ['wheat', 'rice', 'vegetables'],
//       };
//     }

//     if (_chatPartner == null) {
//       _chatPartner = {
//         '_id': 'farmer2',
//         'name': 'Suresh Singh',
//         'userType': 'farmer',
//         'location': 'Haryana',
//         'crops': ['tomatoes', 'potatoes', 'onions'],
//       };

//       // Load messages for this dummy farmer chat
//       _loadMessages();
//     }
//   }

//   // Load conversation using conversationId
//   Future<void> _loadConversation(String conversationId) async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       // Here you would typically fetch messages from your backend using the conversationId
//       // For now, we'll just simulate loading with some delay
//       await Future.delayed(const Duration(milliseconds: 500));

//       // Add some dummy messages for testing
//       setState(() {
//         _messages.clear();
//         _messages.addAll([
//           {
//             'senderId': _currentFarmer?['_id'] ?? 'farmer1',
//             'text': 'Hello, I received your notification!',
//             'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toString(),
//           },
//           {
//             'senderId': _chatPartner?['_id'] ?? 'farmer2',
//             'text': 'Great! Let\'s discuss our farming issues.',
//             'timestamp': DateTime.now().toString(),
//           },
//         ]);
//         _isLoading = false;
//       });

//       // Scroll to bottom after messages load
//       Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print('Error loading conversation: $e');
//     }
//   }

//   Future<void> _loadCurrentFarmer() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final farmerString = prefs.getString('farmer');

//       if (farmerString != null) {
//         setState(() {
//           _currentFarmer = jsonDecode(farmerString);
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading profile: $e')),
//       );
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Get chat partner from route arguments if available
//     final args = ModalRoute.of(context)?.settings.arguments;
//     if (args != null && args is Map<String, dynamic>) {
//       setState(() {
//         _chatPartner = args;
//       });
//       _loadMessages();
//     }
//   }

//   Future<void> _loadMessages() async {
//     // This would normally fetch messages from an API
//     // For now, we'll use dummy data
//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(const Duration(milliseconds: 800));

//     if (_chatPartner != null) {
//       // Check if this is a farmer-to-farmer conversation
//       final bool isFarmerToFarmer = _chatPartner!['userType'] == 'farmer';

//       setState(() {
//         if (isFarmerToFarmer) {
//           // Farmer-to-farmer conversation messages
//           _messages.addAll(_getFarmerToFarmerDummyMessages());
//         } else {
//           // Regular support conversation messages
//           _messages.addAll(_getDummyMessages());
//         }
//         _isLoading = false;
//       });

//       // Scroll to bottom after messages load
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollToBottom();
//       });
//     }
//   }

//   // Helper method to get dummy messages for testing
//   List<Map<String, dynamic>> _getDummyMessages() {
//     final now = DateTime.now();

//     return [
//       {
//         'senderId': _chatPartner!['_id'],
//         'text': 'Hello, how can I help you with your farming needs?',
//         'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
//       },
//       {
//         'senderId': _currentFarmer!['_id'],
//         'text': 'I\'m looking for advice on organic pest control for my tomato plants.',
//         'timestamp': now.subtract(const Duration(hours: 23)).toIso8601String(),
//       },
//       {
//         'senderId': _chatPartner!['_id'],
//         'text': 'I recommend using neem oil spray. It\'s effective and completely organic.',
//         'timestamp': now.subtract(const Duration(hours: 22)).toIso8601String(),
//       },
//     ];
//   }

//   // Helper method to get farmer-to-farmer dummy messages for testing
//   List<Map<String, dynamic>> _getFarmerToFarmerDummyMessages() {
//     final now = DateTime.now();

//     return [
//       {
//         'senderId': _chatPartner!['_id'],
//         'text': 'Hi there! I saw you grow tomatoes too. How\'s your crop doing this season?',
//         'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
//       },
//       {
//         'senderId': _currentFarmer!['_id'],
//         'text': 'Having some issues with pests. Do you have any organic solutions?',
//         'timestamp': now.subtract(const Duration(hours: 23)).toIso8601String(),
//       },
//       {
//         'senderId': _chatPartner!['_id'],
//         'text': 'I use neem oil mixed with a bit of soap. Works great for my farm!',
//         'timestamp': now.subtract(const Duration(hours: 22)).toIso8601String(),
//       },
//     ];
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;

//     final messageText = _messageController.text.trim();
//     final bool isFarmerToFarmer = _chatPartner != null && _chatPartner!['userType'] == 'farmer';

//     setState(() {
//       _messages.add({
//         'senderId': _currentFarmer!['_id'],
//         'text': messageText,
//         'timestamp': DateTime.now().toIso8601String(),
//       });
//     });

//     _messageController.clear();
//     _scrollToBottom();

//     // Simulate reply after a short delay
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         setState(() {
//           String replyText = isFarmerToFarmer
//               ? 'Thanks for sharing! I\'ll try that solution on my farm too.'
//               : 'Thanks for your message! I\'ll get back to you soon.';

//           _messages.add({
//             'senderId': _chatPartner!['_id'],
//             'text': replyText,
//             'timestamp': DateTime.now().toIso8601String(),
//           });
//         });
//         _scrollToBottom();
//       }
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _chatPartner != null
//             ? Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 16,
//                     backgroundImage: _chatPartner!['profileImage'] != null
//                         ? NetworkImage(_chatPartner!['profileImage'])
//                         : null,
//                     backgroundColor: Colors.grey.shade200,
//                     child: _chatPartner!['profileImage'] == null
//                         ? const Icon(Icons.person, size: 16, color: Colors.grey)
//                         : null,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(_chatPartner!['name'] ?? 'Chat'),
//                 ],
//               )
//             : const Text('Chat'),
//         backgroundColor: Colors.green.shade700,
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _chatPartner == null
//               ? _buildChatList()
//               : _buildChatMessages(),
//     );
//   }

//   Widget _buildChatList() {
//     // This would normally fetch chat partners from an API
//     // For now, we'll use dummy data
//     final dummyPartners = [
//       {
//         '_id': '1',
//         'name': 'Farmer Support',
//         'profileImage': null,
//         'lastMessage': 'How can I help you today?',
//         'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
//       },
//       {
//         '_id': '2',
//         'name': 'Local Retailer',
//         'profileImage': null,
//         'lastMessage': 'I\'m interested in buying your organic vegetables.',
//         'timestamp': DateTime.now().subtract(const Duration(days: 1)),
//       },
//       {
//         '_id': '3',
//         'name': 'Agricultural Expert',
//         'profileImage': null,
//         'lastMessage': 'The soil testing results are ready.',
//         'timestamp': DateTime.now().subtract(const Duration(days: 3)),
//       },
//     ];

//     return ListView.builder(
//       itemCount: dummyPartners.length,
//       itemBuilder: (context, index) {
//         final partner = dummyPartners[index];
//         return ListTile(
//           leading: CircleAvatar(
//             backgroundColor: Colors.green.shade100,
//             child: const Icon(Icons.person, color: Colors.green),
//           ),
//           title: Text(partner['name'] as String),
//           subtitle: Text(partner['lastMessage'] as String),
//           trailing: Text(
//             _formatTimestamp(partner['timestamp'] as DateTime),
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//           ),
//           onTap: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const ChatScreen(),
//                 settings: RouteSettings(arguments: partner),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildChatMessages() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.all(16),
//             itemCount: _messages.length,
//             itemBuilder: (context, index) {
//               final message = _messages[index];
//               final isMe = message['senderId'] == _currentFarmer!['_id'];

//               return Align(
//                 alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: isMe ? Colors.green.shade100 : Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.7,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         message['text'],
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _formatMessageTimestamp(message['timestamp']),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 3,
//                 offset: const Offset(0, -1),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.attach_file),
//                 color: Colors.grey.shade600,
//                 onPressed: () {
//                   // Implement attachment functionality
//                 },
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: InputDecoration(
//                     hintText: 'Type a message...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(24),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                   ),
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               CircleAvatar(
//                 backgroundColor: Colors.green.shade700,
//                 child: IconButton(
//                   icon: const Icon(Icons.send),
//                   color: Colors.white,
//                   onPressed: _sendMessage,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inDays == 0) {
//       return 'Today';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays} days ago';
//     } else {
//       return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//     }
//   }

//   String _formatMessageTimestamp(String timestamp) {
//     final dateTime = DateTime.parse(timestamp);
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);

//     if (difference.inDays == 0) {
//       return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else {
//       return '${dateTime.day}/${dateTime.month}';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? chatPartner;
  final String? conversationId;

  const ChatScreen({super.key, this.chatPartner, this.conversationId});

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
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentFarmer();
    _initializeChat();
  }

  void _initializeChat() {
    // Set up the chat with Krishi Bhavan officer
    _chatPartner = {
      '_id': 'officer_ravindra',
      'name': 'Ravindra Kumar',
      'userType': 'officer',
      'designation': 'Krishi Bhavan Officer',
      'location': 'Thrissur District',
      'profileImage': null,
      'isOnline': true,
    };

    _loadConversationMessages();
  }

  Future<void> _loadCurrentFarmer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerString = prefs.getString('farmer');

      if (farmerString != null) {
        setState(() {
          _currentFarmer = jsonDecode(farmerString);
        });
      } else {
        // Create dummy farmer data for testing
        setState(() {
          _currentFarmer = {
            '_id': 'farmer_ravi',
            'name': 'Ravi Menon',
            'userType': 'farmer',
            'location': 'Thrissur, Kerala',
            'crops': ['coconut', 'rice', 'spices'],
          };
        });
      }
    } catch (e) {
      // Create dummy farmer data if error
      setState(() {
        _currentFarmer = {
          '_id': 'farmer_ravi',
          'name': 'Ravi Menon',
          'userType': 'farmer',
          'location': 'Thrissur, Kerala',
          'crops': ['coconut', 'rice', 'spices'],
        };
      });
    }
  }

  Future<void> _loadConversationMessages() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    final now = DateTime.now();

    setState(() {
      _messages.addAll([
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'നമസ്കാരം! I\'m Ravindra from Thrissur Krishi Bhavan. I saw your query about the Coconut Development Scheme. How can I help you?',
          'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'Hello sir, I read about the scheme in the community post. I have 2 acres of coconut farm but yield is very low. Can I apply for this scheme?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 58))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'Absolutely! The scheme is perfect for your situation. It provides financial subsidy for high-yielding coconut seedlings and technical support to improve productivity. What\'s your current yield per palm per year?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 55))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'Currently getting only 40-50 coconuts per palm annually. Some palms are very old, around 30+ years.',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 52))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'That\'s quite low compared to the potential of 120-150 coconuts per palm. Through this scheme, you can:\n\n🌴 Get 75% subsidy on quality seedlings\n💰 Join productivity clusters for better marketing\n📚 Receive training on modern techniques\n🔬 Access soil testing facilities\n\nWould you like me to check your eligibility?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 48))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'Yes please! What documents do I need? And how much subsidy can I get for 2 acres?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 45))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'For 2 acres, you can plant approximately 160-200 new palms. Here\'s what you need:\n\n📋 Required Documents:\n• Land ownership documents\n• Aadhaar card\n• Bank passbook\n• Previous yield records (if available)\n\n💸 Financial Benefits:\n• Seedling cost: ₹180 each (You pay ₹45, govt pays ₹135)\n• Total subsidy: ₹21,600 - ₹27,000\n• Additional support for drip irrigation if needed',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 40))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'This sounds great! When can I apply? And what about the cluster groups you mentioned?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 35))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'Perfect timing! Applications are open now until March 31st. \n\n🤝 About Cluster Groups:\n• Groups of 10-15 farmers in same area\n• Collective bargaining for better coconut prices\n• Shared resources like processing equipment\n• Group training programs\n• Bulk procurement of inputs at lower costs\n\nI can connect you with the Thrissur cluster group. They\'re doing very well!',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 30))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'Excellent! How do I apply? Can I visit your office tomorrow?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 25))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'Yes, please visit tomorrow between 10 AM - 4 PM. Our office is at:\n\n📍 Krishi Bhavan, Thrissur\nNear Civil Station\nPhone: 0487-2320xxx\n\nBring all documents I mentioned. I\'ll help you fill the application and also introduce you to our Agricultural Officer who handles technical training.\n\nAlso, there\'s a field visit planned next week to successful scheme beneficiaries. Would you like to join?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 20))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'Definitely! I would love to see how other farmers have benefited. Thank you so much for the detailed information sir.',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 15))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'You\'re most welcome! That\'s what we\'re here for - to support our farmers. 🌱\n\nJust one more thing - do you have any specific concerns about transitioning to new varieties? Many farmers worry about the initial period.',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 10))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'Yes, I\'m worried about income during the 4-5 years before new palms start producing. How do other farmers manage?',
          'timestamp': now
              .subtract(const Duration(hours: 1, minutes: 5))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _chatPartner!['_id'],
          'senderName': 'Ravindra Kumar',
          'text':
              'Great question! Here\'s how we address this:\n\n🌾 Intercropping options:\n• Grow spices, vegetables between coconut rows\n• Black pepper vines on coconut palms\n• Ginger, turmeric as ground crops\n\n💼 Additional support:\n• MNREGA work opportunities\n• Coconut processing training (value addition)\n• Connection to food processing units\n\n📅 Gradual replacement suggested - replace 25% palms each year instead of all at once.',
          'timestamp': now
              .subtract(const Duration(minutes: 58))
              .toIso8601String(),
          'messageType': 'text',
        },
        {
          'senderId': _currentFarmer!['_id'],
          'senderName': 'Ravi Menon',
          'text':
              'That\'s very thoughtful planning! I feel much more confident now. See you tomorrow at 10 AM. 🙏',
          'timestamp': now
              .subtract(const Duration(minutes: 55))
              .toIso8601String(),
          'messageType': 'text',
        },
      ]);
      _isLoading = false;
    });

    // Scroll to bottom after messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();

    setState(() {
      _messages.add({
        'senderId': _currentFarmer!['_id'],
        'senderName': _currentFarmer!['name'],
        'text': messageText,
        'timestamp': DateTime.now().toIso8601String(),
        'messageType': 'text',
      });
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate officer's response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'senderId': _chatPartner!['_id'],
            'senderName': _chatPartner!['name'],
            'text':
                'Thank you for your message! I\'ll get back to you with detailed information shortly. Feel free to ask if you have any other questions about the scheme.',
            'timestamp': DateTime.now().toIso8601String(),
            'messageType': 'text',
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200, width: 2),
              ),
              child: const Icon(
                Icons.support_agent,
                color: Color(0xFF2E7D32),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _chatPartner?['name'] ?? 'Officer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.lightGreenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Krishi Bhavan Officer',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Office: 0487-2320xxx'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            )
          : Column(
              children: [
                // Scheme info banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade50, Colors.green.shade100],
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.green.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Discussing: Coconut Development Scheme',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return _buildTypingIndicator();
                      }

                      final message = _messages[index];
                      final isMe =
                          message['senderId'] == _currentFarmer!['_id'];

                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade200, width: 2),
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF2E7D32) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'],
                        style: TextStyle(
                          fontSize: 16,
                          color: isMe ? Colors.white : Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatMessageTimestamp(message['timestamp']),
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe ? Colors.white70 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(left: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.shade200, width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8, bottom: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade200, width: 2),
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 18,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ask about the scheme...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
                onPressed: _sendMessage,
                iconSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMessageTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}