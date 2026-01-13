import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_time.dart';
import '../models/hadith.dart';
import '../models/occasion.dart';
import '../models/occasion_image.dart';
import '../models/theme.dart' as app_theme;
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  PrayerTime? _prayerTime;
  Hadith? _currentHadith;
  List<Occasion> _todayOccasions = [];
  List<OccasionImage> _occasionImages = [];
  app_theme.Theme? _theme;
  bool _isLoading = true;

  static const String _cachedHadithKey = 'cached_hadith';

  PrayerTime? get prayerTime => _prayerTime;
  Hadith? get currentHadith => _currentHadith;
  List<Occasion> get todayOccasions => _todayOccasions;
  List<OccasionImage> get occasionImages => _occasionImages;
  app_theme.Theme? get theme => _theme;
  bool get isLoading => _isLoading;

  // الألوان الافتراضية (الأخضر الإسلامي)
  static const Color defaultPrimaryColor = Color(0xFF1a472a); // الأخضر الفاتح
  static const Color defaultSecondaryColor = Color(0xFF0d2818); // الأخضر الغامق

  // الحصول على اللون الرئيسي (الخلفية الرئيسية)
  Color get primaryBackgroundColor {
    if (_theme != null) {
      return Color(_theme!.primaryColorInt);
    }
    return defaultPrimaryColor;
  }

  // الحصول على اللون الثانوي (للـ cards)
  Color get secondaryBackgroundColor {
    if (_theme != null) {
      return Color(_theme!.secondaryColorInt);
    }
    return defaultSecondaryColor;
  }

  // تحميل الحديث المحفوظ من التخزين المحلي
  Future<void> loadCachedHadith() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedHadithJson = prefs.getString(_cachedHadithKey);

      if (cachedHadithJson != null && cachedHadithJson.isNotEmpty) {
        final jsonData = json.decode(cachedHadithJson);
        _currentHadith = Hadith.fromJson(jsonData);
        print(
            '✅ [Provider] Loaded cached hadith: ${_currentHadith!.text.substring(0, _currentHadith!.text.length > 30 ? 30 : _currentHadith!.text.length)}...');
        notifyListeners();
      }
    } catch (e) {
      print('❌ [Provider] Error loading cached hadith: $e');
    }
  }

  // حفظ الحديث في التخزين المحلي
  Future<void> _saveHadithToCache(Hadith? hadith) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (hadith != null) {
        final hadithJson = json.encode(hadith.toJson());
        await prefs.setString(_cachedHadithKey, hadithJson);
        print('✅ [Provider] Saved hadith to cache');
      } else {
        await prefs.remove(_cachedHadithKey);
      }
    } catch (e) {
      print('❌ [Provider] Error saving hadith to cache: $e');
    }
  }

  Future<void> loadData({bool silent = false}) async {
    // تحميل الحديث المحفوظ أولاً لعرضه فوراً قبل تحميل البيانات الجديدة
    await loadCachedHadith();

    // فقط نعرض شاشة التحميل إذا لم يكن silent mode
    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      print('Loading data from API... ${silent ? "(silent)" : ""}');

      // Load all data in parallel (including theme)
      final results = await Future.wait([
        ApiService.getTodayPrayerTimes(),
        ApiService.getRandomHadith(),
        ApiService.getTodayOccasions(),
        ApiService.getAllOccasionImages(),
        ApiService.getCurrentTheme(),
      ]);

      _prayerTime = results[0] as PrayerTime?;
      final newHadith = results[1] as Hadith?;
      if (newHadith != null) {
        _currentHadith = newHadith;
        await _saveHadithToCache(newHadith);
      } else if (_currentHadith == null) {
        // إذا فشل تحميل الحديث الجديد ولم يكن هناك حديث محفوظ، نحاول تحميله مرة أخرى
        await loadCachedHadith();
      }
      _todayOccasions = results[2] as List<Occasion>;
      _occasionImages = results[3] as List<OccasionImage>;
      _theme = results[4] as app_theme.Theme?;

      print('✅ [Provider] Data loaded:');
      print('   PrayerTime: ${_prayerTime?.date ?? "null"}');
      if (_currentHadith != null) {
        print(
            '   Hadith: ${_currentHadith!.text.substring(0, _currentHadith!.text.length > 30 ? 30 : _currentHadith!.text.length)}...');
      } else {
        print('   Hadith: null');
      }
      print('   Occasions: ${_todayOccasions.length}');
      print('   Images: ${_occasionImages.length}');
      if (_theme != null) {
        print('   Theme: ${_theme!.name}');
        print('   Primary color: ${_theme!.primaryBackgroundColor}');
        print('   Secondary color: ${_theme!.secondaryBackgroundColor}');
      } else {
        print('   Theme: null (using defaults)');
      }

      if (_prayerTime == null) {
        print('⚠️ [Provider] WARNING: PrayerTime is null!');
      }

      // فقط نحدث حالة التحميل إذا لم يكن silent mode
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    } catch (e, stackTrace) {
      print('Error loading data: $e');
      print('Stack trace: $stackTrace');

      // في حالة الخطأ، نتأكد من وجود حديث محفوظ
      if (_currentHadith == null) {
        await loadCachedHadith();
      }

      // فقط نحدث حالة التحميل إذا لم يكن silent mode
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> refreshHadith() async {
    final newHadith = await ApiService.getRandomHadith();
    if (newHadith != null) {
      _currentHadith = newHadith;
      await _saveHadithToCache(newHadith);
      notifyListeners();
    }
  }

  Future<void> refreshTheme() async {
    _theme = await ApiService.getCurrentTheme();
    notifyListeners();
  }
}
