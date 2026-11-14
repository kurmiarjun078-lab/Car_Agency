import 'package:flutter/material.dart';
import '../../widgets/car_image.dart';

/// Full-screen, pinch-to-zoom photo viewer for a car.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key, required this.title, required this.images});

  final String title;
  final List<String> images;

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          if (images.length > 1)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('${_page + 1}/${images.length}'),
              ),
            ),
        ],
      ),
      body: images.isEmpty
          ? const Center(
              child: Text('No photos', style: TextStyle(color: Colors.white)),
            )
          : PageView.builder(
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: CarImage(asset: images[i], fit: BoxFit.contain, dark: true),
                ),
              ),
            ),
    );
  }
}
