import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/auth_interceptor.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource({ApiClient? apiClient})
      : _apiClient = apiClient ??
            ApiClient(
              Dio(),
              authInterceptor: AuthInterceptor(Supabase.instance.client),
            );

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/users/me');
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> updatePreferences({
    required List<String> travelStyles,
    required List<String> interests,
    required String budgetLevel,
    required String travelPace,
    required List<String> companionTypes,
    required List<String> activityPreferences,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/users/me/preferences',
      data: {
        'travelStyles': travelStyles,
        'interests': interests,
        'budgetLevel': budgetLevel,
        'travelPace': travelPace,
        'companionTypes': companionTypes,
        'activityPreferences': activityPreferences,
      },
    );
    return response.data ?? {};
  }
}
