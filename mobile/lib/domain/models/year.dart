import 'package:freezed_annotation/freezed_annotation.dart';

import 'week.dart';

part 'year.freezed.dart';

@freezed
abstract class YearPlanItem with _$YearPlanItem {
  const factory YearPlanItem({
    required String id,
    required int month,
    required String title,
    required bool done,
    required int order,
  }) = _YearPlanItem;
}

@freezed
abstract class YearMonth with _$YearMonth {
  const factory YearMonth({
    required int month,
    required int done,
    required int total,
    required int percent,
    required List<Deadline> deadlines,
    required List<YearPlanItem> items,
  }) = _YearMonth;
}

@freezed
abstract class YearDashboard with _$YearDashboard {
  const factory YearDashboard({
    required int year,
    required String keyword,
    required String vision,
    required int done,
    required int total,
    required int percent,
    int? currentMonth,
    required List<YearMonth> months,
  }) = _YearDashboard;
}
