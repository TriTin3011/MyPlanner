//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/life_area.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_goal_area_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsGoalAreaDto {
  /// Returns a new [StatsGoalAreaDto] instance.
  StatsGoalAreaDto({

    required  this.area,

    required  this.done,

    required  this.total,
  });

  @JsonKey(
    
    name: r'area',
    required: true,
    includeIfNull: false,
  unknownEnumValue: LifeArea.unknownDefaultOpenApi,
  )


  final LifeArea area;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final int done;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final int total;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsGoalAreaDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            area,
            done,
            total,
        ],
        [
            other.area,
            other.done,
            other.total,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        area,
        done,
        total,
    ],);

  factory StatsGoalAreaDto.fromJson(Map<String, dynamic> json) => _$StatsGoalAreaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsGoalAreaDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

