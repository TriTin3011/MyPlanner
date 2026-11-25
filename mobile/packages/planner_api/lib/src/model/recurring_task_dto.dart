//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/task_tag.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'recurring_task_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecurringTaskDto {
  /// Returns a new [RecurringTaskDto] instance.
  RecurringTaskDto({

    required  this.id,

    required  this.title,

    required  this.weekdays,

    required  this.tags,

    required  this.active,

    required  this.startDate,

    required  this.skippedDates,

    required  this.createdAt,
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
    
    name: r'weekdays',
    required: true,
    includeIfNull: false,
  )


  final List<int> weekdays;



  @JsonKey(
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  unknownEnumValue: TaskTag.unknownDefaultOpenApi,
  )


  final List<TaskTag> tags;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    
    name: r'startDate',
    required: true,
    includeIfNull: false,
  )


  final String startDate;



  @JsonKey(
    
    name: r'skippedDates',
    required: true,
    includeIfNull: false,
  )


  final List<String> skippedDates;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is RecurringTaskDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            weekdays,
            tags,
            active,
            startDate,
            skippedDates,
            createdAt,
        ],
        [
            other.id,
            other.title,
            other.weekdays,
            other.tags,
            other.active,
            other.startDate,
            other.skippedDates,
            other.createdAt,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        weekdays,
        tags,
        active,
        startDate,
        skippedDates,
        createdAt,
    ],);

  factory RecurringTaskDto.fromJson(Map<String, dynamic> json) => _$RecurringTaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecurringTaskDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

