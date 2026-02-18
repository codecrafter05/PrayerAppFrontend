import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hadith.dart';
import '../providers/app_provider.dart';

class NewsTickerWidget extends StatelessWidget {
  final Hadith? hadith;
  final VoidCallback onRefresh;

  const NewsTickerWidget({
    super.key,
    required this.hadith,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (hadith == null || hadith!.text.isEmpty) {
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Center(
          child: Text(
            hadith!.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
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
