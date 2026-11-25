// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HealthDtoCWProxy {
  HealthDto status(String status);

  HealthDto database(bool database);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthDto call({String status, bool database});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHealthDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHealthDto.copyWith.fieldName(...)`
class _$HealthDtoCWProxyImpl implements _$HealthDtoCWProxy {
  const _$HealthDtoCWProxyImpl(this._value);

  final HealthDto _value;

  @override
  HealthDto status(String status) => this(status: status);

  @override
  HealthDto database(bool database) => this(database: database);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthDto call({
    Object? status = const $CopyWithPlaceholder(),
    Object? database = const $CopyWithPlaceholder(),
  }) {
    return HealthDto(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      database: database == const $CopyWithPlaceholder()
          ? _value.database
          // ignore: cast_nullable_to_non_nullable
          : database as bool,
    );
  }
}

extension $HealthDtoCopyWith on HealthDto {
  /// Returns a callable class that can be used as follows: `instanceOfHealthDto.copyWith(...)` or like so:`instanceOfHealthDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HealthDtoCWProxy get copyWith => _$HealthDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthDto _$HealthDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HealthDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status', 'database']);
      final val = HealthDto(
        status: $checkedConvert('status', (v) => v as String),
        database: $checkedConvert('database', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$HealthDtoToJson(HealthDto instance) => <String, dynamic>{
  'status': instance.status,
  'database': instance.database,
};
