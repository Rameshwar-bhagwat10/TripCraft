import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../logging/app_logger.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug("Request: [${options.method}] ${options.uri}");
    AppLogger.debug("Headers: ${options.headers}");
    if (options.data != null) {
      AppLogger.debug("Body: ${options.data}");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug("Response [${response.statusCode}]: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.warning("Network Error: [${err.response?.statusCode}] ${err.message}");
    
    AppException appException;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      appException = NetworkException("Connection timed out");
    } else if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      final responseData = err.response?.data;
      final message = responseData is Map ? (responseData['message'] ?? err.message) : err.message;
      
      if (statusCode == 401 || statusCode == 403) {
        appException = AuthException(message.toString());
      } else if (statusCode == 400 || statusCode == 422) {
        appException = ValidationException(message.toString());
      } else {
        appException = ApiException(message.toString(), statusCode: statusCode, errorData: responseData);
      }
    } else {
      appException = NetworkException(err.message ?? "Connection failure");
    }
    
    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
      message: appException.message,
    );
    
    super.onError(customErr, handler);
  }
}