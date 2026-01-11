import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_time.dart';
import '../models/occasion.dart';
import '../utils/prayer_utils.dart';
import '../providers/app_provider.dart';

class PrayerTimesWidget extends StatefulWidget {
  final PrayerTime? prayerTime;
  final List<Occasion> todayOccasions;

  const PrayerTimesWidget({
    super.key,
    required this.prayerTime,
    required this.todayOccasions,
  });

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  Timer? _timer;
  Map<String, dynamic>? _nextPrayer;

  @override
  void initState() {
    super.initState();
    _updateNextPrayer();
    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateNextPrayer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateNextPrayer() {
    if (widget.prayerTime != null) {
      setState(() {
        _nextPrayer = PrayerUtils.getNextPrayer(widget.prayerTime!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prayerTime == null) {
      return const Center(
        child: Text(
          'لا توجد بيانات أوقات الصلاة',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First Row: Two Prayer Times
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildPrayerCard('الفجر', widget.prayerTime!.fajr,
                      Icons.wb_sunny, _nextPrayer?['name'] == 'الفجر'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPrayerCard('الشروق', widget.prayerTime!.sunrise,
                      Icons.wb_twilight, _nextPrayer?['name'] == 'الشروق'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Second Row: Two Prayer Times
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildPrayerCard('الظهر', widget.prayerTime!.dhuhr,
                      Icons.wb_sunny_outlined, _nextPrayer?['name'] == 'الظهر'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPrayerCard('المغرب', widget.prayerTime!.maghrib,
                      Icons.nightlight_round, _nextPrayer?['name'] == 'المغرب'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Third Row: Countdown and Occasions
          Expanded(
            child: Row(
              children: [
                // Countdown
                if (_nextPrayer != null)
                  Expanded(
                    child: _buildCountdownCard(),
                  ),
                if (_nextPrayer != null) const SizedBox(width: 10),
                // Today's Occasions
                Expanded(
                  child: _buildOccasionCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard() {
    final provider = Provider.of<AppProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: provider.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, color: Color(0xFFd4af37), size: 50),
          const SizedBox(height: 12),
          Text(
            'المتبقى على ${_nextPrayer!['name']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            PrayerUtils.formatRemainingTime(_nextPrayer!['remaining']),
            style: const TextStyle(
              color: Color(0xFFd4af37),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionCard() {
    final provider = Provider.of<AppProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: provider.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event, color: Color(0xFFd4af37), size: 50),
          const SizedBox(height: 12),
          const Text(
            'مناسبات اليوم',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.todayOccasions.isNotEmpty
                ? widget.todayOccasions.first.name
                : 'لا توجد',
            style: TextStyle(
              color: widget.todayOccasions.isNotEmpty
                  ? const Color(0xFFd4af37)
                  : Colors.white70,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(
      String name, String time, IconData icon, bool isNextPrayer) {
    final provider = Provider.of<AppProvider>(context);
    // Use white background if this is the next prayer
    final backgroundColor =
        isNextPrayer ? Colors.white : provider.secondaryBackgroundColor;
    // Use dark green text/icon if background is white, otherwise use gold/white
    final textColor =
        isNextPrayer ? provider.secondaryBackgroundColor : Colors.white;
    final iconColor = isNextPrayer
        ? provider.secondaryBackgroundColor
        : const Color(0xFFd4af37);
    final timeColor = isNextPrayer
        ? provider.secondaryBackgroundColor
        : const Color(0xFFd4af37);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 50),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            PrayerUtils.convertTo12Hour(time),
            style: TextStyle(
              color: timeColor,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
