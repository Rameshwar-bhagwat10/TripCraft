import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_preferences_domain.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
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

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;
  final SupabaseClient? _supabaseClient;

  ProfileRemoteDataSourceImpl({
    required Dio dio,
    SupabaseClient? supabaseClient,
  })  : _dio = dio,
        _supabaseClient = supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  @override
  Future<UserProfile> getProfile() async {
    final response = await _dio.get('/users/me');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? language,
    String? currency,
  }) async {
    final payload = <String, dynamic>{};
    if (fullName != null) payload['fullName'] = fullName;
    if (avatarUrl != null) payload['avatarUrl'] = avatarUrl;
    if (language != null) payload['language'] = language;
    if (currency != null) payload['currency'] = currency;

    final response = await _dio.patch('/users/me', data: payload);
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserProfile> updatePreferences(UserPreferencesDomain preferences) async {
    final response = await _dio.put(
      '/users/me/preferences',
      data: preferences.toJson(),
    );
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> uploadAvatar({required File imageFile, required String userId}) async {
    final extension = imageFile.path.split('.').last;
    final path = '$userId/profile.$extension';

    await _client.storage.from('avatars').upload(
          path,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _client.storage.from('avatars').getPublicUrl(path);
    return publicUrl;
  }

  @override
  Future<void> removeAvatar({required String userId}) async {
    try {
      await _client.storage.from('avatars').remove([
        '$userId/profile.png',
        '$userId/profile.jpg',
        '$userId/profile.jpeg',
        '$userId/profile.webp',
      ]);
    } catch (_) {
      // Ignore cleanup error if file does not exist
    }
  }
}
