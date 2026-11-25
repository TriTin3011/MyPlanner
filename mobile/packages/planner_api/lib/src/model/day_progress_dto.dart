//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'day_progress_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DayProgressDto {
  /// Returns a new [DayProgressDto] instance.
  DayProgressDto({

    required  this.date,

    required  this.tasksDone,

    required  this.tasksTotal,

    required  this.percent,

    required  this.hasDeadline,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



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



  @JsonKey(
    
    name: r'hasDeadline',
    required: true,
    includeIfNull: false,
  )


  final bool hasDeadline;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is DayProgressDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            tasksDone,
            tasksTotal,
            percent,
            hasDeadline,
        ],
        [
            other.date,
            other.tasksDone,
            other.tasksTotal,
            other.percent,
            other.hasDeadline,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        tasksDone,
        tasksTotal,
        percent,
        hasDeadline,
    ],);

  factory DayProgressDto.fromJson(Map<String, dynamic> json) => _$DayProgressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DayProgressDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

