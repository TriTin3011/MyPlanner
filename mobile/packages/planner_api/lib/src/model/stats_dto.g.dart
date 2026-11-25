// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsDtoCWProxy {
  StatsDto range(String range);

  StatsDto from(String from);

  StatsDto to(String to);

  StatsDto previousFrom(String previousFrom);

  StatsDto previousTo(String previousTo);

  StatsDto hero(StatsHeroDto hero);

  StatsDto kpis(StatsKpisDto kpis);

  StatsDto trend(StatsTrendDto trend);

  StatsDto heatmap(List<StatsHeatmapDayDto> heatmap);

  StatsDto weekdayProductivity(List<StatsWeekdayDto> weekdayProductivity);

  StatsDto habitConsistency(List<StatsHabitDto> habitConsistency);

  StatsDto goals(StatsGoalsDto goals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsDto call({
    String range,
    String from,
    String to,
    String previousFrom,
    String previousTo,
    StatsHeroDto hero,
    StatsKpisDto kpis,
    StatsTrendDto trend,
    List<StatsHeatmapDayDto> heatmap,
    List<StatsWeekdayDto> weekdayProductivity,
    List<StatsHabitDto> habitConsistency,
    StatsGoalsDto goals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsDto.copyWith.fieldName(...)`
class _$StatsDtoCWProxyImpl implements _$StatsDtoCWProxy {
  const _$StatsDtoCWProxyImpl(this._value);

  final StatsDto _value;

  @override
  StatsDto range(String range) => this(range: range);

  @override
  StatsDto from(String from) => this(from: from);

  @override
  StatsDto to(String to) => this(to: to);

  @override
  StatsDto previousFrom(String previousFrom) =>
      this(previousFrom: previousFrom);

  @override
  StatsDto previousTo(String previousTo) => this(previousTo: previousTo);

  @override
  StatsDto hero(StatsHeroDto hero) => this(hero: hero);

  @override
  StatsDto kpis(StatsKpisDto kpis) => this(kpis: kpis);

  @override
  StatsDto trend(StatsTrendDto trend) => this(trend: trend);

  @override
  StatsDto heatmap(List<StatsHeatmapDayDto> heatmap) => this(heatmap: heatmap);

  @override
  StatsDto weekdayProductivity(List<StatsWeekdayDto> weekdayProductivity) =>
      this(weekdayProductivity: weekdayProductivity);

  @override
  StatsDto habitConsistency(List<StatsHabitDto> habitConsistency) =>
      this(habitConsistency: habitConsistency);

  @override
  StatsDto goals(StatsGoalsDto goals) => this(goals: goals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsDto call({
    Object? range = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? previousFrom = const $CopyWithPlaceholder(),
    Object? previousTo = const $CopyWithPlaceholder(),
    Object? hero = const $CopyWithPlaceholder(),
    Object? kpis = const $CopyWithPlaceholder(),
    Object? trend = const $CopyWithPlaceholder(),
    Object? heatmap = const $CopyWithPlaceholder(),
    Object? weekdayProductivity = const $CopyWithPlaceholder(),
    Object? habitConsistency = const $CopyWithPlaceholder(),
    Object? goals = const $CopyWithPlaceholder(),
  }) {
    return StatsDto(
      range: range == const $CopyWithPlaceholder()
          ? _value.range
          // ignore: cast_nullable_to_non_nullable
          : range as String,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      previousFrom: previousFrom == const $CopyWithPlaceholder()
          ? _value.previousFrom
          // ignore: cast_nullable_to_non_nullable
          : previousFrom as String,
      previousTo: previousTo == const $CopyWithPlaceholder()
          ? _value.previousTo
          // ignore: cast_nullable_to_non_nullable
          : previousTo as String,
      hero: hero == const $CopyWithPlaceholder()
          ? _value.hero
          // ignore: cast_nullable_to_non_nullable
          : hero as StatsHeroDto,
      kpis: kpis == const $CopyWithPlaceholder()
          ? _value.kpis
          // ignore: cast_nullable_to_non_nullable
          : kpis as StatsKpisDto,
      trend: trend == const $CopyWithPlaceholder()
          ? _value.trend
          // ignore: cast_nullable_to_non_nullable
          : trend as StatsTrendDto,
      heatmap: heatmap == const $CopyWithPlaceholder()
          ? _value.heatmap
          // ignore: cast_nullable_to_non_nullable
          : heatmap as List<StatsHeatmapDayDto>,
      weekdayProductivity: weekdayProductivity == const $CopyWithPlaceholder()
          ? _value.weekdayProductivity
          // ignore: cast_nullable_to_non_nullable
          : weekdayProductivity as List<StatsWeekdayDto>,
      habitConsistency: habitConsistency == const $CopyWithPlaceholder()
          ? _value.habitConsistency
          // ignore: cast_nullable_to_non_nullable
          : habitConsistency as List<StatsHabitDto>,
      goals: goals == const $CopyWithPlaceholder()
          ? _value.goals
          // ignore: cast_nullable_to_non_nullable
          : goals as StatsGoalsDto,
    );
  }
}

extension $StatsDtoCopyWith on StatsDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsDto.copyWith(...)` or like so:`instanceOfStatsDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsDtoCWProxy get copyWith => _$StatsDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsDto _$StatsDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'StatsDto',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'range',
        'from',
        'to',
        'previousFrom',
        'previousTo',
        'hero',
        'kpis',
        'trend',
        'heatmap',
        'weekdayProductivity',
        'habitConsistency',
        'goals',
      ],
    );
    final val = StatsDto(
      range: $checkedConvert('range', (v) => v as String),
      from: $checkedConvert('from', (v) => v as String),
      to: $checkedConvert('to', (v) => v as String),
      previousFrom: $checkedConvert('previousFrom', (v) => v as String),
      previousTo: $checkedConvert('previousTo', (v) => v as String),
      hero: $checkedConvert(
        'hero',
        (v) => StatsHeroDto.fromJson(v as Map<String, dynamic>),
      ),
      kpis: $checkedConvert(
        'kpis',
        (v) => StatsKpisDto.fromJson(v as Map<String, dynamic>),
      ),
      trend: $checkedConvert(
        'trend',
        (v) => StatsTrendDto.fromJson(v as Map<String, dynamic>),
      ),
      heatmap: $checkedConvert(
        'heatmap',
        (v) => (v as List<dynamic>)
            .map((e) => StatsHeatmapDayDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      weekdayProductivity: $checkedConvert(
        'weekdayProductivity',
        (v) => (v as List<dynamic>)
            .map((e) => StatsWeekdayDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      habitConsistency: $checkedConvert(
        'habitConsistency',
        (v) => (v as List<dynamic>)
            .map((e) => StatsHabitDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      goals: $checkedConvert(
        'goals',
        (v) => StatsGoalsDto.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$StatsDtoToJson(StatsDto instance) => <String, dynamic>{
  'range': instance.range,
  'from': instance.from,
  'to': instance.to,
  'previousFrom': instance.previousFrom,
  'previousTo': instance.previousTo,
  'hero': instance.hero.toJson(),
  'kpis': instance.kpis.toJson(),
  'trend': instance.trend.toJson(),
  'heatmap': instance.heatmap.map((e) => e.toJson()).toList(),
  'weekdayProductivity': instance.weekdayProductivity
      .map((e) => e.toJson())
      .toList(),
  'habitConsistency': instance.habitConsistency.map((e) => e.toJson()).toList(),
  'goals': instance.goals.toJson(),
};
