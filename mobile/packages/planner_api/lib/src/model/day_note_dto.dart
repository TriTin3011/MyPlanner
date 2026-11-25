//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'day_note_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DayNoteDto {
  /// Returns a new [DayNoteDto] instance.
  DayNoteDto({

    required  this.date,

    required  this.content,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



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
      other is DayNoteDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            content,
            updatedAt,
        ],
        [
            other.date,
            other.content,
            other.updatedAt,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        content,
        updatedAt,
    ],);

  factory DayNoteDto.fromJson(Map<String, dynamic> json) => _$DayNoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DayNoteDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

