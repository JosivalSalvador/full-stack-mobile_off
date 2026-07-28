import 'dart:developer' as developer;

/// Centralizes how the app records diagnostic events and errors.
///
/// Callers must never pass sensitive values (passwords, derived keys,
/// tokens) as message or data — only pass what is safe to appear in a
/// device's debug log.
abstract final class AppLogger {
  /// Logs an informational event, such as a completed action.
  static void info(String message, {Map<String, Object?>? data}) {
    developer.log(_format(message, data), name: 'keymory_off', level: 800);
  }

  /// Logs a warning: something unexpected happened, but the app recovered.
  static void warning(String message, {Map<String, Object?>? data}) {
    developer.log(_format(message, data), name: 'keymory_off', level: 900);
  }

  /// Logs an error, optionally including the [error] object and
  /// [stackTrace] that caused it.
  static void error(
    String message, {
    Map<String, Object?>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      _format(message, data),
      name: 'keymory_off',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _format(String message, Map<String, Object?>? data) {
    if (data == null || data.isEmpty) return message;
    return '$message | $data';
  }
}
