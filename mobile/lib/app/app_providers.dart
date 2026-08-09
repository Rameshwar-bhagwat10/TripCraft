import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/network/api_client.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/network_info.dart';
import '../core/storage/local_database.dart';
import '../core/storage/secure_storage.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl(const FlutterSecureStorage());
});

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  final db = LocalDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthInterceptor(supabase);
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final authInterceptor = ref.watch(authInterceptorProvider);
  return ApiClient(dio, authInterceptor: authInterceptor);
});