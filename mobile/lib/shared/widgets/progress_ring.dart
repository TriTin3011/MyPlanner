import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/palette.dart';

/// Vòng % (số do backend tính, widget chỉ vẽ).
class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.percent, this.size = 72, this.stroke = 8, this.label});

  final int percent;
  final double size, stroke;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      label: '$percent%',
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: percent.clamp(0, 100) / 100),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => CustomPaint(
            painter: _RingPainter(v, p.accentTint, p.primary, stroke),
            child: Center(
              child: Text(
                label ?? '$percent%',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: size * .24, color: p.primaryInk),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.track, this.fill, this.stroke);
  final double value, stroke;
  final Color track, fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, 0, math.pi * 2, false, base..color = track);
    if (value > 0) canvas.drawArc(r, -math.pi / 2, math.pi * 2 * value, false, base..color = fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value || old.fill != fill || old.track != track;
}

/// Thanh % nằm ngang mảnh.
class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.percent, this.color, this.height = 8});
  final int percent;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: percent.clamp(0, 100) / 100,
        minHeight: height,
        backgroundColor: p.accentTint,
        color: color ?? p.primary,
      ),
    );
  }
}
