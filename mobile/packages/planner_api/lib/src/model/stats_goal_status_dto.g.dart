// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_goal_status_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsGoalStatusDtoCWProxy {
  StatsGoalStatusDto notStarted(int notStarted);

  StatsGoalStatusDto inProgress(int inProgress);

  StatsGoalStatusDto done(int done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsGoalStatusDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsGoalStatusDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsGoalStatusDto call({int notStarted, int inProgress, int done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsGoalStatusDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsGoalStatusDto.copyWith.fieldName(...)`
class _$StatsGoalStatusDtoCWProxyImpl implements _$StatsGoalStatusDtoCWProxy {
  const _$StatsGoalStatusDtoCWProxyImpl(this._value);

  final StatsGoalStatusDto _value;

  @override
  StatsGoalStatusDto notStarted(int notStarted) => this(notStarted: notStarted);

  @override
  StatsGoalStatusDto inProgress(int inProgress) => this(inProgress: inProgress);

  @override
  StatsGoalStatusDto done(int done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsGoalStatusDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsGoalStatusDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsGoalStatusDto call({
    Object? notStarted = const $CopyWithPlaceholder(),
    Object? inProgress = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return StatsGoalStatusDto(
      notStarted: notStarted == const $CopyWithPlaceholder()
          ? _value.notStarted
          // ignore: cast_nullable_to_non_nullable
          : notStarted as int,
      inProgress: inProgress == const $CopyWithPlaceholder()
          ? _value.inProgress
          // ignore: cast_nullable_to_non_nullable
          : inProgress as int,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int,
    );
  }
}

extension $StatsGoalStatusDtoCopyWith on StatsGoalStatusDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsGoalStatusDto.copyWith(...)` or like so:`instanceOfStatsGoalStatusDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsGoalStatusDtoCWProxy get copyWith =>
      _$StatsGoalStatusDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsGoalStatusDto _$StatsGoalStatusDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsGoalStatusDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['notStarted', 'inProgress', 'done'],
      );
      final val = StatsGoalStatusDto(
        notStarted: $checkedConvert('notStarted', (v) => (v as num).toInt()),
        inProgress: $checkedConvert('inProgress', (v) => (v as num).toInt()),
        done: $checkedConvert('done', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$StatsGoalStatusDtoToJson(StatsGoalStatusDto instance) =>
    <String, dynamic>{
      'notStarted': instance.notStarted,
      'inProgress': instance.inProgress,
      'done': instance.done,
    };
