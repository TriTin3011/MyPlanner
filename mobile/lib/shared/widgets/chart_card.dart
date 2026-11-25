import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/app_settings.dart';
import '../../design/palette.dart';
import '../../l10n/app_localizations.dart';
import 'section.dart';

/// Một điểm của biểu đồ: nhãn trục X, giá trị chính (%) và chú thích cho Bảng.
class ChartPoint {
  const ChartPoint({required this.label, required this.value, this.detail, this.highlight = false});
  final String label;
  final double value;
  final String? detail;
  final bool highlight;
}

/// Thẻ biểu đồ Đường / Cột / Bảng (≈ `ChartCard.tsx`). Lựa chọn của người dùng
/// lưu theo `settingsKey` trong `SharedPreferences`, như toggle bên web.
class ChartCard extends ConsumerWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.settingsKey,
    required this.points,
    this.maxY = 100,
    this.unit = '%',
    this.header,
    this.height = 190,
  });

  final String title, settingsKey, unit;
  final List<ChartPoint> points;
  final double maxY, height;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kind = ref.watch(settingsProvider.select((s) => s.chart(settingsKey)));
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      title: title,
      trailing: SegmentedButton<ChartKind>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: const TextStyle(fontSize: 12),
        ),
        segments: [
          ButtonSegment(value: ChartKind.line, icon: const Icon(Icons.show_chart, size: 18), tooltip: l10n.chartLine),
          ButtonSegment(value: ChartKind.bar, icon: const Icon(Icons.bar_chart, size: 18), tooltip: l10n.chartBar),
          ButtonSegment(value: ChartKind.table, icon: const Icon(Icons.table_rows_outlined, size: 18), tooltip: l10n.chartTable),
        ],
        selected: {kind},
        onSelectionChanged: (s) => ref.read(settingsProvider.notifier).setChart(settingsKey, s.first),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Chừa khoảng để chữ đầu khung không đè lên nhãn "100" của trục.
          if (header != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: header),
          if (points.isEmpty)
            SizedBox(height: 80, child: Center(child: Text('—', style: TextStyle(color: context.palette.muted))))
          else
            switch (kind) {
              ChartKind.table => _Table(points: points, unit: unit),
              _ => SizedBox(height: height, child: _Chart(points: points, bar: kind == ChartKind.bar, maxY: maxY, unit: unit)),
            },
        ],
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.points, required this.bar, required this.maxY, required this.unit});
  final List<ChartPoint> points;
  final bool bar;
  final double maxY;
  final String unit;

  /// Nhiều điểm (12 tuần, 31 ngày) thì chỉ ghi nhãn cách quãng cho đỡ chồng chữ.
  int get _labelEvery => points.length <= 8 ? 1 : (points.length / 6).ceil();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final axisStyle = TextStyle(color: p.muted, fontSize: 10);
    final titles = FlTitlesData(
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: maxY / 2,
          getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: axisStyle),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTitlesWidget: (v, meta) {
            final i = v.toInt();
            if (i < 0 || i >= points.length || i % _labelEvery != 0 || v != i.toDouble()) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(points[i].label, style: axisStyle.copyWith(
                fontWeight: points[i].highlight ? FontWeight.w800 : null,
                color: points[i].highlight ? p.primaryText : p.muted,
              )),
            );
          },
        ),
      ),
    );
    final grid = FlGridData(
      drawVerticalLine: false,
      horizontalInterval: maxY / 4,
      getDrawingHorizontalLine: (_) => FlLine(color: p.line, strokeWidth: 1, dashArray: [4, 4]),
    );

    if (bar) {
      return BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          gridData: grid,
          titlesData: titles,
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => p.ink,
              getTooltipItem: (g, _, rod, _) => BarTooltipItem(
                '${points[g.x].label}\n${rod.toY.round()}$unit',
                TextStyle(color: p.surface, fontSize: 12),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: points[i].value,
                  width: points.length > 14 ? 6 : 14,
                  color: points[i].highlight ? p.primary : p.primary.withValues(alpha: .7),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxY, color: p.accentTint),
                ),
              ]),
          ],
        ),
      );
    }

    return LineChart(
      LineChartData(
        maxY: maxY,
        minY: 0,
        minX: 0,
        maxX: (points.length - 1).toDouble().clamp(1, double.infinity),        gridData: grid,
        titlesData: titles,
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => p.ink,
            getTooltipItems: (spots) => [
              for (final s in spots)
                LineTooltipItem('${points[s.x.toInt()].label}\n${s.y.round()}$unit', TextStyle(color: p.surface, fontSize: 12)),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].value)],
            // Đường cong Bézier vẫn vọt quá điểm khi số liệu nhảy 0 ↔ 100 (dù bật
            // preventCurveOverShooting), làm vùng tô thủng dưới trục. Giữ đường gấp khúc.
            isCurved: false,
            color: p.primary,
            barWidth: 3,
            dotData: FlDotData(show: points.length <= 14),
            belowBarData: BarAreaData(show: true, color: p.primary.withValues(alpha: .12)),
          ),
        ],
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.points, required this.unit});
  final List<ChartPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      children: [
        for (final pt in points)
          Container(
            constraints: const BoxConstraints(minHeight: 36),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.line))),
            child: Row(
              children: [
                Expanded(
                  child: Text(pt.label,
                      style: TextStyle(fontWeight: pt.highlight ? FontWeight.w800 : FontWeight.w500)),
                ),
                if (pt.detail != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(pt.detail!, style: TextStyle(color: p.muted, fontSize: 12)),
                  ),
                Text('${pt.value.round()}$unit', style: TextStyle(fontWeight: FontWeight.w700, color: p.primaryInk)),
              ],
            ),
          ),
      ],
    );
  }
}
