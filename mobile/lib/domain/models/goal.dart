import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';

part 'goal.freezed.dart';

enum LifeArea { health, finance, career, growth, relationship, learning, family, hobby }

enum GoalStatus { notStarted, inProgress, done }

@freezed
abstract class AreaSummary with _$AreaSummary {
  const factory AreaSummary({
    required LifeArea area,
    required int count,
    required int percent,
  }) = _AreaSummary;
}

/// Thẻ mục tiêu trên bảng: mọi phần trăm và cờ "chậm kế hoạch" do backend tính.
@freezed
abstract class GoalCard with _$GoalCard {
  const factory GoalCard({
    required String id,
    required String title,
    required LifeArea area,
    required GoalStatus status,
    required CalendarDate startDate,
    required CalendarDate deadline,
    String? reward,
    required int daysLeft,
    required int stepsDone,
    required int stepsTotal,
    required int overdueSteps,
    required int stepPercent,
    required int timePercent,
    required bool behind,
  }) = _GoalCard;
}

@freezed
abstract class GoalBoard with _$GoalBoard {
  const factory GoalBoard({
    required int done,
    required int total,
    required int percent,
    required List<AreaSummary> areas,
    required List<GoalCard> goals,
  }) = _GoalBoard;
}

@freezed
abstract class GoalStep with _$GoalStep {
  const factory GoalStep({
    required String id,
    required String title,
    CalendarDate? deadline,
    required bool done,
    required int order,
  }) = _GoalStep;
}

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String title,
    required LifeArea area,
    required GoalStatus status,
    required CalendarDate startDate,
    required CalendarDate deadline,
    String? reward,
    String? why,
    required List<GoalStep> steps,
  }) = _Goal;
}

@freezed
abstract class GoalDraft with _$GoalDraft {
  const factory GoalDraft({
    required String title,
    required LifeArea area,
    required GoalStatus status,
    required CalendarDate startDate,
    required CalendarDate deadline,
    String? reward,
    String? why,
  }) = _GoalDraft;

  factory GoalDraft.fromGoal(Goal g) => GoalDraft(
        title: g.title,
        area: g.area,
        status: g.status,
        startDate: g.startDate,
        deadline: g.deadline,
        reward: g.reward,
        why: g.why,
      );
}
