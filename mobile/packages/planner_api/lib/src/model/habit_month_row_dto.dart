//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'habit_month_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HabitMonthRowDto {
  /// Returns a new [HabitMonthRowDto] instance.
  HabitMonthRowDto({

    required  this.id,

    required  this.title,

    required  this.order,

    required  this.startDate,

    required  this.percent,

    required  this.currentStreak,

    required  this.longestStreak,

    required  this.doneDates,
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
    
    name: r'startDate',
    required: true,
    includeIfNull: false,
  )


  final String startDate;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



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



  @JsonKey(
    
    name: r'doneDates',
    required: true,
    includeIfNull: false,
  )


  final List<String> doneDates;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HabitMonthRowDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            order,
            startDate,
            percent,
            currentStreak,
            longestStreak,
            doneDates,
        ],
        [
            other.id,
            other.title,
            other.order,
            other.startDate,
            other.percent,
            other.currentStreak,
            other.longestStreak,
            other.doneDates,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        order,
        startDate,
        percent,
        currentStreak,
        longestStreak,
        doneDates,
    ],);

  factory HabitMonthRowDto.fromJson(Map<String, dynamic> json) => _$HabitMonthRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HabitMonthRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

