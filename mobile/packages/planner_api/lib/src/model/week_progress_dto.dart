//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'week_progress_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeekProgressDto {
  /// Returns a new [WeekProgressDto] instance.
  WeekProgressDto({

    required  this.weekKey,

    required  this.monday,

    required  this.tasksDone,

    required  this.tasksTotal,

    required  this.percent,
  });

  @JsonKey(
    
    name: r'weekKey',
    required: true,
    includeIfNull: false,
  )


  final String weekKey;



  @JsonKey(
    
    name: r'monday',
    required: true,
    includeIfNull: false,
  )


  final String monday;



  @JsonKey(
    
    name: r'tasksDone',
    required: true,
    includeIfNull: false,
  )


  final int tasksDone;



  @JsonKey(
    
    name: r'tasksTotal',
    required: true,
    includeIfNull: false,
  )


  final int tasksTotal;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is WeekProgressDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            weekKey,
            monday,
            tasksDone,
            tasksTotal,
            percent,
        ],
        [
            other.weekKey,
            other.monday,
            other.tasksDone,
            other.tasksTotal,
            other.percent,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        weekKey,
        monday,
        tasksDone,
        tasksTotal,
        percent,
    ],);

  factory WeekProgressDto.fromJson(Map<String, dynamic> json) => _$WeekProgressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WeekProgressDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

