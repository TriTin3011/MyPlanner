//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_week_point_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsWeekPointDto {
  /// Returns a new [StatsWeekPointDto] instance.
  StatsWeekPointDto({

    required  this.weekKey,

    required  this.monday,

    required  this.done,

    required  this.total,

    required  this.percent,
  });

  @JsonKey(
    
    name: r'weekKey',
    required: true,
    includeIfNull: false,
  )


  final String weekKey;



  @JsonKey(
    
    name: r'monday',
    required: true,
    includeIfNull: false,
  )


  final String monday;



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



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsWeekPointDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            weekKey,
            monday,
            done,
            total,
            percent,
        ],
        [
            other.weekKey,
            other.monday,
            other.done,
            other.total,
            other.percent,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        weekKey,
        monday,
        done,
        total,
        percent,
    ],);

  factory StatsWeekPointDto.fromJson(Map<String, dynamic> json) => _$StatsWeekPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsWeekPointDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

