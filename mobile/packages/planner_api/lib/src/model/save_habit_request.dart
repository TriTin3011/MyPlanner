//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_habit_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveHabitRequest {
  /// Returns a new [SaveHabitRequest] instance.
  SaveHabitRequest({

    required  this.title,

     this.active = true,

     this.startDate,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    defaultValue: true,
    name: r'active',
    required: false,
    includeIfNull: false,
  )


  final bool? active;



  @JsonKey(
    
    name: r'startDate',
    required: false,
    includeIfNull: false,
  )


  final String? startDate;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SaveHabitRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            title,
            active,
            startDate,
        ],
        [
            other.title,
            other.active,
            other.startDate,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        title,
        active,
        startDate,
    ],);

  factory SaveHabitRequest.fromJson(Map<String, dynamic> json) => _$SaveHabitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveHabitRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

