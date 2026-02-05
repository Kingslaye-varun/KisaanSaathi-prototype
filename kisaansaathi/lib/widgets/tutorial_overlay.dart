import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';
import 'dart:math' as math;

class TutorialStep {
  final String title;
  final String description;
  final GlobalKey targetKey;
  final Alignment alignment;

  TutorialStep({
    required this.title,
    required this.description,
    required this.targetKey,
    this.alignment = Alignment.bottomCenter,
  });
}

class TutorialOverlay extends StatefulWidget {
  final String screenName;
  final List<TutorialStep> steps;
  final VoidCallback onComplete;

  const TutorialOverlay({
    Key? key,
    required this.screenName,
    required this.steps,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();

  static Future<void> show({
    required BuildContext context,
    required String screenName,
    required List<TutorialStep> steps,
  }) async {
    final completed = await TutorialService.isTutorialCompleted(screenName);
    if (completed) return;

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (context) => TutorialOverlay(
          screenName: screenName,
          steps: steps,
          onComplete: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _currentStep = 0;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTargetRect();
    });
  }

  void _updateTargetRect() {
    if (_currentStep < widget.steps.length) {
      final RenderBox? renderBox = widget.steps[_currentStep]
          .targetKey
          .currentContext
          ?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        setState(() {
          _targetRect = position & renderBox.size;
        });
      }
    }
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
        _targetRect = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTargetRect();
      });
    } else {
      _completeTutorial();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _targetRect = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTargetRect();
      });
    }
  }

  void _completeTutorial() async {
    await TutorialService.markTutorialCompleted(widget.screenName);
    widget.onComplete();
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Semi-transparent overlay with hole
        CustomPaint(
          size: screenSize,
          painter: _HolePainter(
            holeRect: _targetRect,
            holeRadius: 8,
          ),
        ),
        // Instruction card
        if (_targetRect != null)
          Positioned(
            left: 16,
            right: 16,
            top: _calculateCardPosition(screenSize),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 240, // Reduced height
                ),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              step.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Text(
                            '${_currentStep + 1}/${widget.steps.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _skipTutorial,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                          Row(
                            children: [
                              if (_currentStep > 0)
                                TextButton(
                                  onPressed: _previousStep,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  child: const Text('Previous', style: TextStyle(fontSize: 13)),
                                ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _nextStep,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: Text(
                                  _currentStep < widget.steps.length - 1
                                      ? 'Next'
                                      : 'Got it!',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  double _calculateCardPosition(Size screenSize) {
    if (_targetRect == null) return screenSize.height / 2 - 150;

    final targetBottom = _targetRect!.bottom;
    final targetTop = _targetRect!.top;
    final targetCenter = (_targetRect!.top + _targetRect!.bottom) / 2;
    
    // Account for highlight padding and border
    final highlightPadding = 24.0; // Increased from 20 to match new inflate value
    final adjustedTargetTop = targetTop - highlightPadding;
    final adjustedTargetBottom = targetBottom + highlightPadding;
    
    final cardHeight = 260.0; // Reduced to match new max height
    final minGap = 20.0; // Additional gap for safety

    // Calculate actual available space
    final spaceAbove = adjustedTargetTop - 80; // Status bar
    final spaceBelow = screenSize.height - adjustedTargetBottom - 80; // Bottom nav

    // Debug: Always prefer the side with more space
    if (spaceBelow >= spaceAbove) {
      // Show below
      final position = adjustedTargetBottom + minGap;
      // Make sure it fits on screen
      if (position + cardHeight > screenSize.height - 20) {
        // Not enough space below, try above
        return math.max(20.0, adjustedTargetTop - cardHeight - minGap);
      }
      return position;
    } else {
      // Show above
      final position = adjustedTargetTop - cardHeight - minGap;
      // Make sure it fits on screen
      if (position < 80) {
        // Not enough space above, try below
        return math.min(screenSize.height - cardHeight - 20, adjustedTargetBottom + minGap);
      }
      return position;
    }
  }
}

class _HolePainter extends CustomPainter {
  final Rect? holeRect;
  final double holeRadius;

  _HolePainter({
    required this.holeRect,
    required this.holeRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create the overlay with a hole using Path
    final overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (holeRect != null) {
      // Create hole path and add to overlay with more padding for brightness
      overlayPath.addRRect(
        RRect.fromRectAndRadius(
          holeRect!.inflate(16), // Increased from 12 to 16
          Radius.circular(holeRadius),
        ),
      );
    }

    // Draw the overlay with hole - darker for better contrast
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.88) // Increased from 0.85
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, paint);

    // Draw glowing border around hole for better visibility
    if (holeRect != null) {
      // Outer glow - brighter
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.5) // Increased from 0.3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10 // Increased from 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6); // Increased blur

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          holeRect!.inflate(16),
          Radius.circular(holeRadius),
        ),
        glowPaint,
      );

      // Main border - brighter and thicker
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4; // Increased from 3

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          holeRect!.inflate(16),
          Radius.circular(holeRadius),
        ),
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HolePainter oldDelegate) {
    return oldDelegate.holeRect != holeRect;
  }
}
