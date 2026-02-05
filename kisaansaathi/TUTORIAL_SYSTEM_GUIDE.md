# Tutorial System & Daily Quotes Guide

## Overview
This guide explains how to use the overlay tutorial system and daily quote feature in KisaanSaathi.

## Features

### 1. Daily Quote Dialog
- Shows a motivational farming quote once per day
- Bilingual (Hindi + English)
- Beautiful gradient design
- Automatically tracks if shown today

### 2. Tutorial Overlay System
- Interactive step-by-step tutorials
- Highlights specific UI elements
- Shows only once per screen (unless replayed)
- Skip or navigate through steps
- Semi-transparent overlay with spotlight effect

## Files Created

```
lib/
├── services/
│   ├── tutorial_service.dart      # Manages tutorial state
│   └── quote_service.dart          # Provides daily quotes
└── widgets/
    ├── tutorial_overlay.dart       # Tutorial overlay component
    └── daily_quote_dialog.dart     # Daily quote dialog
```

## Usage

### Adding Tutorial to Any Screen

```dart
import 'package:flutter/material.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/daily_quote_dialog.dart';

class YourScreen extends StatefulWidget {
  @override
  State<YourScreen> createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  // Create GlobalKeys for elements you want to highlight
  final GlobalKey _button1Key = GlobalKey();
  final GlobalKey _button2Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _showTutorialAndQuote();
  }

  Future<void> _showTutorialAndQuote() async {
    // Wait for widgets to build
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    // Show daily quote first
    await DailyQuoteDialog.show(context);
    
    if (!mounted) return;

    // Then show tutorial
    await TutorialOverlay.show(
      context: context,
      screenName: 'your_screen_name', // Unique identifier
      steps: [
        TutorialStep(
          title: 'Feature Title',
          description: 'Detailed description of this feature...',
          targetKey: _button1Key,
        ),
        TutorialStep(
          title: 'Another Feature',
          description: 'Description of another feature...',
          targetKey: _button2Key,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Assign keys to widgets you want to highlight
          ElevatedButton(
            key: _button1Key,
            onPressed: () {},
            child: Text('Button 1'),
          ),
          ElevatedButton(
            key: _button2Key,
            onPressed: () {},
            child: Text('Button 2'),
          ),
        ],
      ),
    );
  }
}
```

### Adding Help Button to Replay Tutorial

```dart
AppBar(
  actions: [
    IconButton(
      icon: Icon(Icons.help_outline),
      onPressed: () {
        // Replay tutorial with different screen name
        TutorialOverlay.show(
          context: context,
          screenName: 'your_screen_replay', // Different name to show again
          steps: [...], // Same steps
        );
      },
    ),
  ],
)
```

### Managing Tutorial State

```dart
import '../services/tutorial_service.dart';

// Check if tutorial completed
bool completed = await TutorialService.isTutorialCompleted('screen_name');

// Mark tutorial as completed
await TutorialService.markTutorialCompleted('screen_name');

// Reset specific tutorial
await TutorialService.resetTutorial('screen_name');

// Reset all tutorials
await TutorialService.resetAllTutorials();
```

### Adding More Quotes

Edit `lib/services/quote_service.dart`:

```dart
static final List<Map<String, String>> _farmingQuotes = [
  {
    'quote': 'Hindi quote here',
    'quote_en': 'English translation',
    'author': 'लेखक का नाम',
    'author_en': 'Author Name'
  },
  // Add more quotes...
];
```

## Tutorial Step Properties

```dart
TutorialStep(
  title: 'Step Title',           // Main heading
  description: 'Description',     // Detailed explanation
  targetKey: _globalKey,          // Widget to highlight
  alignment: Alignment.bottomCenter, // Optional: card position
)
```

## Customization

### Change Tutorial Colors

In `tutorial_overlay.dart`, modify:

```dart
// Overlay darkness
Colors.black.withOpacity(0.7)  // Change 0.7 to adjust darkness

// Highlight border color
borderPaint..color = Colors.white  // Change to any color

// Card background
color: Colors.white  // Change card background

// Button colors
backgroundColor: Colors.green  // Change button color
```

### Change Quote Dialog Design

In `daily_quote_dialog.dart`, modify:

```dart
// Gradient colors
colors: [
  Color(0xFF4CAF50),  // Start color
  Color(0xFF8BC34A),  // End color
]

// Icon
Icon(Icons.wb_sunny, size: 48)  // Change icon
```

## Example Implementation

See `lib/screens/farmer_home_screen_tutorial.dart` for a complete working example with:
- 6 tutorial steps
- Daily quote integration
- Help button to replay tutorial
- Proper key assignments

## Integration Steps

1. **Import the widgets** in your screen
2. **Create GlobalKeys** for elements to highlight
3. **Call tutorial in initState** with delay
4. **Assign keys** to widgets in build method
5. **Add help button** (optional) to replay tutorial

## Best Practices

1. **Keep descriptions concise** - 2-3 sentences max
2. **Use bilingual text** - Hindi + English for better reach
3. **Highlight important features** - Don't overwhelm with too many steps
4. **Test on different screen sizes** - Ensure card positioning works
5. **Unique screen names** - Use descriptive, unique identifiers
6. **Wait for build** - Always add delay before showing tutorial

## Troubleshooting

### Tutorial not showing
- Check if already completed: `TutorialService.isTutorialCompleted()`
- Ensure delay is sufficient: `await Future.delayed(Duration(milliseconds: 500))`
- Verify GlobalKeys are assigned to widgets

### Highlight not appearing
- Make sure widget with GlobalKey is visible
- Check if widget is built before tutorial shows
- Increase delay if needed

### Quote showing every time
- Check SharedPreferences is working
- Verify date comparison logic
- Clear app data and test again

## Future Enhancements

- [ ] Add animation to tutorial transitions
- [ ] Support for video tutorials
- [ ] Analytics to track tutorial completion
- [ ] Multi-language quote support
- [ ] Custom quote categories
- [ ] Tutorial progress indicator
