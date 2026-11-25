//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'goal_step_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoalStepDto {
  /// Returns a new [GoalStepDto] instance.
  GoalStepDto({

    required  this.id,

    required  this.title,

    required  this.deadline,

    required  this.done,

    required  this.doneAt,

    required  this.order,
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



  @JsonKey(
    
    name: r'doneAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? doneAt;



  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final int order;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is GoalStepDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            deadline,
            done,
            doneAt,
            order,
        ],
        [
            other.id,
            other.title,
            other.deadline,
            other.done,
            other.doneAt,
            other.order,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        deadline,
        done,
        doneAt,
        order,
    ],);

  factory GoalStepDto.fromJson(Map<String, dynamic> json) => _$GoalStepDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalStepDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

