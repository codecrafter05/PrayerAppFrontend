import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/prayer_time.dart';
import '../providers/app_provider.dart';

class HeaderWidget extends StatefulWidget {
  final PrayerTime? prayerTime;

  const HeaderWidget({
    super.key,
    required this.prayerTime,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = _currentTime;
    final dayName = DateFormat('EEEE', 'ar').format(now);

    // Format: "6 يناير 2026 م" (Arabic month name, English numbers)
    final monthNameAr = DateFormat('MMMM', 'ar').format(now);
    final day = now.day;
    final year = now.year;
    final gregorianDate = '$day $monthNameAr $year م';

    // Format time as HH:MM:SS with English numbers
    final timeString = DateFormat('HH:mm:ss', 'en_US').format(now);

    final provider = Provider.of<AppProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: provider.secondaryBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Day Name
          Text(
            dayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Spacer
          const Spacer(),

          // Gregorian Date
          Text(
            gregorianDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Spacer
          const Spacer(),

          // Time Clock
          Text(
            timeString,
            style: const TextStyle(
              color: Color(0xFFd4af37), // Gold color
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Spacer
          const Spacer(),

          // Hijri Date
          Text(
            widget.prayerTime?.hijriDate ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Spacer
          const Spacer(),

          // Mosque Name
          const Text(
            'مسجد الديه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
