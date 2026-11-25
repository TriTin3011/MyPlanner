import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';

part 'habit_item.freezed.dart';

/// Thói quen như một tài nguyên CRUD (khác `HabitRow` là dòng thống kê tháng).
@freezed
abstract class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String title,
    required int order,
    required bool active,
    required CalendarDate startDate,
  }) = _Habit;
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userName,
    String? displayName,
    String? avatarUrl,
  }) = _UserProfile;
}
