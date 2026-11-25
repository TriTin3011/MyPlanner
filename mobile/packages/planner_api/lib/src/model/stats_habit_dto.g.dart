// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_habit_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsHabitDtoCWProxy {
  StatsHabitDto habitId(String habitId);

  StatsHabitDto title(String title);

  StatsHabitDto percent(int percent);

  StatsHabitDto doneDays(int doneDays);

  StatsHabitDto possibleDays(int possibleDays);

  StatsHabitDto currentStreak(int currentStreak);

  StatsHabitDto longestStreak(int longestStreak);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsHabitDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsHabitDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsHabitDto call({
    String habitId,
    String title,
    int percent,
    int doneDays,
    int possibleDays,
    int currentStreak,
    int longestStreak,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsHabitDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsHabitDto.copyWith.fieldName(...)`
class _$StatsHabitDtoCWProxyImpl implements _$StatsHabitDtoCWProxy {
  const _$StatsHabitDtoCWProxyImpl(this._value);

  final StatsHabitDto _value;

  @override
  StatsHabitDto habitId(String habitId) => this(habitId: habitId);

  @override
  StatsHabitDto title(String title) => this(title: title);

  @override
  StatsHabitDto percent(int percent) => this(percent: percent);

  @override
  StatsHabitDto doneDays(int doneDays) => this(doneDays: doneDays);

  @override
  StatsHabitDto possibleDays(int possibleDays) =>
      this(possibleDays: possibleDays);

  @override
  StatsHabitDto currentStreak(int currentStreak) =>
      this(currentStreak: currentStreak);

  @override
  StatsHabitDto longestStreak(int longestStreak) =>
      this(longestStreak: longestStreak);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsHabitDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsHabitDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsHabitDto call({
    Object? habitId = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? doneDays = const $CopyWithPlaceholder(),
    Object? possibleDays = const $CopyWithPlaceholder(),
    Object? currentStreak = const $CopyWithPlaceholder(),
    Object? longestStreak = const $CopyWithPlaceholder(),
  }) {
    return StatsHabitDto(
      habitId: habitId == const $CopyWithPlaceholder()
          ? _value.habitId
          // ignore: cast_nullable_to_non_nullable
          : habitId as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      doneDays: doneDays == const $CopyWithPlaceholder()
          ? _value.doneDays
          // ignore: cast_nullable_to_non_nullable
          : doneDays as int,
      possibleDays: possibleDays == const $CopyWithPlaceholder()
          ? _value.possibleDays
          // ignore: cast_nullable_to_non_nullable
          : possibleDays as int,
      currentStreak: currentStreak == const $CopyWithPlaceholder()
          ? _value.currentStreak
          // ignore: cast_nullable_to_non_nullable
          : currentStreak as int,
      longestStreak: longestStreak == const $CopyWithPlaceholder()
          ? _value.longestStreak
          // ignore: cast_nullable_to_non_nullable
          : longestStreak as int,
    );
  }
}

extension $StatsHabitDtoCopyWith on StatsHabitDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsHabitDto.copyWith(...)` or like so:`instanceOfStatsHabitDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsHabitDtoCWProxy get copyWith => _$StatsHabitDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsHabitDto _$StatsHabitDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StatsHabitDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'habitId',
      'title',
      'percent',
      'doneDays',
      'possibleDays',
      'currentStreak',
      'longestStreak',
    ],
  );
  final val = StatsHabitDto(
    habitId: $checkedConvert('habitId', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    percent: $checkedConvert('percent', (v) => (v as num).toInt()),
    doneDays: $checkedConvert('doneDays', (v) => (v as num).toInt()),
    possibleDays: $checkedConvert('possibleDays', (v) => (v as num).toInt()),
    currentStreak: $checkedConvert('currentStreak', (v) => (v as num).toInt()),
    longestStreak: $checkedConvert('longestStreak', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$StatsHabitDtoToJson(StatsHabitDto instance) =>
    <String, dynamic>{
      'habitId': instance.habitId,
      'title': instance.title,
      'percent': instance.percent,
      'doneDays': instance.doneDays,
      'possibleDays': instance.possibleDays,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
    };
