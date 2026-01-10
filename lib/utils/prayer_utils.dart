import '../models/prayer_time.dart';

class PrayerUtils {
  // Get next prayer time and remaining time
  static Map<String, dynamic> getNextPrayer(PrayerTime prayerTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Parse prayer times
    final fajrTime = _parseTime(prayerTime.fajr);
    final sunriseTime = _parseTime(prayerTime.sunrise);
    final dhuhrTime = _parseTime(prayerTime.dhuhr);
    final maghribTime = _parseTime(prayerTime.maghrib);

    // Create DateTime objects for today
    final fajrDateTime =
        today.add(Duration(hours: fajrTime.hour, minutes: fajrTime.minute));
    final sunriseDateTime = today
        .add(Duration(hours: sunriseTime.hour, minutes: sunriseTime.minute));
    final dhuhrDateTime =
        today.add(Duration(hours: dhuhrTime.hour, minutes: dhuhrTime.minute));
    final maghribDateTime = today
        .add(Duration(hours: maghribTime.hour, minutes: maghribTime.minute));

    // Find next prayer
    DateTime? nextPrayer;
    String nextPrayerName = '';

    if (now.isBefore(fajrDateTime)) {
      nextPrayer = fajrDateTime;
      nextPrayerName = 'الفجر';
    } else if (now.isBefore(sunriseDateTime)) {
      nextPrayer = sunriseDateTime;
      nextPrayerName = 'الشروق';
    } else if (now.isBefore(dhuhrDateTime)) {
      nextPrayer = dhuhrDateTime;
      nextPrayerName = 'الظهر';
    } else if (now.isBefore(maghribDateTime)) {
      nextPrayer = maghribDateTime;
      nextPrayerName = 'المغرب';
    } else {
      // If all prayers passed, next is tomorrow's Fajr
      nextPrayer = fajrDateTime.add(const Duration(days: 1));
      nextPrayerName = 'الفجر';
    }

    final remaining = nextPrayer.difference(now);

    return {
      'name': nextPrayerName,
      'time': nextPrayer,
      'remaining': remaining,
      'hours': remaining.inHours,
      'minutes': remaining.inMinutes % 60,
      'seconds': remaining.inSeconds % 60,
    };
  }

  static TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Format remaining time as string (HH:MM:SS format)
  static String formatRemainingTime(Duration remaining) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    // Format as HH:MM:SS (always show hours, minutes, seconds)
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});
}
