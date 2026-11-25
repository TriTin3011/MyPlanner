//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/deadline_kind.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'deadline_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeadlineDto {
  /// Returns a new [DeadlineDto] instance.
  DeadlineDto({

    required  this.date,

    required  this.kind,

    required  this.goalId,

    required  this.goalTitle,

    required  this.title,

    required  this.done,

    required  this.overdue,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  unknownEnumValue: DeadlineKind.unknownDefaultOpenApi,
  )


  final DeadlineKind kind;



  @JsonKey(
    
    name: r'goalId',
    required: true,
    includeIfNull: false,
  )


  final String goalId;



  @JsonKey(
    
    name: r'goalTitle',
    required: true,
    includeIfNull: false,
  )


  final String goalTitle;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;



  @JsonKey(
    
    name: r'overdue',
    required: true,
    includeIfNull: false,
  )


  final bool overdue;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is DeadlineDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            kind,
            goalId,
            goalTitle,
            title,
            done,
            overdue,
        ],
        [
            other.date,
            other.kind,
            other.goalId,
            other.goalTitle,
            other.title,
            other.done,
            other.overdue,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        kind,
        goalId,
        goalTitle,
        title,
        done,
        overdue,
    ],);

  factory DeadlineDto.fromJson(Map<String, dynamic> json) => _$DeadlineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeadlineDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

