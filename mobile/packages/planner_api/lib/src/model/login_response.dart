//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'login_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LoginResponse {
  /// Returns a new [LoginResponse] instance.
  LoginResponse({

    required  this.accessToken,

    required  this.expiresAt,

    required  this.userName,

     this.displayName,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;



  @JsonKey(
    
    name: r'userName',
    required: true,
    includeIfNull: false,
  )


  final String userName;



  @JsonKey(
    
    name: r'displayName',
    required: false,
    includeIfNull: false,
  )


  final String? displayName;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is LoginResponse &&
      runtimeType == other.runtimeType &&
      equals(
        [
            accessToken,
            expiresAt,
            userName,
            displayName,
        ],
        [
            other.accessToken,
            other.expiresAt,
            other.userName,
            other.displayName,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        accessToken,
        expiresAt,
        userName,
        displayName,
    ],);

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

