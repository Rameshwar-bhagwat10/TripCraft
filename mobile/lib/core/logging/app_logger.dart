import 'package:logger/logger.dart';
import '../../config/environment/environment.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
    level: Environment.isDevelopment ? Level.debug : Level.warning,
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(_sanitize(message), error: error, stackTrace: stackTrace);
  }

  static void info(String message) {
    _logger.i(_sanitize(message));
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(_sanitize(message), error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(_sanitize(message), error: error, stackTrace: stackTrace);
  }

  static String _sanitize(String data) {
    final tokenRegex = RegExp(
      r'(token|password|key|secret|anonKey|authorization)["\s:=]+([^\s,";}]+)',
      caseSensitive: false,
    );
    return data.replaceAllMapped(tokenRegex, (match) {
      final key = match.group(1);
      return '$key: [REDACTED]';
    });
  }
}