//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/goal_status.dart';
import 'package:planner_api/src/model/life_area.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'goal_card_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoalCardDto {
  /// Returns a new [GoalCardDto] instance.
  GoalCardDto({

    required  this.id,

    required  this.title,

    required  this.area,

    required  this.status,

    required  this.startDate,

    required  this.deadline,

    required  this.reward,

    required  this.daysLeft,

    required  this.stepsDone,

    required  this.stepsTotal,

    required  this.overdueSteps,

    required  this.stepPercent,

    required  this.timePercent,

    required  this.behind,
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
    
    name: r'daysLeft',
    required: true,
    includeIfNull: false,
  )


  final int daysLeft;



  @JsonKey(
    
    name: r'stepsDone',
    required: true,
    includeIfNull: false,
  )


  final int stepsDone;



  @JsonKey(
    
    name: r'stepsTotal',
    required: true,
    includeIfNull: false,
  )


  final int stepsTotal;



  @JsonKey(
    
    name: r'overdueSteps',
    required: true,
    includeIfNull: false,
  )


  final int overdueSteps;



  @JsonKey(
    
    name: r'stepPercent',
    required: true,
    includeIfNull: false,
  )


  final int stepPercent;



  @JsonKey(
    
    name: r'timePercent',
    required: true,
    includeIfNull: false,
  )


  final int timePercent;



  @JsonKey(
    
    name: r'behind',
    required: true,
    includeIfNull: false,
  )


  final bool behind;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is GoalCardDto &&
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
            daysLeft,
            stepsDone,
            stepsTotal,
            overdueSteps,
            stepPercent,
            timePercent,
            behind,
        ],
        [
            other.id,
            other.title,
            other.area,
            other.status,
            other.startDate,
            other.deadline,
            other.reward,
            other.daysLeft,
            other.stepsDone,
            other.stepsTotal,
            other.overdueSteps,
            other.stepPercent,
            other.timePercent,
            other.behind,
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
        daysLeft,
        stepsDone,
        stepsTotal,
        overdueSteps,
        stepPercent,
        timePercent,
        behind,
    ],);

  factory GoalCardDto.fromJson(Map<String, dynamic> json) => _$GoalCardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalCardDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

