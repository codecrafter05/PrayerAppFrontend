import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/header_widget.dart';
import '../widgets/occasion_image_widget.dart';
import '../widgets/prayer_times_widget.dart';
import '../widgets/news_ticker_widget.dart';
import '../utils/prayer_utils.dart';
import 'prayer_notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _prayerCheckTimer;
  String? _currentPrayer;
  DateTime? _prayerNotificationStartTime;

  @override
  void initState() {
    super.initState();
    // Set fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // تحميل البيانات عند فتح التطبيق (كاش أولاً، ثم من السيرفر إذا في نت)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.loadData();
    });

    // التحقق من وقت الصلاة كل ثانية
    _prayerCheckTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkPrayerTime();
    });
  }

  @override
  void dispose() {
    _prayerCheckTimer?.cancel();
    super.dispose();
  }

  void _checkPrayerTime() {
    final provider = Provider.of<AppProvider>(context, listen: false);

    if (provider.prayerTime == null) return;

    final currentPrayer = PrayerUtils.getCurrentPrayer(provider.prayerTime!);

    if (currentPrayer != null) {
      // Prayer time detected
      if (_currentPrayer != currentPrayer) {
        // New prayer time started
        setState(() {
          _currentPrayer = currentPrayer;
          _prayerNotificationStartTime = DateTime.now();
        });
      } else if (_prayerNotificationStartTime != null) {
        // Check if 5 minutes have passed
        final duration =
            DateTime.now().difference(_prayerNotificationStartTime!);
        if (duration.inMinutes >= 5) {
          // Hide notification after 5 minutes
          setState(() {
            _currentPrayer = null;
            _prayerNotificationStartTime = null;
          });
        }
      }
    } else {
      // Not prayer time
      if (_currentPrayer != null) {
        setState(() {
          _currentPrayer = null;
          _prayerNotificationStartTime = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show prayer notification screen if it's prayer time
    if (_currentPrayer != null) {
      return PrayerNotificationScreen(prayerName: _currentPrayer!);
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // سيتم تحديده من خلال Consumer
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            // استخدام اللون الديناميكي من Theme
            return Container(
              color: provider.primaryBackgroundColor,
              child: _buildContent(provider),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(AppProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'جاري تحميل البيانات...',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      );
    }

    // Debug info
    if (kDebugMode) {
      print('🔵 Provider state:');
      print('  - isLoading: ${provider.isLoading}');
      print('  - prayerTime: ${provider.prayerTime?.date ?? "null"}');
      print(
          '  - hadith: ${provider.currentHadith?.text.substring(0, 30) ?? "null"}...');
      print('  - occasions: ${provider.todayOccasions.length}');
      print('  - images: ${provider.occasionImages.length}');
      print('  - theme: ${provider.theme?.name ?? "default"}');
      print('  - primary color: ${provider.primaryBackgroundColor}');
      print('  - secondary color: ${provider.secondaryBackgroundColor}');
    }

    // Show error if no prayer time
    if (provider.prayerTime == null) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'لا توجد بيانات أوقات الصلاة',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                const SizedBox(height: 10),
                const Text(
                  'تأكد من أن السيرفر يعمل وأن التاريخ اليوم موجود في قاعدة البيانات',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Debug info
                if (kDebugMode)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Debug Info:',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'PrayerTime: ${provider.prayerTime?.date ?? "null"}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          'Hadith: ${provider.currentHadith != null ? "exists" : "null"}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          'Occasions: ${provider.todayOccasions.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          'Images: ${provider.occasionImages.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => provider.loadData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFd4af37),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Disable scroll
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            // Header
            HeaderWidget(
              prayerTime: provider.prayerTime,
            ),

            // Main Content Area: Image on Left, Prayer Times on Right
            Expanded(
              child: Row(
                children: [
                  // Right: Prayer Times and Occasions (appears on right in RTL)
                  Expanded(
                    flex: 2, // 40% of width
                    child: PrayerTimesWidget(
                      prayerTime: provider.prayerTime,
                      todayOccasions: provider.todayOccasions,
                    ),
                  ),

                  // Left: Occasion Image (appears on left in RTL)
                  Expanded(
                    flex: 3, // 60% of width
                    child: provider.occasionImages.isNotEmpty
                        ? OccasionImageWidget(
                            images: provider.occasionImages,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // News Ticker
            NewsTickerWidget(
              hadith: provider.currentHadith,
              onRefresh: () => provider.refreshHadith(),
            ),
          ],
        ),
      ),
    );
  }
}
