import 'package:flutter/material.dart';

import 'login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                'SehatBandhu',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Choose your language',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 26),
              _LanguageCard(
                label: 'English',
                onTap: () => _goToLogin(context, 'en'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                label: 'हिन्दी',
                onTap: () => _goToLogin(context, 'hi'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                label: 'मराठी',
                onTap: () => _goToLogin(context, 'mr'),
              ),
              const Spacer(),
              Text(
                'Simple care for every village',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
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

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
