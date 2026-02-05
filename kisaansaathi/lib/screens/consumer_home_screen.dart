import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/community_screen.dart';
import '../screens/chatbot_screen.dart';
import '../screens/consumer_chat_list_screen.dart';
import '../screens/consumer_profile_screen.dart';
import '../utils/image_helper.dart';
import '../widgets/language_switcher.dart';

class ConsumerHomeScreen extends StatefulWidget {
  const ConsumerHomeScreen({super.key});

  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  String _consumerName = '';
  String _profileImageUrl = '';
  bool _showChatbot = false;

  @override
  void initState() {
    super.initState();
    _loadConsumerData();
  }

  Future<void> _loadConsumerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _consumerName = prefs.getString('consumerName') ?? 'Consumer';
      _profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    });
    print('🔵 Consumer loaded: $_consumerName');
  }

  void _toggleChatbot() {
    setState(() {
      _showChatbot = !_showChatbot;
    });
    print('🤖 Chatbot toggled: $_showChatbot');
  }

  void _openChatList() {
    print('💬 Opening chat list');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConsumerChatListScreen()),
    );
  }

  void _openProfile() {
    print('👤 Opening profile');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConsumerProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: Colors.green.shade600,
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          // Language switcher
          const LanguageSwitcher(),
          // Chat icon
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: _openChatList,
            tooltip: 'Chats',
          ),
          // Profile icon
          IconButton(
            icon: ImageHelper.getProfileImage(
              imageUrl: _profileImageUrl,
              name: _consumerName,
              radius: 16,
            ),
            onPressed: _openProfile,
            tooltip: 'Profile',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Main content - Community Screen (without its own AppBar)
          const CommunityScreen(showAppBar: false),

          // Floating chatbot button (bottom right)
          if (!_showChatbot)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _toggleChatbot,
                backgroundColor: Colors.green.shade700,
                child: const Icon(Icons.smart_toy, color: Colors.white),
              ),
            ),

          // Chatbot overlay
          if (_showChatbot)
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.smart_toy, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'AI Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _toggleChatbot,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: ChatbotScreen()),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
