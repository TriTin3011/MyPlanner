import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for HealthApi
void main() {
  final instance = PlannerApi().getHealthApi();

  group(HealthApi, () {
    //Future<HealthDto> apiHealthGet() async
    test('test apiHealthGet', () async {
      // TODO
    });

  });
}
