/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Util dos Loggers
 ** Obs...:
 */

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static bool _isDebugMode = false;

  static void init(bool isDebugMode) {
    _isDebugMode = isDebugMode;
  }

  static void log(String message) {
    if (_isDebugMode || kDebugMode) {
      developer.log('[Rewalker Midnight] $message', name: 'AppLogger');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_isDebugMode || kDebugMode) {
      developer.log(
        '[Rewalker Midnight] [ERROR] $message',
        name: 'AppLogger',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
