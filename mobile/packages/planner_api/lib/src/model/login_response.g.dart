// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LoginResponseCWProxy {
  LoginResponse accessToken(String accessToken);

  LoginResponse expiresAt(DateTime expiresAt);

  LoginResponse userName(String userName);

  LoginResponse displayName(String? displayName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoginResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoginResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  LoginResponse call({
    String accessToken,
    DateTime expiresAt,
    String userName,
    String? displayName,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLoginResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLoginResponse.copyWith.fieldName(...)`
class _$LoginResponseCWProxyImpl implements _$LoginResponseCWProxy {
  const _$LoginResponseCWProxyImpl(this._value);

  final LoginResponse _value;

  @override
  LoginResponse accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  LoginResponse expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  LoginResponse userName(String userName) => this(userName: userName);

  @override
  LoginResponse displayName(String? displayName) =>
      this(displayName: displayName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoginResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoginResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  LoginResponse call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? userName = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
  }) {
    return LoginResponse(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
      userName: userName == const $CopyWithPlaceholder()
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String,
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String?,
    );
  }
}

extension $LoginResponseCopyWith on LoginResponse {
  /// Returns a callable class that can be used as follows: `instanceOfLoginResponse.copyWith(...)` or like so:`instanceOfLoginResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LoginResponseCWProxy get copyWith => _$LoginResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['accessToken', 'expiresAt', 'userName'],
      );
      final val = LoginResponse(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        expiresAt: $checkedConvert(
          'expiresAt',
          (v) => DateTime.parse(v as String),
        ),
        userName: $checkedConvert('userName', (v) => v as String),
        displayName: $checkedConvert('displayName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'userName': instance.userName,
      'displayName': ?instance.displayName,
    };
