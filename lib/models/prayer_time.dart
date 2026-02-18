class PrayerTime {
  final String date;
  final String dateFormatted;
  final String hijriDate;
  final String dayName;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String maghrib;

  PrayerTime({
    required this.date,
    required this.dateFormatted,
    required this.hijriDate,
    required this.dayName,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.maghrib,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      date: json['date'] ?? '',
      dateFormatted: json['date_formatted'] ?? '',
      hijriDate: json['hijri_date'] ?? '',
      dayName: json['day_name'] ?? '',
      fajr: json['fajr'] ?? '',
      sunrise: json['sunrise'] ?? '',
      dhuhr: json['dhuhr'] ?? '',
      maghrib: json['maghrib'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'date_formatted': dateFormatted,
      'hijri_date': hijriDate,
      'day_name': dayName,
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'maghrib': maghrib,
    };
  }
}

