// DTO (sinh từ OpenAPI) → model domain. Chỉ file trong data/ được thấy DTO.
//
// Enum: client sinh ra có giá trị `unknownDefaultOpenApi` khi backend gửi giá
// trị mới mà bản app này chưa biết. Mapper quy về giá trị an toàn hoặc bỏ qua,
// để app cũ không vỡ cả màn hình khi backend nâng cấp (SPEC §2.5).
import 'package:planner_api/planner_api.dart' as api;

import '../../domain/models/goal.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_item.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/task.dart';
import '../../domain/models/today.dart';
import '../../domain/models/week.dart';
import '../../domain/models/year.dart';
import '../../domain/values/calendar_date.dart';
import '../../domain/values/week_key.dart';

CalendarDate _d(String s) => CalendarDate.parse(s);
CalendarDate? _dn(String? s) => s == null ? null : CalendarDate.tryParse(s);

// ---- enum ----------------------------------------------------------------

TaskTag? taskTagFromDto(api.TaskTag t) => switch (t) {
      api.TaskTag.urgent => TaskTag.urgent,
      api.TaskTag.important => TaskTag.important,
      api.TaskTag.unknownDefaultOpenApi => null,
    };

api.TaskTag taskTagToDto(TaskTag t) => switch (t) {
      TaskTag.urgent => api.TaskTag.urgent,
      TaskTag.important => api.TaskTag.important,
    };

List<TaskTag> _tags(List<api.TaskTag> tags) => tags.map(taskTagFromDto).nonNulls.toList();

/// Lĩnh vực lạ → "Phát triển bản thân", nhóm chung nhất.
LifeArea lifeAreaFromDto(api.LifeArea a) => switch (a) {
      api.LifeArea.health => LifeArea.health,
      api.LifeArea.finance => LifeArea.finance,
      api.LifeArea.career => LifeArea.career,
      api.LifeArea.growth => LifeArea.growth,
      api.LifeArea.relationship => LifeArea.relationship,
      api.LifeArea.learning => LifeArea.learning,
      api.LifeArea.family => LifeArea.family,
      api.LifeArea.hobby => LifeArea.hobby,
      api.LifeArea.unknownDefaultOpenApi => LifeArea.growth,
    };

api.LifeArea lifeAreaToDto(LifeArea a) => switch (a) {
      LifeArea.health => api.LifeArea.health,
      LifeArea.finance => api.LifeArea.finance,
      LifeArea.career => api.LifeArea.career,
      LifeArea.growth => api.LifeArea.growth,
      LifeArea.relationship => api.LifeArea.relationship,
      LifeArea.learning => api.LifeArea.learning,
      LifeArea.family => api.LifeArea.family,
      LifeArea.hobby => api.LifeArea.hobby,
    };

/// Trạng thái lạ → "Đang làm", không giả vờ là xong.
GoalStatus goalStatusFromDto(api.GoalStatus s) => switch (s) {
      api.GoalStatus.notStarted => GoalStatus.notStarted,
      api.GoalStatus.inProgress => GoalStatus.inProgress,
      api.GoalStatus.done => GoalStatus.done,
      api.GoalStatus.unknownDefaultOpenApi => GoalStatus.inProgress,
    };

api.GoalStatus goalStatusToDto(GoalStatus s) => switch (s) {
      GoalStatus.notStarted => api.GoalStatus.notStarted,
      GoalStatus.inProgress => api.GoalStatus.inProgress,
      GoalStatus.done => api.GoalStatus.done,
    };

DeadlineKind deadlineKindFromDto(api.DeadlineKind k) =>
    k == api.DeadlineKind.goal ? DeadlineKind.goal : DeadlineKind.step;

StatsRange statsRangeFromCode(String code) =>
    StatsRange.values.where((r) => r.code == code).firstOrNull ?? StatsRange.w12;

// ---- task ----------------------------------------------------------------

extension TaskDtoX on api.TaskDto {
  Task toModel() => Task(
        id: id,
        title: title,
        date: _d(date),
        originalDate: _dn(originalDate),
        done: done,
        tags: _tags(tags),
        subtasks: subtasks.map((s) => Subtask(id: s.id, title: s.title, done: s.done)).toList(),
        recurringId: recurringId,
        order: order,
      );
}

api.SaveTaskRequest taskDraftToDto(TaskDraft d) => api.SaveTaskRequest(
      title: d.title.trim(),
      date: d.date.toIso(),
      tags: d.tags.map(taskTagToDto).toList(),
      subtasks: d.subtasks
          .where((s) => s.title.trim().isNotEmpty)
          .map((s) => api.SubtaskInput(id: s.id, title: s.title.trim(), done: s.done))
          .toList(),
    );

extension DayProgressDtoX on api.DayProgressDto {
  DayProgress toModel() => DayProgress(
        date: _d(date),
        tasksDone: tasksDone,
        tasksTotal: tasksTotal,
        percent: percent,
        hasDeadline: hasDeadline,
      );
}

extension RecurringDtoX on api.RecurringTaskDto {
  RecurringTask toModel() => RecurringTask(
        id: id,
        title: title,
        weekdays: weekdays.toList()..sort(),
        tags: _tags(tags),
        active: active,
        startDate: _d(startDate),
      );
}

// ---- today ---------------------------------------------------------------

extension TodayDashboardDtoX on api.TodayDashboardDto {
  TodayDashboard toModel() => TodayDashboard(
        date: _d(date),
        percent: percent,
        tasksDone: tasksDone,
        tasksTotal: tasksTotal,
        habitsDone: habitsDone,
        habitsTotal: habitsTotal,
        tasks: tasks.map((t) => t.toModel()).toList(),
        backlog: backlog.map((t) => t.toModel()).toList(),
        habits: habits.map((h) => TodayHabit(id: h.id, title: h.title, done: h.done)).toList(),
        note: note?.content ?? '',
      );
}

// ---- week ----------------------------------------------------------------

extension WeekDashboardDtoX on api.WeekDashboardDto {
  WeekDashboard toModel() => WeekDashboard(
        weekKey: WeekKey.parse(weekKey),
        from: _d(from),
        to: _d(to),
        tasksDone: tasksDone,
        tasksTotal: tasksTotal,
        habitPercent: habitPercent,
        todayRemaining: todayRemaining,
        comment: comment,
        days: days.map((d) => d.toModel()).toList(),
        insights: insights.toList(),
      );
}

extension WeekProgressDtoX on api.WeekProgressDto {
  WeekProgress toModel() => WeekProgress(
        weekKey: WeekKey.parse(weekKey),
        monday: _d(monday),
        tasksDone: tasksDone,
        tasksTotal: tasksTotal,
        percent: percent,
      );
}

extension DeadlineDtoX on api.DeadlineDto {
  Deadline toModel() => Deadline(
        date: _d(date),
        kind: deadlineKindFromDto(kind),
        goalId: goalId,
        goalTitle: goalTitle,
        title: title,
        done: done,
        overdue: overdue,
      );
}

// ---- habits --------------------------------------------------------------

extension HabitMonthDtoX on api.HabitMonthDto {
  HabitMonth toModel() => HabitMonth(
        month: month,
        from: _d(from),
        to: _d(to),
        percent: percent,
        longestStreak: longestStreak == null
            ? null
            : HabitHighlight(
                habitId: longestStreak!.habitId,
                title: longestStreak!.title,
                value: longestStreak!.value,
              ),
        mostConsistent: mostConsistent == null
            ? null
            : HabitHighlight(
                habitId: mostConsistent!.habitId,
                title: mostConsistent!.title,
                value: mostConsistent!.value,
              ),
        habits: habits
            .map((h) => HabitRow(
                  id: h.id,
                  title: h.title,
                  order: h.order,
                  startDate: _d(h.startDate),
                  percent: h.percent,
                  currentStreak: h.currentStreak,
                  longestStreak: h.longestStreak,
                  doneDates: h.doneDates.map(_d).toSet(),
                ))
            .toList(),
        days: days
            .map((d) => HabitDayCount(date: _d(d.date), done: d.done, total: d.total, percent: d.percent))
            .toList(),
      );
}

extension HabitDtoX on api.HabitDto {
  Habit toModel() => Habit(id: id, title: title, order: order, active: active, startDate: _d(startDate));
}

// ---- goals ---------------------------------------------------------------

extension GoalBoardDtoX on api.GoalBoardDto {
  GoalBoard toModel() => GoalBoard(
        done: done,
        total: total,
        percent: percent,
        areas: areas
            .map((a) => AreaSummary(area: lifeAreaFromDto(a.area), count: a.count, percent: a.percent))
            .toList(),
        goals: goals
            .map((g) => GoalCard(
                  id: g.id,
                  title: g.title,
                  area: lifeAreaFromDto(g.area),
                  status: goalStatusFromDto(g.status),
                  startDate: _d(g.startDate),
                  deadline: _d(g.deadline),
                  reward: g.reward,
                  daysLeft: g.daysLeft,
                  stepsDone: g.stepsDone,
                  stepsTotal: g.stepsTotal,
                  overdueSteps: g.overdueSteps,
                  stepPercent: g.stepPercent,
                  timePercent: g.timePercent,
                  behind: g.behind,
                ))
            .toList(),
      );
}

extension GoalDtoX on api.GoalDto {
  Goal toModel() => Goal(
        id: id,
        title: title,
        area: lifeAreaFromDto(area),
        status: goalStatusFromDto(status),
        startDate: _d(startDate),
        deadline: _d(deadline),
        reward: reward,
        why: why,
        steps: (steps.toList()..sort((a, b) => a.order.compareTo(b.order)))
            .map((s) => GoalStep(
                  id: s.id,
                  title: s.title,
                  deadline: _dn(s.deadline),
                  done: s.done,
                  order: s.order,
                ))
            .toList(),
      );
}

String? _blankToNull(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();

api.SaveGoalRequest goalDraftToDto(GoalDraft d) => api.SaveGoalRequest(
      title: d.title.trim(),
      area: lifeAreaToDto(d.area),
      status: goalStatusToDto(d.status),
      startDate: d.startDate.toIso(),
      deadline: d.deadline.toIso(),
      reward: _blankToNull(d.reward),
      why: _blankToNull(d.why),
    );

// ---- year ----------------------------------------------------------------

extension YearDashboardDtoX on api.YearDashboardDto {
  YearDashboard toModel() => YearDashboard(
        year: year,
        keyword: keyword,
        vision: vision,
        done: done,
        total: total,
        percent: percent,
        currentMonth: currentMonth,
        months: months
            .map((m) => YearMonth(
                  month: m.month,
                  done: m.done,
                  total: m.total,
                  percent: m.percent,
                  deadlines: m.deadlines.map((d) => d.toModel()).toList(),
                  items: m.items
                      .map((i) => YearPlanItem(
                            id: i.id,
                            month: i.month,
                            title: i.title,
                            done: i.done,
                            order: i.order,
                          ))
                      .toList(),
                ))
            .toList(),
      );
}

// ---- stats ---------------------------------------------------------------

StatsWeekPoint _weekPoint(api.StatsWeekPointDto p) => StatsWeekPoint(
      weekKey: WeekKey.parse(p.weekKey),
      monday: _d(p.monday),
      done: p.done,
      total: p.total,
      percent: p.percent,
    );

extension StatsDtoX on api.StatsDto {
  Stats toModel() => Stats(
        range: statsRangeFromCode(range),
        from: _d(from),
        to: _d(to),
        hero: StatsHero(
          completionPercent: hero.completionPercent,
          tasksDone: hero.tasksDone,
          tasksTotal: hero.tasksTotal,
          deltaPoints: hero.deltaPoints,
          bestWeekday: hero.bestWeekday,
          weeklySparkline: hero.weeklySparkline.map(_weekPoint).toList(),
        ),
        kpis: StatsKpis(
          tasksDone: kpis.tasksDone,
          tasksDonePercentChange: kpis.tasksDonePercentChange,
          activityCurrentStreak: kpis.activityCurrentStreak,
          activityLongestStreak: kpis.activityLongestStreak,
          habitPercent: kpis.habitPercent,
          habitDeltaPoints: kpis.habitDeltaPoints,
        ),
        trendAverage: trend.averagePercent,
        trend: trend.points.map(_weekPoint).toList(),
        heatmap: heatmap.map((h) => StatsHeatmapDay(date: _d(h.date), done: h.done, level: h.level)).toList(),
        weekdays: weekdayProductivity
            .map((w) => StatsWeekday(weekday: w.weekday, averageDone: w.averageDone))
            .toList(),
        habits: habitConsistency
            .map((h) => StatsHabit(
                  habitId: h.habitId,
                  title: h.title,
                  percent: h.percent,
                  doneDays: h.doneDays,
                  possibleDays: h.possibleDays,
                  currentStreak: h.currentStreak,
                  longestStreak: h.longestStreak,
                ))
            .toList(),
        goals: StatsGoals(
          total: goals.total,
          percentDone: goals.percentDone,
          notStarted: goals.byStatus.notStarted,
          inProgress: goals.byStatus.inProgress,
          done: goals.byStatus.done,
          byArea: goals.byArea
              .map((a) => StatsGoalArea(area: lifeAreaFromDto(a.area), done: a.done, total: a.total))
              .toList(),
        ),
      );
}

extension CurrentUserDtoX on api.CurrentUserDto {
  UserProfile toModel() => UserProfile(userName: userName, displayName: displayName, avatarUrl: avatarUrl);
}
