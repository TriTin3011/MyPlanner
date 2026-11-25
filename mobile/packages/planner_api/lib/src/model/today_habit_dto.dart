//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'today_habit_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TodayHabitDto {
  /// Returns a new [TodayHabitDto] instance.
  TodayHabitDto({

    required  this.id,

    required  this.title,

    required  this.order,

    required  this.done,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final int order;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is TodayHabitDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            order,
            done,
        ],
        [
            other.id,
            other.title,
            other.order,
            other.done,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        order,
        done,
    ],);

  factory TodayHabitDto.fromJson(Map<String, dynamic> json) => _$TodayHabitDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TodayHabitDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

