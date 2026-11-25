//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/task_dto.dart';
import 'package:planner_api/src/model/today_habit_dto.dart';
import 'package:planner_api/src/model/day_note_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'today_dashboard_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TodayDashboardDto {
  /// Returns a new [TodayDashboardDto] instance.
  TodayDashboardDto({

    required  this.date,

    required  this.percent,

    required  this.tasksDone,

    required  this.tasksTotal,

    required  this.habitsDone,

    required  this.habitsTotal,

    required  this.tasks,

    required  this.backlog,

    required  this.habits,

    required  this.note,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



  @JsonKey(
    
    name: r'tasksDone',
    required: true,
    includeIfNull: false,
  )


  final int tasksDone;



  @JsonKey(
    
    name: r'tasksTotal',
    required: true,
    includeIfNull: false,
  )


  final int tasksTotal;



  @JsonKey(
    
    name: r'habitsDone',
    required: true,
    includeIfNull: false,
  )


  final int habitsDone;



  @JsonKey(
    
    name: r'habitsTotal',
    required: true,
    includeIfNull: false,
  )


  final int habitsTotal;



  @JsonKey(
    
    name: r'tasks',
    required: true,
    includeIfNull: false,
  )


  final List<TaskDto> tasks;



  @JsonKey(
    
    name: r'backlog',
    required: true,
    includeIfNull: false,
  )


  final List<TaskDto> backlog;



  @JsonKey(
    
    name: r'habits',
    required: true,
    includeIfNull: false,
  )


  final List<TodayHabitDto> habits;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final DayNoteDto? note;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is TodayDashboardDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            percent,
            tasksDone,
            tasksTotal,
            habitsDone,
            habitsTotal,
            tasks,
            backlog,
            habits,
            note,
        ],
        [
            other.date,
            other.percent,
            other.tasksDone,
            other.tasksTotal,
            other.habitsDone,
            other.habitsTotal,
            other.tasks,
            other.backlog,
            other.habits,
            other.note,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        percent,
        tasksDone,
        tasksTotal,
        habitsDone,
        habitsTotal,
        tasks,
        backlog,
        habits,
        note,
    ],);

  factory TodayDashboardDto.fromJson(Map<String, dynamic> json) => _$TodayDashboardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TodayDashboardDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

