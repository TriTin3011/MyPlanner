import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for DashboardApi
void main() {
  final instance = PlannerApi().getDashboardApi();

  group(DashboardApi, () {
    //Future<List<DayProgressDto>> apiDashboardDaysGet({ String from, String to }) async
    test('test apiDashboardDaysGet', () async {
      // TODO
    });

    //Future<HabitMonthDto> apiDashboardHabitsGet({ String month, String today }) async
    test('test apiDashboardHabitsGet', () async {
      // TODO
    });

    //Future<TodayDashboardDto> apiDashboardTodayGet({ String date }) async
    test('test apiDashboardTodayGet', () async {
      // TODO
    });

    //Future<WeekDashboardDto> apiDashboardWeekGet({ String weekKey, String today }) async
    test('test apiDashboardWeekGet', () async {
      // TODO
    });

    //Future<List<WeekProgressDto>> apiDashboardWeeksGet({ String to, int count }) async
    test('test apiDashboardWeeksGet', () async {
      // TODO
    });

  });
}
