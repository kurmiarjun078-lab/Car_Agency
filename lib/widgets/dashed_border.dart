import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dashed rounded-rectangle border (admin "Add Image" tiles).
class DashedRRectPainter extends CustomPainter {
  const DashedRRectPainter({
    this.color = const Color(0xFF8E8E93),
    this.radius = 22,
    this.dash = 5,
    this.gap = 4,
    this.strokeWidth = 1.4,
  });

  final Color color;
  final double radius;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + dash, metric.length)),
          paint,
        );
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}
