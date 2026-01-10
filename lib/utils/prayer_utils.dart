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

  /// Convert 24-hour time string (HH:mm) to 12-hour format with AM/PM in Arabic
  /// Example: "14:30" -> "2:30 مساءً"
  static String convertTo12Hour(String time24) {
    final parts = time24.split(':');
    if (parts.length != 2) return time24;

    try {
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String period;
      if (hour == 0) {
        hour = 12;
        period = 'ص';
      } else if (hour == 12) {
        period = 'م';
      } else if (hour < 12) {
        period = 'ص';
      } else {
        hour = hour - 12;
        period = 'م';
      }

      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  /// Check if current time is within prayer time (5 minutes window)
  /// Returns prayer name if it's prayer time, null otherwise
  static String? getCurrentPrayer(PrayerTime prayerTime) {
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

    // Check if current time is within 5 minutes after any prayer time
    // Show notification when prayer time arrives and for 5 minutes after
    final prayerWindowEnd = const Duration(minutes: 5);
    
    // Allow checking within the same minute (for precision)
    final tolerance = const Duration(seconds: -1);

    if (now.isAfter(fajrDateTime.add(tolerance)) && 
        now.isBefore(fajrDateTime.add(prayerWindowEnd))) {
      return 'الفجر';
    } else if (now.isAfter(sunriseDateTime.add(tolerance)) && 
               now.isBefore(sunriseDateTime.add(prayerWindowEnd))) {
      return 'الشروق';
    } else if (now.isAfter(dhuhrDateTime.add(tolerance)) && 
               now.isBefore(dhuhrDateTime.add(prayerWindowEnd))) {
      return 'الظهر';
    } else if (now.isAfter(maghribDateTime.add(tolerance)) && 
               now.isBefore(maghribDateTime.add(prayerWindowEnd))) {
      return 'المغرب';
    }

    return null;
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});
}
