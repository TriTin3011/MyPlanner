// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seed_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SeedRequestCWProxy {
  SeedRequest today(String today);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SeedRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SeedRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SeedRequest call({String today});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSeedRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSeedRequest.copyWith.fieldName(...)`
class _$SeedRequestCWProxyImpl implements _$SeedRequestCWProxy {
  const _$SeedRequestCWProxyImpl(this._value);

  final SeedRequest _value;

  @override
  SeedRequest today(String today) => this(today: today);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SeedRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SeedRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SeedRequest call({Object? today = const $CopyWithPlaceholder()}) {
    return SeedRequest(
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as String,
    );
  }
}

extension $SeedRequestCopyWith on SeedRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSeedRequest.copyWith(...)` or like so:`instanceOfSeedRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SeedRequestCWProxy get copyWith => _$SeedRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeedRequest _$SeedRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SeedRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['today']);
      final val = SeedRequest(
        today: $checkedConvert('today', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SeedRequestToJson(SeedRequest instance) =>
    <String, dynamic>{'today': instance.today};
