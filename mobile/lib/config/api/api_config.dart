import '../../config/environment/environment.dart';

class ApiConfig {
  static String get baseUrl => Environment.apiBaseUrl;
  
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}