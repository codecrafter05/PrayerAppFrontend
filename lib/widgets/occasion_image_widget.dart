import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/occasion_image.dart';

class OccasionImageWidget extends StatefulWidget {
  final List<OccasionImage> images;

  const OccasionImageWidget({
    super.key,
    required this.images,
  });

  @override
  State<OccasionImageWidget> createState() => _OccasionImageWidgetState();
}

class _OccasionImageWidgetState extends State<OccasionImageWidget> {
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Only start timer if there are more than one image
    if (widget.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.images.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentImage = widget.images[_currentIndex];

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox.expand(
          child: CachedNetworkImage(
            imageUrl: currentImage.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

