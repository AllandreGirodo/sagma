import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

Future<void> configureAppCheckDebugToken(String? debugToken) async {
  final token = (debugToken ?? '').trim();
  if (token.isEmpty) {
    return;
  }

  final host = web.window.location.hostname;
  final isLocalhost =
      host == 'localhost' ||
      host == '127.0.0.1' ||
      host == '0.0.0.0' ||
      host == '::1';

  if (!isLocalhost) {
    return;
  }

  // Em localhost, expõe o token real somente quando ele existe.
  // Isso evita o SDK cair em estado inválido com valor booleano falso.
  (web.window as JSObject).setProperty(
    'FIREBASE_APPCHECK_DEBUG_TOKEN'.toJS,
    token.toJS,
  );
}
