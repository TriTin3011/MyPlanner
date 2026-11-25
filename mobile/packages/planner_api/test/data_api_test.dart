import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for DataApi
void main() {
  final instance = PlannerApi().getDataApi();

  group(DataApi, () {
    //Future<ImportResultDto> apiDevSeedPost(SeedRequest seedRequest) async
    test('test apiDevSeedPost', () async {
      // TODO
    });

    //Future<BackupDto> apiExportGet() async
    test('test apiExportGet', () async {
      // TODO
    });

    //Future<ImportResultDto> apiImportPost(BackupDto backupDto) async
    test('test apiImportPost', () async {
      // TODO
    });

    //Future<WeekDeleteResultDto> apiWeeksWeekKeyDelete(String weekKey) async
    test('test apiWeeksWeekKeyDelete', () async {
      // TODO
    });

  });
}
