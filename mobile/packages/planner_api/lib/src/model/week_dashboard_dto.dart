//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/day_progress_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'week_dashboard_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeekDashboardDto {
  /// Returns a new [WeekDashboardDto] instance.
  WeekDashboardDto({

    required  this.weekKey,

    required  this.from,

    required  this.to,

    required  this.tasksDone,

    required  this.tasksTotal,

    required  this.habitPercent,

    required  this.todayRemaining,

    required  this.comment,

    required  this.days,

    required  this.insights,
  });

  @JsonKey(
    
    name: r'weekKey',
    required: true,
    includeIfNull: false,
  )


  final String weekKey;



  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final String from;



  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final String to;



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
    
    name: r'habitPercent',
    required: true,
    includeIfNull: false,
  )


  final int habitPercent;



  @JsonKey(
    
    name: r'todayRemaining',
    required: true,
    includeIfNull: false,
  )


  final int todayRemaining;



  @JsonKey(
    
    name: r'comment',
    required: true,
    includeIfNull: false,
  )


  final String comment;



  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final List<DayProgressDto> days;



  @JsonKey(
    
    name: r'insights',
    required: true,
    includeIfNull: false,
  )


  final List<String> insights;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is WeekDashboardDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            weekKey,
            from,
            to,
            tasksDone,
            tasksTotal,
            habitPercent,
            todayRemaining,
            comment,
            days,
            insights,
        ],
        [
            other.weekKey,
            other.from,
            other.to,
            other.tasksDone,
            other.tasksTotal,
            other.habitPercent,
            other.todayRemaining,
            other.comment,
            other.days,
            other.insights,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        weekKey,
        from,
        to,
        tasksDone,
        tasksTotal,
        habitPercent,
        todayRemaining,
        comment,
        days,
        insights,
    ],);

  factory WeekDashboardDto.fromJson(Map<String, dynamic> json) => _$WeekDashboardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WeekDashboardDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

