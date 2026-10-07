import 'package:flutter/material.dart';

/// Shows [asset] if it exists, otherwise a neutral placeholder.
/// >>> Replace by dropping the real PNG/JPG into assets/cars/ <<<
class CarImage extends StatelessWidget {
  const CarImage({
    super.key,
    this.asset,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.dark = false,
  });

  final String? asset;
  final BoxFit fit;
  final double radius;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final placeholder = _CarPlaceholder(dark: dark);
    Widget child = asset == null
        ? placeholder
        : Image.asset(
            asset!,
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => placeholder,
          );
    if (radius > 0) {
      child = ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
    }
    return child;
  }
}

class _CarPlaceholder extends StatelessWidget {
  const _CarPlaceholder({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final side = c.biggest.shortestSide.isFinite ? c.biggest.shortestSide : 80.0;
      return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? const [Color(0xFF2B2B2E), Color(0xFF0E0E10)]
                : const [Color(0xFFEDEEF1), Color(0xFFD9DBE0)],
          ),
        ),
        child: Icon(
          Icons.directions_car_filled_rounded,
          size: (side * 0.45).clamp(20.0, 96.0).toDouble(),
          color: dark ? Colors.white24 : Colors.black26,
        ),
      );
    });
  }
}

/// Round user avatar with a person-icon fallback.
class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.size, this.asset, this.ring = false});

  final double size;
  final String? asset;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: const Color(0xFFD9DCE2),
      alignment: Alignment.center,
      child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: ring ? Border.all(color: Colors.white, width: 4) : null,
        boxShadow: ring
            ? const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: asset == null
            ? fallback
            : Image.asset(
                asset!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              ),
      ),
    );
  }
}
