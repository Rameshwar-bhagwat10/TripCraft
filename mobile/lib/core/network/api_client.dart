import 'package:dio/dio.dart';
import '../../config/api/api_config.dart';
import '../errors/app_exception.dart';
import 'api_interceptor.dart';
import 'auth_interceptor.dart';
import 'network_response.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio, {required AuthInterceptor authInterceptor}) {
    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
    );
    
    _dio.interceptors.addAll([
      authInterceptor,
      ApiInterceptor(),
    ]);
  }

  Dio get client => _dio;

  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(() => _dio.get<T>(path, queryParameters: queryParameters, options: options));
  }

  Future<NetworkResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(() => _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  Future<NetworkResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(() => _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  Future<NetworkResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(() => _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  Future<NetworkResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(() => _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  Future<NetworkResponse<T>> _request<T>(Future<Response<T>> Function() call) async {
    try {
      final response = await call();
      return NetworkResponse.success(response.data);
    } on DioException catch (e) {
      if (e.error is AppException) {
        return NetworkResponse.failure(e.error as AppException);
      }
      return NetworkResponse.failure(UnknownException(e.message ?? "Request failed"));
    } catch (e) {
      return NetworkResponse.failure(UnknownException(e.toString()));
    }
  }
}