import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, size: 20),
      tooltip: 'Change Language',
      onSelected: (String value) {
        // TODO: Implement language switching
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language: $value (Coming soon)')),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'English',
          child: Text('English'),
        ),
        const PopupMenuItem<String>(
          value: 'Hindi',
          child: Text('हिंदी (Hindi)'),
        ),
        const PopupMenuItem<String>(
          value: 'Malayalam',
          child: Text('മലയാളം (Malayalam)'),
        ),
      ],
    );
  }
}
