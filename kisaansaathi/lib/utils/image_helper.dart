import 'package:flutter/material.dart';

class ImageHelper {
  static Widget getProfileImage({
    required String imageUrl,
    required String name,
    double radius = 20,
  }) {
    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
        child: imageUrl.isEmpty ? _getInitials(name, radius) : null,
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.green.shade700,
        child: _getInitials(name, radius),
      );
    }
  }

  static Widget _getInitials(String name, double radius) {
    String initials = '';
    if (name.isNotEmpty) {
      List<String> nameParts = name.split(' ');
      if (nameParts.isNotEmpty) {
        initials = nameParts[0][0].toUpperCase();
        if (nameParts.length > 1) {
          initials += nameParts[1][0].toUpperCase();
        }
      }
    }
    return Text(
      initials,
      style: TextStyle(
        color: Colors.white,
        fontSize: radius * 0.8,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
