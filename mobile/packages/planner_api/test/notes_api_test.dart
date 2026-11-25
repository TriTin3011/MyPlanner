import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for NotesApi
void main() {
  final instance = PlannerApi().getNotesApi();

  group(NotesApi, () {
    //Future<DayNoteDto> apiNotesDayDateGet(String date) async
    test('test apiNotesDayDateGet', () async {
      // TODO
    });

    //Future<DayNoteDto> apiNotesDayDatePut(String date, SaveNoteRequest saveNoteRequest) async
    test('test apiNotesDayDatePut', () async {
      // TODO
    });

    //Future<WeekNoteDto> apiNotesWeekWeekKeyGet(String weekKey) async
    test('test apiNotesWeekWeekKeyGet', () async {
      // TODO
    });

    //Future<WeekNoteDto> apiNotesWeekWeekKeyPut(String weekKey, SaveNoteRequest saveNoteRequest) async
    test('test apiNotesWeekWeekKeyPut', () async {
      // TODO
    });

  });
}
