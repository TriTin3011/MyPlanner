// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateProfileRequestCWProxy {
  UpdateProfileRequest displayName(String? displayName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateProfileRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateProfileRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateProfileRequest call({String? displayName});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateProfileRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateProfileRequest.copyWith.fieldName(...)`
class _$UpdateProfileRequestCWProxyImpl
    implements _$UpdateProfileRequestCWProxy {
  const _$UpdateProfileRequestCWProxyImpl(this._value);

  final UpdateProfileRequest _value;

  @override
  UpdateProfileRequest displayName(String? displayName) =>
      this(displayName: displayName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateProfileRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateProfileRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateProfileRequest call({
    Object? displayName = const $CopyWithPlaceholder(),
  }) {
    return UpdateProfileRequest(
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String?,
    );
  }
}

extension $UpdateProfileRequestCopyWith on UpdateProfileRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateProfileRequest.copyWith(...)` or like so:`instanceOfUpdateProfileRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateProfileRequestCWProxy get copyWith =>
      _$UpdateProfileRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateProfileRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['displayName']);
  final val = UpdateProfileRequest(
    displayName: $checkedConvert('displayName', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{'displayName': instance.displayName};
