// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_goal_area_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsGoalAreaDtoCWProxy {
  StatsGoalAreaDto area(LifeArea area);

  StatsGoalAreaDto done(int done);

  StatsGoalAreaDto total(int total);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsGoalAreaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsGoalAreaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsGoalAreaDto call({LifeArea area, int done, int total});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsGoalAreaDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsGoalAreaDto.copyWith.fieldName(...)`
class _$StatsGoalAreaDtoCWProxyImpl implements _$StatsGoalAreaDtoCWProxy {
  const _$StatsGoalAreaDtoCWProxyImpl(this._value);

  final StatsGoalAreaDto _value;

  @override
  StatsGoalAreaDto area(LifeArea area) => this(area: area);

  @override
  StatsGoalAreaDto done(int done) => this(done: done);

  @override
  StatsGoalAreaDto total(int total) => this(total: total);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsGoalAreaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsGoalAreaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsGoalAreaDto call({
    Object? area = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
  }) {
    return StatsGoalAreaDto(
      area: area == const $CopyWithPlaceholder()
          ? _value.area
          // ignore: cast_nullable_to_non_nullable
          : area as LifeArea,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
    );
  }
}

extension $StatsGoalAreaDtoCopyWith on StatsGoalAreaDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsGoalAreaDto.copyWith(...)` or like so:`instanceOfStatsGoalAreaDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsGoalAreaDtoCWProxy get copyWith => _$StatsGoalAreaDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsGoalAreaDto _$StatsGoalAreaDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsGoalAreaDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['area', 'done', 'total']);
      final val = StatsGoalAreaDto(
        area: $checkedConvert(
          'area',
          (v) => $enumDecode(
            _$LifeAreaEnumMap,
            v,
            unknownValue: LifeArea.unknownDefaultOpenApi,
          ),
        ),
        done: $checkedConvert('done', (v) => (v as num).toInt()),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$StatsGoalAreaDtoToJson(StatsGoalAreaDto instance) =>
    <String, dynamic>{
      'area': _$LifeAreaEnumMap[instance.area]!,
      'done': instance.done,
      'total': instance.total,
    };

const _$LifeAreaEnumMap = {
  LifeArea.health: 'health',
  LifeArea.finance: 'finance',
  LifeArea.career: 'career',
  LifeArea.growth: 'growth',
  LifeArea.relationship: 'relationship',
  LifeArea.learning: 'learning',
  LifeArea.family: 'family',
  LifeArea.hobby: 'hobby',
  LifeArea.unknownDefaultOpenApi: 'unknown_default_open_api',
};
