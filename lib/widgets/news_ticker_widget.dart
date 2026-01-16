import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hadith.dart';
import '../providers/app_provider.dart';

class NewsTickerWidget extends StatefulWidget {
  final Hadith? hadith;
  final VoidCallback onRefresh;

  const NewsTickerWidget({
    super.key,
    required this.hadith,
    required this.onRefresh,
  });

  @override
  State<NewsTickerWidget> createState() => _NewsTickerWidgetState();
}

class _NewsTickerWidgetState extends State<NewsTickerWidget> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    // تحديث الحديث كل 5 دقائق
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      widget.onRefresh();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hadith == null || widget.hadith!.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final provider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: provider.secondaryBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Center(
          child: Text(
            widget.hadith!.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
