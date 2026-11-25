//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/deadline_dto.dart';
import 'package:planner_api/src/model/year_plan_item_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'year_month_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class YearMonthDto {
  /// Returns a new [YearMonthDto] instance.
  YearMonthDto({

    required  this.month,

    required  this.done,

    required  this.total,

    required  this.percent,

    required  this.deadlines,

    required  this.items,
  });

  @JsonKey(
    
    name: r'month',
    required: true,
    includeIfNull: false,
  )


  final int month;



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



  @JsonKey(
    
    name: r'deadlines',
    required: true,
    includeIfNull: false,
  )


  final List<DeadlineDto> deadlines;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<YearPlanItemDto> items;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is YearMonthDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            month,
            done,
            total,
            percent,
            deadlines,
            items,
        ],
        [
            other.month,
            other.done,
            other.total,
            other.percent,
            other.deadlines,
            other.items,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        month,
        done,
        total,
        percent,
        deadlines,
        items,
    ],);

  factory YearMonthDto.fromJson(Map<String, dynamic> json) => _$YearMonthDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YearMonthDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

