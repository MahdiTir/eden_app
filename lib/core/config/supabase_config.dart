import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration
///
/// reads from .env file
class SupabaseConfig {
  // Your Supabase project URL
  static String get url => dotenv.get('SUPABASE_URL', fallback: '');

  // Your Supabase anon/public key
  static String get anonKey => dotenv.get('SUPABASE_ANON_KEY', fallback: '');
}
