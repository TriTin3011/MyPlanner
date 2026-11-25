//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_note_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveNoteRequest {
  /// Returns a new [SaveNoteRequest] instance.
  SaveNoteRequest({

    required  this.content,
  });

  @JsonKey(
    
    name: r'content',
    required: true,
    includeIfNull: false,
  )


  final String content;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SaveNoteRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            content,
        ],
        [
            other.content,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        content,
    ],);

  factory SaveNoteRequest.fromJson(Map<String, dynamic> json) => _$SaveNoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveNoteRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

