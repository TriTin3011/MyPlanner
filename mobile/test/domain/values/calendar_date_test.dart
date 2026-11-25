import 'package:flutter_test/flutter_test.dart';
import 'package:myplanner/domain/values/calendar_date.dart';
import 'package:myplanner/domain/values/week_key.dart';

void main() {
  group('CalendarDate', () {
    test('đọc và ghi đúng dạng YYYY-MM-DD', () {
      final d = CalendarDate.parse('2026-11-24');
      expect(d.year, 2026);
      expect(d.month, 11);
      expect(d.day, 24);
      expect(d.toIso(), '2026-11-24');
    });

    test('từ chối ngày không tồn tại và chuỗi sai', () {
      expect(() => CalendarDate.parse('2026-02-30'), throwsFormatException);
      expect(() => CalendarDate.parse('2026-11-24T00:00:00'), throwsFormatException);
      expect(CalendarDate.tryParse('abc'), isNull);
    });

    test('hôm nay lấy theo giờ địa phương, không đổi sang UTC', () {
      // 23:30 ngày 24 giờ địa phương vẫn là ngày 24, dù ở UTC+7 thì UTC đã là 16:30.
      final late = DateTime(2026, 11, 24, 23, 30);
      expect(CalendarDate.today(late).toIso(), '2026-11-24');
      final early = DateTime(2026, 11, 24, 0, 15);
      expect(CalendarDate.today(early).toIso(), '2026-11-24');
    });

    test('thời điểm UTC được quy về ngày địa phương', () {
      final utc = DateTime.utc(2026, 11, 24, 20);
      final local = utc.toLocal();
      expect(CalendarDate.fromLocal(utc), CalendarDate(local.year, local.month, local.day));
    });

    test('cộng ngày qua cuối tháng, cuối năm và năm nhuận', () {
      expect(CalendarDate(2026, 12, 31).addDays(1).toIso(), '2027-01-01');
      expect(CalendarDate(2028, 2, 28).addDays(1).toIso(), '2028-02-29');
      expect(CalendarDate(2026, 3, 1).addDays(-1).toIso(), '2026-02-28');
    });

    test('cộng tháng kẹp về cuối tháng', () {
      expect(CalendarDate(2026, 1, 31).addMonths(1).toIso(), '2026-02-28');
      expect(CalendarDate(2026, 12, 15).addMonths(1).toIso(), '2027-01-15');
      expect(CalendarDate(2026, 1, 15).addMonths(-1).toIso(), '2025-12-15');
    });

    test('Thứ 2 của tuần', () {
      expect(CalendarDate(2026, 11, 24).monday.toIso(), '2026-11-23');
      expect(CalendarDate(2026, 11, 29).monday.toIso(), '2026-11-23'); // Chủ nhật
      expect(CalendarDate(2026, 11, 23).monday.toIso(), '2026-11-23');
    });

    test('so sánh và bằng nhau theo giá trị', () {
      expect(CalendarDate(2026, 1, 1), CalendarDate.parse('2026-01-01'));
      expect(CalendarDate(2026, 1, 1).isBefore(CalendarDate(2026, 1, 2)), isTrue);
      expect(CalendarDate(2026, 1, 1).daysUntil(CalendarDate(2026, 2, 1)), 31);
    });
  });

  group('WeekKey', () {
    test('tuần ISO thông thường', () {
      expect(WeekKey.of(CalendarDate(2026, 11, 24)).toString(), '2026-W48');
      expect(WeekKey.parse('2026-W48').monday.toIso(), '2026-11-23');
    });

    test('ngày cuối năm thuộc tuần 1 năm sau và ngược lại', () {
      expect(WeekKey.of(CalendarDate(2025, 12, 29)).toString(), '2026-W01');
      expect(WeekKey.of(CalendarDate(2027, 1, 1)).toString(), '2026-W53');
      expect(WeekKey.of(CalendarDate(2021, 1, 3)).toString(), '2020-W53');
    });

    test('số tuần trong năm và kiểm tra hợp lệ', () {
      expect(WeekKey.weeksInYear(2026), 53);
      expect(WeekKey.weeksInYear(2025), 52);
      expect(() => WeekKey.parse('2025-W53'), throwsFormatException);
    });

    test('tuần trước, tuần sau và 7 ngày', () {
      final w = WeekKey.parse('2026-W01');
      expect(w.previous().toString(), '2025-W52');
      expect(w.next().toString(), '2026-W02');
      expect(w.days.first.toIso(), '2025-12-29');
      expect(w.days.last.toIso(), '2026-01-04');
    });
  });
}
