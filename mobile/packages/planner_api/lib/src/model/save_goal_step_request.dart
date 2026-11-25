//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_goal_step_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveGoalStepRequest {
  /// Returns a new [SaveGoalStepRequest] instance.
  SaveGoalStepRequest({

    required  this.title,

    required  this.deadline,

    required  this.done,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'deadline',
    required: true,
    includeIfNull: true,
  )


  final String? deadline;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SaveGoalStepRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            title,
            deadline,
            done,
        ],
        [
            other.title,
            other.deadline,
            other.done,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        title,
        deadline,
        done,
    ],);

  factory SaveGoalStepRequest.fromJson(Map<String, dynamic> json) => _$SaveGoalStepRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveGoalStepRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

