import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kisaansaathi/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class FertilizerRecommendationScreen extends StatefulWidget {
  const FertilizerRecommendationScreen({super.key});

  @override
  _FertilizerRecommendationScreenState createState() =>
      _FertilizerRecommendationScreenState();
}

class _FertilizerRecommendationScreenState
    extends State<FertilizerRecommendationScreen> {
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  bool _isLoading = false;
  String _recommendation = '';
  String _weatherSummary = '';
  String _placeName = '';
  final String _geminiApiKey = 'AIzaSyCPf2GtBruvCynh3Sf5wyncMeFPPwQWyj0';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _cropController.dispose();
    _monthsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendation() async {
    if (_cropController.text.isEmpty || _monthsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both crop name and planting months')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendation = '';
    });

    try {
      await _getWeatherData();

final prompt = '''
Analyze ${_cropController.text} cultivation during ${_monthsController.text} in $_placeName.
Respond in this exact structured format:

**Suitability Analysis:**
- [✔/✘] 1-line verdict
- Climate: [bullet point]
- Soil: [bullet point]
- Risks: [bullet point]

**Recommended Fertilizers (always provide 3):**
1. **Name:** [Fertilizer 1]
   - Composition: [NPK + micronutrients]
   - Dosage: [amount/area]
   - Timing: [growth stage]
   - Benefits: [1 line]

2. **Name:** [Fertilizer 2]
   [Same format...]

3. **Name:** [Fertilizer 3]
   [Same format...]

**Management Notes:**
- [Bullet 1: Best alternative crop if unsuitable]
- [Bullet 2: Ideal planting window]
- [Bullet 3: Critical precaution]
''';

      final model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: _geminiApiKey,
      );

      final response = await model.generateContent([Content.text(prompt)]);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      setState(() {
        _recommendation = response.text ?? 'No recommendation available';
      });
    } catch (e) {
      setState(() {
        _recommendation = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        // ignore: deprecated_member_use
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
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.low,
      );

      final weatherData = await apiService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _weatherSummary = '${weatherData['weather'][0]['main']}, ${weatherData['main']['temp'].round()}°C, Humidity: ${weatherData['main']['humidity']}%';
      });
    } catch (e) {
      setState(() {
        _weatherSummary = 'Weather data unavailable';
      });
    }
  }

<<<<<<< Updated upstream
=======
  Widget _buildCropSelection() {
    final cropNames = _getCropNames(context);

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
              AppLocalizations.of(context).selectYourCrop,
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
              itemCount: cropNames.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCropIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCropIndex = index),
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
                            image: DecorationImage(
                              image: AssetImage(cropImages[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cropNames[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.green.shade700
                                : Colors.black87,
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
    final soilNames = _getSoilTypeNames(context);
    final soilDescriptions = _getSoilDescriptions(context);

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
              AppLocalizations.of(context).selectSoilType,
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
              itemCount: soilNames.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedSoilIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSoilIndex = index),
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
                          soilNames[index],
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
                          soilDescriptions[index],
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
              AppLocalizations.of(context).landSizeAndBudget,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 20),

            // Land Size
            Text(
              '${AppLocalizations.of(context).landSize}: ${_landSize.toStringAsFixed(1)} ${AppLocalizations.of(context).acres}',
            ),
            Slider(
              value: _landSize,
              min: 0.1,
              max: 10.0,
              divisions: 99,
              label:
                  '${_landSize.toStringAsFixed(1)} ${AppLocalizations.of(context).acres}',
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _landSize = value),
            ),

            const SizedBox(height: 20),

            // Budget
            Text(
              '${AppLocalizations.of(context).budget}: ₹${_budget.toStringAsFixed(0)}',
            ),
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
    final monthNames = _getMonthNames(context);

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
              AppLocalizations.of(context).plantingMonth,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _selectedMonthIndex == -1 ? null : _selectedMonthIndex,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              hint: Text(AppLocalizations.of(context).selectPlantingMonth),
              items: List.generate(monthNames.length, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(monthNames[index]),
                );
              }),
              onChanged: (value) =>
                  setState(() => _selectedMonthIndex = value ?? -1),
            ),
          ],
        ),
      ),
    );
  }

>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Recommendation'),
        backgroundColor: Colors.green.shade700,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input Section
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _cropController,
                              decoration: InputDecoration(
                                labelText: 'Crop Name',
                                border: OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _monthsController,
                              decoration: InputDecoration(
                                labelText: 'Planting Period (Months)',
                                border: OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Location Info
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(_placeName),
                            Text(
                              'Weather: $_weatherSummary',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Recommendation Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _getRecommendation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green.shade700,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Get Fertilizer Recommendation'),
                    ),

                    const SizedBox(height: 20),

                    // Results Section
                    if (_recommendation.isNotEmpty)
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Recommendation for ${_cropController.text}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _recommendation,
                                style: const TextStyle(height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Spacer to prevent overflow
                    if (_recommendation.isEmpty) const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}