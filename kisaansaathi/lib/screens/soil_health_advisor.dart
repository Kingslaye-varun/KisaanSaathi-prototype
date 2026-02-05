import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kisaansaathi/config/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SoilHealthAdvisorScreen extends StatefulWidget {
  const SoilHealthAdvisorScreen({super.key});

  @override
  _SoilHealthAdvisorScreenState createState() => _SoilHealthAdvisorScreenState();
}

class _SoilHealthAdvisorScreenState extends State<SoilHealthAdvisorScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  
  // Form controllers
  final TextEditingController _previousCropsController = TextEditingController();
  final TextEditingController _cropRepetitionController = TextEditingController();
  final TextEditingController _fertilizersUsedController = TextEditingController();
  
  // Location data
  String _location = 'Unknown location';
  bool _isLoadingLocation = false;
  
  // Form data
  String _farmingType = 'Irrigated';
  String _yieldTrend = 'Same';
  String _soilColor = 'Dark Brown';
  String _soilTexture = 'Loamy';
  String _waterRetention = 'Good';
  String _drainageQuality = 'Good';
  String _fertilizerIntensity = 'Medium';
  String _organicUsage = 'Compost';
  bool _poorGrowth = false;
  bool _yellowing = false;
  bool _pestRecurrence = false;
  String _rainfallPattern = 'Normal';
  String _farmerGoal = 'Higher yield';
  
  // Response data
  bool _isLoading = false;
  String _soilHealthResponse = '';
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          setState(() {
            _location = 'Location permission denied';
            _isLoadingLocation = false;
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
        _location = placemarks.isNotEmpty 
            ? '${placemarks[0].locality}, ${placemarks[0].administrativeArea}' 
            : 'Current location';
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _location = 'Unable to get location';
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getSoilHealthAdvice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _soilHealthResponse = '';
    });

    try {
      final prompt = '''
You are an expert Agricultural Soil Health Advisor for Indian farmers.
Analyze the farmer inputs and provide clear soil health feedback in exactly 300-400 words.

INPUT DATA:
Farmer Location: $_location
Farming Type: $_farmingType
Previous crops: ${_previousCropsController.text}
Same crop repeated: ${_cropRepetitionController.text} years
Yield trend: $_yieldTrend
Soil color: $_soilColor
Soil texture: $_soilTexture
Water retention: $_waterRetention
Drainage quality: $_drainageQuality
Fertilizers used: ${_fertilizersUsedController.text}
Fertilizer usage level: $_fertilizerIntensity
Organic input usage: $_organicUsage
Poor plant growth: $_poorGrowth
Yellowing leaves: $_yellowing
Repeated pest or disease: $_pestRecurrence
Rainfall pattern: $_rainfallPattern
Primary goal: $_farmerGoal

RESPONSE FORMAT (300-400 words total, no symbols like bullets, stars, or dashes):

1. Soil Health Status
Overall condition and brief explanation in 2-3 lines.

2. Key Soil Issues
List major problems based on inputs in simple sentences.

3. Soil Improvement Actions
Step by step actions using organic and low cost methods. Mention timing.

4. Recommended Crops for Next Season
Suggest 3-4 suitable crops and how each improves soil health.

5. Crop Rotation Plan
Simple 2-3 season rotation plan.

6. Smart Tips
Water management and fertilizer optimization advice.

RULES:
- Keep response between 300-400 words only
- Use simple farming language
- No bullet points, asterisks, dashes, or special symbols
- Write in plain sentences and paragraphs
- Focus on practical Indian farming solutions
- Avoid technical jargon
''';

      // Try with soil-specific API key first
      String apiKeyToUse = Secrets.geminiApiKeySoil;
      http.Response? response;
      
      try {
        response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKeyToUse'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {
                    'text': prompt,
                  },
                ],
              },
            ],
            'generationConfig': {
              'temperature': 0.7,
              'topK': 40,
              'topP': 0.95,
              'maxOutputTokens': 8000,
            },
          }),
        );
      } catch (e) {
        print('Error with soil API key: $e');
      }

      // If soil API key fails or returns 429, try with backup keys
      if (response == null || response.statusCode == 429) {
        print('Soil API key failed (${response?.statusCode}), trying backup keys...');
        
        // Try with primary API key
        try {
          apiKeyToUse = Secrets.geminiApiKey;
          response = await http.post(
            Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKeyToUse'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {
                      'text': prompt,
                    },
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 8000,
              },
            }),
          );
        } catch (e) {
          print('Error with primary API key: $e');
        }
      }

      // If primary key also fails, try with secondary key
      if (response == null || response.statusCode == 429) {
        print('Primary API key failed (${response?.statusCode}), trying secondary key...');
        
        try {
          apiKeyToUse = Secrets.geminiApiKey2;
          response = await http.post(
            Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKeyToUse'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {
                      'text': prompt,
                    },
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 8000,
              },
            }),
          );
        } catch (e) {
          print('Error with secondary API key: $e');
        }
      }

      // If secondary key also fails, try with tertiary key
      if (response == null || response.statusCode == 429) {
        print('Secondary API key failed (${response?.statusCode}), trying tertiary key...');
        
        try {
          apiKeyToUse = Secrets.geminiApiKey3;
          response = await http.post(
            Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKeyToUse'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {
                      'text': prompt,
                    },
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 8000,
              },
            }),
          );
        } catch (e) {
          print('Error with tertiary API key: $e');
        }
      }

      // Handle the response
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String responseText = data['candidates'][0]['content']['parts'][0]['text'] ?? 
            'Sorry, I couldn\'t generate soil health advice. Please try again.';

        setState(() {
          _soilHealthResponse = responseText;
        });

        // Scroll to show the response
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        });
      } else if (response != null && response.statusCode == 429) {
        // All API keys are rate limited
        setState(() {
          _soilHealthResponse = '''
Rate Limit Exceeded

All our AI services are currently experiencing high traffic. Please try again in a few minutes.

Meanwhile, here are some general soil health tips:

Soil Health Status
Check your soil color and texture regularly. Dark, crumbly soil usually indicates good health.

Basic Soil Improvement Actions
Add organic compost to your soil. Practice crop rotation every season. Avoid overuse of chemical fertilizers. Maintain proper drainage.

General Crop Recommendations
Legumes like beans and peas improve soil nitrogen. Deep rooted crops help break soil compaction. Cover crops protect soil between seasons.

Smart Tips
Water early morning or evening. Use drip irrigation when possible. Test soil pH annually. Keep soil covered with mulch.

Please try the AI advisor again in 10-15 minutes for personalized recommendations.
''';
        });
      } else {
        // Other API errors
        String errorMessage = 'Unknown error occurred';
        if (response != null) {
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['error']['message'] ?? 'API Error ${response.statusCode}';
          } catch (e) {
            errorMessage = 'API Error ${response.statusCode}';
          }
        }
        
        setState(() {
          _soilHealthResponse = '''
Service Temporarily Unavailable

We are experiencing technical difficulties with our AI service.

Error Details: $errorMessage

Basic Soil Health Guidelines

Soil Assessment
Observe soil color as darker is usually better. Check soil texture which should be crumbly, not too hard or sandy. Test water retention where soil should hold moisture but drain excess.

Immediate Actions
Add organic matter like compost, cow dung, or green manure. Ensure proper drainage to prevent waterlogging. Avoid walking on wet soil to prevent compaction. Use cover crops during fallow periods.

Crop Rotation Benefits
Rotate between cereals, legumes, and vegetables. Legumes add nitrogen to soil naturally. Deep rooted crops improve soil structure.

Please try again later for personalized AI recommendations.
''';
        });
      }
    } catch (e) {
      setState(() {
        _soilHealthResponse = '''
Connection Error

Unable to connect to our AI service. Please check your internet connection.

Offline Soil Health Tips

Quick Soil Health Check
Color Test: Dark brown or black soil is usually healthy. Squeeze Test: Moist soil should form a ball but crumble when poked. Drainage Test: Water should soak in within 30 minutes.

Basic Improvements
Organic Matter: Add compost, farmyard manure, or green manure. Crop Rotation: Alternate between different crop families. Cover Crops: Plant legumes during off season. Minimal Tillage: Reduce soil disturbance.

Natural Fertilizers
Cow dung compost, vermicompost from earthworms, green manure like dhaincha and sunhemp, neem cake for pest control.

Water Management
Drip irrigation saves water and prevents soil erosion. Mulching retains moisture and adds organic matter. Proper drainage prevents salt buildup.

Try the AI advisor again when your connection improves.

Error Details: $e
''';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Health Advisor'),
        backgroundColor: Colors.brown.shade700,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Location Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.brown.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Farm Location',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _isLoadingLocation
                          ? const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Getting location...'),
                              ],
                            )
                          : Text(
                              _location,
                              style: const TextStyle(fontSize: 16),
                            ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Update Location'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Farming Type
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Farming Type',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _farmingType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['Irrigated', 'Rainfed'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _farmingType = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Crop History
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crop History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _previousCropsController,
                        decoration: const InputDecoration(
                          labelText: 'Previous crops (last 2-3 seasons)',
                          hintText: 'e.g., Rice, Wheat, Cotton',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter previous crops';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cropRepetitionController,
                        decoration: const InputDecoration(
                          labelText: 'Same crop repeated (years)',
                          hintText: 'e.g., 2 years',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter crop repetition years';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Yield Trend:', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _yieldTrend,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['Increased', 'Same', 'Decreased'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _yieldTrend = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Soil Characteristics
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Soil Characteristics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Soil Color:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _soilColor,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Dark Brown', 'Light Brown', 'Black', 'Red', 'Yellow'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _soilColor = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Soil Texture:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _soilTexture,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Loamy', 'Clay', 'Sandy', 'Silty'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _soilTexture = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Water Retention:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _waterRetention,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Good', 'Moderate', 'Poor'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _waterRetention = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Drainage Quality:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _drainageQuality,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Good', 'Moderate', 'Poor'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _drainageQuality = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Fertilizer & Inputs
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fertilizer & Inputs',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _fertilizersUsedController,
                        decoration: const InputDecoration(
                          labelText: 'Fertilizers used',
                          hintText: 'e.g., Urea, DAP, NPK',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter fertilizers used';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Fertilizer Usage Level:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _fertilizerIntensity,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Low', 'Medium', 'High'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _fertilizerIntensity = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Organic Input Usage:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _organicUsage,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Compost', 'Green manure', 'None'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _organicUsage = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Observed Issues
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observed Issues',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Poor plant growth'),
                        value: _poorGrowth,
                        onChanged: (bool? value) {
                          setState(() {
                            _poorGrowth = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Yellowing leaves'),
                        value: _yellowing,
                        onChanged: (bool? value) {
                          setState(() {
                            _yellowing = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Repeated pest or disease'),
                        value: _pestRecurrence,
                        onChanged: (bool? value) {
                          setState(() {
                            _pestRecurrence = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Climate & Goals
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Climate & Goals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Rainfall Pattern:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _rainfallPattern,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Normal', 'Excess', 'Low'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _rainfallPattern = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Primary Goal:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _farmerGoal,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: ['Soil improvement', 'Higher yield', 'Lower cost', 'Crop diversification'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _farmerGoal = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Get Advice Button
              ElevatedButton(
                onPressed: _isLoading ? null : _getSoilHealthAdvice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Analyzing Soil Health...',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      )
                    : const Text(
                        'Get Soil Health Advice',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 24),

              // Response Card
              if (_soilHealthResponse.isNotEmpty)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.eco, color: Colors.brown.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Soil Health Analysis',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _soilHealthResponse,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        // Add retry button if there was an error
                        if (_soilHealthResponse.contains('Rate Limit') || 
                            _soilHealthResponse.contains('Error') ||
                            _soilHealthResponse.contains('Unavailable'))
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _getSoilHealthAdvice,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _previousCropsController.dispose();
    _cropRepetitionController.dispose();
    _fertilizersUsedController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}