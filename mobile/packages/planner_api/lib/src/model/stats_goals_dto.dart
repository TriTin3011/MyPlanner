//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/stats_goal_area_dto.dart';
import 'package:planner_api/src/model/stats_goal_status_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_goals_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsGoalsDto {
  /// Returns a new [StatsGoalsDto] instance.
  StatsGoalsDto({

    required  this.total,

    required  this.percentDone,

    required  this.byStatus,

    required  this.byArea,
  });

  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final int total;



  @JsonKey(
    
    name: r'percentDone',
    required: true,
    includeIfNull: false,
  )


  final int percentDone;



  @JsonKey(
    
    name: r'byStatus',
    required: true,
    includeIfNull: false,
  )


  final StatsGoalStatusDto byStatus;



  @JsonKey(
    
    name: r'byArea',
    required: true,
    includeIfNull: false,
  )


  final List<StatsGoalAreaDto> byArea;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsGoalsDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            total,
            percentDone,
            byStatus,
            byArea,
        ],
        [
            other.total,
            other.percentDone,
            other.byStatus,
            other.byArea,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        total,
        percentDone,
        byStatus,
        byArea,
    ],);

  factory StatsGoalsDto.fromJson(Map<String, dynamic> json) => _$StatsGoalsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsGoalsDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

