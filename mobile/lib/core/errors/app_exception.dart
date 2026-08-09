abstract class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return "${prefix ?? ''}$message";
  }
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, "Network Error: ");
}

class ApiException extends AppException {
  final int? statusCode;
  final dynamic errorData;

  ApiException(String message, {this.statusCode, this.errorData})
      : super(message, "API Error [${statusCode ?? 'N/A'}]: ");
}

class AuthException extends AppException {
  AuthException(String message) : super(message, "Authentication Error: ");
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException(String message, {this.errors})
      : super(message, "Validation Error: ");
}

class UnknownException extends AppException {
  UnknownException(String message) : super(message, "Unexpected Error: ");
}