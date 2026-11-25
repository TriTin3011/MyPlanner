import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'palette.dart';

/// Viền "vẽ tay": khung bo góc mà mỗi cạnh hơi cong lệch, cộng bóng cứng lệch
/// (2px, 3px). Tương đương `.sketch` + `SketchBorders` bên web, nhưng vẽ bằng
/// `CustomPainter` vì Flutter không có `border-image`.
///
/// Độ lệch lấy từ `seed` cố định (thường là hash của key), nên cùng một thẻ luôn
/// được vẽ giống nhau giữa các lần build: không "rung" khi rebuild.
class SketchPainter extends CustomPainter {
  SketchPainter({
    required this.ink,
    required this.fill,
    required this.shadow,
    this.radius = 14,
    this.strokeWidth = 2,
    this.seed = 7,
    this.shadowOffset = const Offset(2, 3),
  });

  final Color ink, fill, shadow;
  final double radius, strokeWidth;
  final int seed;
  final Offset shadowOffset;

  Path _wobbly(Size size, math.Random r) {
    double j() => (r.nextDouble() - .5) * 1.6;
    final w = size.width, h = size.height, rad = math.min(radius, math.min(w, h) / 2);
    final p = Path()..moveTo(rad + j(), j());
    // cạnh trên, góc phải trên
    p.quadraticBezierTo(w / 2 + j() * 2, j() * 1.2, w - rad + j(), j());
    p.quadraticBezierTo(w + j(), j(), w + j(), rad + j());
    // cạnh phải, góc phải dưới
    p.quadraticBezierTo(w + j() * 1.2, h / 2 + j() * 2, w + j(), h - rad + j());
    p.quadraticBezierTo(w + j(), h + j(), w - rad + j(), h + j());
    // cạnh dưới, góc trái dưới
    p.quadraticBezierTo(w / 2 + j() * 2, h + j() * 1.2, rad + j(), h + j());
    p.quadraticBezierTo(j(), h + j(), j(), h - rad + j());
    // cạnh trái, góc trái trên
    p.quadraticBezierTo(j() * 1.2, h / 2 + j() * 2, j(), rad + j());
    p.quadraticBezierTo(j(), j(), rad + j(), j());
    return p..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _wobbly(size, math.Random(seed));
    if (shadowOffset != Offset.zero) {
      canvas.drawPath(path.shift(shadowOffset), Paint()..color = shadow);
    }
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(SketchPainter old) =>
      old.ink != ink || old.fill != fill || old.shadow != shadow || old.seed != seed || old.radius != radius;
}

/// Thẻ vẽ tay dùng khắp app (≈ class `.sketch` bên web). Padding mặc định 14
/// (`p-3.5` của web trên điện thoại).
class SketchBox extends StatelessWidget {
  const SketchBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.fill,
    this.seed,
    this.radius = 14,
    this.shadow = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? fill;
  final int? seed;
  final double radius;
  final bool shadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final box = CustomPaint(
      painter: SketchPainter(
        ink: p.sketchInk,
        fill: fill ?? p.surface,
        shadow: p.sketchInk.withValues(alpha: p.brightness == Brightness.dark ? .55 : .9),
        radius: radius,
        seed: seed ?? (key?.hashCode ?? 7),
        shadowOffset: shadow ? const Offset(2, 3) : Offset.zero,
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return box;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(borderRadius: BorderRadius.circular(radius), onTap: onTap, child: box),
    );
  }
}

/// Nền giấy kẻ ô 22px (≈ `.paper`).
class PaperBackground extends StatelessWidget {
  const PaperBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return CustomPaint(painter: _GridPainter(p.paper, p.grid), child: child);
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.bg, this.grid);
  final Color bg, grid;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);
    final line = Paint()
      ..color = grid
      ..strokeWidth = 1;
    const step = 22.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.bg != bg || old.grid != grid;
}
