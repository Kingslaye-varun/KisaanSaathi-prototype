import 'package:flutter/material.dart';
import '../screens/crop_yield_prediction_screen.dart';

class CropYieldWidget extends StatelessWidget {
  const CropYieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CropYieldPredictionScreen(),
          ),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[600]!, Colors.green[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.agriculture,
                size: 100,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Yield Prediction',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI-powered crop yield forecasting',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ML Models',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Arrow
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
