/// Một ngày trên lịch, không có giờ và không có múi giờ (tương đương `DateOnly` của .NET).
///
/// Vì sao không dùng `DateTime`: `DateTime(2026, 11, 24)` là nửa đêm giờ địa phương,
/// đổi sang UTC có thể lùi về ngày 23. Mọi phép cộng ngày ở đây làm trên UTC
/// nên không bị lệch bởi giờ mùa hè.
class CalendarDate implements Comparable<CalendarDate> {
  CalendarDate(int year, int month, int day) : _utc = DateTime.utc(year, month, day);

  CalendarDate._(this._utc);

  /// Ngày hôm nay theo đồng hồ máy (giờ địa phương), đúng quy tắc "client gửi hôm nay".
  factory CalendarDate.today([DateTime? now]) {
    final n = now ?? DateTime.now();
    return CalendarDate(n.year, n.month, n.day);
  }

  /// Lấy phần ngày theo giờ địa phương của một thời điểm.
  factory CalendarDate.fromLocal(DateTime t) {
    final l = t.toLocal();
    return CalendarDate(l.year, l.month, l.day);
  }

  /// Đọc chuỗi `YYYY-MM-DD` (dạng API trả về). Ném [FormatException] nếu sai.
  factory CalendarDate.parse(String s) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s.trim());
    if (m == null) throw FormatException('Ngày không hợp lệ', s);
    final y = int.parse(m[1]!), mo = int.parse(m[2]!), d = int.parse(m[3]!);
    final date = CalendarDate(y, mo, d);
    if (date.month != mo || date.day != d) throw FormatException('Ngày không tồn tại', s);
    return date;
  }

  static CalendarDate? tryParse(String? s) {
    if (s == null) return null;
    try {
      return CalendarDate.parse(s);
    } on FormatException {
      return null;
    }
  }

  final DateTime _utc;

  int get year => _utc.year;
  int get month => _utc.month;
  int get day => _utc.day;

  /// 1 = Thứ 2 … 7 = Chủ nhật (ISO 8601, giống `DateTime.weekday`).
  int get weekday => _utc.weekday;

  CalendarDate addDays(int days) => CalendarDate._(_utc.add(Duration(days: days)));

  /// Cộng tháng, kẹp ngày về cuối tháng nếu tháng đích ngắn hơn (31/1 + 1 tháng = 28/2).
  CalendarDate addMonths(int months) {
    final total = year * 12 + (month - 1) + months;
    final y = total ~/ 12, m = total % 12 + 1;
    final last = DateTime.utc(y, m + 1, 0).day;
    return CalendarDate(y, m, day > last ? last : day);
  }

  /// Thứ 2 của tuần chứa ngày này (tuần bắt đầu Thứ 2).
  CalendarDate get monday => addDays(1 - weekday);

  CalendarDate get firstOfMonth => CalendarDate(year, month, 1);

  int get daysInMonth => DateTime.utc(year, month + 1, 0).day;

  int daysUntil(CalendarDate other) => other._utc.difference(_utc).inDays;

  bool isBefore(CalendarDate other) => _utc.isBefore(other._utc);
  bool isAfter(CalendarDate other) => _utc.isAfter(other._utc);

  /// Dạng API: `2026-11-24`.
  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// Dùng cho widget cần `DateTime` (ví dụ `showDatePicker`): nửa đêm giờ địa phương.
  DateTime toLocalDateTime() => DateTime(year, month, day);

  @override
  int compareTo(CalendarDate other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) => other is CalendarDate && other._utc == _utc;

  @override
  int get hashCode => _utc.hashCode;

  @override
  String toString() => toIso();
}
