import 'package:flutter/material.dart';
import 'package:kisaansaathi/l10n/app_localizations.dart';
import 'package:kisaansaathi/services/tutorial_service.dart';

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;

  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeTutorial();
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  void _completeTutorial() async {
    await TutorialService.completeHomeScreenTutorial();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];
    final localizations = AppLocalizations.of(context);

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Spotlight effect
          CustomPaint(
            size: Size.infinite,
            painter: SpotlightPainter(spotlightRect: step.targetRect),
          ),

          // Pulsing circle around target
          if (step.targetRect != null)
            Positioned(
              left: step.targetRect!.left - 10,
              top: step.targetRect!.top - 10,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: step.targetRect!.width + 20,
                      height: step.targetRect!.height + 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green.shade400,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(
                          (step.targetRect!.width + 20) / 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Instruction card
          Positioned(
            left: 20,
            right: 20,
            bottom: 100,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Row(
                      children: [
                        Text(
                          '${_currentStep + 1}/${widget.steps.length}',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _skipTutorial,
                          child: Text(
                            _getText(localizations, 'skip'),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Next button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _currentStep == widget.steps.length - 1
                              ? _getText(localizations, 'got_it')
                              : _getText(localizations, 'next'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getText(AppLocalizations loc, String key) {
    switch (key) {
      case 'skip':
        return loc.locale.languageCode == 'hi'
            ? 'छोड़ें'
            : loc.locale.languageCode == 'ml'
            ? 'ഒഴിവാക്കുക'
            : 'Skip';
      case 'next':
        return loc.locale.languageCode == 'hi'
            ? 'अगला'
            : loc.locale.languageCode == 'ml'
            ? 'അടുത്തത്'
            : 'Next';
      case 'got_it':
        return loc.locale.languageCode == 'hi'
            ? 'समझ गया'
            : loc.locale.languageCode == 'ml'
            ? 'മനസ്സിലായി'
            : 'Got it!';
      default:
        return key;
    }
  }
}

class TutorialStep {
  final String title;
  final String description;
  final Rect? targetRect;

  TutorialStep({
    required this.title,
    required this.description,
    this.targetRect,
  });
}

class SpotlightPainter extends CustomPainter {
  final Rect? spotlightRect;

  SpotlightPainter({this.spotlightRect});

  @override
  void paint(Canvas canvas, Size size) {
    if (spotlightRect == null) return;

    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Draw the overlay with a hole for the spotlight
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(spotlightRect!, const Radius.circular(12)),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
