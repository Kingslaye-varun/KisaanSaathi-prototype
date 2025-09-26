import 'package:flutter/material.dart';
import '../services/farmer_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerProfileView extends StatefulWidget {
  final String farmerId;
  
  const FarmerProfileView({Key? key, required this.farmerId}) : super(key: key);

  @override
  State<FarmerProfileView> createState() => _FarmerProfileViewState();
}

class _FarmerProfileViewState extends State<FarmerProfileView> {
  bool _isLoading = true;
  Map<String, dynamic>? _farmerData;
  final FarmerService _farmerService = FarmerService();
  bool _isCurrentUser = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    _loadFarmerData();
  }
  
  Future<void> _checkCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerData = prefs.getString('farmerData');
    
    if (farmerData != null) {
      final farmer = json.decode(farmerData);
      setState(() {
        _currentUserId = farmer['_id'];
        _isCurrentUser = _currentUserId == widget.farmerId;
      });
    }
  }

  Future<void> _loadFarmerData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final result = await FarmerService.getFarmerById(widget.farmerId);
      
      if (result.success) {
        setState(() {
          _farmerData = result.data;
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message ?? 'Failed to load farmer data')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_farmerData?['name'] ?? 'Farmer Profile'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _farmerData == null
              ? const Center(child: Text('Failed to load farmer data'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green.shade100,
                        backgroundImage: _farmerData?['profileImage']?['url'] != null
                            ? NetworkImage(_farmerData!['profileImage']['url'])
                            : null,
                        child: _farmerData?['profileImage']?['url'] == null
                            ? const Icon(Icons.person, size: 60, color: Colors.green)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Farmer Name
                      Text(
                        _farmerData?['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Phone Number
                      Text(
                        'Phone: ${_farmerData?['phoneNumber'] ?? 'Not provided'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      
                      // Chat Button (only show if not current user)
                      if (!_isCurrentUser) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.chat),
                          label: const Text('Chat with Farmer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context, 
                              '/chat',
                              arguments: {
                                '_id': _farmerData!['_id'],
                                'name': _farmerData!['name'],
                                'profileImage': _farmerData?['profileImage']?['url'],
                                'userType': 'farmer',
                              },
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      
                      // Farmer Details Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Farmer Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              
                              // Location
                              _buildDetailRow(
                                Icons.location_on,
                                'Location',
                                _farmerData?['location'] ?? 'Not specified',
                              ),
                              
                              // Crops
                              _buildDetailRow(
                                Icons.grass,
                                'Main Crops',
                                _farmerData?['crops']?.join(', ') ?? 'Not specified',
                              ),
                              
                              // Land Size
                              _buildDetailRow(
                                Icons.landscape,
                                'Land Size',
                                _farmerData?['landSize'] != null
                                    ? '${_farmerData!['landSize']} acres'
                                    : 'Not specified',
                              ),
                              
                              // Joined Date
                              _buildDetailRow(
                                Icons.calendar_today,
                                'Joined',
                                _farmerData?['createdAt'] != null
                                    ? _formatDate(_farmerData!['createdAt'])
                                    : 'Unknown',
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons - Different for own profile vs others
                      _isCurrentUser
                      ? ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chat',
                                  arguments: {
                                    'farmerId': widget.farmerId,
                                    'farmerName': _farmerData?['name'] ?? 'Farmer',
                                  },
                                );
                              },
                              icon: const Icon(Icons.message),
                              label: const Text('Send Message'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
