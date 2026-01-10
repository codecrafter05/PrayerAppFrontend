import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class PrayerNotificationScreen extends StatelessWidget {
  final String prayerName;

  const PrayerNotificationScreen({
    super.key,
    required this.prayerName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.primaryBackgroundColor,
          body: Container(
            color: provider.primaryBackgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Islamic Crescent Symbol
                  Text(
                    '☪',
                    style: TextStyle(
                      fontSize: 180,
                      color: const Color(0xFFd4af37),
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Notification Text
                  Text(
                    'حان وقت أذان $prayerName',
                    style: GoogleFonts.almarai(
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
