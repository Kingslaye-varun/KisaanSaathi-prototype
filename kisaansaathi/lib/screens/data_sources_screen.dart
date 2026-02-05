import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/data_source_service.dart';

class DataSourcesScreen extends StatefulWidget {
  const DataSourcesScreen({Key? key}) : super(key: key);

  @override
  State<DataSourcesScreen> createState() => _DataSourcesScreenState();
}

class _DataSourcesScreenState extends State<DataSourcesScreen> {
  String selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Market Data',
    'Weather',
    'Schemes',
    'Soil',
    'Insurance',
    'Education',
  ];

  @override
  Widget build(BuildContext context) {
    final sources = selectedCategory == 'All'
        ? DataSourceService.getAllSources()
        : DataSourceService.getSourcesByCategory(selectedCategory);

    final verifiedCount = sources.where((s) => s.isGovernmentVerified).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Sources'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verified Data Sources',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$verifiedCount Government Authorized Sources',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'All data in KisaanSaathi comes from official government portals and verified APIs. Tap any source to visit the official website.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green.shade700,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green.shade700 : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Sources List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sources.length,
              itemBuilder: (context, index) {
                final source = sources[index];
                return _buildSourceCard(source);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(DataSourceInfo source) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: source.isGovernmentVerified
              ? Colors.green.shade200
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _launchUrl(source.url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: source.isGovernmentVerified
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      source.isGovernmentVerified
                          ? Icons.verified
                          : Icons.info_outline,
                      color: source.isGovernmentVerified
                          ? Colors.green
                          : Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          source.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: source.isGovernmentVerified
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            source.isGovernmentVerified
                                ? 'Gov. Verified'
                                : 'Commercial API',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: source.isGovernmentVerified
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.open_in_new,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                source.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    source.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open URL')),
        );
      }
    }
  }
}
