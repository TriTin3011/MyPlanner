import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../design/palette.dart';
import '../domain/models/goal.dart';
import '../domain/models/task.dart';
import '../domain/values/calendar_date.dart';
import '../l10n/app_localizations.dart';

/// Nhãn hiển thị cho enum domain. Domain không biết ngôn ngữ; tầng UI dịch.
extension LabelsX on AppLocalizations {
  String area(LifeArea a) => switch (a) {
        LifeArea.health => areaHealth,
        LifeArea.finance => areaFinance,
        LifeArea.career => areaCareer,
        LifeArea.growth => areaGrowth,
        LifeArea.relationship => areaRelationship,
        LifeArea.learning => areaLearning,
        LifeArea.family => areaFamily,
        LifeArea.hobby => areaHobby,
      };

  String status(GoalStatus s) => switch (s) {
        GoalStatus.notStarted => statusNotStarted,
        GoalStatus.inProgress => statusInProgress,
        GoalStatus.done => statusDone,
      };

  String tag(TaskTag t) => t == TaskTag.urgent ? tagUrgent : tagImportant;

  /// 1 = Thứ 2 … 7 = Chủ nhật (ISO), giống backend.
  String weekdayShort(int isoWeekday) => switch (isoWeekday) {
        1 => weekdayShort1,
        2 => weekdayShort2,
        3 => weekdayShort3,
        4 => weekdayShort4,
        5 => weekdayShort5,
        6 => weekdayShort6,
        _ => weekdayShort7,
      };
}

/// Định dạng ngày theo ngôn ngữ đang chọn (≈ `Intl.DateTimeFormat` bên web).
class DateText {
  DateText(this.locale);
  final String locale;

  String dayMonth(CalendarDate d) => DateFormat.Md(locale).format(d.toLocalDateTime());
  String full(CalendarDate d) => DateFormat.yMMMMEEEEd(locale).format(d.toLocalDateTime());
  String weekdayLong(CalendarDate d) => DateFormat.EEEE(locale).format(d.toLocalDateTime());
  String monthYear(CalendarDate d) => DateFormat.yMMMM(locale).format(d.toLocalDateTime());
  String monthShort(int month) => DateFormat.MMM(locale).format(DateTime(2000, month));
}

extension LocaleX on BuildContext {
  String get localeName => Localizations.localeOf(this).languageCode;
  DateText get dates => DateText(localeName);
}

/// Màu cho mỗi lĩnh vực (giống `lifeAreas.ts`, dùng chung cho chip, radar, thanh).
Color areaColor(LifeArea a) => switch (a) {
      LifeArea.health => const Color(0xFF16A34A),
      LifeArea.finance => const Color(0xFFCA8A04),
      LifeArea.career => const Color(0xFF2563EB),
      LifeArea.growth => const Color(0xFF9333EA),
      LifeArea.relationship => const Color(0xFFDB2777),
      LifeArea.learning => const Color(0xFF0891B2),
      LifeArea.family => const Color(0xFFEA580C),
      LifeArea.hobby => const Color(0xFF65A30D),
    };

extension TagColors on Palette {
  (Color, Color) tagColors(TaskTag t) => t == TaskTag.urgent ? (urgentBg, urgentFg) : (importantBg, importantFg);
}
