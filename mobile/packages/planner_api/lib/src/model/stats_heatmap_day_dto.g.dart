// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_heatmap_day_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsHeatmapDayDtoCWProxy {
  StatsHeatmapDayDto date(String date);

  StatsHeatmapDayDto done(int done);

  StatsHeatmapDayDto level(int level);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsHeatmapDayDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsHeatmapDayDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsHeatmapDayDto call({String date, int done, int level});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsHeatmapDayDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsHeatmapDayDto.copyWith.fieldName(...)`
class _$StatsHeatmapDayDtoCWProxyImpl implements _$StatsHeatmapDayDtoCWProxy {
  const _$StatsHeatmapDayDtoCWProxyImpl(this._value);

  final StatsHeatmapDayDto _value;

  @override
  StatsHeatmapDayDto date(String date) => this(date: date);

  @override
  StatsHeatmapDayDto done(int done) => this(done: done);

  @override
  StatsHeatmapDayDto level(int level) => this(level: level);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsHeatmapDayDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsHeatmapDayDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsHeatmapDayDto call({
    Object? date = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? level = const $CopyWithPlaceholder(),
  }) {
    return StatsHeatmapDayDto(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int,
      level: level == const $CopyWithPlaceholder()
          ? _value.level
          // ignore: cast_nullable_to_non_nullable
          : level as int,
    );
  }
}

extension $StatsHeatmapDayDtoCopyWith on StatsHeatmapDayDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsHeatmapDayDto.copyWith(...)` or like so:`instanceOfStatsHeatmapDayDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsHeatmapDayDtoCWProxy get copyWith =>
      _$StatsHeatmapDayDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsHeatmapDayDto _$StatsHeatmapDayDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsHeatmapDayDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['date', 'done', 'level']);
      final val = StatsHeatmapDayDto(
        date: $checkedConvert('date', (v) => v as String),
        done: $checkedConvert('done', (v) => (v as num).toInt()),
        level: $checkedConvert('level', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$StatsHeatmapDayDtoToJson(StatsHeatmapDayDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'done': instance.done,
      'level': instance.level,
    };
