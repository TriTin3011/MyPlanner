import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for YearsApi
void main() {
  final instance = PlannerApi().getYearsApi();

  group(YearsApi, () {
    //Future<YearDashboardDto> apiDashboardYearGet({ int year, String today }) async
    test('test apiDashboardYearGet', () async {
      // TODO
    });

    //Future apiYearItemsIdDelete(String id) async
    test('test apiYearItemsIdDelete', () async {
      // TODO
    });

    //Future<YearPlanItemDto> apiYearItemsIdPut(String id, UpdateYearItemRequest updateYearItemRequest) async
    test('test apiYearItemsIdPut', () async {
      // TODO
    });

    //Future<YearMetaDto> apiYearsYearGet(int year) async
    test('test apiYearsYearGet', () async {
      // TODO
    });

    //Future<List<YearPlanItemDto>> apiYearsYearItemsGet(int year) async
    test('test apiYearsYearItemsGet', () async {
      // TODO
    });

    //Future<YearPlanItemDto> apiYearsYearItemsPost(int year, CreateYearItemRequest createYearItemRequest) async
    test('test apiYearsYearItemsPost', () async {
      // TODO
    });

    //Future apiYearsYearItemsReorderPut(int year, ReorderYearItemsRequest reorderYearItemsRequest) async
    test('test apiYearsYearItemsReorderPut', () async {
      // TODO
    });

    //Future<YearMetaDto> apiYearsYearPut(int year, SaveYearMetaRequest saveYearMetaRequest) async
    test('test apiYearsYearPut', () async {
      // TODO
    });

  });
}
