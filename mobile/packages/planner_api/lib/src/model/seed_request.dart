//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'seed_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SeedRequest {
  /// Returns a new [SeedRequest] instance.
  SeedRequest({

    required  this.today,
  });

  @JsonKey(
    
    name: r'today',
    required: true,
    includeIfNull: false,
  )


  final String today;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is SeedRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            today,
        ],
        [
            other.today,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        today,
    ],);

  factory SeedRequest.fromJson(Map<String, dynamic> json) => _$SeedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SeedRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

