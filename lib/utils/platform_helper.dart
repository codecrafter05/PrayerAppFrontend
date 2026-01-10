import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformHelper {
  /// Get the correct base URL based on the platform
  /// Django runs on 0.0.0.0:8000 which means it listens on all interfaces
  /// But to connect FROM the app, we need to use 127.0.0.1 or localhost
  static String getBaseUrl() {
    // For Web, use localhost or 127.0.0.1
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    
    // For Android Emulator, use special IP (10.0.2.2 maps to host's 127.0.0.1)
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    
    // For iOS Simulator and Desktop, use 127.0.0.1 (same as localhost)
    // This connects to Django running on 0.0.0.0:8000
    if (Platform.isIOS || Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return 'http://127.0.0.1:8000';
    }
    
    // Default fallback - use 127.0.0.1 (connects to Django on 0.0.0.0:8000)
    return 'http://127.0.0.1:8000';
  }
}

