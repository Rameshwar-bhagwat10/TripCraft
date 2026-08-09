import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../features/authentication/domain/entities/auth_state.dart';
import '../features/authentication/presentation/providers/auth_provider.dart';
import '../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/authentication/presentation/screens/reset_password_screen.dart';
import '../features/authentication/presentation/screens/verify_email_screen.dart';
import '../features/design_system/design_system.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/onboarding/onboarding.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String designSystem = '/design-system';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: _ListenableAdapter(authNotifier),
    redirect: (context, state) {
      final status = authState.status;
      final loc = state.matchedLocation;

      final isPublicRoute = loc == RouteConstants.login ||
          loc == RouteConstants.register ||
          loc == RouteConstants.forgotPassword ||
          loc == RouteConstants.resetPassword ||
          loc == AppRoutes.designSystem;

      if (status == AuthStatus.initializing) {
        return loc == RouteConstants.splash ? null : RouteConstants.splash;
      }

      if (status == AuthStatus.unauthenticated || status == AuthStatus.error) {
        return isPublicRoute ? null : RouteConstants.login;
      }

      if (status == AuthStatus.emailVerificationRequired) {
        return loc == RouteConstants.verifyEmail ? null : RouteConstants.verifyEmail;
      }

      if (status == AuthStatus.onboardingRequired) {
        return loc == RouteConstants.onboarding ? null : RouteConstants.onboarding;
      }

      if (status == AuthStatus.authenticated) {
        if (loc == RouteConstants.splash ||
            loc == RouteConstants.login ||
            loc == RouteConstants.register ||
            loc == RouteConstants.verifyEmail ||
            loc == RouteConstants.onboarding) {
          return RouteConstants.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteConstants.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: RouteConstants.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteConstants.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.designSystem,
        builder: (context, state) => const DesignSystemScreen(),
      ),
    ],
  );
});

class _ListenableAdapter extends ChangeNotifier {
  _ListenableAdapter(StateNotifier notifier) {
    notifier.addListener((_) {
      notifyListeners();
    });
  }
}