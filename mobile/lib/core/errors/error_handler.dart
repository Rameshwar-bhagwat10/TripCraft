import 'app_exception.dart';
import '../logging/app_logger.dart';

class ErrorHandler {
  static AppException handle(dynamic error, [StackTrace? stackTrace]) {
    AppLogger.error("Global Error Interceptor caught an exception", error, stackTrace);
    
    if (error is AppException) {
      return error;
    }
    
    return UnknownException(error.toString());
  }
}