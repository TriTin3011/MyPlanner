//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/area_summary_dto.dart';
import 'package:planner_api/src/model/goal_card_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'goal_board_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoalBoardDto {
  /// Returns a new [GoalBoardDto] instance.
  GoalBoardDto({

    required  this.done,

    required  this.total,

    required  this.percent,

    required  this.areas,

    required  this.goals,
  });

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
    
    name: r'areas',
    required: true,
    includeIfNull: false,
  )


  final List<AreaSummaryDto> areas;



  @JsonKey(
    
    name: r'goals',
    required: true,
    includeIfNull: false,
  )


  final List<GoalCardDto> goals;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is GoalBoardDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            done,
            total,
            percent,
            areas,
            goals,
        ],
        [
            other.done,
            other.total,
            other.percent,
            other.areas,
            other.goals,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        done,
        total,
        percent,
        areas,
        goals,
    ],);

  factory GoalBoardDto.fromJson(Map<String, dynamic> json) => _$GoalBoardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalBoardDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

