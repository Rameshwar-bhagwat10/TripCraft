enum AuthStatus {
  initializing,
  unauthenticated,
  authenticating,
  authenticated,
  emailVerificationRequired,
  onboardingRequired,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final bool onboardingCompleted;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.userId,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.onboardingCompleted = false,
    this.errorMessage,
  });

  factory AuthState.initializing() => const AuthState(status: AuthStatus.initializing);
  factory AuthState.unauthenticated() => const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.authenticating() => const AuthState(status: AuthStatus.authenticating);
  factory AuthState.authenticated({
    required String userId,
    required String email,
    String? fullName,
    String? avatarUrl,
    bool onboardingCompleted = true,
  }) =>
      AuthState(
        status: AuthStatus.authenticated,
        userId: userId,
        email: email,
        fullName: fullName,
        avatarUrl: avatarUrl,
        onboardingCompleted: onboardingCompleted,
      );
  factory AuthState.emailVerificationRequired(String email) => AuthState(
        status: AuthStatus.emailVerificationRequired,
        email: email,
      );
  factory AuthState.onboardingRequired({
    required String userId,
    required String email,
    String? fullName,
  }) =>
      AuthState(
        status: AuthStatus.onboardingRequired,
        userId: userId,
        email: email,
        fullName: fullName,
      );
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );
}
