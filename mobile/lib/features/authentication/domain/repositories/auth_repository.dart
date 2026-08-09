import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Session? get currentSession;
  User? get currentUser;
  Stream<AuthState> get onAuthStateChange;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  });

  Future<bool> signInWithGoogle();
  Future<bool> signInWithApple();

  Future<void> resetPasswordForEmail(String email);
  Future<void> updateUserPassword(String newPassword);
  Future<void> resendVerificationEmail(String email);
  Future<void> signOut();

  Future<Map<String, dynamic>> getUserProfile();
  Future<Map<String, dynamic>> saveUserPreferences({
    required List<String> travelStyles,
    required List<String> interests,
    required String budgetLevel,
    required String travelPace,
    required List<String> companionTypes,
    required List<String> activityPreferences,
  });
}
