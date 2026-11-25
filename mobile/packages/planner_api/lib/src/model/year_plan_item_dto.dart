//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'year_plan_item_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class YearPlanItemDto {
  /// Returns a new [YearPlanItemDto] instance.
  YearPlanItemDto({

    required  this.id,

    required  this.year,

    required  this.month,

    required  this.title,

    required  this.done,

    required  this.order,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'year',
    required: true,
    includeIfNull: false,
  )


  final int year;



  @JsonKey(
    
    name: r'month',
    required: true,
    includeIfNull: false,
  )


  final int month;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;



  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final int order;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is YearPlanItemDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            year,
            month,
            title,
            done,
            order,
        ],
        [
            other.id,
            other.year,
            other.month,
            other.title,
            other.done,
            other.order,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        year,
        month,
        title,
        done,
        order,
    ],);

  factory YearPlanItemDto.fromJson(Map<String, dynamic> json) => _$YearPlanItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YearPlanItemDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

