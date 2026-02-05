import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ConnectionTestButton extends StatelessWidget {
  const ConnectionTestButton({Key? key}) : super(key: key);

  String get apiUrl {
    if (Platform.isAndroid) {
      // Physical Android device - use computer's IP
      return 'http://10.0.144.209:5000';
      // For emulator: return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      // Physical iOS device - use computer's IP
      return 'http://10.0.144.209:5000';
      // For simulator: return 'http://localhost:5000';
    } else {
      return 'http://localhost:5000';
    }
  }

  Future<void> _testConnection(BuildContext context) async {
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Testing connection to $apiUrl...')),
    );

    try {
      // Test root endpoint
      final response = await http.get(
        Uri.parse(apiUrl),
      ).timeout(const Duration(seconds: 5));

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Connected! Status: ${response.statusCode}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Show dialog with details
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('✅ Connection Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Platform: ${Platform.operatingSystem}'),
              const SizedBox(height: 8),
              Text('URL: $apiUrl'),
              const SizedBox(height: 8),
              Text('Status Code: ${response.statusCode}'),
              const SizedBox(height: 8),
              const Text('Server is reachable!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Connection Failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );

      // Show dialog with error details
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('❌ Connection Failed'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform: ${Platform.operatingSystem}'),
                const SizedBox(height: 8),
                Text('Trying URL: $apiUrl'),
                const SizedBox(height: 8),
                const Text('Error:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(e.toString()),
                const SizedBox(height: 16),
                const Text('Solutions:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (Platform.isAndroid) ...[
                  const Text('Android Emulator: URL is correct'),
                  const Text('Physical Device: Change to your IP'),
                  const Text('  1. Run: ipconfig'),
                  const Text('  2. Find IPv4 Address'),
                  const Text('  3. Update apiUrl in code'),
                ] else if (Platform.isIOS) ...[
                  const Text('iOS Simulator: URL is correct'),
                  const Text('Physical Device: Change to your IP'),
                ] else ...[
                  const Text('1. Check server is running'),
                  const Text('2. Verify URL is correct'),
                ],
                const SizedBox(height: 8),
                const Text('3. Check firewall settings'),
                const Text('4. Ensure same WiFi (physical device)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _testConnection(context),
      icon: const Icon(Icons.wifi_tethering),
      label: const Text('Test Server Connection'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
