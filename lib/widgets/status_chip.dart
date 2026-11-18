import 'package:flutter/material.dart';

/// Small coloured pill for a booking status.
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final String status;

  static (Color, Color) colorsFor(String status) => switch (status) {
        'Confirmed' => (const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
        'Completed' => (const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
        'Cancelled' => (const Color(0xFFFFEBEE), const Color(0xFFC62828)),
        _ => (const Color(0xFFFFF3E0), const Color(0xFFE65100)),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = colorsFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
