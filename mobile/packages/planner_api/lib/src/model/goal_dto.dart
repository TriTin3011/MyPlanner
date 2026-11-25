//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/goal_status.dart';
import 'package:planner_api/src/model/life_area.dart';
import 'package:planner_api/src/model/goal_step_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'goal_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoalDto {
  /// Returns a new [GoalDto] instance.
  GoalDto({

    required  this.id,

    required  this.title,

    required  this.area,

    required  this.status,

    required  this.startDate,

    required  this.deadline,

    required  this.reward,

    required  this.why,

    required  this.steps,

    required  this.createdAt,

    required  this.completedAt,
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
    
    name: r'area',
    required: true,
    includeIfNull: false,
  unknownEnumValue: LifeArea.unknownDefaultOpenApi,
  )


  final LifeArea area;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  unknownEnumValue: GoalStatus.unknownDefaultOpenApi,
  )


  final GoalStatus status;



  @JsonKey(
    
    name: r'startDate',
    required: true,
    includeIfNull: false,
  )


  final String startDate;



  @JsonKey(
    
    name: r'deadline',
    required: true,
    includeIfNull: false,
  )


  final String deadline;



  @JsonKey(
    
    name: r'reward',
    required: true,
    includeIfNull: true,
  )


  final String? reward;



  @JsonKey(
    
    name: r'why',
    required: true,
    includeIfNull: true,
  )


  final String? why;



  @JsonKey(
    
    name: r'steps',
    required: true,
    includeIfNull: false,
  )


  final List<GoalStepDto> steps;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'completedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? completedAt;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is GoalDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            area,
            status,
            startDate,
            deadline,
            reward,
            why,
            steps,
            createdAt,
            completedAt,
        ],
        [
            other.id,
            other.title,
            other.area,
            other.status,
            other.startDate,
            other.deadline,
            other.reward,
            other.why,
            other.steps,
            other.createdAt,
            other.completedAt,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        area,
        status,
        startDate,
        deadline,
        reward,
        why,
        steps,
        createdAt,
        completedAt,
    ],);

  factory GoalDto.fromJson(Map<String, dynamic> json) => _$GoalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

