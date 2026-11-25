// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_weekday_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsWeekdayDtoCWProxy {
  StatsWeekdayDto weekday(int weekday);

  StatsWeekdayDto averageDone(double averageDone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsWeekdayDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsWeekdayDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsWeekdayDto call({int weekday, double averageDone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsWeekdayDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsWeekdayDto.copyWith.fieldName(...)`
class _$StatsWeekdayDtoCWProxyImpl implements _$StatsWeekdayDtoCWProxy {
  const _$StatsWeekdayDtoCWProxyImpl(this._value);

  final StatsWeekdayDto _value;

  @override
  StatsWeekdayDto weekday(int weekday) => this(weekday: weekday);

  @override
  StatsWeekdayDto averageDone(double averageDone) =>
      this(averageDone: averageDone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsWeekdayDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsWeekdayDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsWeekdayDto call({
    Object? weekday = const $CopyWithPlaceholder(),
    Object? averageDone = const $CopyWithPlaceholder(),
  }) {
    return StatsWeekdayDto(
      weekday: weekday == const $CopyWithPlaceholder()
          ? _value.weekday
          // ignore: cast_nullable_to_non_nullable
          : weekday as int,
      averageDone: averageDone == const $CopyWithPlaceholder()
          ? _value.averageDone
          // ignore: cast_nullable_to_non_nullable
          : averageDone as double,
    );
  }
}

extension $StatsWeekdayDtoCopyWith on StatsWeekdayDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsWeekdayDto.copyWith(...)` or like so:`instanceOfStatsWeekdayDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsWeekdayDtoCWProxy get copyWith => _$StatsWeekdayDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsWeekdayDto _$StatsWeekdayDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsWeekdayDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['weekday', 'averageDone']);
      final val = StatsWeekdayDto(
        weekday: $checkedConvert('weekday', (v) => (v as num).toInt()),
        averageDone: $checkedConvert(
          'averageDone',
          (v) => (v as num).toDouble(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StatsWeekdayDtoToJson(StatsWeekdayDto instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'averageDone': instance.averageDone,
    };
