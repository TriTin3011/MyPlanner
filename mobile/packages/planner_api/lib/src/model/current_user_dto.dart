//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'current_user_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CurrentUserDto {
  /// Returns a new [CurrentUserDto] instance.
  CurrentUserDto({

    required  this.userName,

     this.avatarUrl,

     this.displayName,
  });

  @JsonKey(
    
    name: r'userName',
    required: true,
    includeIfNull: false,
  )


  final String userName;



  @JsonKey(
    
    name: r'avatarUrl',
    required: false,
    includeIfNull: false,
  )


  final String? avatarUrl;



  @JsonKey(
    
    name: r'displayName',
    required: false,
    includeIfNull: false,
  )


  final String? displayName;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is CurrentUserDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            userName,
            avatarUrl,
            displayName,
        ],
        [
            other.userName,
            other.avatarUrl,
            other.displayName,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        userName,
        avatarUrl,
        displayName,
    ],);

  factory CurrentUserDto.fromJson(Map<String, dynamic> json) => _$CurrentUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

