import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/language_selection_screen.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  await HiveService.init();
  runApp(const ProviderScope(child: SehatBandhuApp()));
}

class SehatBandhuApp extends StatelessWidget {
  const SehatBandhuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SehatBandhu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LanguageSelectionScreen(),
    );
  }
}
