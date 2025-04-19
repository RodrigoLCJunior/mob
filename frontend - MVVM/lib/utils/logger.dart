import 'dart:developer' as developer;

class Logger {
  static bool _isDebugMode = false;

  static void init(bool isDebugMode) {
    _isDebugMode = isDebugMode;
  }

  static void log(String message) {
    if (_isDebugMode) {
      developer.log('[Midnight Never End] $message', name: 'AppLogger');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_isDebugMode) {
      developer.log(
        '[ERROR] $message',
        name: 'AppLogger',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
