import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../models/hadith.dart';
import '../models/occasion.dart';
import '../models/occasion_image.dart';
import '../models/theme.dart' as app_theme;
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';

class AppProvider with ChangeNotifier {
  PrayerTime? _prayerTime;
  Hadith? _currentHadith;
  List<Occasion> _todayOccasions = [];
  List<OccasionImage> _occasionImages = [];
  app_theme.Theme? _theme;
  bool _isLoading = true;

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

  /// تحميل البيانات المحفوظة من الكاش (للعرض الفوري عند فتح التطبيق)
  Future<void> _loadFromCache() async {
    _prayerTime = await CacheService.loadPrayerTime();
    _currentHadith = await CacheService.loadHadith();
    _todayOccasions = await CacheService.loadOccasions();
    _occasionImages = await CacheService.loadOccasionImages();
    _theme = await CacheService.loadTheme();
  }

  /// حفظ البيانات في الكاش بعد جلبها من السيرفر
  Future<void> _saveToCache() async {
    if (_prayerTime != null) await CacheService.savePrayerTime(_prayerTime);
    if (_currentHadith != null) await CacheService.saveHadith(_currentHadith);
    if (_todayOccasions.isNotEmpty) {
      await CacheService.saveOccasions(_todayOccasions);
    }
    if (_occasionImages.isNotEmpty) {
      await CacheService.saveOccasionImages(_occasionImages);
    }
    if (_theme != null) await CacheService.saveTheme(_theme);
  }

  /// استراتيجية العمل: كاش أولاً ثم السيرفر إذا في إنترنت
  /// - عند فتح التطبيق: نعرض الكاش فوراً، ثم نجلب من السيرفر فقط إذا في نت
  /// - بدون نت: نستخدم الكاش فقط (لا إعادة تحميل دورية)
  Future<void> loadData({bool silent = false}) async {
    // 1. تحميل من الكاش أولاً لعرض فوري
    await _loadFromCache();
    final hadCachedData = _prayerTime != null;

    if (!silent) {
      _isLoading = !hadCachedData; // إذا فيه كاش لا نعرض شاشة التحميل
    }
    notifyListeners();

    // 2. التحقق من النت - إذا ما فيه نت نكمل بالكاش فقط
    final hasNet = await ConnectivityService.hasInternet;
    if (!hasNet) {
      print('📴 [Provider] No internet - using cached data only');
      if (!silent) _isLoading = false;
      notifyListeners();
      return;
    }

    // 3. جلب من السيرفر في الخلفية (فيه نت)
    if (!silent) _isLoading = true;
    notifyListeners();

    try {
      print('🌐 [Provider] Fetching fresh data from API...');

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
      } else if (_currentHadith == null) {
        await _loadFromCache(); // نعيد تحميل الكاش للحديث إذا فشل
      }
      _todayOccasions = results[2] as List<Occasion>;
      _occasionImages = results[3] as List<OccasionImage>;
      _theme = results[4] as app_theme.Theme?;

      await _saveToCache();

      print('✅ [Provider] Data loaded from API');
      if (!silent) _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ [Provider] Error fetching from API: $e');
      print('Stack trace: $stackTrace');

      // عند الفشل نعتمد على الكاش (قد يكون null إذا أول مرة بدون نت)
      if (_currentHadith == null) await _loadFromCache();

      if (!silent) _isLoading = false;
      notifyListeners();
    }
  }

  /// تحديث الحديث يدوياً (يُستدعى من زر التحديث في الشريط)
  Future<void> refreshHadith() async {
    if (!await ConnectivityService.hasInternet) return;
    final newHadith = await ApiService.getRandomHadith();
    if (newHadith != null) {
      _currentHadith = newHadith;
      await CacheService.saveHadith(newHadith);
      notifyListeners();
    }
  }

  Future<void> refreshTheme() async {
    _theme = await ApiService.getCurrentTheme();
    notifyListeners();
  }
}
