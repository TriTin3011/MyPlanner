import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for RecurringApi
void main() {
  final instance = PlannerApi().getRecurringApi();

  group(RecurringApi, () {
    //Future<List<RecurringTaskDto>> apiRecurringGet() async
    test('test apiRecurringGet', () async {
      // TODO
    });

    //Future apiRecurringIdDelete(String id) async
    test('test apiRecurringIdDelete', () async {
      // TODO
    });

    //Future<RecurringTaskDto> apiRecurringIdPut(String id, SaveRecurringRequest saveRecurringRequest) async
    test('test apiRecurringIdPut', () async {
      // TODO
    });

    //Future<CountDto> apiRecurringMaterializePost(MaterializeRequest materializeRequest) async
    test('test apiRecurringMaterializePost', () async {
      // TODO
    });

    //Future<RecurringTaskDto> apiRecurringPost(SaveRecurringRequest saveRecurringRequest) async
    test('test apiRecurringPost', () async {
      // TODO
    });

  });
}
