//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'habit_log_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HabitLogDto {
  /// Returns a new [HabitLogDto] instance.
  HabitLogDto({

    required  this.habitId,

    required  this.date,
  });

  @JsonKey(
    
    name: r'habitId',
    required: true,
    includeIfNull: false,
  )


  final String habitId;



  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HabitLogDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            habitId,
            date,
        ],
        [
            other.habitId,
            other.date,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        habitId,
        date,
    ],);

  factory HabitLogDto.fromJson(Map<String, dynamic> json) => _$HabitLogDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HabitLogDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

