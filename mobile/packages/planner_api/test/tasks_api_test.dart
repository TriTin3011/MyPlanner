import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for TasksApi
void main() {
  final instance = PlannerApi().getTasksApi();

  group(TasksApi, () {
    //Future<List<TaskDto>> apiTasksBacklogGet({ String today }) async
    test('test apiTasksBacklogGet', () async {
      // TODO
    });

    //Future<List<TaskDto>> apiTasksGet({ String from, String to }) async
    test('test apiTasksGet', () async {
      // TODO
    });

    //Future apiTasksIdDelete(String id) async
    test('test apiTasksIdDelete', () async {
      // TODO
    });

    //Future<TaskDto> apiTasksIdDonePatch(String id, SetDoneRequest setDoneRequest) async
    test('test apiTasksIdDonePatch', () async {
      // TODO
    });

    //Future<TaskDto> apiTasksIdPut(String id, SaveTaskRequest saveTaskRequest) async
    test('test apiTasksIdPut', () async {
      // TODO
    });

    //Future<CountDto> apiTasksMoveBacklogToTodayPost(MoveBacklogRequest moveBacklogRequest) async
    test('test apiTasksMoveBacklogToTodayPost', () async {
      // TODO
    });

    //Future<TaskDto> apiTasksPost(SaveTaskRequest saveTaskRequest) async
    test('test apiTasksPost', () async {
      // TODO
    });

    //Future apiTasksReorderPut(ReorderTasksRequest reorderTasksRequest) async
    test('test apiTasksReorderPut', () async {
      // TODO
    });

  });
}
