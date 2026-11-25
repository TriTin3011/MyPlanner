import 'calendar_date.dart';

/// Khoá tuần ISO 8601 dạng `2026-W47` (tuần bắt đầu Thứ 2, tuần 1 là tuần chứa Thứ 5 đầu năm).
/// Phải khớp cách backend tính, vì `weekKey` là khoá của ghi chú tuần và `dashboard/week`.
class WeekKey implements Comparable<WeekKey> {
  const WeekKey(this.isoYear, this.week);

  /// Tuần chứa [date]. Năm ISO lấy theo Thứ 5 của tuần đó, nên 29/12/2025 thuộc 2026-W01.
  factory WeekKey.of(CalendarDate date) {
    final thursday = date.addDays(4 - date.weekday);
    final jan1 = CalendarDate(thursday.year, 1, 1);
    final week = jan1.daysUntil(thursday) ~/ 7 + 1;
    return WeekKey(thursday.year, week);
  }

  factory WeekKey.parse(String s) {
    final m = RegExp(r'^(\d{4})-W(\d{2})$').firstMatch(s.trim());
    if (m == null) throw FormatException('Khoá tuần không hợp lệ', s);
    final key = WeekKey(int.parse(m[1]!), int.parse(m[2]!));
    if (key.week < 1 || key.week > weeksInYear(key.isoYear)) {
      throw FormatException('Tuần không tồn tại', s);
    }
    return key;
  }

  final int isoYear;
  final int week;

  /// Năm ISO có 53 tuần khi ngày 28/12 rơi vào tuần 53.
  static int weeksInYear(int isoYear) => WeekKey.of(CalendarDate(isoYear, 12, 28)).week;

  /// Thứ 2 của tuần: Thứ 2 của tuần chứa 4/1, cộng thêm (week - 1) tuần.
  CalendarDate get monday => CalendarDate(isoYear, 1, 4).monday.addDays((week - 1) * 7);

  CalendarDate get sunday => monday.addDays(6);

  List<CalendarDate> get days => List.generate(7, monday.addDays);

  WeekKey next() => WeekKey.of(monday.addDays(7));
  WeekKey previous() => WeekKey.of(monday.addDays(-7));

  @override
  int compareTo(WeekKey other) => monday.compareTo(other.monday);

  @override
  bool operator ==(Object other) =>
      other is WeekKey && other.isoYear == isoYear && other.week == week;

  @override
  int get hashCode => Object.hash(isoYear, week);

  @override
  String toString() => '$isoYear-W${week.toString().padLeft(2, '0')}';
}
