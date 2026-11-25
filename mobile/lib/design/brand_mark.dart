import 'package:flutter/material.dart';

import 'palette.dart';

/// Logo Mầm: vòng tiến độ có lá + ba chấm (`docs/brand/logo-vong.svg`), vẽ lại
/// bằng `Canvas` theo viewBox 64 để màu đi theo theme như `BrandMark.tsx`.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return CustomPaint(
      size: Size.square(size),
      painter: _BrandPainter(primary: p.primary, ink: p.primaryInk, tint: p.accentTint),
    );
  }
}

class _BrandPainter extends CustomPainter {
  _BrandPainter({required this.primary, required this.ink, required this.tint});
  final Color primary, ink, tint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 64);
    canvas.drawCircle(const Offset(32, 34), 22, Paint()..color = tint);

    // Cung M32 12 A22 22 0 1 1 12.5 24: từ đỉnh vòng (32,12) chạy theo chiều kim
    // đồng hồ tới (12.5,24) ở bên trái — gần trọn vòng, chừa khe trên trái.
    final arc = Path()
      ..moveTo(32, 12)
      ..arcToPoint(const Offset(12.5, 24), radius: const Radius.circular(22), largeArc: true);
    canvas.drawPath(
      arc,
      Paint()
        ..color = primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final leaf = Path()
      ..moveTo(32, 12)
      ..cubicTo(31, 7, 35, 3, 41, 3)
      ..cubicTo(41, 8, 37, 12, 32, 12)
      ..close();
    canvas.drawPath(leaf, Paint()..color = primary);
    canvas.drawPath(
      leaf,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(const Offset(23, 36), 3.2, Paint()..color = ink);
    canvas.drawCircle(const Offset(32, 36), 3.2, Paint()..color = ink);
    canvas.drawCircle(const Offset(41, 36), 3.2, Paint()..color = primary);
  }

  @override
  bool shouldRepaint(_BrandPainter old) => old.primary != primary || old.ink != ink || old.tint != tint;
}
