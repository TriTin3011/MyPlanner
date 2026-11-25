//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_habit_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsHabitDto {
  /// Returns a new [StatsHabitDto] instance.
  StatsHabitDto({

    required  this.habitId,

    required  this.title,

    required  this.percent,

    required  this.doneDays,

    required  this.possibleDays,

    required  this.currentStreak,

    required  this.longestStreak,
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
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



  @JsonKey(
    
    name: r'doneDays',
    required: true,
    includeIfNull: false,
  )


  final int doneDays;



  @JsonKey(
    
    name: r'possibleDays',
    required: true,
    includeIfNull: false,
  )


  final int possibleDays;



  @JsonKey(
    
    name: r'currentStreak',
    required: true,
    includeIfNull: false,
  )


  final int currentStreak;



  @JsonKey(
    
    name: r'longestStreak',
    required: true,
    includeIfNull: false,
  )


  final int longestStreak;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsHabitDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            habitId,
            title,
            percent,
            doneDays,
            possibleDays,
            currentStreak,
            longestStreak,
        ],
        [
            other.habitId,
            other.title,
            other.percent,
            other.doneDays,
            other.possibleDays,
            other.currentStreak,
            other.longestStreak,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        habitId,
        title,
        percent,
        doneDays,
        possibleDays,
        currentStreak,
        longestStreak,
    ],);

  factory StatsHabitDto.fromJson(Map<String, dynamic> json) => _$StatsHabitDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsHabitDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

