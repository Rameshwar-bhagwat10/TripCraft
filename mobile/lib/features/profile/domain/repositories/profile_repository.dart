import 'dart:io';
import '../entities/user_preferences_domain.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? language,
    String? currency,
  });
  Future<UserProfile> updatePreferences(UserPreferencesDomain preferences);
  Future<String> uploadAvatar({required File imageFile, required String userId});
  Future<void> removeAvatar({required String userId});
}
