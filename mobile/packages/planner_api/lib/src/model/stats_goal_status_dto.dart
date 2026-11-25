//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'stats_goal_status_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatsGoalStatusDto {
  /// Returns a new [StatsGoalStatusDto] instance.
  StatsGoalStatusDto({

    required  this.notStarted,

    required  this.inProgress,

    required  this.done,
  });

  @JsonKey(
    
    name: r'notStarted',
    required: true,
    includeIfNull: false,
  )


  final int notStarted;



  @JsonKey(
    
    name: r'inProgress',
    required: true,
    includeIfNull: false,
  )


  final int inProgress;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final int done;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is StatsGoalStatusDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            notStarted,
            inProgress,
            done,
        ],
        [
            other.notStarted,
            other.inProgress,
            other.done,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        notStarted,
        inProgress,
        done,
    ],);

  factory StatsGoalStatusDto.fromJson(Map<String, dynamic> json) => _$StatsGoalStatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatsGoalStatusDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

