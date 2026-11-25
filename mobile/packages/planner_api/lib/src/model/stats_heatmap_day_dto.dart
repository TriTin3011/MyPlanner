//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_heatmap_day_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsHeatmapDayDto {
  /// Returns a new [StatsHeatmapDayDto] instance.
  StatsHeatmapDayDto({

    required  this.date,

    required  this.done,

    required  this.level,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final int done;



  @JsonKey(
    
    name: r'level',
    required: true,
    includeIfNull: false,
  )


  final int level;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsHeatmapDayDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            done,
            level,
        ],
        [
            other.date,
            other.done,
            other.level,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        done,
        level,
    ],);

  factory StatsHeatmapDayDto.fromJson(Map<String, dynamic> json) => _$StatsHeatmapDayDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsHeatmapDayDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

