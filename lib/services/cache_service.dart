import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_time.dart';
import '../models/hadith.dart';
import '../models/occasion.dart';
import '../models/occasion_image.dart';
import '../models/theme.dart' as app_theme;

/// مفاتيح التخزين المحلي
class CacheKeys {
  static const String prayerTime = 'cached_prayer_time';
  static const String hadith = 'cached_hadith';
  static const String occasions = 'cached_occasions';
  static const String occasionImages = 'cached_occasion_images';
  static const String theme = 'cached_theme';
}

/// خدمة تخزين البيانات محلياً للعمل بدون إنترنت
class CacheService {
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// حفظ أوقات الصلاة
  static Future<void> savePrayerTime(PrayerTime? pt) async {
    final prefs = await _prefs;
    if (pt != null) {
      await prefs.setString(CacheKeys.prayerTime, json.encode(pt.toJson()));
      if (kDebugMode) print('✅ [Cache] Saved prayer time');
    } else {
      await prefs.remove(CacheKeys.prayerTime);
    }
  }

  /// تحميل أوقات الصلاة المحفوظة
  static Future<PrayerTime?> loadPrayerTime() async {
    try {
      final prefs = await _prefs;
      final str = prefs.getString(CacheKeys.prayerTime);
      if (str != null && str.isNotEmpty) {
        return PrayerTime.fromJson(json.decode(str));
      }
    } catch (e) {
      if (kDebugMode) print('❌ [Cache] Error loading prayer time: $e');
    }
    return null;
  }

  /// حفظ الحديث
  static Future<void> saveHadith(Hadith? hadith) async {
    final prefs = await _prefs;
    if (hadith != null) {
      await prefs.setString(CacheKeys.hadith, json.encode(hadith.toJson()));
      if (kDebugMode) print('✅ [Cache] Saved hadith');
    } else {
      await prefs.remove(CacheKeys.hadith);
    }
  }

  /// تحميل الحديث المحفوظ
  static Future<Hadith?> loadHadith() async {
    try {
      final prefs = await _prefs;
      final str = prefs.getString(CacheKeys.hadith);
      if (str != null && str.isNotEmpty) {
        return Hadith.fromJson(json.decode(str));
      }
    } catch (e) {
      if (kDebugMode) print('❌ [Cache] Error loading hadith: $e');
    }
    return null;
  }

  /// حفظ المناسبات
  static Future<void> saveOccasions(List<Occasion> occasions) async {
    final prefs = await _prefs;
    if (occasions.isNotEmpty) {
      final list = occasions.map((o) => o.toJson()).toList();
      await prefs.setString(CacheKeys.occasions, json.encode(list));
      if (kDebugMode) print('✅ [Cache] Saved ${occasions.length} occasions');
    } else {
      await prefs.remove(CacheKeys.occasions);
    }
  }

  /// تحميل المناسبات المحفوظة
  static Future<List<Occasion>> loadOccasions() async {
    try {
      final prefs = await _prefs;
      final str = prefs.getString(CacheKeys.occasions);
      if (str != null && str.isNotEmpty) {
        final list = json.decode(str) as List;
        return list.map((e) => Occasion.fromJson(e)).toList();
      }
    } catch (e) {
      if (kDebugMode) print('❌ [Cache] Error loading occasions: $e');
    }
    return [];
  }

  /// حفظ صور المناسبات
  static Future<void> saveOccasionImages(List<OccasionImage> images) async {
    final prefs = await _prefs;
    if (images.isNotEmpty) {
      final list = images.map((i) => i.toJson()).toList();
      await prefs.setString(CacheKeys.occasionImages, json.encode(list));
      if (kDebugMode) print('✅ [Cache] Saved ${images.length} occasion images');
    } else {
      await prefs.remove(CacheKeys.occasionImages);
    }
  }

  /// تحميل صور المناسبات المحفوظة
  static Future<List<OccasionImage>> loadOccasionImages() async {
    try {
      final prefs = await _prefs;
      final str = prefs.getString(CacheKeys.occasionImages);
      if (str != null && str.isNotEmpty) {
        final list = json.decode(str) as List;
        return list.map((e) => OccasionImage.fromJson(e)).toList();
      }
    } catch (e) {
      if (kDebugMode) print('❌ [Cache] Error loading occasion images: $e');
    }
    return [];
  }

  /// حفظ الثيم
  static Future<void> saveTheme(app_theme.Theme? theme) async {
    final prefs = await _prefs;
    if (theme != null) {
      await prefs.setString(CacheKeys.theme, json.encode(theme.toJson()));
      if (kDebugMode) print('✅ [Cache] Saved theme');
    } else {
      await prefs.remove(CacheKeys.theme);
    }
  }

  /// تحميل الثيم المحفوظ
  static Future<app_theme.Theme?> loadTheme() async {
    try {
      final prefs = await _prefs;
      final str = prefs.getString(CacheKeys.theme);
      if (str != null && str.isNotEmpty) {
        return app_theme.Theme.fromJson(json.decode(str));
      }
    } catch (e) {
      if (kDebugMode) print('❌ [Cache] Error loading theme: $e');
    }
    return null;
  }

  /// هل يوجد بيانات محفوظة (للتحقق من إمكانية العمل أوفلاين)
  static Future<bool> hasCachedData() async {
    final pt = await loadPrayerTime();
    return pt != null;
  }
}
