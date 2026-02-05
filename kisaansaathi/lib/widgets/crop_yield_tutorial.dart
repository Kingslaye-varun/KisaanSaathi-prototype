import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';

class CropYieldTutorial extends StatefulWidget {
  final VoidCallback onComplete;

  const CropYieldTutorial({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<CropYieldTutorial> createState() => _CropYieldTutorialState();
}

class _CropYieldTutorialState extends State<CropYieldTutorial> {
  int _currentStep = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'Welcome to Yield Prediction',
      description: 'Predict your crop yield using AI-powered machine learning models trained on real agricultural data.',
      icon: Icons.analytics,
    ),
    TutorialStep(
      title: 'Enter Crop Details',
      description: 'Select your state, crop type, and season. These factors significantly impact yield predictions.',
      icon: Icons.grass,
    ),
    TutorialStep(
      title: 'Provide Farm Data',
      description: 'Enter area, rainfall, fertilizer, and pesticide usage. Accurate data leads to better predictions.',
      icon: Icons.agriculture,
    ),
    TutorialStep(
      title: 'AI Model Ensemble',
      description: 'We use 4 ML models (Random Forest, XGBoost, LightGBM, CNN-LSTM) combined for accurate predictions.',
      icon: Icons.psychology,
    ),
    TutorialStep(
      title: 'Data Source',
      description: 'Models trained on verified Mendeley dataset with 19,000+ crop records from across India.',
      icon: Icons.dataset,
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _completeTutorial();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  Future<void> _completeTutorial() async {
    await TutorialService.markTutorialCompleted('crop_yield_prediction');
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Material(
      color: Colors.black.withOpacity(0.85),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.icon,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                step.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                step.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentStep ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentStep
                          ? Colors.green[700]
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip/Back Button
                  TextButton(
                    onPressed: _currentStep == 0 ? _skipTutorial : _previousStep,
                    child: Text(
                      _currentStep == 0 ? 'Skip' : 'Back',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  // Next/Done Button
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentStep == _steps.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontSize: 16),
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
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
