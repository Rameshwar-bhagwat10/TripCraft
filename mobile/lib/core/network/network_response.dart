import '../errors/app_exception.dart';

class NetworkResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final AppException? error;

  NetworkResponse.success(this.data, [this.message])
      : success = true,
        error = null;

  NetworkResponse.failure(this.error, [this.message])
      : success = false,
        data = null;
}