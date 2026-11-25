//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'avatar_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AvatarDto {
  /// Returns a new [AvatarDto] instance.
  AvatarDto({

    required  this.avatarUrl,
  });

  @JsonKey(
    
    name: r'avatarUrl',
    required: true,
    includeIfNull: true,
  )


  final String? avatarUrl;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is AvatarDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            avatarUrl,
        ],
        [
            other.avatarUrl,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        avatarUrl,
    ],);

  factory AvatarDto.fromJson(Map<String, dynamic> json) => _$AvatarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

