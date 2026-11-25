// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CountDtoCWProxy {
  CountDto count(int count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CountDto call({int count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCountDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCountDto.copyWith.fieldName(...)`
class _$CountDtoCWProxyImpl implements _$CountDtoCWProxy {
  const _$CountDtoCWProxyImpl(this._value);

  final CountDto _value;

  @override
  CountDto count(int count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CountDto call({Object? count = const $CopyWithPlaceholder()}) {
    return CountDto(
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
    );
  }
}

extension $CountDtoCopyWith on CountDto {
  /// Returns a callable class that can be used as follows: `instanceOfCountDto.copyWith(...)` or like so:`instanceOfCountDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CountDtoCWProxy get copyWith => _$CountDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountDto _$CountDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CountDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['count']);
      final val = CountDto(
        count: $checkedConvert('count', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CountDtoToJson(CountDto instance) => <String, dynamic>{
  'count': instance.count,
};
