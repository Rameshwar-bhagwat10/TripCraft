import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/logging/app_logger.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<sb.AuthState>? _authSubscription;

  AuthNotifier(this._repository) : super(AuthState.initializing()) {
    _init();
  }

  void _init() {
    _checkCurrentSession();
    _authSubscription = _repository.onAuthStateChange.listen((data) {
      _handleAuthEvent(data.event, data.session);
    });
  }

  Future<void> _checkCurrentSession() async {
    try {
      final session = _repository.currentSession;
      if (session == null) {
        state = AuthState.unauthenticated();
        return;
      }
      await _processAuthenticatedSession(session);
    } catch (e, stack) {
      AppLogger.error('Error checking initial session', e, stack);
      state = AuthState.unauthenticated();
    }
  }

  void _handleAuthEvent(sb.AuthChangeEvent event, sb.Session? session) {
    if (session == null || event == sb.AuthChangeEvent.signedOut) {
      state = AuthState.unauthenticated();
    } else if (event == sb.AuthChangeEvent.signedIn ||
        event == sb.AuthChangeEvent.tokenRefreshed ||
        event == sb.AuthChangeEvent.userUpdated) {
      _processAuthenticatedSession(session);
    }
  }

  Future<void> _processAuthenticatedSession(sb.Session session) async {
    final user = session.user;

    try {
      final profile = await _repository.getUserProfile();
      final onboardingCompleted = profile['onboardingCompleted'] == true;

      if (!onboardingCompleted) {
        state = AuthState.onboardingRequired(
          userId: user.id,
          email: user.email ?? '',
          fullName: user.userMetadata?['full_name'],
        );
      } else {
        state = AuthState.authenticated(
          userId: user.id,
          email: user.email ?? '',
          fullName: user.userMetadata?['full_name'],
          avatarUrl: profile['avatarUrl'],
          onboardingCompleted: true,
        );
      }
    } catch (e) {
      // Fallback if NestJS backend isn't online yet
      state = AuthState.onboardingRequired(
        userId: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'],
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = AuthState.authenticating();
    try {
      await _repository.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final session = _repository.currentSession;
      if (session != null) {
        await _processAuthenticatedSession(session);
      }
      return true;
    } on sb.AuthException catch (e) {
      final userMessage = _mapSupabaseError(e);
      state = AuthState.error(userMessage);
      return false;
    } catch (e) {
      state = AuthState.error('Unable to sign in. Please check your network connection and try again.');
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = AuthState.authenticating();
    try {
      await _repository.signUpWithEmailAndPassword(
        email: email.trim(),
        password: password,
        fullName: fullName.trim(),
      );
      final session = _repository.currentSession;
      if (session != null) {
        await _processAuthenticatedSession(session);
      } else {
        state = AuthState.emailVerificationRequired(email.trim());
      }
      return true;
    } on sb.AuthException catch (e) {
      state = AuthState.error(_mapSupabaseError(e));
      return false;
    } catch (e) {
      state = AuthState.error('Registration failed. Please try again.');
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthState.authenticating();
    try {
      await _repository.signInWithGoogle();
    } catch (e) {
      state = AuthState.error('Google Sign-In failed or was cancelled.');
    }
  }

  Future<void> signInWithApple() async {
    state = AuthState.authenticating();
    try {
      await _repository.signInWithApple();
    } catch (e) {
      state = AuthState.error('Apple Sign-In failed or was cancelled.');
    }
  }

  Future<bool> checkEmailVerification() async {
    try {
      final session = _repository.currentSession;
      if (session != null) {
        await _processAuthenticatedSession(session);
        return true;
      }

      final user = _repository.currentUser;
      final email = state.email ?? user?.email ?? '';
      final userId = user?.id ?? 'user-id';
      final fullName = user?.userMetadata?['full_name'];

      state = AuthState.onboardingRequired(
        userId: userId,
        email: email,
        fullName: fullName,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      await _repository.resendVerificationEmail(email);
    } catch (e) {
      AppLogger.error('Resend email failed', e);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _repository.resetPasswordForEmail(email.trim());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      await _repository.updateUserPassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  void markOnboardingComplete() {
    final currentUser = _repository.currentUser;
    if (currentUser != null) {
      state = AuthState.authenticated(
        userId: currentUser.id,
        email: currentUser.email ?? '',
        fullName: currentUser.userMetadata?['full_name'],
        onboardingCompleted: true,
      );
    } else {
      state = AuthState.authenticated(
        userId: state.userId ?? 'user-id',
        email: state.email ?? '',
        fullName: state.fullName,
        onboardingCompleted: true,
      );
    }
  }

  String _mapSupabaseError(sb.AuthException error) {
    final msg = error.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'The email or password is incorrect. Please check your credentials and try again.';
    } else if (msg.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    } else if (msg.contains('user already registered') || msg.contains('already exists')) {
      return 'An account with this email address already exists. Please sign in.';
    } else if (msg.contains('password should be at least')) {
      return 'Password must be at least 6 characters long.';
    }
    return error.message;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}