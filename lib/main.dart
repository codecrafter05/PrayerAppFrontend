import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'مسجد الديه - شاشة التلفاز',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: provider.primaryBackgroundColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: provider.primaryBackgroundColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              // استخدام خط Almarai الجميل والواضح للعربية
              textTheme: GoogleFonts.almaraiTextTheme(
                ThemeData.dark().textTheme,
              ).apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'SA'),
              Locale('en', 'US'),
            ],
            locale: const Locale('ar', 'SA'),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
