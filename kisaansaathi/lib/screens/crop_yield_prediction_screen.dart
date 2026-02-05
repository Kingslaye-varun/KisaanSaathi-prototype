import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../widgets/data_source_badge.dart';
import '../widgets/crop_yield_tutorial.dart';
import '../widgets/connection_test_button.dart';
import '../services/tutorial_service.dart';

class CropYieldPredictionScreen extends StatefulWidget {
  const CropYieldPredictionScreen({Key? key}) : super(key: key);

  @override
  State<CropYieldPredictionScreen> createState() => _CropYieldPredictionScreenState();
}

class _CropYieldPredictionScreenState extends State<CropYieldPredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showTutorial = false;
  Map<String, dynamic>? _predictionResult;

  // API URL helper - automatically selects correct URL based on platform
  String get apiUrl {
    if (Platform.isAndroid) {
      // Physical Android device - use computer's IP address
      return 'http://10.0.144.209:5000';
      
      // For Android Emulator, use:
      // return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      // Physical iOS device - use computer's IP address
      return 'http://10.0.144.209:5000';
      
      // For iOS Simulator, use:
      // return 'http://localhost:5000';
    } else {
      // Web or other platforms
      return 'http://localhost:5000';
    }
  }

  // Form controllers
  final _areaController = TextEditingController();
  final _rainfallController = TextEditingController();
  final _fertilizerController = TextEditingController();
  final _pesticideController = TextEditingController();

  // Dropdown values
  String? _selectedState;
  String? _selectedCrop;
  String? _selectedSeason;
  int _selectedYear = DateTime.now().year;

  // Data lists
  final List<String> _states = [
    'Andhra Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat',
    'Haryana', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh',
    'Maharashtra', 'Manipur', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan',
    'Tamil Nadu', 'Telangana', 'Uttar Pradesh', 'West Bengal'
  ];

  final List<String> _crops = [
    'Rice', 'Wheat', 'Maize', 'Bajra', 'Jowar', 'Cotton', 'Sugarcane',
    'Groundnut', 'Soyabean', 'Sunflower', 'Potato', 'Onion', 'Tomato',
    'Banana', 'Mango', 'Coconut', 'Arhar/Tur', 'Gram', 'Moong', 'Urad'
  ];

  final List<String> _seasons = [
    'Kharif', 'Rabi', 'Summer', 'Autumn', 'Whole Year'
  ];

  @override
  void initState() {
    super.initState();
    _checkTutorial();
  }

  Future<void> _checkTutorial() async {
    final completed = await TutorialService.isTutorialCompleted('crop_yield_prediction');
    if (!completed) {
      setState(() => _showTutorial = true);
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    _rainfallController.dispose();
    _fertilizerController.dispose();
    _pesticideController.dispose();
    super.dispose();
  }

  Future<void> _predictYield() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    try {
      print('Making prediction request...');
      print('Platform: ${Platform.operatingSystem}');
      print('API URL: $apiUrl/predict_yield');
      print('State: $_selectedState, Crop: $_selectedCrop, Season: $_selectedSeason');
      
      final response = await http.post(
        Uri.parse('$apiUrl/predict_yield'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state': _selectedState,
          'crop': _selectedCrop,
          'season': _selectedSeason,
          'area': double.parse(_areaController.text),
          'annual_rainfall': double.parse(_rainfallController.text),
          'fertilizer': double.parse(_fertilizerController.text),
          'pesticide': double.parse(_pesticideController.text),
          'crop_year': _selectedYear,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Server not responding');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          setState(() {
            _predictionResult = result;
          });
        } else {
          _showError('Prediction failed: ${result['error'] ?? 'Unknown error'}');
        }
      } else {
        _showError('Server error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error details: $e');
      _showError('Connection error: $e\n\nMake sure Flask server is running on port 5000');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Crop Yield Prediction'),
            backgroundColor: Colors.green[700],
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => setState(() => _showTutorial = true),
                tooltip: 'Show Tutorial',
              ),
            ],
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Data Source Badge
              const DataSourceBadge(
                source: 'Mendeley Dataset',
                sourceUrl: 'https://data.mendeley.com/datasets/ncw2vbcgnk/2',
              ),
              const SizedBox(height: 16),

              // Info Card
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Predict crop yield using AI-powered hybrid models',
                          style: TextStyle(color: Colors.green[900], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Connection Test Button (for debugging)
              const ConnectionTestButton(),
              const SizedBox(height: 20),

              // State Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedState,
                decoration: _inputDecoration('State', Icons.location_on),
                items: _states.map((state) {
                  return DropdownMenuItem(value: state, child: Text(state));
                }).toList(),
                onChanged: (value) => setState(() => _selectedState = value),
                validator: (value) => value == null ? 'Select state' : null,
              ),
              const SizedBox(height: 12),

              // Crop Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCrop,
                decoration: _inputDecoration('Crop', Icons.grass),
                items: _crops.map((crop) {
                  return DropdownMenuItem(value: crop, child: Text(crop));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCrop = value),
                validator: (value) => value == null ? 'Select crop' : null,
              ),
              const SizedBox(height: 12),

              // Season Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedSeason,
                decoration: _inputDecoration('Season', Icons.wb_sunny),
                items: _seasons.map((season) {
                  return DropdownMenuItem(value: season, child: Text(season));
                }).toList(),
                onChanged: (value) => setState(() => _selectedSeason = value),
                validator: (value) => value == null ? 'Select season' : null,
              ),
              const SizedBox(height: 12),

              // Year Dropdown
              DropdownButtonFormField<int>(
                initialValue: _selectedYear,
                decoration: _inputDecoration('Crop Year', Icons.calendar_today),
                items: List.generate(10, (index) {
                  final year = DateTime.now().year - index;
                  return DropdownMenuItem(value: year, child: Text('$year'));
                }).toList(),
                onChanged: (value) => setState(() => _selectedYear = value!),
              ),
              const SizedBox(height: 12),

              // Area Input
              TextFormField(
                controller: _areaController,
                decoration: _inputDecoration('Area (hectares)', Icons.crop_square),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter area';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Rainfall Input
              TextFormField(
                controller: _rainfallController,
                decoration: _inputDecoration('Annual Rainfall (mm)', Icons.water_drop),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter rainfall';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Fertilizer Input
              TextFormField(
                controller: _fertilizerController,
                decoration: _inputDecoration('Fertilizer (kg)', Icons.science),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter fertilizer';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Pesticide Input
              TextFormField(
                controller: _pesticideController,
                decoration: _inputDecoration('Pesticide (kg)', Icons.pest_control),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter pesticide';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Predict Button
              ElevatedButton(
                onPressed: _isLoading ? null : _predictYield,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Predict Yield',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 24),

              // Results
              if (_predictionResult != null) _buildResultCard(),
            ],
          ),
        ),
      ),
    ),
        
        // Tutorial Overlay
        if (_showTutorial)
          CropYieldTutorial(
            onComplete: () => setState(() => _showTutorial = false),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }

  Widget _buildResultCard() {
    final result = _predictionResult!;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Prediction Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Main Prediction
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Predicted Yield', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    '${result['predicted_yield']} ${result['unit']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Production: ${result['predicted_production']} tonnes',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Individual Model Predictions
            const Text(
              'Model Breakdown',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (result['individual_predictions']['random_forest'] != null)
              _buildModelPrediction('Random Forest', result['individual_predictions']['random_forest']),
            if (result['individual_predictions']['xgboost'] != null)
              _buildModelPrediction('XGBoost', result['individual_predictions']['xgboost']),
            if (result['individual_predictions']['lightgbm'] != null)
              _buildModelPrediction('LightGBM', result['individual_predictions']['lightgbm']),
            if (result['individual_predictions']['cnn_lstm'] != null)
              _buildModelPrediction('CNN-LSTM', result['individual_predictions']['cnn_lstm']),
          ],
        ),
      ),
    );
  }

  Widget _buildModelPrediction(String model, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(model, style: const TextStyle(fontSize: 13)),
          Text(
            '$value t/ha',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
