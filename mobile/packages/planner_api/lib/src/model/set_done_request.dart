//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'set_done_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SetDoneRequest {
  /// Returns a new [SetDoneRequest] instance.
  SetDoneRequest({

    required  this.done,
  });

  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SetDoneRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            done,
        ],
        [
            other.done,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        done,
    ],);

  factory SetDoneRequest.fromJson(Map<String, dynamic> json) => _$SetDoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SetDoneRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

