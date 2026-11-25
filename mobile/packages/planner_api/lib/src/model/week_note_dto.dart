//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'week_note_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeekNoteDto {
  /// Returns a new [WeekNoteDto] instance.
  WeekNoteDto({

    required  this.weekKey,

    required  this.content,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'weekKey',
    required: true,
    includeIfNull: false,
  )


  final String weekKey;



  @JsonKey(
    
    name: r'content',
    required: true,
    includeIfNull: false,
  )


  final String content;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is WeekNoteDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            weekKey,
            content,
            updatedAt,
        ],
        [
            other.weekKey,
            other.content,
            other.updatedAt,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        weekKey,
        content,
        updatedAt,
    ],);

  factory WeekNoteDto.fromJson(Map<String, dynamic> json) => _$WeekNoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WeekNoteDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

