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

class _NewsTickerWidgetState extends State<NewsTickerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();

    // Refresh hadith every 2 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      widget.onRefresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
      height: 80,
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
      child: Stack(
        children: [
          SlideTransition(
            position: _animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.format_quote,
                      color: Color(0xFFd4af37),
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Text(
                        widget.hadith!.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.format_quote,
                      color: Color(0xFFd4af37),
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
