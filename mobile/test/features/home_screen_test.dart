import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/home/domain/entities/home_data.dart';
import 'package:tripcraft/features/home/domain/repositories/home_repository.dart';
import 'package:tripcraft/features/home/presentation/providers/home_provider.dart';
import 'package:tripcraft/features/home/presentation/screens/home_screen.dart';
import 'package:tripcraft/features/profile/domain/entities/user_profile.dart';
import 'package:tripcraft/features/profile/domain/repositories/profile_repository.dart';
import 'package:tripcraft/features/profile/presentation/providers/profile_provider.dart';

class DummyHomeRepository implements HomeRepository {
  @override
  Future<HomeData> getHomeData() async {
    return const HomeData(
      upcomingTrip: null,
      recommendations: [],
      weather: WeatherPreviewData(
        location: 'Mumbai, India',
        temperature: 28,
        condition: 'Sunny',
        feelsLike: 29,
        icon: 'sun',
      ),
    );
  }
}

class DummyProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> getProfile() async {
    return const UserProfile(
      id: 'user-123',
      email: 'traveler@example.com',
      fullName: 'Rameshwar Bhagwat',
    );
  }

  @override
  Future<UserProfile> updateProfile({String? fullName, String? avatarUrl, String? language, String? currency}) async {
    return const UserProfile(id: 'dummy', email: 'dummy@example.com');
  }

  @override
  Future<UserProfile> updatePreferences(dynamic preferences) async {
    return const UserProfile(id: 'dummy', email: 'dummy@example.com');
  }

  @override
  Future<String> uploadAvatar({required dynamic imageFile, required String userId}) async {
    return '';
  }

  @override
  Future<void> removeAvatar({required String userId}) async {}
}

void main() {
  testWidgets('HomeScreen renders greeting, search entry and recommendation carousel', (WidgetTester tester) async {
    final mockProfile = const UserProfile(
      id: 'user-123',
      email: 'traveler@example.com',
      fullName: 'Rameshwar Bhagwat',
    );

    final mockHomeData = const HomeData(
      upcomingTrip: null,
      recommendations: [],
      weather: WeatherPreviewData(
        location: 'Mumbai, India',
        temperature: 28,
        condition: 'Sunny',
        feelsLike: 29,
        icon: 'sun',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(DummyProfileRepository()),
          profileProvider.overrideWith((ref) {
            return ProfileNotifier(DummyProfileRepository(), ProfileState(profile: mockProfile));
          }),
          homeRepositoryProvider.overrideWithValue(DummyHomeRepository()),
          homeProvider.overrideWith((ref) {
            return HomeNotifier(DummyHomeRepository(), HomeState(data: mockHomeData));
          }),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('WELCOME BACK'), findsOneWidget);
    expect(find.text('Ready for Goa?'), findsOneWidget);
    expect(find.text('TRIPCRAFT AI COPILOT'), findsOneWidget);
    expect(find.text('FEATURED DESTINATIONS'), findsOneWidget);
  });
}
