// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_goals_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsGoalsDtoCWProxy {
  StatsGoalsDto total(int total);

  StatsGoalsDto percentDone(int percentDone);

  StatsGoalsDto byStatus(StatsGoalStatusDto byStatus);

  StatsGoalsDto byArea(List<StatsGoalAreaDto> byArea);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsGoalsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsGoalsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsGoalsDto call({
    int total,
    int percentDone,
    StatsGoalStatusDto byStatus,
    List<StatsGoalAreaDto> byArea,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsGoalsDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsGoalsDto.copyWith.fieldName(...)`
class _$StatsGoalsDtoCWProxyImpl implements _$StatsGoalsDtoCWProxy {
  const _$StatsGoalsDtoCWProxyImpl(this._value);

  final StatsGoalsDto _value;

  @override
  StatsGoalsDto total(int total) => this(total: total);

  @override
  StatsGoalsDto percentDone(int percentDone) => this(percentDone: percentDone);

  @override
  StatsGoalsDto byStatus(StatsGoalStatusDto byStatus) =>
      this(byStatus: byStatus);

  @override
  StatsGoalsDto byArea(List<StatsGoalAreaDto> byArea) => this(byArea: byArea);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsGoalsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsGoalsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsGoalsDto call({
    Object? total = const $CopyWithPlaceholder(),
    Object? percentDone = const $CopyWithPlaceholder(),
    Object? byStatus = const $CopyWithPlaceholder(),
    Object? byArea = const $CopyWithPlaceholder(),
  }) {
    return StatsGoalsDto(
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
      percentDone: percentDone == const $CopyWithPlaceholder()
          ? _value.percentDone
          // ignore: cast_nullable_to_non_nullable
          : percentDone as int,
      byStatus: byStatus == const $CopyWithPlaceholder()
          ? _value.byStatus
          // ignore: cast_nullable_to_non_nullable
          : byStatus as StatsGoalStatusDto,
      byArea: byArea == const $CopyWithPlaceholder()
          ? _value.byArea
          // ignore: cast_nullable_to_non_nullable
          : byArea as List<StatsGoalAreaDto>,
    );
  }
}

extension $StatsGoalsDtoCopyWith on StatsGoalsDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsGoalsDto.copyWith(...)` or like so:`instanceOfStatsGoalsDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsGoalsDtoCWProxy get copyWith => _$StatsGoalsDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsGoalsDto _$StatsGoalsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsGoalsDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['total', 'percentDone', 'byStatus', 'byArea'],
      );
      final val = StatsGoalsDto(
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        percentDone: $checkedConvert('percentDone', (v) => (v as num).toInt()),
        byStatus: $checkedConvert(
          'byStatus',
          (v) => StatsGoalStatusDto.fromJson(v as Map<String, dynamic>),
        ),
        byArea: $checkedConvert(
          'byArea',
          (v) => (v as List<dynamic>)
              .map((e) => StatsGoalAreaDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StatsGoalsDtoToJson(StatsGoalsDto instance) =>
    <String, dynamic>{
      'total': instance.total,
      'percentDone': instance.percentDone,
      'byStatus': instance.byStatus.toJson(),
      'byArea': instance.byArea.map((e) => e.toJson()).toList(),
    };
