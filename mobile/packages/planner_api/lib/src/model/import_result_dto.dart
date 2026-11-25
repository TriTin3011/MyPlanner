//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'import_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ImportResultDto {
  /// Returns a new [ImportResultDto] instance.
  ImportResultDto({

    required  this.tasks,

    required  this.habits,

    required  this.habitLogs,

    required  this.goals,
  });

  @JsonKey(
    
    name: r'tasks',
    required: true,
    includeIfNull: false,
  )


  final int tasks;



  @JsonKey(
    
    name: r'habits',
    required: true,
    includeIfNull: false,
  )


  final int habits;



  @JsonKey(
    
    name: r'habitLogs',
    required: true,
    includeIfNull: false,
  )


  final int habitLogs;



  @JsonKey(
    
    name: r'goals',
    required: true,
    includeIfNull: false,
  )


  final int goals;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is ImportResultDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            tasks,
            habits,
            habitLogs,
            goals,
        ],
        [
            other.tasks,
            other.habits,
            other.habitLogs,
            other.goals,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        tasks,
        habits,
        habitLogs,
        goals,
    ],);

  factory ImportResultDto.fromJson(Map<String, dynamic> json) => _$ImportResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImportResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

