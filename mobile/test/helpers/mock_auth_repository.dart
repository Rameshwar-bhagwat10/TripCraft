import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripcraft/features/authentication/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Session? get currentSession => null;

  @override
  User? get currentUser => null;

  @override
  Stream<AuthState> get onAuthStateChange => _controller.stream;

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {}

  @override
  Future<void> signUpWithEmailAndPassword({required String email, required String password, required String fullName}) async {}

  @override
  Future<bool> signInWithGoogle() async => true;

  @override
  Future<bool> signInWithApple() async => true;

  @override
  Future<void> resetPasswordForEmail(String email) async {}

  @override
  Future<void> updateUserPassword(String newPassword) async {}

  @override
  Future<void> resendVerificationEmail(String email) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<Map<String, dynamic>> getUserProfile() async => {
        'id': 'mock-id',
        'email': 'mock@example.com',
        'onboardingCompleted': false,
      };

  @override
  Future<Map<String, dynamic>> saveUserPreferences({
    required List<String> travelStyles,
    required List<String> interests,
    required String budgetLevel,
    required String travelPace,
    required List<String> companionTypes,
    required List<String> activityPreferences,
  }) async =>
      {
        'onboardingCompleted': true,
      };

  void dispose() {
    _controller.close();
  }
}
