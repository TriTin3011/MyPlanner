//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'week_delete_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeekDeleteResultDto {
  /// Returns a new [WeekDeleteResultDto] instance.
  WeekDeleteResultDto({

    required  this.tasks,

    required  this.habitLogs,

    required  this.notes,
  });

  @JsonKey(
    
    name: r'tasks',
    required: true,
    includeIfNull: false,
  )


  final int tasks;



  @JsonKey(
    
    name: r'habitLogs',
    required: true,
    includeIfNull: false,
  )


  final int habitLogs;



  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final int notes;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is WeekDeleteResultDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            tasks,
            habitLogs,
            notes,
        ],
        [
            other.tasks,
            other.habitLogs,
            other.notes,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        tasks,
        habitLogs,
        notes,
    ],);

  factory WeekDeleteResultDto.fromJson(Map<String, dynamic> json) => _$WeekDeleteResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WeekDeleteResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

