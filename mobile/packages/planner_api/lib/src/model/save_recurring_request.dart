//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/task_tag.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_recurring_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveRecurringRequest {
  /// Returns a new [SaveRecurringRequest] instance.
  SaveRecurringRequest({

    required  this.title,

    required  this.weekdays,

    required  this.tags,

    required  this.active,

    required  this.startDate,
  });

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
    includeIfNull: true,
  unknownEnumValue: TaskTag.unknownDefaultOpenApi,
  )


  final List<TaskTag>? tags;



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




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SaveRecurringRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            title,
            weekdays,
            tags,
            active,
            startDate,
        ],
        [
            other.title,
            other.weekdays,
            other.tags,
            other.active,
            other.startDate,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        title,
        weekdays,
        tags,
        active,
        startDate,
    ],);

  factory SaveRecurringRequest.fromJson(Map<String, dynamic> json) => _$SaveRecurringRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveRecurringRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

