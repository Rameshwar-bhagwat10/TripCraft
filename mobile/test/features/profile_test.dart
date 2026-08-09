import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/profile/domain/entities/user_preferences_domain.dart';
import 'package:tripcraft/features/profile/domain/entities/user_profile.dart';
import 'package:tripcraft/features/profile/domain/repositories/profile_repository.dart';
import 'package:tripcraft/features/profile/presentation/providers/profile_provider.dart';
import 'package:tripcraft/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:tripcraft/features/profile/presentation/screens/profile_screen.dart';
import 'package:tripcraft/features/profile/presentation/screens/travel_preferences_screen.dart';

class DummyProfileRepository implements ProfileRepository {
  final UserProfile mockProfile;

  DummyProfileRepository({
    this.mockProfile = const UserProfile(id: 'dummy', email: 'dummy@example.com'),
  });

  @override
  Future<UserProfile> getProfile() async {
    return mockProfile;
  }

  @override
  Future<UserProfile> updateProfile({String? fullName, String? avatarUrl, String? language, String? currency}) async {
    return mockProfile.copyWith(
      fullName: fullName ?? mockProfile.fullName,
      avatarUrl: avatarUrl ?? mockProfile.avatarUrl,
      language: language ?? mockProfile.language,
      currency: currency ?? mockProfile.currency,
    );
  }

  @override
  Future<UserProfile> updatePreferences(UserPreferencesDomain preferences) async {
    return mockProfile.copyWith(preferences: preferences);
  }

  @override
  Future<String> uploadAvatar({required File imageFile, required String userId}) async {
    return 'https://example.com/avatar.png';
  }

  @override
  Future<void> removeAvatar({required String userId}) async {}
}

void main() {
  testWidgets('ProfileScreen renders header, name and section options', (WidgetTester tester) async {
    final mockProfile = UserProfile(
      id: 'user-123',
      email: 'traveler@example.com',
      fullName: 'Rameshwar Bhagwat',
      preferences: const UserPreferencesDomain(
        travelStyles: ['Adventure', 'Nature'],
        budgetLevel: 'Moderate',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            DummyProfileRepository(mockProfile: mockProfile),
          ),
          profileProvider.overrideWith((ref) {
            final repo = DummyProfileRepository(mockProfile: mockProfile);
            return ProfileNotifier(repo, ProfileState(profile: mockProfile));
          }),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Rameshwar Bhagwat'), findsWidgets);
    expect(find.text('traveler@example.com'), findsOneWidget);
    expect(find.text('PERSONAL INFORMATION'), findsOneWidget);
    expect(find.text('TRAVEL PREFERENCES'), findsOneWidget);
  });

  testWidgets('EditProfileScreen renders name input field and save button', (WidgetTester tester) async {
    final mockProfile = UserProfile(
      id: 'user-123',
      email: 'traveler@example.com',
      fullName: 'Rameshwar Bhagwat',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            DummyProfileRepository(mockProfile: mockProfile),
          ),
          profileProvider.overrideWith((ref) {
            final repo = DummyProfileRepository(mockProfile: mockProfile);
            return ProfileNotifier(repo, ProfileState(profile: mockProfile));
          }),
        ],
        child: const MaterialApp(
          home: EditProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('TravelPreferencesScreen renders travel style and budget choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            DummyProfileRepository(),
          ),
          profileProvider.overrideWith((ref) {
            final repo = DummyProfileRepository();
            return ProfileNotifier(repo, const ProfileState(profile: UserProfile(id: 'dummy', email: 'dummy@example.com')));
          }),
        ],
        child: const MaterialApp(
          home: TravelPreferencesScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Travel Personalization'), findsOneWidget);
    expect(find.text('TRAVEL STYLES'), findsOneWidget);
    expect(find.text('BUDGET LEVEL'), findsOneWidget);
  });
}
