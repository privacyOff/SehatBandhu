import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
const _supabaseAnonKey =
    String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  static Future<void> initialize() async {
    if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) {
      debugPrint(
        '[Supabase] Missing config. Pass --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=...',
      );
      throw StateError('Supabase credentials are missing');
    }

    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      debug: kDebugMode,
    );

    debugPrint('[Supabase] init completed for $_supabaseUrl');
  }
}
