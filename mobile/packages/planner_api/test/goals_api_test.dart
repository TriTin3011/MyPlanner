import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for GoalsApi
void main() {
  final instance = PlannerApi().getGoalsApi();

  group(GoalsApi, () {
    //Future<GoalBoardDto> apiDashboardGoalsGet({ String today }) async
    test('test apiDashboardGoalsGet', () async {
      // TODO
    });

    //Future<List<DeadlineDto>> apiDeadlinesGet({ String from, String to, String today }) async
    test('test apiDeadlinesGet', () async {
      // TODO
    });

    //Future<List<GoalDto>> apiGoalsGet() async
    test('test apiGoalsGet', () async {
      // TODO
    });

    //Future apiGoalsIdDelete(String id) async
    test('test apiGoalsIdDelete', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsIdGet(String id) async
    test('test apiGoalsIdGet', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsIdPut(String id, SaveGoalRequest saveGoalRequest) async
    test('test apiGoalsIdPut', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsIdStepsPost(String id, SaveGoalStepRequest saveGoalStepRequest) async
    test('test apiGoalsIdStepsPost', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsIdStepsReorderPut(String id, ReorderRequest reorderRequest) async
    test('test apiGoalsIdStepsReorderPut', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsIdStepsStepIdDelete(String id, String stepId) async
    test('test apiGoalsIdStepsStepIdDelete', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsIdStepsStepIdPut(String id, String stepId, SaveGoalStepRequest saveGoalStepRequest) async
    test('test apiGoalsIdStepsStepIdPut', () async {
      // TODO
    });

    //Future<GoalDto> apiGoalsPost(SaveGoalRequest saveGoalRequest) async
    test('test apiGoalsPost', () async {
      // TODO
    });

  });
}
