// // ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:kisaansaathi/services/api_service.dart';
// import 'package:kisaansaathi/widgets/custom_button.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CropRecommendationScreen extends StatefulWidget {
//   const CropRecommendationScreen({super.key});

//   @override
//   State<CropRecommendationScreen> createState() =>
//       _CropRecommendationScreenState();
// }

// class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
//   bool _isLoading = false;
//   Map<String, dynamic>? _weatherData;
//   List<Map<String, dynamic>>? _recommendations;
//   String? _errorMessage;
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }

//   Future<void> _checkLocationPermission() async {
//     final status = await Permission.location.request();
//     if (status.isGranted) {
//       setState(() => _isLoading = true);
//       try {
//         final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         setState(() => _currentPosition = position);
//         await _fetchWeatherData();
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'Location access needed for best recommendations';
//           _isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         _errorMessage = 'Please enable location for crop suggestions';
//       });
//     }
//   }

//   Future<void> _fetchWeatherData() async {
//     if (_currentPosition == null) return;

//     try {
//       final weatherData = await ApiService().getCurrentWeather(
//         latitude: _currentPosition!.latitude,
//         longitude: _currentPosition!.longitude,
//       );
//       setState(() {
//         _weatherData = weatherData;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Weather data unavailable';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _generateRecommendations() async {
//     if (_currentPosition == null || _weatherData == null) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _recommendations = null;
//     });

//     try {
//       final prompt =
//           '''
// Suggest 5 best crops to grow in ${_weatherData!['name']} right now considering:
// - Weather: ${_weatherData!['weather'][0]['main']}
// - Temperature: ${_weatherData!['main']['temp']}°C
// - Humidity: ${_weatherData!['main']['humidity']}%
// - Local market demand

// For each crop provide:
// 1. Name (clean format, no special chars)
// 2. One-line suitability reason
// 3. Detailed growing method
// 4. Financial benefits (market price, demand, profit margin)
// 5. Additional advantages
// ''';

//       final response = await ApiService().getChatbotResponse(
//         prompt,
//         latitude: _currentPosition!.latitude,
//         longitude: _currentPosition!.longitude,
//         weatherData: _weatherData,
//       );

//       _parseRecommendations(response);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to get recommendations';
//         _isLoading = false;
//       });
//     }
//   }

//   void _parseRecommendations(String response) {
//     final recommendations = <Map<String, dynamic>>[];
//     final cropSections = response.split(RegExp(r'\n\d+\.'));

//     for (var section in cropSections) {
//       if (section.trim().isEmpty) continue;

//       final lines = section.trim().split('\n');
//       if (lines.isEmpty) continue;

//       // Clean crop name - remove special chars and extra spaces
//       final cropName = lines[0].trim().replaceAll(RegExp(r'[^\w\s]+'), '');

//       String reason = '';
//       String instructions = '';
//       String financial = '';
//       String benefits = '';

//       for (var line in lines.skip(1)) {
//         line = line.trim();
//         if (line.startsWith('Why:')) {
//           reason = line.replaceAll('Why:', '').trim();
//         } else if (line.startsWith('How:'))
//           instructions = line.replaceAll('How:', '').trim();
//         else if (line.startsWith('Financial:'))
//           financial = line.replaceAll('Financial:', '').trim();
//         else if (line.startsWith('Benefits:'))
//           benefits = line.replaceAll('Benefits:', '').trim();
//         else if (reason.isEmpty)
//           reason = line;
//         else if (instructions.isEmpty)
//           instructions += '\n$line';
//         else if (financial.isEmpty)
//           financial += '\n$line';
//         else
//           benefits += '\n$line';
//       }

//       if (cropName.isNotEmpty) {
//         recommendations.add({
//           'name': cropName,
//           'reason': reason,
//           'instructions': instructions,
//           'financial': financial,
//           'benefits': benefits,
//         });
//       }
//     }

//     setState(() {
//       _recommendations = recommendations.take(5).toList();
//       _isLoading = false;
//     });
//   }

//   void _showCropDetails(Map<String, dynamic> crop) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text(crop['name']),
//             backgroundColor: Colors.green.shade700,
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   crop['name'],
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   crop['reason'],
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 24),
//                 _buildDetailCard('Growing Method', crop['instructions']),
//                 _buildDetailCard('Financial Benefits', crop['financial']),
//                 _buildDetailCard('Additional Advantages', crop['benefits']),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailCard(String title, String content) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green.shade800,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(content, style: const TextStyle(fontSize: 15)),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Best Crops For You'),
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.white, Color(0xFFE8F5E9)],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               if (_weatherData != null) ...[
//                 Card(
//                   elevation: 1,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       children: [
//                         _getWeatherIcon(_weatherData!['weather'][0]['main']),
//                         const SizedBox(width: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${_weatherData!['name']}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               '${_weatherData!['main']['temp'].round()}°C | ${_weatherData!['weather'][0]['main']}',
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//               ],
//               CustomButton(
//                 text: 'Find Best Crops',
//                 onPressed: _isLoading ? () {} : _generateRecommendations,
//                 color: Colors.green.shade700,
//               ),
//               const SizedBox(height: 16),
//               if (_isLoading) const CircularProgressIndicator(),
//               if (_errorMessage != null)
//                 Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
//               if (_recommendations != null) ...[
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Recommended Crops:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: _recommendations!.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemBuilder: (context, index) {
//                       final crop = _recommendations![index];
//                       return Card(
//                         elevation: 2,
//                         child: ListTile(
//                           title: Text(
//                             crop['name'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           subtitle: Text(crop['reason']),
//                           trailing: const Icon(
//                             Icons.info_outline,
//                             color: Colors.green,
//                           ),
//                           onTap: () => _showCropDetails(crop),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _getWeatherIcon(String condition) {
//     IconData icon;
//     Color color;

//     switch (condition.toLowerCase()) {
//       case 'rain':
//         icon = Icons.umbrella;
//         color = Colors.blue.shade700;
//         break;
//       case 'clouds':
//         icon = Icons.cloud;
//         color = Colors.blueGrey;
//         break;
//       case 'clear':
//         icon = Icons.wb_sunny;
//         color = Colors.amber;
//         break;
//       default:
//         icon = Icons.device_thermostat;
//         color = Colors.grey;
//     }

//     return Icon(icon, color: color, size: 36);
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisaansaathi/services/api_service.dart';
import 'package:kisaansaathi/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kisaansaathi/l10n/app_localizations.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});
  

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;
  List<Map<String, dynamic>>? _recommendations;
  String? _errorMessage;
  Position? _currentPosition;

  // New input fields
  final TextEditingController _budgetController = TextEditingController();
  late String _selectedCropType;
  late String _selectedLandSize;
  late String _selectedWaterAvailability;

  late List<String> _cropTypes;
  late List<String> _landSizes;
  late List<String> _waterAvailability;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize lists with localized values
    _cropTypes = [
      AppLocalizations.of(context).cashCrops,
      AppLocalizations.of(context).foodCrops,
      AppLocalizations.of(context).vegetables,
      AppLocalizations.of(context).fruits,
      AppLocalizations.of(context).mixedFarming,
    ];
    
    _landSizes = [
      AppLocalizations.of(context).lessThan1Acre,
      AppLocalizations.of(context).oneToFiveAcres,
      AppLocalizations.of(context).fiveToTenAcres,
      AppLocalizations.of(context).moreThanTenAcres,
    ];
    
    _waterAvailability = [
      AppLocalizations.of(context).good,
      AppLocalizations.of(context).moderate,
      AppLocalizations.of(context).limited,
    ];
    
    // Set default selections
    _selectedCropType = _cropTypes[0];
    _selectedLandSize = _landSizes[1]; // 1-5 Acres
    _selectedWaterAvailability = _waterAvailability[0]; // Good
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() => _isLoading = true);
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() => _currentPosition = position);
        await _fetchWeatherData();
      } catch (e) {
        setState(() {
        _errorMessage = AppLocalizations.of(context).locationAccessNeeded;
        _isLoading = false;
      });
      }
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context).enableLocationForCrops;
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    if (_currentPosition == null) return;

    try {
      final weatherData = await ApiService().getCurrentWeather(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context).weatherDataUnavailable;
        _isLoading = false;
      });
    }
  }

  Future<void> _generateRecommendations() async {
    if (_currentPosition == null || _weatherData == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recommendations = null;
    });

    try {
      final budget = _budgetController.text.isEmpty
          ? 'moderate budget'
          : 'budget of ${_budgetController.text} rupees';

      final prompt =
          '''
You are an experienced agriculture advisor helping a farmer in ${_weatherData!['name']}. Based on current conditions, suggest exactly 4 best crops.

Current Conditions:
- Weather: ${_weatherData!['weather'][0]['main']}
- Temperature: ${_weatherData!['main']['temp']}°C
- Humidity: ${_weatherData!['main']['humidity']}%

Farmer Requirements:
- Crop Type Preference: $_selectedCropType
- Available Budget: $budget
- Land Size: $_selectedLandSize
- Water Availability: $_selectedWaterAvailability

IMPORTANT FORMATTING RULES:
- Use simple language that farmers can easily understand
- NO asterisks, NO special characters, NO bullet points
- Write in plain sentences only
- Numbers should be written as digits

For each of the 4 crops, provide information in this EXACT format:

CROP 1
Name: [Crop name in English]
Why Good: [2-3 simple sentences explaining why this crop suits their situation]
How to Grow: [4-5 simple sentences covering: when to plant, how to prepare land, watering needs, fertilizer needs, and harvest time]
Money Matters: [3-4 sentences about: cost to grow, market price, expected profit, and where to sell]
Extra Benefits: [2-3 sentences about other advantages like: improves soil, quick harvest, less disease, good for next crop, etc]

CROP 2
[Same format]

CROP 3
[Same format]

CROP 4
[Same format]

Remember: Keep all language simple and conversational. Avoid technical terms. If you must use a technical term, explain it simply. Write as if speaking to the farmer directly.
''';

      final response = await ApiService().getChatbotResponse(
        prompt,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        weatherData: _weatherData,
      );

      _parseRecommendations(response);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get recommendations';
        _isLoading = false;
      });
    }
  }

  void _parseRecommendations(String response) {
    final recommendations = <Map<String, dynamic>>[];

    // Split by CROP headers
    final cropSections = response.split(RegExp(r'CROP \d+'));

    for (var section in cropSections) {
      if (section.trim().isEmpty) continue;

      final lines = section.trim().split('\n');

      String name = '';
      String reason = '';
      String instructions = '';
      String financial = '';
      String benefits = '';

      String currentSection = '';

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        if (line.startsWith('Name:')) {
          name = line.replaceFirst('Name:', '').trim();
          name = name.replaceAll(RegExp(r'[*#\[\]]'), '');
        } else if (line.startsWith('Why Good:')) {
          currentSection = 'reason';
          reason = line.replaceFirst('Why Good:', '').trim();
        } else if (line.startsWith('How to Grow:')) {
          currentSection = 'instructions';
          instructions = line.replaceFirst('How to Grow:', '').trim();
        } else if (line.startsWith('Money Matters:')) {
          currentSection = 'financial';
          financial = line.replaceFirst('Money Matters:', '').trim();
        } else if (line.startsWith('Extra Benefits:')) {
          currentSection = 'benefits';
          benefits = line.replaceFirst('Extra Benefits:', '').trim();
        } else {
          // Continue adding to current section
          line = line.replaceAll(RegExp(r'[*#\[\]]'), '');
          switch (currentSection) {
            case 'reason':
              reason += ' $line';
              break;
            case 'instructions':
              instructions += ' $line';
              break;
            case 'financial':
              financial += ' $line';
              break;
            case 'benefits':
              benefits += ' $line';
              break;
          }
        }
      }

      if (name.isNotEmpty && reason.isNotEmpty) {
        recommendations.add({
          'name': name,
          'reason': reason.trim(),
          'instructions': instructions.trim(),
          'financial': financial.trim(),
          'benefits': benefits.trim(),
        });
      }
    }

    setState(() {
      _recommendations = recommendations.take(4).toList();
      _isLoading = false;
      if (_recommendations!.isEmpty) {
        _errorMessage = 'Could not parse recommendations. Please try again.';
      }
    });
  }

  void _showCropDetails(Map<String, dynamic> crop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(crop['name']),
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop['name'],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        crop['reason'],
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailCard(
                  AppLocalizations.of(context).howToGrow,
                  crop['instructions'],
                  Icons.agriculture,
                  Colors.green,
                ),
                _buildDetailCard(
                  AppLocalizations.of(context).moneyMatters,
                  crop['financial'],
                  Icons.currency_rupee,
                  Colors.orange,
                ),
                _buildDetailCard(
                  AppLocalizations.of(context).extraBenefits,
                  crop['benefits'],
                  Icons.star,
                  Colors.amber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 15, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).tellUsAboutYourFarm,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 16),

            // Crop Type Selection
            Text(
              AppLocalizations.of(context).whatTypeOfCrops,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCropType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _cropTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCropType = value!);
              },
            ),
            const SizedBox(height: 16),

            // Budget Input
            Text(
              AppLocalizations.of(context).budget,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).budgetHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                prefixIcon: const Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 16),

            // Land Size Selection
            Text(
              AppLocalizations.of(context).landSize,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedLandSize,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _landSizes.map((size) {
                return DropdownMenuItem(value: size, child: Text(size));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedLandSize = value!);
              },
            ),
            const SizedBox(height: 16),

            // Water Availability Selection
            Text(
              AppLocalizations.of(context).waterAvailability,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedWaterAvailability,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _waterAvailability.map((water) {
                return DropdownMenuItem(value: water, child: Text(water));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedWaterAvailability = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).bestCropsForYou),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE8F5E9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_weatherData != null) ...[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _getWeatherIcon(_weatherData!['weather'][0]['main']),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_weatherData!['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${_weatherData!['main']['temp'].round()}°C | ${_weatherData!['weather'][0]['main']}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInputSection(),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: AppLocalizations.of(context).getRecommendations,
                        onPressed: _isLoading
                            ? () {}
                            : _generateRecommendations,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 16),

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      if (_recommendations != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context).recommendedCrops,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recommendations!.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final crop = _recommendations![index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _showCropDetails(crop),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              crop['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              crop['reason'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade700,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.green.shade600,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    IconData icon;
    Color color;

    switch (condition.toLowerCase()) {
      case 'rain':
        icon = Icons.umbrella;
        color = Colors.blue.shade700;
        break;
      case 'clouds':
        icon = Icons.cloud;
        color = Colors.blueGrey;
        break;
      case 'clear':
        icon = Icons.wb_sunny;
        color = Colors.amber;
        break;
      default:
        icon = Icons.device_thermostat;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 36);
  }
}
