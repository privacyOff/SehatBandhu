import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://oxgvdicgxveteaddcqpe.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94Z3ZkaWNneHZldGVhZGRjcXBlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzMzEyNDcsImV4cCI6MjA4ODkwNzI0N30.GkFaioqfEJrTRkmPsShfbvcb8WPrrXY9CyWehwVPfHc',
    );
  }
}
