import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for HabitsApi
void main() {
  final instance = PlannerApi().getHabitsApi();

  group(HabitsApi, () {
    //Future<List<HabitDto>> apiHabitsGet({ bool includeInactive }) async
    test('test apiHabitsGet', () async {
      // TODO
    });

    //Future apiHabitsIdDelete(String id) async
    test('test apiHabitsIdDelete', () async {
      // TODO
    });

    //Future<HabitDto> apiHabitsIdPut(String id, SaveHabitRequest saveHabitRequest) async
    test('test apiHabitsIdPut', () async {
      // TODO
    });

    //Future<HabitDto> apiHabitsPost(SaveHabitRequest saveHabitRequest) async
    test('test apiHabitsPost', () async {
      // TODO
    });

    //Future apiHabitsReorderPut(ReorderRequest reorderRequest) async
    test('test apiHabitsReorderPut', () async {
      // TODO
    });

  });
}
