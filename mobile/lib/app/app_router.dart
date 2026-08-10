import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../features/ai_copilot/presentation/screens/ai_copilot_screen.dart';
import '../features/ai_copilot/presentation/screens/ai_memories_screen.dart';
import '../features/authentication/domain/entities/auth_state.dart';
import '../features/authentication/presentation/providers/auth_provider.dart';
import '../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/authentication/presentation/screens/reset_password_screen.dart';
import '../features/authentication/presentation/screens/verify_email_screen.dart';
import '../features/design_system/design_system.dart';
import '../features/explore/presentation/screens/destination_details_screen.dart';
import '../features/explore/presentation/screens/destination_search_screen.dart';
import '../features/explore/presentation/screens/explore_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/itinerary/presentation/screens/itinerary_item_details_screen.dart';
import '../features/itinerary/presentation/screens/itinerary_screen.dart';
import '../features/maps/presentation/screens/trip_map_screen.dart';
import '../features/onboarding/onboarding.dart';
import '../features/places/presentation/screens/place_details_screen.dart';
import '../features/places/presentation/screens/places_screen.dart';
import '../features/profile/presentation/screens/app_preferences_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/travel_preferences_screen.dart';
import '../features/route_intelligence/presentation/screens/route_details_screen.dart';
import '../features/route_intelligence/presentation/screens/route_intelligence_screen.dart';
import '../features/saved/presentation/screens/saved_screen.dart';
import '../features/smart_trip_intelligence/presentation/screens/trip_intelligence_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/trip_operations/presentation/screens/add_booking_screen.dart';
import '../features/trip_operations/presentation/screens/booking_detail_screen.dart';
import '../features/trip_operations/presentation/screens/bookings_list_screen.dart';
import '../features/trip_operations/presentation/screens/document_vault_screen.dart';
import '../features/trip_operations/presentation/screens/trip_operations_screen.dart';
import '../features/trips/presentation/screens/create_trip_screen.dart';
import '../features/trips/presentation/screens/edit_trip_screen.dart';
import '../features/trips/presentation/screens/trip_workspace_screen.dart';
import '../features/trips/presentation/screens/trips_screen.dart';
import '../features/weather/presentation/screens/trip_weather_screen.dart';
import '../shared/layouts/app_shell.dart';

class AppRoutes {
  static const String designSystem = '/design-system';
}

class AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AuthRouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) {
      notifyListeners();
    });
  }
}

final authRouterNotifierProvider = Provider<AuthRouterNotifier>((ref) {
  return AuthRouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authRouterNotifierProvider);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
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

      // App Shell Branch Navigation (Home, Explore, Trips, Saved, Profile)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trips',
                builder: (context, state) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                builder: (context, state) => const SavedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Sub-routes (hides bottom nav bar)
      GoRoute(
        path: '/ai-copilot',
        builder: (context, state) {
          final tripId = state.uri.queryParameters['tripId'];
          return AiCopilotScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '/profile/ai-memories',
        builder: (context, state) => const AiMemoriesScreen(),
      ),
      GoRoute(
        path: '/explore/search',
        builder: (context, state) => const DestinationSearchScreen(),
      ),
      GoRoute(
        path: '/explore/places',
        builder: (context, state) => const PlacesScreen(),
      ),
      GoRoute(
        path: '/places/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'place-fort';
          return PlaceDetailsScreen(placeId: id);
        },
      ),
      GoRoute(
        path: '/explore/destination/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'dest-goa';
          return DestinationDetailsScreen(destinationId: id);
        },
      ),
      GoRoute(
        path: '/trips/create',
        builder: (context, state) {
          final destId = state.uri.queryParameters['destinationId'];
          return CreateTripScreen(initialDestinationId: destId);
        },
      ),
      GoRoute(
        path: '/trips/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return TripWorkspaceScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return EditTripScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/operations',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return TripOperationsScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/bookings',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return BookingsListScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/bookings/create',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return AddBookingScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/bookings/:bookingId',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          final bookingId = state.pathParameters['bookingId'] ?? 'book-flight-1';
          return BookingDetailScreen(tripId: id, bookingId: bookingId);
        },
      ),
      GoRoute(
        path: '/trips/:id/documents',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return DocumentVaultScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/itinerary',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return ItineraryScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/items/:itemId',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          final itemId = state.pathParameters['itemId'] ?? 'item-1';
          return ItineraryItemDetailsScreen(tripId: id, itemId: itemId);
        },
      ),
      GoRoute(
        path: '/trips/:id/map',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return TripMapScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/weather',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return TripWeatherScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/intelligence',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          return TripIntelligenceScreen(tripId: id);
        },
      ),
      GoRoute(
        path: '/trips/:id/days/:dayId/route',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          final dayId = state.pathParameters['dayId'] ?? 'day-1';
          return RouteDetailsScreen(tripId: id, dayId: dayId);
        },
      ),
      GoRoute(
        path: '/trips/:id/days/:dayId/intelligence',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'trip-goa-escape';
          final dayId = state.pathParameters['dayId'] ?? 'day-1';
          return RouteIntelligenceScreen(tripId: id, dayId: dayId);
        },
      ),
      GoRoute(
        path: RouteConstants.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteConstants.travelPreferences,
        builder: (context, state) => const TravelPreferencesScreen(),
      ),
      GoRoute(
        path: RouteConstants.appPreferences,
        builder: (context, state) => const AppPreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.designSystem,
        builder: (context, state) => const DesignSystemScreen(),
      ),
    ],
  );
});