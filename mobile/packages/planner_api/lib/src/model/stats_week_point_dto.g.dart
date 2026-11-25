// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_week_point_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsWeekPointDtoCWProxy {
  StatsWeekPointDto weekKey(String weekKey);

  StatsWeekPointDto monday(String monday);

  StatsWeekPointDto done(int done);

  StatsWeekPointDto total(int total);

  StatsWeekPointDto percent(int percent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsWeekPointDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsWeekPointDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsWeekPointDto call({
    String weekKey,
    String monday,
    int done,
    int total,
    int percent,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsWeekPointDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsWeekPointDto.copyWith.fieldName(...)`
class _$StatsWeekPointDtoCWProxyImpl implements _$StatsWeekPointDtoCWProxy {
  const _$StatsWeekPointDtoCWProxyImpl(this._value);

  final StatsWeekPointDto _value;

  @override
  StatsWeekPointDto weekKey(String weekKey) => this(weekKey: weekKey);

  @override
  StatsWeekPointDto monday(String monday) => this(monday: monday);

  @override
  StatsWeekPointDto done(int done) => this(done: done);

  @override
  StatsWeekPointDto total(int total) => this(total: total);

  @override
  StatsWeekPointDto percent(int percent) => this(percent: percent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsWeekPointDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsWeekPointDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsWeekPointDto call({
    Object? weekKey = const $CopyWithPlaceholder(),
    Object? monday = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
  }) {
    return StatsWeekPointDto(
      weekKey: weekKey == const $CopyWithPlaceholder()
          ? _value.weekKey
          // ignore: cast_nullable_to_non_nullable
          : weekKey as String,
      monday: monday == const $CopyWithPlaceholder()
          ? _value.monday
          // ignore: cast_nullable_to_non_nullable
          : monday as String,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
    );
  }
}

extension $StatsWeekPointDtoCopyWith on StatsWeekPointDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsWeekPointDto.copyWith(...)` or like so:`instanceOfStatsWeekPointDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsWeekPointDtoCWProxy get copyWith =>
      _$StatsWeekPointDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsWeekPointDto _$StatsWeekPointDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsWeekPointDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['weekKey', 'monday', 'done', 'total', 'percent'],
      );
      final val = StatsWeekPointDto(
        weekKey: $checkedConvert('weekKey', (v) => v as String),
        monday: $checkedConvert('monday', (v) => v as String),
        done: $checkedConvert('done', (v) => (v as num).toInt()),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$StatsWeekPointDtoToJson(StatsWeekPointDto instance) =>
    <String, dynamic>{
      'weekKey': instance.weekKey,
      'monday': instance.monday,
      'done': instance.done,
      'total': instance.total,
      'percent': instance.percent,
    };
