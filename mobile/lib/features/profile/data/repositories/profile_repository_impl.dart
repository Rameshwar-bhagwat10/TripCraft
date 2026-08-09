import 'dart:io';
import '../../domain/entities/user_preferences_domain.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfile> getProfile() {
    return _remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? language,
    String? currency,
  }) {
    return _remoteDataSource.updateProfile(
      fullName: fullName,
      avatarUrl: avatarUrl,
      language: language,
      currency: currency,
    );
  }

  @override
  Future<UserProfile> updatePreferences(UserPreferencesDomain preferences) {
    return _remoteDataSource.updatePreferences(preferences);
  }

  @override
  Future<String> uploadAvatar({required File imageFile, required String userId}) {
    return _remoteDataSource.uploadAvatar(imageFile: imageFile, userId: userId);
  }

  @override
  Future<void> removeAvatar({required String userId}) {
    return _remoteDataSource.removeAvatar(userId: userId);
  }
}
