import 'package:flutter/foundation.dart';

class Logger {
  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO] $message');
  }

  static void warn(String message) {
    if (kDebugMode) debugPrint('[WARN] $message');
  }

  static void error(String message) {
    // Em release podemos querer enviar para um serviço remoto; por enquanto logamos apenas em debug
    if (kDebugMode) debugPrint('[ERROR] $message');
  }
}
