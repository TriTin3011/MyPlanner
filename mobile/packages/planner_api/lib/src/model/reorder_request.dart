//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'reorder_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReorderRequest {
  /// Returns a new [ReorderRequest] instance.
  ReorderRequest({

    required  this.ids,
  });

  @JsonKey(
    
    name: r'ids',
    required: true,
    includeIfNull: false,
  )


  final List<String> ids;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is ReorderRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            ids,
        ],
        [
            other.ids,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        ids,
    ],);

  factory ReorderRequest.fromJson(Map<String, dynamic> json) => _$ReorderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

