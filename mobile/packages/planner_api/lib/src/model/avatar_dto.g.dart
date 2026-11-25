// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AvatarDtoCWProxy {
  AvatarDto avatarUrl(String? avatarUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvatarDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvatarDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AvatarDto call({String? avatarUrl});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAvatarDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAvatarDto.copyWith.fieldName(...)`
class _$AvatarDtoCWProxyImpl implements _$AvatarDtoCWProxy {
  const _$AvatarDtoCWProxyImpl(this._value);

  final AvatarDto _value;

  @override
  AvatarDto avatarUrl(String? avatarUrl) => this(avatarUrl: avatarUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvatarDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvatarDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AvatarDto call({Object? avatarUrl = const $CopyWithPlaceholder()}) {
    return AvatarDto(
      avatarUrl: avatarUrl == const $CopyWithPlaceholder()
          ? _value.avatarUrl
          // ignore: cast_nullable_to_non_nullable
          : avatarUrl as String?,
    );
  }
}

extension $AvatarDtoCopyWith on AvatarDto {
  /// Returns a callable class that can be used as follows: `instanceOfAvatarDto.copyWith(...)` or like so:`instanceOfAvatarDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AvatarDtoCWProxy get copyWith => _$AvatarDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarDto _$AvatarDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AvatarDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['avatarUrl']);
      final val = AvatarDto(
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AvatarDtoToJson(AvatarDto instance) => <String, dynamic>{
  'avatarUrl': instance.avatarUrl,
};
