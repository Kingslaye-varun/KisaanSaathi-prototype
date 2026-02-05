import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/farmer_service.dart';
import '../screens/farmer_chat_detail_screen.dart';
import '../utils/image_helper.dart';

class FarmersListScreen extends StatefulWidget {
  const FarmersListScreen({super.key});

  @override
  State<FarmersListScreen> createState() => _FarmersListScreenState();
}

class _FarmersListScreenState extends State<FarmersListScreen> {
  final FarmerService _farmerService = FarmerService();
  List<Map<String, dynamic>> _farmers = [];
  bool _isLoading = true;
  String _currentFarmerId = '';

  @override
  void initState() {
    super.initState();
    _loadFarmers();
  }

  Future<void> _loadFarmers() async {
    print('🔵 Loading farmers list...');

    final prefs = await SharedPreferences.getInstance();
    _currentFarmerId = prefs.getString('farmerId') ?? '';

    try {
      final farmers = await _farmerService.getAllFarmers();

      setState(() {
        // Filter out current farmer
        _farmers = farmers.where((f) => f['_id'] != _currentFarmerId).toList();
        _isLoading = false;
      });

      print('✅ Loaded ${_farmers.length} farmers');
    } catch (e) {
      print('❌ Error loading farmers: $e');
      setState(() => _isLoading = false);
    }
  }

  void _openChat(Map<String, dynamic> farmer) {
    print('💬 Opening chat with: ${farmer['name']}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FarmerChatDetailScreen(
          otherUserId: farmer['_id'],
          otherUserName: farmer['name'],
          otherUserImage: farmer['profileImage']?['url'],
          otherUserType: 'farmer',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Farmers'),
        backgroundColor: Colors.green.shade600,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _farmers.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadFarmers,
              child: ListView.builder(
                itemCount: _farmers.length,
                itemBuilder: (context, index) {
                  final farmer = _farmers[index];
                  return _buildFarmerTile(farmer);
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
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No farmers found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerTile(Map<String, dynamic> farmer) {
    return InkWell(
      onTap: () => _openChat(farmer),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            ImageHelper.getProfileImage(
              imageUrl: farmer['profileImage']?['url'],
              name: farmer['name'] ?? 'Farmer',
              radius: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmer['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    farmer['location'] ?? 'Location not specified',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chat_bubble_outline, color: Colors.green.shade700),
          ],
        ),
      ),
    );
  }
}
