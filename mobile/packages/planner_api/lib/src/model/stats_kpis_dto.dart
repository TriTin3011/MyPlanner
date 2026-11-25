//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_kpis_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsKpisDto {
  /// Returns a new [StatsKpisDto] instance.
  StatsKpisDto({

    required  this.tasksDone,

    required  this.tasksDonePercentChange,

    required  this.activityCurrentStreak,

    required  this.activityLongestStreak,

    required  this.habitPercent,

    required  this.habitDeltaPoints,
  });

  @JsonKey(
    
    name: r'tasksDone',
    required: true,
    includeIfNull: false,
  )


  final int tasksDone;



  @JsonKey(
    
    name: r'tasksDonePercentChange',
    required: true,
    includeIfNull: true,
  )


  final int? tasksDonePercentChange;



  @JsonKey(
    
    name: r'activityCurrentStreak',
    required: true,
    includeIfNull: false,
  )


  final int activityCurrentStreak;



  @JsonKey(
    
    name: r'activityLongestStreak',
    required: true,
    includeIfNull: false,
  )


  final int activityLongestStreak;



  @JsonKey(
    
    name: r'habitPercent',
    required: true,
    includeIfNull: false,
  )


  final int habitPercent;



  @JsonKey(
    
    name: r'habitDeltaPoints',
    required: true,
    includeIfNull: false,
  )


  final int habitDeltaPoints;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsKpisDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            tasksDone,
            tasksDonePercentChange,
            activityCurrentStreak,
            activityLongestStreak,
            habitPercent,
            habitDeltaPoints,
        ],
        [
            other.tasksDone,
            other.tasksDonePercentChange,
            other.activityCurrentStreak,
            other.activityLongestStreak,
            other.habitPercent,
            other.habitDeltaPoints,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        tasksDone,
        tasksDonePercentChange,
        activityCurrentStreak,
        activityLongestStreak,
        habitPercent,
        habitDeltaPoints,
    ],);

  factory StatsKpisDto.fromJson(Map<String, dynamic> json) => _$StatsKpisDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsKpisDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

