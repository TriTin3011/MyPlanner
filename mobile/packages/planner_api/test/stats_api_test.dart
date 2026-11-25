import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for StatsApi
void main() {
  final instance = PlannerApi().getStatsApi();

  group(StatsApi, () {
    //Future<StatsDto> apiStatsGet({ String range, String today }) async
    test('test apiStatsGet', () async {
      // TODO
    });

  });
}
