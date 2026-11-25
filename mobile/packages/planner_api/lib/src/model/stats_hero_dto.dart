//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/stats_week_point_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_hero_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsHeroDto {
  /// Returns a new [StatsHeroDto] instance.
  StatsHeroDto({

    required  this.completionPercent,

    required  this.tasksDone,

    required  this.tasksTotal,

    required  this.deltaPoints,

    required  this.bestWeekday,

    required  this.weeklySparkline,
  });

  @JsonKey(
    
    name: r'completionPercent',
    required: true,
    includeIfNull: false,
  )


  final int completionPercent;



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
    
    name: r'deltaPoints',
    required: true,
    includeIfNull: false,
  )


  final int deltaPoints;



  @JsonKey(
    
    name: r'bestWeekday',
    required: true,
    includeIfNull: true,
  )


  final int? bestWeekday;



  @JsonKey(
    
    name: r'weeklySparkline',
    required: true,
    includeIfNull: false,
  )


  final List<StatsWeekPointDto> weeklySparkline;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsHeroDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            completionPercent,
            tasksDone,
            tasksTotal,
            deltaPoints,
            bestWeekday,
            weeklySparkline,
        ],
        [
            other.completionPercent,
            other.tasksDone,
            other.tasksTotal,
            other.deltaPoints,
            other.bestWeekday,
            other.weeklySparkline,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        completionPercent,
        tasksDone,
        tasksTotal,
        deltaPoints,
        bestWeekday,
        weeklySparkline,
    ],);

  factory StatsHeroDto.fromJson(Map<String, dynamic> json) => _$StatsHeroDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsHeroDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

