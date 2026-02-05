import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kisaansaathi/l10n/app_localizations.dart';

class NearbyStorageScreen extends StatefulWidget {
  const NearbyStorageScreen({super.key});

  @override
  _NearbyStorageScreenState createState() => _NearbyStorageScreenState();
}

class _NearbyStorageScreenState extends State<NearbyStorageScreen> {
  bool _isLoading = false;
  String _statusMessage = '';
  double _searchRadius = 5.0;
  String _selectedStorageType = ''; // Will be set in initState
  List<String> _storageTypes = [];
  
  // Storage type descriptions for farmers
  Map<String, Map<String, String>> _storageInfo = {
    'Cold Storage': {
      'description': 'Temperature-controlled facility for preserving perishable crops like fruits and vegetables.',
      'benefits': 'Extends shelf life, reduces spoilage, and helps get better market prices during off-season.',
      'ideal_for': 'Potatoes, apples, tomatoes, onions, and other perishable produce.'
    },
    'Warehouse': {
      'description': 'Large storage facility for bulk agricultural products and equipment.',
      'benefits': 'Protects crops from weather, pests, and theft. Allows selling when prices are favorable.',
      'ideal_for': 'Grains, pulses, seeds, and farming equipment.'
    },
    'Refrigerated Storage': {
      'description': 'Specialized cold storage with precise temperature control for highly perishable items.',
      'benefits': 'Maintains freshness and nutritional value. Prevents quality degradation.',
      'ideal_for': 'Dairy products, meat, exotic fruits, and vegetables requiring specific temperatures.'
    },
    'Agricultural Storage': {
      'description': 'Multi-purpose storage designed specifically for farm produce with pest control measures.',
      'benefits': 'Reduces post-harvest losses and provides safe storage for various crop types.',
      'ideal_for': 'Mixed farming produce, fertilizers, and seasonal crops.'
    }
  };

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    _statusMessage = 'Find nearby storage facilities!';
    _selectedStorageType = 'Cold Storage';
    _storageTypes = [
      'Cold Storage',
      'Warehouse',
      'Refrigerated Storage',
      'Agricultural Storage',
    ];

    // Update with localized strings after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          try {
            _statusMessage = AppLocalizations.of(context).findNearbyStorage;
            _selectedStorageType = AppLocalizations.of(context).coldStorage;
            _storageTypes = [
              AppLocalizations.of(context).coldStorage,
              AppLocalizations.of(context).warehouse,
              AppLocalizations.of(context).refrigeratedStorage,
              AppLocalizations.of(context).agriculturalStorage,
            ];
          } catch (e) {
            // Fallback to English if translations fail
            print('Error loading translations: $e');
          }
        });
      }
    });
  }

  Future<void> _findStorageFacilities() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Locating your position...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool enabled = await Geolocator.openLocationSettings();
        if (!enabled) throw 'Please enable location services';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions permanently denied. Please enable in app settings.';
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          throw 'Location permissions required';
        }
      }

      setState(() => _statusMessage = 'Getting your location...');
      Position position = await Geolocator.getCurrentPosition();

      // Map storage types to search terms
      final searchTermMap = {
        'Cold Storage': 'cold storage',
        'Warehouse': 'agricultural warehouse',
        'Refrigerated Storage': 'refrigerated storage',
        'Agricultural Storage': 'agricultural storage facility',
      };

      final searchTerm = searchTermMap[_selectedStorageType] ?? 'cold storage';

      final mapsUrl =
          'geo:${position.latitude},${position.longitude}?q=$searchTerm';
      final webUrl =
          'https://www.google.com/maps/search/$searchTerm/@${position.latitude},${position.longitude},${_searchRadius}km';

      if (await canLaunchUrl(Uri.parse(mapsUrl))) {
        await launchUrl(
          Uri.parse(mapsUrl),
          mode: LaunchMode.externalApplication,
        );
        _statusMessage = 'Showing $_selectedStorageType within ${_searchRadius.round()} km radius';
      }
      else if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      }
      else if (await canLaunchUrl(Uri.parse('https://maps.google.com'))) {
        await launchUrl(
          Uri.parse('https://maps.google.com'),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch maps application';
      }
    } catch (e) {
      setState(
        () => _statusMessage =
            'Error: ${e.toString().replaceAll('Exception:', '')}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_statusMessage),
          backgroundColor: Colors.red[800],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context).findNearbyStorage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/storage_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.darken,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Main Card
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warehouse,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _statusMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Storage Type Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedStorageType,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                underline: Container(),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedStorageType = newValue!;
                                  });
                                },
                                items: _storageTypes.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                dropdownColor: const Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.amber[700],
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: Colors.amber,
                                valueIndicatorColor: Colors.amber,
                                overlayColor: Colors.amber.withAlpha(32),
                              ),
                              child: Slider(
                                value: _searchRadius,
                                min: 1,
                                max: 50,
                                divisions: 49,
                                label: '${_searchRadius.round()} km',
                                onChanged: (value) =>
                                    setState(() => _searchRadius = value),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).searchRadius,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.map),
                                label: Text(
                                  AppLocalizations.of(context).findStorage,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : _findStorageFacilities,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Storage Info Card
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green[700]!.withOpacity(0.9),
                              Colors.green[500]!.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getIconForStorageType(_selectedStorageType),
                                  size: 28,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedStorageType,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white70, thickness: 1),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.info_outline,
                              _storageInfo[_selectedStorageType]?['description'] ?? '',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.thumb_up_outlined,
                              _storageInfo[_selectedStorageType]?['benefits'] ?? '',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.check_circle_outline,
                              _storageInfo[_selectedStorageType]?['ideal_for'] ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Helpful Tips Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber[100],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.amber[800],
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Helpful Tips',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• Call the storage facility before visiting to check availability',
                              style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• Compare rates from multiple facilities for best value',
                              style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• Ask about humidity control for your specific crop needs',
                              style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Features Grid - Fixed height
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: _storageTypes.map((type) {
                          final isSelected = _selectedStorageType == type;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStorageType = type;
                              });
                            },
                            child: Card(
                              elevation: isSelected ? 12 : 8,
                              shadowColor: isSelected ? Colors.blue[900] : Colors.black45,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: isSelected 
                                    ? BorderSide(color: Colors.amber[700]!, width: 2)
                                    : BorderSide.none,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isSelected
                                          ? Colors.blue[800]!.withOpacity(0.95)
                                          : Colors.blue[700]!.withOpacity(0.7),
                                      isSelected
                                          ? Colors.lightBlue[600]!.withOpacity(0.95)
                                          : Colors.lightBlue[500]!.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    if (isSelected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.amber[700],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getIconForStorageType(type),
                                              size: 32,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 8),
                                            Flexible(
                                              child: Text(
                                                type,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: _findStorageFacilities,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  IconData _getIconForStorageType(String type) {
    switch (type) {
      case 'Cold Storage':
        return Icons.ac_unit;
      case 'Warehouse':
        return Icons.warehouse;
      case 'Refrigerated Storage':
        return Icons.kitchen;
      case 'Agricultural Storage':
        return Icons.grass;
      default:
        return Icons.storage;
    }
  }
  
  // Helper method to build info rows with icon and text
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}