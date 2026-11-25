//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'habit_day_count_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HabitDayCountDto {
  /// Returns a new [HabitDayCountDto] instance.
  HabitDayCountDto({

    required  this.date,

    required  this.done,

    required  this.total,

    required  this.percent,
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
    includeIfNull: true,
  )


  final int? done;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: true,
  )


  final int? total;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: true,
  )


  final int? percent;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HabitDayCountDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            done,
            total,
            percent,
        ],
        [
            other.date,
            other.done,
            other.total,
            other.percent,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        done,
        total,
        percent,
    ],);

  factory HabitDayCountDto.fromJson(Map<String, dynamic> json) => _$HabitDayCountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HabitDayCountDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

