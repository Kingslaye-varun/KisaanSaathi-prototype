import 'package:flutter/material.dart';

class ImageHelper {
  // Get profile image widget with fallback to local asset
  static Widget getProfileImage({
    String? imageUrl,
    required String name,
    double radius = 20,
  }) {
    // Always use local placeholder for now
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.green.shade100,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  // Get post image widget with fallback
  static Widget getPostImage({
    String? imageUrl,
    double? width,
    double? height,
  }) {
    // Use placeholder image
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.image, size: 50, color: Colors.grey.shade400),
    );
  }
}
