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
    final prefs = await SharedPreferences.getInstance();
    _currentFarmerId = prefs.getString('farmerId') ?? '';

    try {
      final farmers = await _farmerService.getAllFarmers();
      setState(() {
        _farmers = farmers.where((f) => f['_id'] != _currentFarmerId).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _openChat(Map<String, dynamic> farmer) {
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
                itemBuilder: (context, index) =>
                    _buildFarmerTile(_farmers[index]),
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
    final String? imageUrl = farmer['profileImage']?['url'];
    final String name = farmer['name'] ?? 'Unknown';
    final bool isVerified = farmer['isVerified'] ?? false;

    return InkWell(
      onTap: () => _openChat(farmer),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade300, width: 2),
                  ),
                  child: ImageHelper.getProfileImage(
                    imageUrl: imageUrl,
                    name: name,
                    radius: 32,
                  ),
                ),
                if (isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        farmer['phoneNumber'] ?? 'No phone',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (farmer['farmerId'] != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ID: ${farmer['farmerId']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble,
                color: Colors.green.shade700,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
