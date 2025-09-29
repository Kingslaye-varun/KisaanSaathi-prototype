// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:kisaansaathi/services/api_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FertilizerRecommendationScreen extends StatefulWidget {
//   const FertilizerRecommendationScreen({Key? key}) : super(key: key);

//   @override
//   _FertilizerRecommendationScreenState createState() =>
//       _FertilizerRecommendationScreenState();
// }

// class _FertilizerRecommendationScreenState
//     extends State<FertilizerRecommendationScreen> {
//   final TextEditingController _cropController = TextEditingController();
//   final TextEditingController _monthsController = TextEditingController();
//   bool _isLoading = false;
//   String _recommendation = '';
//   String _weatherSummary = '';
//   String _placeName = '';
//   final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _cropController.dispose();
//     _monthsController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _getRecommendation() async {
//     if (_cropController.text.isEmpty || _monthsController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter both crop name and planting months')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _recommendation = '';
//     });

//     try {
//       await _getWeatherData();

// final prompt = '''
// Analyze ${_cropController.text} cultivation during ${_monthsController.text} in $_placeName.
// Respond in this exact structured format:

// **Suitability Analysis:**
// - [✔/✘] 1-line verdict
// - Climate: [bullet point]
// - Soil: [bullet point]
// - Risks: [bullet point]

// **Recommended Fertilizers (always provide 3):**
// 1. **Name:** [Fertilizer 1]
//    - Composition: [NPK + micronutrients]
//    - Dosage: [amount/area]
//    - Timing: [growth stage]
//    - Benefits: [1 line]

// 2. **Name:** [Fertilizer 2]
//    [Same format...]

// 3. **Name:** [Fertilizer 3]
//    [Same format...]

// **Management Notes:**
// - [Bullet 1: Best alternative crop if unsuitable]
// - [Bullet 2: Ideal planting window]
// - [Bullet 3: Critical precaution]
// ''';

//       final model = GenerativeModel(
//         model: 'gemini-2.0-flash',
//         apiKey: _geminiApiKey,
//       );

//       final response = await model.generateContent([Content.text(prompt)]);

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       });

//       setState(() {
//         _recommendation = response.text ?? 'No recommendation available';
//       });
//     } catch (e) {
//       setState(() {
//         _recommendation = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       var status = await Permission.location.status;
//       if (!status.isGranted) {
//         status = await Permission.location.request();
//         if (!status.isGranted) {
//           setState(() {
//             _placeName = 'Unknown location';
//           });
//           return;
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         // ignore: deprecated_member_use
//         desiredAccuracy: LocationAccuracy.low,
//       );

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       setState(() {
//         _placeName = placemarks.isNotEmpty
//             ? '${placemarks[0].locality}, ${placemarks[0].administrativeArea}'
//             : 'Current location';
//       });
//     } catch (e) {
//       setState(() {
//         _placeName = 'Unknown location';
//       });
//     }
//   }

//   Future<void> _getWeatherData() async {
//     try {
//       final apiService = ApiService();
//       Position position = await Geolocator.getCurrentPosition(
//         // ignore: deprecated_member_use
//         desiredAccuracy: LocationAccuracy.low,
//       );

//       final weatherData = await apiService.getCurrentWeather(
//         latitude: position.latitude,
//         longitude: position.longitude,
//       );

//       setState(() {
//         _weatherSummary = '${weatherData['weather'][0]['main']}, ${weatherData['main']['temp'].round()}°C, Humidity: ${weatherData['main']['humidity']}%';
//       });
//     } catch (e) {
//       setState(() {
//         _weatherSummary = 'Weather data unavailable';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fertilizer Recommendation'),
//         backgroundColor: Colors.green.shade700,
//         elevation: 4,
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             controller: _scrollController,
//             padding: const EdgeInsets.all(16),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minHeight: constraints.maxHeight),
//               child: IntrinsicHeight(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Input Section
//                     Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             TextField(
//                               controller: _cropController,
//                               decoration: InputDecoration(
//                                 labelText: 'Crop Name',
//                                 border: OutlineInputBorder(),
//                                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             TextField(
//                               controller: _monthsController,
//                               decoration: InputDecoration(
//                                 labelText: 'Planting Period (Months)',
//                                 border: OutlineInputBorder(),
//                                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Location Info
//                     Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Location Details',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green.shade700,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(_placeName),
//                             Text(
//                               'Weather: $_weatherSummary',
//                               style: TextStyle(color: Colors.grey.shade600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Recommendation Button
//                     ElevatedButton(
//                       onPressed: _isLoading ? null : _getRecommendation,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.green.shade700,
//                       ),
//                       child: _isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text('Get Fertilizer Recommendation'),
//                     ),

//                     const SizedBox(height: 20),

//                     // Results Section
//                     if (_recommendation.isNotEmpty)
//                       Card(
//                         elevation: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Text(
//                                 'Recommendation for ${_cropController.text}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Colors.green.shade700,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 _recommendation,
//                                 style: const TextStyle(height: 1.5),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                     // Spacer to prevent overflow
//                     if (_recommendation.isEmpty) const Spacer(),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kisaansaathi/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FertilizerRecommendationScreen extends StatefulWidget {
  const FertilizerRecommendationScreen({Key? key}) : super(key: key);

  @override
  _FertilizerRecommendationScreenState createState() =>
      _FertilizerRecommendationScreenState();
}

class _FertilizerRecommendationScreenState
    extends State<FertilizerRecommendationScreen> {
  bool _isLoading = false;
  String _recommendation = '';
  String _weatherSummary = '';
  String _placeName = '';
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final ScrollController _scrollController = ScrollController();

  // User inputs
  String _selectedCrop = '';
  String _selectedSoilType = '';
  double _landSize = 1.0; // in acres
  double _budget = 5000.0; // in rupees
  String _selectedMonth = '';

  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  // Kerala specific crops data
  final List<Map<String, String>> keralaCrops = [
    {'name': 'Rice', 'image': 'assets/crops/rice.jpg', 'malayalam': 'നെല്ല്'},
    {
      'name': 'Coconut',
      'image': 'assets/crops/coconut.jpg',
      'malayalam': 'തേങ്ങ',
    },
    {
      'name': 'Rubber',
      'image': 'assets/crops/rubber.jpg',
      'malayalam': 'റബ്ബർ',
    },
    {'name': 'Spices', 'image': 'assets/crops/spices.jpg', 'malayalam': 'മസാല'},
    {'name': 'Banana', 'image': 'assets/crops/banana.jpg', 'malayalam': 'വാഴ'},
    {
      'name': 'Tapioca',
      'image': 'assets/crops/tapioca.jpg',
      'malayalam': 'കപ്പ',
    },
    {
      'name': 'Vegetables',
      'image': 'assets/crops/vegetables.jpg',
      'malayalam': 'പച്ചക്കറി',
    },
    {
      'name': 'Ginger',
      'image': 'assets/crops/ginger.jpg',
      'malayalam': 'ഇഞ്ചി',
    },
  ];

  // Kerala soil types
  final List<Map<String, String>> soilTypes = [
    {
      'name': 'Laterite Soil',
      'image': 'assets/soil/laterite.jpg',
      'description': 'Red clay soil',
    },
    {
      'name': 'Alluvial Soil',
      'image': 'assets/soil/alluvial.jpg',
      'description': 'River soil',
    },
    {
      'name': 'Coastal Sandy',
      'image': 'assets/soil/coastal.jpg',
      'description': 'Beach area soil',
    },
    {
      'name': 'Forest Soil',
      'image': 'assets/soil/forest.jpg',
      'description': 'Hill area soil',
    },
  ];

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initTts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      String cleanText = text
          .replaceAll(RegExp(r'[*#]'), '')
          .replaceAll('**', '');
      await flutterTts.speak(cleanText);
      setState(() => _isSpeaking = false);
    }
  }

  Future<void> _saveToDatabase() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['NODE_API_URL']}/api/farmers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'crop': _selectedCrop,
          'soilType': _selectedSoilType,
          'landSize': _landSize,
          'budget': _budget,
          'plantingMonth': _selectedMonth,
          'location': _placeName,
          'weather': _weatherSummary,
          'recommendation': _recommendation,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: ${e.toString()}')),
      );
    }
  }

  Future<void> _getRecommendation() async {
    if (_selectedCrop.isEmpty ||
        _selectedSoilType.isEmpty ||
        _selectedMonth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendation = '';
    });

    try {
      await _getWeatherData();

      // Load prompt from file (you'll create this)
      String prompt = await _loadPromptFromFile();

      // Replace placeholders with actual values
      prompt = prompt
          .replaceAll('{crop}', _selectedCrop)
          .replaceAll('{soilType}', _selectedSoilType)
          .replaceAll('{landSize}', _landSize.toString())
          .replaceAll('{budget}', _budget.toString())
          .replaceAll('{month}', _selectedMonth)
          .replaceAll('{location}', _placeName)
          .replaceAll('{weather}', _weatherSummary);

      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _geminiApiKey,
      );

      final response = await model.generateContent([Content.text(prompt)]);

      String cleanRecommendation =
          (response.text ?? 'No recommendation available')
              .replaceAll(RegExp(r'[*#]'), '')
              .replaceAll('**', '');

      setState(() {
        _recommendation = cleanRecommendation;
      });

      // Save to database
      await _saveToDatabase();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        _recommendation = 'Error getting recommendation. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _loadPromptFromFile() async {
    // This will load from your fertilizer_prompt.py file
    // For now, return a basic prompt template
    return '''
    You are an agricultural expert for Kerala farmers. Provide fertilizer recommendations for {crop} cultivation in {soilType} soil during {month} in {location}.

    Farm Details:
    - Land Size: {landSize} acres
    - Budget: ₹{budget}
    - Weather: {weather}

    Provide a short, practical answer in simple English without technical terms. Include:
    1. Is this crop suitable for the given conditions?
    2. 2-3 specific fertilizer recommendations with quantities needed for {landSize} acres
    3. Total estimated cost within ₹{budget} budget
    4. Best planting tips

    Keep the answer under 200 words and farmer-friendly.
    ''';
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          setState(() {
            _placeName = 'Unknown location';
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _placeName = placemarks.isNotEmpty
            ? '${placemarks[0].locality}, ${placemarks[0].administrativeArea}'
            : 'Current location';
      });
    } catch (e) {
      setState(() {
        _placeName = 'Unknown location';
      });
    }
  }

  Future<void> _getWeatherData() async {
    try {
      final apiService = ApiService();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final weatherData = await apiService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _weatherSummary =
            '${weatherData['weather'][0]['main']}, ${weatherData['main']['temp'].round()}°C, Humidity: ${weatherData['main']['humidity']}%';
      });
    } catch (e) {
      setState(() {
        _weatherSummary = 'Weather data unavailable';
      });
    }
  }

  Widget _buildCropSelection() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Crop',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: keralaCrops.length,
              itemBuilder: (context, index) {
                final crop = keralaCrops[index];
                final isSelected = _selectedCrop == crop['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCrop = crop['name']!),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      color: isSelected ? Colors.green.shade50 : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Icon(
                            Icons.agriculture,
                            size: 30,
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          crop['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.green.shade700
                                : Colors.black87,
                          ),
                        ),
                        Text(
                          crop['malayalam']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoilSelection() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Soil Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: soilTypes.length,
              itemBuilder: (context, index) {
                final soil = soilTypes[index];
                final isSelected = _selectedSoilType == soil['name'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedSoilType = soil['name']!),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.brown : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      color: isSelected ? Colors.brown.shade50 : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.brown.shade100,
                          ),
                          child: Icon(
                            Icons.landscape,
                            size: 30,
                            color: Colors.brown.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          soil['name']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isSelected
                                ? Colors.brown.shade700
                                : Colors.black87,
                          ),
                        ),
                        Text(
                          soil['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandSizeAndBudget() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Land Size & Budget',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 20),

            // Land Size
            Text('Land Size: ${_landSize.toStringAsFixed(1)} acres'),
            Slider(
              value: _landSize,
              min: 0.1,
              max: 10.0,
              divisions: 99,
              label: '${_landSize.toStringAsFixed(1)} acres',
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _landSize = value),
            ),

            const SizedBox(height: 20),

            // Budget
            Text('Budget: ₹${_budget.toStringAsFixed(0)}'),
            Slider(
              value: _budget,
              min: 1000,
              max: 50000,
              divisions: 49,
              label: '₹${_budget.toStringAsFixed(0)}',
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _budget = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelection() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Planting Month',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedMonth.isEmpty ? null : _selectedMonth,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              hint: const Text('Select planting month'),
              items: months.map((month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => _selectedMonth = value ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Fertilizer Guide'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Location Info
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red.shade400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _placeName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _weatherSummary.isNotEmpty
                                ? _weatherSummary
                                : 'Getting weather...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildCropSelection(),
            _buildSoilSelection(),
            _buildLandSizeAndBudget(),
            _buildMonthSelection(),

            // Get Recommendation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _getRecommendation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Get Fertilizer Recommendation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Results Section
            if (_recommendation.isNotEmpty)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Fertilizer Recommendation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _speak(_recommendation),
                            icon: Icon(
                              _isSpeaking ? Icons.stop : Icons.volume_up,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        _recommendation,
                        style: const TextStyle(height: 1.6, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
