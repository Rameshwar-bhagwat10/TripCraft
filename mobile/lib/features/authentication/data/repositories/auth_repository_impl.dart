import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? authRemoteDataSource,
    UserRemoteDataSource? userRemoteDataSource,
  })  : _authRemoteDataSource = authRemoteDataSource ?? AuthRemoteDataSource(),
        _userRemoteDataSource = userRemoteDataSource ?? UserRemoteDataSource();

  @override
  Session? get currentSession => _authRemoteDataSource.currentSession;

  @override
  User? get currentUser => _authRemoteDataSource.currentUser;

  @override
  Stream<AuthState> get onAuthStateChange => _authRemoteDataSource.onAuthStateChange;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _authRemoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _authRemoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<bool> signInWithGoogle() => _authRemoteDataSource.signInWithGoogle();

  @override
  Future<bool> signInWithApple() => _authRemoteDataSource.signInWithApple();

  @override
  Future<void> resetPasswordForEmail(String email) =>
      _authRemoteDataSource.resetPasswordForEmail(email);

  @override
  Future<void> updateUserPassword(String newPassword) async {
    await _authRemoteDataSource.updateUserPassword(newPassword);
  }

  @override
  Future<void> resendVerificationEmail(String email) =>
      _authRemoteDataSource.resendVerificationEmail(email);

  @override
  Future<void> signOut() => _authRemoteDataSource.signOut();

  @override
  Future<Map<String, dynamic>> getUserProfile() =>
      _userRemoteDataSource.getProfile();

  @override
  Future<Map<String, dynamic>> saveUserPreferences({
    required List<String> travelStyles,
    required List<String> interests,
    required String budgetLevel,
    required String travelPace,
    required List<String> companionTypes,
    required List<String> activityPreferences,
  }) =>
      _userRemoteDataSource.updatePreferences(
        travelStyles: travelStyles,
        interests: interests,
        budgetLevel: budgetLevel,
        travelPace: travelPace,
        companionTypes: companionTypes,
        activityPreferences: activityPreferences,
      );
}
