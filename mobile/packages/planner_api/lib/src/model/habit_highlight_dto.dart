//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'habit_highlight_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HabitHighlightDto {
  /// Returns a new [HabitHighlightDto] instance.
  HabitHighlightDto({

    required  this.habitId,

    required  this.title,

    required  this.value,
  });

  @JsonKey(
    
    name: r'habitId',
    required: true,
    includeIfNull: false,
  )


  final String habitId;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'value',
    required: true,
    includeIfNull: false,
  )


  final int value;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HabitHighlightDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            habitId,
            title,
            value,
        ],
        [
            other.habitId,
            other.title,
            other.value,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        habitId,
        title,
        value,
    ],);

  factory HabitHighlightDto.fromJson(Map<String, dynamic> json) => _$HabitHighlightDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HabitHighlightDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

