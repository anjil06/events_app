import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  /// Default port for the Node.js backend
static const int port = 5000;

  /// Your machine's Wi-Fi LAN IP for physical Android/iOS devices
static const String lanHost = 'http://192.168.1.7:$port';

  /// Standard Android emulator host loopback
static const String emulatorHost = 'http://10.0.2.2:$port';

  /// Localhost for Web / Desktop / Simulator
static const String localhost = 'http://localhost:$port';

  /// Cache for the verified working host
static String? _cachedWorkingHost;

  /// Candidate hosts to check, prioritizing LAN host and emulator host
static List<String> get candidateHosts => [
        lanHost,
emulatorHost,
localhost,
      ];

  /// Set the active verified host
static void setWorkingHost(String host) {
    _cachedWorkingHost = host;
  }

  /// Base URL: returns cached working host if available, otherwise sensible default
static String get baseUrl {
if (_cachedWorkingHost != null && _cachedWorkingHost!.isNotEmpty) {
      return _cachedWorkingHost!;
    }

if (kIsWeb) {
      return localhost;
    }

    try {
if (Platform.isAndroid) {
        // Physical devices cannot reach 10.0.2.2; they use lanHost.
        return lanHost;
      }
    } catch (_) {
      // Fallback
    }

    return localhost;
  }

  // Upload Endpoints
static String get uploadEventImageUrl => '$baseUrl/api/upload/event-image';
static String get uploadProfileImageUrl => '$baseUrl/api/upload/profile-image';
static String get deleteImageUrl => '$baseUrl/api/upload/delete';
static String get healthUrl => '$baseUrl/health';
}
