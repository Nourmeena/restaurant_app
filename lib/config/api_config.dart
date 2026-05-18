import 'package:flutter/foundation.dart';

/// Resolves base URL for the Node API in `/server`.
///
/// 1. `API_BASE_URL` dart-define overrides everything (use for a real phone).
/// 2. Web → `http://localhost:3000`
/// 3. Android → `http://10.0.2.2:3000` (emulator → your PC). On a **physical**
///    Android phone use `--dart-define=API_BASE_URL=http://YOUR_PC_IP:3000`.
/// 4. iOS simulator / desktop → `http://localhost:3000`
String get kApiBaseUrl {
  const fromEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  if (fromEnv.isNotEmpty) return fromEnv;

  if (kIsWeb) {
    return 'http://localhost:3000';
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }

  return 'http://localhost:3000';
}
