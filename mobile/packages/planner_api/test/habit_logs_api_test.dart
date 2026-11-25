import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for HabitLogsApi
void main() {
  final instance = PlannerApi().getHabitLogsApi();

  group(HabitLogsApi, () {
    //Future<List<HabitLogDto>> apiHabitLogsGet({ String from, String to }) async
    test('test apiHabitLogsGet', () async {
      // TODO
    });

    //Future apiHabitLogsHabitIdDateDelete(String habitId, String date) async
    test('test apiHabitLogsHabitIdDateDelete', () async {
      // TODO
    });

    //Future apiHabitLogsHabitIdDatePut(String habitId, String date) async
    test('test apiHabitLogsHabitIdDatePut', () async {
      // TODO
    });

  });
}
