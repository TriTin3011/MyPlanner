//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'google_login_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleLoginRequest {
  /// Returns a new [GoogleLoginRequest] instance.
  GoogleLoginRequest({

    required  this.idToken,
  });

  @JsonKey(
    
    name: r'idToken',
    required: true,
    includeIfNull: false,
  )


  final String idToken;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is GoogleLoginRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            idToken,
        ],
        [
            other.idToken,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        idToken,
    ],);

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) => _$GoogleLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

