//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/habit_highlight_dto.dart';
import 'package:planner_api/src/model/habit_month_row_dto.dart';
import 'package:planner_api/src/model/habit_day_count_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'habit_month_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HabitMonthDto {
  /// Returns a new [HabitMonthDto] instance.
  HabitMonthDto({

    required  this.month,

    required  this.from,

    required  this.to,

    required  this.percent,

    required  this.longestStreak,

    required  this.mostConsistent,

    required  this.habits,

    required  this.days,
  });

  @JsonKey(
    
    name: r'month',
    required: true,
    includeIfNull: false,
  )


  final String month;



  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final String from;



  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final String to;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



  @JsonKey(
    
    name: r'longestStreak',
    required: true,
    includeIfNull: true,
  )


  final HabitHighlightDto? longestStreak;



  @JsonKey(
    
    name: r'mostConsistent',
    required: true,
    includeIfNull: true,
  )


  final HabitHighlightDto? mostConsistent;



  @JsonKey(
    
    name: r'habits',
    required: true,
    includeIfNull: false,
  )


  final List<HabitMonthRowDto> habits;



  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final List<HabitDayCountDto> days;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HabitMonthDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            month,
            from,
            to,
            percent,
            longestStreak,
            mostConsistent,
            habits,
            days,
        ],
        [
            other.month,
            other.from,
            other.to,
            other.percent,
            other.longestStreak,
            other.mostConsistent,
            other.habits,
            other.days,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        month,
        from,
        to,
        percent,
        longestStreak,
        mostConsistent,
        habits,
        days,
    ],);

  factory HabitMonthDto.fromJson(Map<String, dynamic> json) => _$HabitMonthDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HabitMonthDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

