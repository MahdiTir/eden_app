import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign Up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName}, // Store standard metadata
    );

    // We rely on the Postgres Trigger to insert the initial row with the username.
    // However, if we have an active session (email confirmation disabled), we can try to sync it to be safe.
    if (response.session != null && response.user != null) {
      try {
        await _updatePublicUser(response.user!.id, fullName);
      } catch (e) {
        // Ignore RLS errors here, trust the trigger
        // ignore: avoid_print
        print(
          'Manual public user update failed (likely RLS or Trigger handled it): $e',
        );
      }
    }

    return response;
  }

  // Sign In
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Update public.users table
  // The trigger handles row creation, we just update the username
  Future<void> _updatePublicUser(String userId, String username) async {
    try {
      await _supabase
          .from('users')
          .update({
            'username': username,
            // xp_total and confidence_score should be handled by defaults or other logic
          })
          .eq('id', userId);
    } catch (e) {
      // If the trigger hasn't fired yet or row doesn't exist, we might need to wait or handle it.
      // However, usually triggers are immediate.
      // If it fails, we might want to retry or log it.
      // ignore: avoid_print
      print('Error updating public user: $e');
      rethrow;
    }
  }
}
