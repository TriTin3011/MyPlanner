//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/task_tag.dart';
import 'package:planner_api/src/model/subtask_input.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_task_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveTaskRequest {
  /// Returns a new [SaveTaskRequest] instance.
  SaveTaskRequest({

    required  this.title,

    required  this.date,

    required  this.tags,

    required  this.subtasks,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



  @JsonKey(
    
    name: r'tags',
    required: true,
    includeIfNull: true,
  unknownEnumValue: TaskTag.unknownDefaultOpenApi,
  )


  final List<TaskTag>? tags;



  @JsonKey(
    
    name: r'subtasks',
    required: true,
    includeIfNull: true,
  )


  final List<SubtaskInput>? subtasks;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SaveTaskRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            title,
            date,
            tags,
            subtasks,
        ],
        [
            other.title,
            other.date,
            other.tags,
            other.subtasks,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        title,
        date,
        tags,
        subtasks,
    ],);

  factory SaveTaskRequest.fromJson(Map<String, dynamic> json) => _$SaveTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveTaskRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

