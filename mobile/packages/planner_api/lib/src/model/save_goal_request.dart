//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/goal_status.dart';
import 'package:planner_api/src/model/life_area.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_goal_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveGoalRequest {
  /// Returns a new [SaveGoalRequest] instance.
  SaveGoalRequest({

    required  this.title,

    required  this.area,

    required  this.status,

    required  this.startDate,

    required  this.deadline,

    required  this.reward,

    required  this.why,
  });

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




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SaveGoalRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            title,
            area,
            status,
            startDate,
            deadline,
            reward,
            why,
        ],
        [
            other.title,
            other.area,
            other.status,
            other.startDate,
            other.deadline,
            other.reward,
            other.why,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        title,
        area,
        status,
        startDate,
        deadline,
        reward,
        why,
    ],);

  factory SaveGoalRequest.fromJson(Map<String, dynamic> json) => _$SaveGoalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveGoalRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

