// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CurrentUserDtoCWProxy {
  CurrentUserDto userName(String userName);

  CurrentUserDto avatarUrl(String? avatarUrl);

  CurrentUserDto displayName(String? displayName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CurrentUserDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CurrentUserDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CurrentUserDto call({
    String userName,
    String? avatarUrl,
    String? displayName,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCurrentUserDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCurrentUserDto.copyWith.fieldName(...)`
class _$CurrentUserDtoCWProxyImpl implements _$CurrentUserDtoCWProxy {
  const _$CurrentUserDtoCWProxyImpl(this._value);

  final CurrentUserDto _value;

  @override
  CurrentUserDto userName(String userName) => this(userName: userName);

  @override
  CurrentUserDto avatarUrl(String? avatarUrl) => this(avatarUrl: avatarUrl);

  @override
  CurrentUserDto displayName(String? displayName) =>
      this(displayName: displayName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CurrentUserDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CurrentUserDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CurrentUserDto call({
    Object? userName = const $CopyWithPlaceholder(),
    Object? avatarUrl = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
  }) {
    return CurrentUserDto(
      userName: userName == const $CopyWithPlaceholder()
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String,
      avatarUrl: avatarUrl == const $CopyWithPlaceholder()
          ? _value.avatarUrl
          // ignore: cast_nullable_to_non_nullable
          : avatarUrl as String?,
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String?,
    );
  }
}

extension $CurrentUserDtoCopyWith on CurrentUserDto {
  /// Returns a callable class that can be used as follows: `instanceOfCurrentUserDto.copyWith(...)` or like so:`instanceOfCurrentUserDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CurrentUserDtoCWProxy get copyWith => _$CurrentUserDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserDto _$CurrentUserDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrentUserDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['userName']);
      final val = CurrentUserDto(
        userName: $checkedConvert('userName', (v) => v as String),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
        displayName: $checkedConvert('displayName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CurrentUserDtoToJson(CurrentUserDto instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'avatarUrl': ?instance.avatarUrl,
      'displayName': ?instance.displayName,
    };
