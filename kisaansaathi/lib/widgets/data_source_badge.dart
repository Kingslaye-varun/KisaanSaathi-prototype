import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DataSourceBadge extends StatelessWidget {
  final String source;
  final String sourceUrl;
  final DateTime? lastUpdated;
  final bool isVerified;

  const DataSourceBadge({
    Key? key,
    required this.source,
    required this.sourceUrl,
    this.lastUpdated,
    this.isVerified = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: () => _showSourceDetails(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isVerified ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isVerified ? Colors.green : Colors.orange,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.info_outline,
                color: isVerified ? Colors.green : Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Data Source',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isVerified ? Colors.green.shade800 : Colors.orange.shade800,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 10,
                color: isVerified ? Colors.green.shade600 : Colors.orange.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSourceDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isVerified ? Colors.green.shade50 : Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isVerified ? Icons.verified : Icons.info_outline,
                    color: isVerified ? Colors.green : Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isVerified ? 'Verified Data Source' : 'Data Source',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isVerified)
                        Text(
                          'Government Authorized',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.source, 'Source', source),
            const SizedBox(height: 12),
            if (lastUpdated != null)
              _buildInfoRow(
                Icons.update,
                'Last Updated',
                _formatDateTime(lastUpdated!),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(sourceUrl),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('Visit Official Source'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVerified ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This data is sourced from official government portals and verified APIs.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
