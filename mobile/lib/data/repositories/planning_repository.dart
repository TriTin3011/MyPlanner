import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_api/planner_api.dart' as api;

import '../../domain/models/goal.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_item.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/year.dart';
import '../../domain/values/calendar_date.dart';
import '../api/planner_api_provider.dart';
import '../mappers/mappers.dart';

/// Thói quen + nhật ký tick.
class HabitRepository {
  HabitRepository(this._api);
  final api.PlannerApi _api;

  Future<HabitMonth> month(String month, CalendarDate today) async =>
      (await _api.getDashboardApi().apiDashboardHabitsGet(month: month, today: today.toIso()).body()).toModel();

  Future<List<Habit>> all() async =>
      (await _api.getHabitsApi().apiHabitsGet(includeInactive: false).body()).map((h) => h.toModel()).toList();

  Future<void> create(String title, CalendarDate startDate) => _api.getHabitsApi().apiHabitsPost(
      saveHabitRequest: api.SaveHabitRequest(title: title.trim(), active: true, startDate: startDate.toIso()));

  Future<void> rename(String id, String title) => _api
      .getHabitsApi()
      .apiHabitsIdPut(id: id, saveHabitRequest: api.SaveHabitRequest(title: title.trim()));

  Future<void> delete(String id) => _api.getHabitsApi().apiHabitsIdDelete(id: id);

  Future<void> reorder(List<String> ids) =>
      _api.getHabitsApi().apiHabitsReorderPut(reorderRequest: api.ReorderRequest(ids: ids));

  Future<void> setDone(String habitId, CalendarDate date, bool done) => done
      ? _api.getHabitLogsApi().apiHabitLogsHabitIdDatePut(habitId: habitId, date: date.toIso())
      : _api.getHabitLogsApi().apiHabitLogsHabitIdDateDelete(habitId: habitId, date: date.toIso());
}

/// Mục tiêu + các bước.
class GoalRepository {
  GoalRepository(this._api);
  final api.PlannerApi _api;
  api.GoalsApi get _g => _api.getGoalsApi();

  Future<GoalBoard> board(CalendarDate today) async =>
      (await _g.apiDashboardGoalsGet(today: today.toIso()).body()).toModel();

  Future<Goal> get(String id) async => (await _g.apiGoalsIdGet(id: id).body()).toModel();

  Future<Goal> create(GoalDraft d) async => (await _g.apiGoalsPost(saveGoalRequest: goalDraftToDto(d)).body()).toModel();

  Future<Goal> update(String id, GoalDraft d) async =>
      (await _g.apiGoalsIdPut(id: id, saveGoalRequest: goalDraftToDto(d)).body()).toModel();

  Future<void> delete(String id) => _g.apiGoalsIdDelete(id: id);

  api.SaveGoalStepRequest _step(String title, CalendarDate? deadline, bool done) =>
      api.SaveGoalStepRequest(title: title.trim(), deadline: deadline?.toIso(), done: done);

  Future<Goal> addStep(String goalId, String title, CalendarDate? deadline) async =>
      (await _g.apiGoalsIdStepsPost(id: goalId, saveGoalStepRequest: _step(title, deadline, false)).body()).toModel();

  Future<Goal> updateStep(String goalId, GoalStep s) async => (await _g
          .apiGoalsIdStepsStepIdPut(id: goalId, stepId: s.id, saveGoalStepRequest: _step(s.title, s.deadline, s.done))
          .body())
      .toModel();

  Future<Goal> deleteStep(String goalId, String stepId) async =>
      (await _g.apiGoalsIdStepsStepIdDelete(id: goalId, stepId: stepId).body()).toModel();

  Future<Goal> reorderSteps(String goalId, List<String> ids) async =>
      (await _g.apiGoalsIdStepsReorderPut(id: goalId, reorderRequest: api.ReorderRequest(ids: ids)).body()).toModel();
}

/// Kế hoạch năm.
class YearRepository {
  YearRepository(this._api);
  final api.PlannerApi _api;
  api.YearsApi get _y => _api.getYearsApi();

  Future<YearDashboard> dashboard(int year, CalendarDate today) async =>
      (await _y.apiDashboardYearGet(year: year, today: today.toIso()).body()).toModel();

  Future<void> saveMeta(int year, String keyword, String vision) => _y.apiYearsYearPut(
      year: year, saveYearMetaRequest: api.SaveYearMetaRequest(keyword: keyword, vision: vision));

  Future<void> addItem(int year, int month, String title) => _y.apiYearsYearItemsPost(
      year: year, createYearItemRequest: api.CreateYearItemRequest(month: month, title: title.trim()));

  Future<void> updateItem(YearPlanItem i) => _y.apiYearItemsIdPut(
      id: i.id, updateYearItemRequest: api.UpdateYearItemRequest(month: i.month, title: i.title, done: i.done));

  Future<void> deleteItem(String id) => _y.apiYearItemsIdDelete(id: id);

  Future<void> reorder(int year, int month, List<String> ids) => _y.apiYearsYearItemsReorderPut(
      year: year, reorderYearItemsRequest: api.ReorderYearItemsRequest(month: month, ids: ids));
}

class StatsRepository {
  StatsRepository(this._api);
  final api.PlannerApi _api;

  Future<Stats> load(StatsRange range, CalendarDate today) async =>
      (await _api.getStatsApi().apiStatsGet(range: range.code, today: today.toIso()).body()).toModel();
}

final habitRepositoryProvider = Provider((ref) => HabitRepository(ref.watch(plannerApiProvider)));
final goalRepositoryProvider = Provider((ref) => GoalRepository(ref.watch(plannerApiProvider)));
final yearRepositoryProvider = Provider((ref) => YearRepository(ref.watch(plannerApiProvider)));
final statsRepositoryProvider = Provider((ref) => StatsRepository(ref.watch(plannerApiProvider)));
