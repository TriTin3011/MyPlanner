//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_weekday_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsWeekdayDto {
  /// Returns a new [StatsWeekdayDto] instance.
  StatsWeekdayDto({

    required  this.weekday,

    required  this.averageDone,
  });

  @JsonKey(
    
    name: r'weekday',
    required: true,
    includeIfNull: false,
  )


  final int weekday;



  @JsonKey(
    
    name: r'averageDone',
    required: true,
    includeIfNull: false,
  )


  final double averageDone;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsWeekdayDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            weekday,
            averageDone,
        ],
        [
            other.weekday,
            other.averageDone,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        weekday,
        averageDone,
    ],);

  factory StatsWeekdayDto.fromJson(Map<String, dynamic> json) => _$StatsWeekdayDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsWeekdayDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

