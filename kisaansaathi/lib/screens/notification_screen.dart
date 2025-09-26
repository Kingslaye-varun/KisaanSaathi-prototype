import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kisaansaathi/screens/chat_screen.dart';
import 'package:kisaansaathi/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  String? _currentFarmerId;

  @override
  void initState() {
    super.initState();
    _loadCurrentFarmer();
  }

  Future<void> _loadCurrentFarmer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerData = prefs.getString('farmer');
      
      if (farmerData != null) {
        final Map<String, dynamic> farmer = Map<String, dynamic>.from(
          Map<String, dynamic>.from(
            farmerData.startsWith('{') 
                ? Map<String, dynamic>.from(
                    Map<String, dynamic>.from(
                      json.decode(farmerData) as Map
                    )
                  )
                : {'_id': 'farmer1', 'name': 'Test Farmer'}
          )
        );
        
        setState(() {
          _currentFarmerId = farmer['_id'];
        });
        
        _loadNotifications();
      } else {
        // For testing, use a dummy farmer ID
        setState(() {
          _currentFarmerId = 'farmer1';
          _isLoading = false;
        });
        
        _loadNotifications();
      }
    } catch (e) {
      print('Error loading farmer data: $e');
      // For testing, use a dummy farmer ID
      setState(() {
        _currentFarmerId = 'farmer1';
        _isLoading = false;
      });
      
      _loadNotifications();
    }
  }

  

  Future<void> _loadNotifications() async {
    if (_currentFarmerId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final notifications = await _notificationService.getNotifications(_currentFarmerId!);
      
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
  }

  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When someone messages you, you\'ll see it here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          final bool isUnread = notification['read'] == false;
          final String senderType = notification['senderType'] ?? 'farmer';
          
          return InkWell(
            onTap: () async {
              // Mark as read
              if (isUnread) {
                await _markAsRead(notification['_id']);
                setState(() {
                  _notifications[index]['read'] = true;
                });
              }
              
              // Navigate to chat screen
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatPartner: {
                        '_id': notification['senderId'],
                        'name': notification['senderName'],
                        'userType': senderType,
                      },
                      conversationId: notification['conversationId'],
                    ),
                  ),
                ).then((_) => _loadNotifications());
              }
            },
            child: Container(
              color: isUnread ? Colors.blue.withOpacity(0.1) : null,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(notification['senderName'], senderType),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification['senderName'],
                                style: TextStyle(
                                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _formatTimestamp(notification['timestamp']),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['message'],
                          style: TextStyle(
                            color: isUnread ? Colors.black : Colors.grey[700],
                            fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isUnread)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String name, String userType) {
    final bool isOfficer = userType == 'officer';
    
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: isOfficer ? Colors.green[100] : Colors.blue[100],
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              color: isOfficer ? Colors.green[800] : Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        if (isOfficer)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(
                Icons.verified,
                size: 14,
                color: Colors.green[700],
              ),
            ),
          ),
      ],
    );
  }
}