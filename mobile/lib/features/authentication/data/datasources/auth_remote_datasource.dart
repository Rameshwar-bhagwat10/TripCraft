import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase signInWithPassword failed', e, stackTrace);
      rethrow;
    }
  }

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase signUp failed', e, stackTrace);
      rethrow;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      return await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.tripcraft://login-callback',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase signInWithGoogle failed', e, stackTrace);
      rethrow;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      return await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.tripcraft://login-callback',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase signInWithApple failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> resetPasswordForEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.tripcraft://reset-password',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase resetPasswordForEmail failed', e, stackTrace);
      rethrow;
    }
  }

  Future<UserResponse> updateUserPassword(String newPassword) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase updateUserPassword failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Supabase resendVerificationEmail failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, stackTrace) {
      AppLogger.error('Supabase signOut failed', e, stackTrace);
      rethrow;
    }
  }
}
