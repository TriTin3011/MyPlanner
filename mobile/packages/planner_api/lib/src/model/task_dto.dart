//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/task_tag.dart';
import 'package:planner_api/src/model/subtask_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'task_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TaskDto {
  /// Returns a new [TaskDto] instance.
  TaskDto({

    required  this.id,

    required  this.title,

    required  this.date,

    required  this.originalDate,

    required  this.done,

    required  this.doneAt,

    required  this.tags,

    required  this.subtasks,

    required  this.recurringId,

    required  this.order,

    required  this.createdAt,

    required  this.updatedAt,
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
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



  @JsonKey(
    
    name: r'originalDate',
    required: true,
    includeIfNull: true,
  )


  final String? originalDate;



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
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  unknownEnumValue: TaskTag.unknownDefaultOpenApi,
  )


  final List<TaskTag> tags;



  @JsonKey(
    
    name: r'subtasks',
    required: true,
    includeIfNull: false,
  )


  final List<SubtaskDto> subtasks;



  @JsonKey(
    
    name: r'recurringId',
    required: true,
    includeIfNull: true,
  )


  final String? recurringId;



  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final int order;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is TaskDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            date,
            originalDate,
            done,
            doneAt,
            tags,
            subtasks,
            recurringId,
            order,
            createdAt,
            updatedAt,
        ],
        [
            other.id,
            other.title,
            other.date,
            other.originalDate,
            other.done,
            other.doneAt,
            other.tags,
            other.subtasks,
            other.recurringId,
            other.order,
            other.createdAt,
            other.updatedAt,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        date,
        originalDate,
        done,
        doneAt,
        tags,
        subtasks,
        recurringId,
        order,
        createdAt,
        updatedAt,
    ],);

  factory TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

