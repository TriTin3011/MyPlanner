//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/stats_goals_dto.dart';
import 'package:planner_api/src/model/stats_trend_dto.dart';
import 'package:planner_api/src/model/stats_weekday_dto.dart';
import 'package:planner_api/src/model/stats_kpis_dto.dart';
import 'package:planner_api/src/model/stats_habit_dto.dart';
import 'package:planner_api/src/model/stats_hero_dto.dart';
import 'package:planner_api/src/model/stats_heatmap_day_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsDto {
  /// Returns a new [StatsDto] instance.
  StatsDto({

    required  this.range,

    required  this.from,

    required  this.to,

    required  this.previousFrom,

    required  this.previousTo,

    required  this.hero,

    required  this.kpis,

    required  this.trend,

    required  this.heatmap,

    required  this.weekdayProductivity,

    required  this.habitConsistency,

    required  this.goals,
  });

  @JsonKey(
    
    name: r'range',
    required: true,
    includeIfNull: false,
  )


  final String range;



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
    
    name: r'previousFrom',
    required: true,
    includeIfNull: false,
  )


  final String previousFrom;



  @JsonKey(
    
    name: r'previousTo',
    required: true,
    includeIfNull: false,
  )


  final String previousTo;



  @JsonKey(
    
    name: r'hero',
    required: true,
    includeIfNull: false,
  )


  final StatsHeroDto hero;



  @JsonKey(
    
    name: r'kpis',
    required: true,
    includeIfNull: false,
  )


  final StatsKpisDto kpis;



  @JsonKey(
    
    name: r'trend',
    required: true,
    includeIfNull: false,
  )


  final StatsTrendDto trend;



  @JsonKey(
    
    name: r'heatmap',
    required: true,
    includeIfNull: false,
  )


  final List<StatsHeatmapDayDto> heatmap;



  @JsonKey(
    
    name: r'weekdayProductivity',
    required: true,
    includeIfNull: false,
  )


  final List<StatsWeekdayDto> weekdayProductivity;



  @JsonKey(
    
    name: r'habitConsistency',
    required: true,
    includeIfNull: false,
  )


  final List<StatsHabitDto> habitConsistency;



  @JsonKey(
    
    name: r'goals',
    required: true,
    includeIfNull: false,
  )


  final StatsGoalsDto goals;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            range,
            from,
            to,
            previousFrom,
            previousTo,
            hero,
            kpis,
            trend,
            heatmap,
            weekdayProductivity,
            habitConsistency,
            goals,
        ],
        [
            other.range,
            other.from,
            other.to,
            other.previousFrom,
            other.previousTo,
            other.hero,
            other.kpis,
            other.trend,
            other.heatmap,
            other.weekdayProductivity,
            other.habitConsistency,
            other.goals,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        range,
        from,
        to,
        previousFrom,
        previousTo,
        hero,
        kpis,
        trend,
        heatmap,
        weekdayProductivity,
        habitConsistency,
        goals,
    ],);

  factory StatsDto.fromJson(Map<String, dynamic> json) => _$StatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

