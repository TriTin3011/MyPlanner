//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'subtask_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubtaskDto {
  /// Returns a new [SubtaskDto] instance.
  SubtaskDto({

    required  this.id,

    required  this.title,

    required  this.done,
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
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SubtaskDto &&
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

  factory SubtaskDto.fromJson(Map<String, dynamic> json) => _$SubtaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubtaskDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

