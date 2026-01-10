import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';
import '../models/hadith.dart';
import '../models/occasion.dart';
import '../models/occasion_image.dart';
import '../models/theme.dart';
import '../utils/platform_helper.dart';

class ApiService {
  // ⚠️ مهم: اختر العنوان المناسب حسب منصة التشغيل:
  //
  // - iOS Simulator: استخدم 'localhost' أو IP الكمبيوتر
  // - Android Emulator: استخدم '10.0.2.2' (Android emulator special IP)
  // - Android Device/Android TV: استخدم IP الكمبيوتر (مثل: 192.168.100.106)
  // - Web: استخدم 'localhost' أو '127.0.0.1'
  // - Desktop (Mac/Windows/Linux): استخدم 'localhost' أو '127.0.0.1'
  //
  // لمعرفة IP الكمبيوتر:
  //   Mac/Linux: ifconfig | grep "inet " | grep -v 127.0.0.1
  //   Windows: ipconfig

  // Get base URL based on platform
  static String get baseUrl => PlatformHelper.getBaseUrl();

  // بدائل يدوية (إذا أردت تحديدها يدوياً):
  // static const String baseUrl = 'http://localhost:8000';  // iOS Simulator, Web, Desktop
  // static const String baseUrl = 'http://10.0.2.2:8000';    // Android Emulator
  // static const String baseUrl = 'http://127.0.0.1:8000';  // Web/Desktop
  // static const String baseUrl = 'http://192.168.100.106:8000';  // Android Device/TV (استخدم IP الكمبيوتر)

  // Get today's prayer times
  static Future<PrayerTime?> getTodayPrayerTimes() async {
    try {
      final url = Uri.parse('$baseUrl/api/prayer-times/today/');
      print('🔵 [API] Fetching prayer times from: $url');
      print('🔵 [API] Base URL: $baseUrl');

      http.Response response;
      try {
        response = await http.get(url).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            print(
                '❌ [API] Timeout: Failed to fetch prayer times after 15 seconds');
            throw Exception('Connection timeout');
          },
        );
      } catch (e) {
        if (e.toString().contains('Failed host lookup') ||
            e.toString().contains('Connection refused')) {
          print('❌ [API] Connection Error: Cannot reach server at $baseUrl');
          print(
              '❌ [API] Make sure Django server is running: python manage.py runserver 0.0.0.0:8000');
        }
        rethrow;
      }

      print('🔵 [API] Response status: ${response.statusCode}');
      print('🔵 [API] Response body length: ${response.body.length}');
      print(
          '🔵 [API] Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(utf8.decode(response.bodyBytes));
          print('✅ [API] Parsed JSON successfully');
          print('🔵 [API] JSON keys: ${jsonData.keys}');

          if (jsonData['success'] == true) {
            if (jsonData['data'] != null) {
              final prayerTime = PrayerTime.fromJson(jsonData['data']);
              print('✅ [API] Prayer time created successfully!');
              print('✅ [API] Date: ${prayerTime.date}');
              print(
                  '✅ [API] Fajr: ${prayerTime.fajr}, Dhuhr: ${prayerTime.dhuhr}');
              return prayerTime;
            } else {
              print('❌ [API] API returned success=true but data is null');
            }
          } else {
            print('❌ [API] API returned success=false');
            print('❌ [API] Error: ${jsonData['error'] ?? 'Unknown error'}');
          }
        } catch (e) {
          print('❌ [API] JSON parsing error: $e');
          print('❌ [API] Full response body: ${response.body}');
        }
      } else {
        print('❌ [API] HTTP Error: ${response.statusCode}');
        print('❌ [API] Response body: ${response.body}');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [API] Exception fetching prayer times: $e');
      print('❌ [API] Exception type: ${e.runtimeType}');
      if (kDebugMode) {
        print('❌ [API] Stack trace: $stackTrace');
      }
      return null;
    }
  }

  // Get random hadith
  static Future<Hadith?> getRandomHadith() async {
    try {
      final url = Uri.parse('$baseUrl/api/hadith/random/');
      print('🔵 Fetching hadith from: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('❌ Timeout: Failed to fetch hadith');
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final hadith = Hadith.fromJson(jsonData['data']);
          print('✅ Hadith fetched: ${hadith.text.substring(0, 30)}...');
          return hadith;
        } else {
          print('❌ Hadith API returned success=false or data is null');
        }
      } else {
        print('❌ Hadith HTTP Error: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching hadith: $e');
      return null;
    }
  }

  // Get today's occasions
  static Future<List<Occasion>> getTodayOccasions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/occasions/today/'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['success'] == true && jsonData['data'] != null) {
          List<Occasion> occasions = [];
          for (var item in jsonData['data']) {
            occasions.add(Occasion.fromJson(item));
          }
          return occasions;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching occasions: $e');
      return [];
    }
  }

  // Get random occasion image
  static Future<OccasionImage?> getRandomOccasionImage() async {
    try {
      final url = Uri.parse('$baseUrl/api/occasion-images/random/');
      print('🔵 Fetching occasion image from: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('❌ Timeout: Failed to fetch occasion image');
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final image = OccasionImage.fromJson(jsonData['data']);
          print('✅ Occasion image fetched: ${image.imageUrl}');
          return image;
        } else {
          print('❌ Occasion image API returned success=false or data is null');
        }
      } else {
        print('❌ Occasion image HTTP Error: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching occasion image: $e');
      return null;
    }
  }

  // Get all occasion images
  static Future<List<OccasionImage>> getAllOccasionImages() async {
    try {
      final url = Uri.parse('$baseUrl/api/occasion-images/all/');
      print('🔵 Fetching all occasion images from: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('❌ Timeout: Failed to fetch occasion images');
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> imagesJson = jsonData['data'];
          final images = imagesJson
              .map((json) => OccasionImage.fromJson(json))
              .toList();
          print('✅ Fetched ${images.length} occasion images');
          return images;
        } else {
          print('❌ Occasion images API returned success=false or data is null');
        }
      } else {
        print('❌ Occasion images HTTP Error: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      print('❌ Error fetching occasion images: $e');
      return [];
    }
  }

  // Get current theme
  static Future<Theme?> getCurrentTheme() async {
    try {
      final url = Uri.parse('$baseUrl/api/theme/current/');
      print('🔵 Fetching theme from: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('❌ Timeout: Failed to fetch theme');
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final theme = Theme.fromJson(jsonData['data']);
          print('✅ Theme fetched: ${theme.name}');
          print('✅ Primary color: ${theme.primaryBackgroundColor}');
          print('✅ Secondary color: ${theme.secondaryBackgroundColor}');
          return theme;
        } else {
          print('❌ Theme API returned success=false or data is null');
        }
      } else {
        print('❌ Theme HTTP Error: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching theme: $e');
      // في حالة الخطأ، نرجع null وسيستخدم التطبيق الألوان الافتراضية
      return null;
    }
  }
}
