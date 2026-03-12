import 'package:flutter/material.dart';

import '../../shared/widgets/primary_action_button.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryActionButton(
              label: 'English',
              icon: Icons.language,
              onPressed: () => _goToLogin(context, 'en'),
            ),
            const SizedBox(height: 16),
            PrimaryActionButton(
              label: 'हिन्दी',
              icon: Icons.language,
              onPressed: () => _goToLogin(context, 'hi'),
            ),
            const SizedBox(height: 16),
            PrimaryActionButton(
              label: 'मराठी',
              icon: Icons.language,
              onPressed: () => _goToLogin(context, 'mr'),
            ),
          ],
        ),
      ),
    );
  }

  void _goToLogin(BuildContext context, String languageCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(languageCode: languageCode),
      ),
    );
  }
}
