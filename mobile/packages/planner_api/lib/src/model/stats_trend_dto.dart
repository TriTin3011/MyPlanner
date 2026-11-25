//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/stats_week_point_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_trend_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsTrendDto {
  /// Returns a new [StatsTrendDto] instance.
  StatsTrendDto({

    required  this.averagePercent,

    required  this.points,
  });

  @JsonKey(
    
    name: r'averagePercent',
    required: true,
    includeIfNull: false,
  )


  final int averagePercent;



  @JsonKey(
    
    name: r'points',
    required: true,
    includeIfNull: false,
  )


  final List<StatsWeekPointDto> points;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsTrendDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            averagePercent,
            points,
        ],
        [
            other.averagePercent,
            other.points,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        averagePercent,
        points,
    ],);

  factory StatsTrendDto.fromJson(Map<String, dynamic> json) => _$StatsTrendDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsTrendDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

