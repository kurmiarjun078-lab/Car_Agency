import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Shows a car picture. [asset] can be a bundled asset path
/// ('assets/...'), a web URL ('http...') or a base64 string (admin uploads).
/// Falls back to a neutral placeholder when it is missing or broken.
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

  static final Map<String, Uint8List> _cache = {};

  static Uint8List? _decode(String data) {
    final cached = _cache[data];
    if (cached != null) return cached;
    try {
      final comma = data.indexOf(',');
      final raw = data.startsWith('data:') && comma != -1
          ? data.substring(comma + 1)
          : data;
      final bytes = base64Decode(raw);
      _cache[data] = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = _CarPlaceholder(dark: dark);
    final a = asset;
    Widget child;
    if (a == null || a.isEmpty) {
      child = placeholder;
    } else if (a.startsWith('assets/')) {
      child = Image.asset(
        a,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else if (a.startsWith('http')) {
      child = Image.network(
        a,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      final bytes = _decode(a);
      child = bytes == null
          ? placeholder
          : Image.memory(
              bytes,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => placeholder,
            );
    }
    if (radius > 0) {
      child =
          ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
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
      final side =
          c.biggest.shortestSide.isFinite ? c.biggest.shortestSide : 80.0;
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
  const Avatar({
    super.key,
    required this.size,
    this.asset,
    this.photo,
    this.name,
    this.ring = false,
  });

  final double size;
  final String? asset;
  final String? photo;

  /// Used for initials when there is no picture.
  final String? name;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final initial = (name ?? '').trim();
    final fallback = Container(
      color: const Color(0xFFD9DCE2),
      alignment: Alignment.center,
      child: initial.isEmpty
          ? Icon(Icons.person, size: size * 0.6, color: Colors.white)
          : Text(
              initial[0].toUpperCase(),
              style: TextStyle(
                fontSize: size * 0.45,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    );
    final image = (photo?.isNotEmpty ?? false) ? photo : asset;
    Widget imageWidget = fallback;
    if (image != null && image.isNotEmpty) {
      if (image.startsWith('assets/')) {
        imageWidget = Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        );
      } else if (image.startsWith('http')) {
        imageWidget = Image.network(
          image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        );
      } else {
        try {
          final comma = image.indexOf(',');
          final raw = image.startsWith('data:') && comma != -1
              ? image.substring(comma + 1)
              : image;
          imageWidget = Image.memory(
            base64Decode(raw),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback,
          );
        } on FormatException {
          imageWidget = fallback;
        }
      }
    }
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
        child: imageWidget,
      ),
    );
  }
}
