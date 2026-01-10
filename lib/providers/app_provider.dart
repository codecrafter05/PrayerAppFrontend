import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Loading data from API...');

      // Load all data in parallel (including theme)
      final results = await Future.wait([
        ApiService.getTodayPrayerTimes(),
        ApiService.getRandomHadith(),
        ApiService.getTodayOccasions(),
        ApiService.getAllOccasionImages(),
        ApiService.getCurrentTheme(),
      ]);

      _prayerTime = results[0] as PrayerTime?;
      _currentHadith = results[1] as Hadith?;
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

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      print('Error loading data: $e');
      print('Stack trace: $stackTrace');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHadith() async {
    _currentHadith = await ApiService.getRandomHadith();
    notifyListeners();
  }

  Future<void> refreshTheme() async {
    _theme = await ApiService.getCurrentTheme();
    notifyListeners();
  }
}
