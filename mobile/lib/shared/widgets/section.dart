import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/sketch.dart';

/// Thẻ có tiêu đề (+ nút phụ bên phải): khối cơ bản của mọi màn.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child, this.trailing, this.seed});

  final String title;
  final Widget child;
  final Widget? trailing;
  final int? seed;

  @override
  Widget build(BuildContext context) {
    return SketchBox(
      seed: seed ?? title.hashCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
              ?trailing,
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Ô số liệu nhỏ (StatStrip bên web).
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.sub});
  final String label, value;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SketchBox(
      seed: label.hashCode,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: p.muted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: p.primaryInk)),
          if (sub != null)
            Text(sub!, style: TextStyle(color: p.muted, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

/// Hàng ô số liệu, chia đều chiều ngang.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.tiles});
  final List<StatTile> tiles;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: tiles[i]),
          ],
        ],
      ),
    );
  }
}

/// Nhãn nhỏ dạng viên thuốc (tag Gấp/Quan trọng, lĩnh vực…).
class Pill extends StatelessWidget {
  const Pill({super.key, required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
        child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
      );
}

/// Trang chuẩn: nền giấy, padding 12, kéo xuống để tải lại.
class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.children, required this.onRefresh, this.floating});

  final List<Widget> children;
  final Future<void> Function() onRefresh;
  final Widget? floating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: floating,
      body: PaperBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            color: context.palette.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
