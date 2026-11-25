//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'subtask_input.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubtaskInput {
  /// Returns a new [SubtaskInput] instance.
  SubtaskInput({

    required  this.id,

    required  this.title,

    required  this.done,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: true,
  )


  final String? id;



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




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SubtaskInput &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            done,
        ],
        [
            other.id,
            other.title,
            other.done,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        done,
    ],);

  factory SubtaskInput.fromJson(Map<String, dynamic> json) => _$SubtaskInputFromJson(json);

  Map<String, dynamic> toJson() => _$SubtaskInputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

