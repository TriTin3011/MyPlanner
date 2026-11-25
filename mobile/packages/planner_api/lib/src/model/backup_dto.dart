//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/habit_log_dto.dart';
import 'package:planner_api/src/model/task_dto.dart';
import 'package:planner_api/src/model/goal_dto.dart';
import 'package:planner_api/src/model/week_note_dto.dart';
import 'package:planner_api/src/model/day_note_dto.dart';
import 'package:planner_api/src/model/habit_dto.dart';
import 'package:planner_api/src/model/recurring_task_dto.dart';
import 'package:planner_api/src/model/year_plan_item_dto.dart';
import 'package:planner_api/src/model/year_meta_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'backup_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BackupDto {
  /// Returns a new [BackupDto] instance.
  BackupDto({

    required  this.version,

    required  this.exportedAt,

    required  this.tasks,

    required  this.recurring,

    required  this.habits,

    required  this.habitLogs,

    required  this.goals,

    required  this.dayNotes,

    required  this.weekNotes,

    required  this.years,

    required  this.yearItems,
  });

  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final int version;



  @JsonKey(
    
    name: r'exportedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime exportedAt;



  @JsonKey(
    
    name: r'tasks',
    required: true,
    includeIfNull: false,
  )


  final List<TaskDto> tasks;



  @JsonKey(
    
    name: r'recurring',
    required: true,
    includeIfNull: false,
  )


  final List<RecurringTaskDto> recurring;



  @JsonKey(
    
    name: r'habits',
    required: true,
    includeIfNull: false,
  )


  final List<HabitDto> habits;



  @JsonKey(
    
    name: r'habitLogs',
    required: true,
    includeIfNull: false,
  )


  final List<HabitLogDto> habitLogs;



  @JsonKey(
    
    name: r'goals',
    required: true,
    includeIfNull: false,
  )


  final List<GoalDto> goals;



  @JsonKey(
    
    name: r'dayNotes',
    required: true,
    includeIfNull: false,
  )


  final List<DayNoteDto> dayNotes;



  @JsonKey(
    
    name: r'weekNotes',
    required: true,
    includeIfNull: false,
  )


  final List<WeekNoteDto> weekNotes;



  @JsonKey(
    
    name: r'years',
    required: true,
    includeIfNull: false,
  )


  final List<YearMetaDto> years;



  @JsonKey(
    
    name: r'yearItems',
    required: true,
    includeIfNull: false,
  )


  final List<YearPlanItemDto> yearItems;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is BackupDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            version,
            exportedAt,
            tasks,
            recurring,
            habits,
            habitLogs,
            goals,
            dayNotes,
            weekNotes,
            years,
            yearItems,
        ],
        [
            other.version,
            other.exportedAt,
            other.tasks,
            other.recurring,
            other.habits,
            other.habitLogs,
            other.goals,
            other.dayNotes,
            other.weekNotes,
            other.years,
            other.yearItems,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        version,
        exportedAt,
        tasks,
        recurring,
        habits,
        habitLogs,
        goals,
        dayNotes,
        weekNotes,
        years,
        yearItems,
    ],);

  factory BackupDto.fromJson(Map<String, dynamic> json) => _$BackupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BackupDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

