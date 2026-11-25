// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_month_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HabitMonthDtoCWProxy {
  HabitMonthDto month(String month);

  HabitMonthDto from(String from);

  HabitMonthDto to(String to);

  HabitMonthDto percent(int percent);

  HabitMonthDto longestStreak(HabitHighlightDto? longestStreak);

  HabitMonthDto mostConsistent(HabitHighlightDto? mostConsistent);

  HabitMonthDto habits(List<HabitMonthRowDto> habits);

  HabitMonthDto days(List<HabitDayCountDto> days);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitMonthDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitMonthDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitMonthDto call({
    String month,
    String from,
    String to,
    int percent,
    HabitHighlightDto? longestStreak,
    HabitHighlightDto? mostConsistent,
    List<HabitMonthRowDto> habits,
    List<HabitDayCountDto> days,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHabitMonthDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHabitMonthDto.copyWith.fieldName(...)`
class _$HabitMonthDtoCWProxyImpl implements _$HabitMonthDtoCWProxy {
  const _$HabitMonthDtoCWProxyImpl(this._value);

  final HabitMonthDto _value;

  @override
  HabitMonthDto month(String month) => this(month: month);

  @override
  HabitMonthDto from(String from) => this(from: from);

  @override
  HabitMonthDto to(String to) => this(to: to);

  @override
  HabitMonthDto percent(int percent) => this(percent: percent);

  @override
  HabitMonthDto longestStreak(HabitHighlightDto? longestStreak) =>
      this(longestStreak: longestStreak);

  @override
  HabitMonthDto mostConsistent(HabitHighlightDto? mostConsistent) =>
      this(mostConsistent: mostConsistent);

  @override
  HabitMonthDto habits(List<HabitMonthRowDto> habits) => this(habits: habits);

  @override
  HabitMonthDto days(List<HabitDayCountDto> days) => this(days: days);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitMonthDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitMonthDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitMonthDto call({
    Object? month = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? longestStreak = const $CopyWithPlaceholder(),
    Object? mostConsistent = const $CopyWithPlaceholder(),
    Object? habits = const $CopyWithPlaceholder(),
    Object? days = const $CopyWithPlaceholder(),
  }) {
    return HabitMonthDto(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as String,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      longestStreak: longestStreak == const $CopyWithPlaceholder()
          ? _value.longestStreak
          // ignore: cast_nullable_to_non_nullable
          : longestStreak as HabitHighlightDto?,
      mostConsistent: mostConsistent == const $CopyWithPlaceholder()
          ? _value.mostConsistent
          // ignore: cast_nullable_to_non_nullable
          : mostConsistent as HabitHighlightDto?,
      habits: habits == const $CopyWithPlaceholder()
          ? _value.habits
          // ignore: cast_nullable_to_non_nullable
          : habits as List<HabitMonthRowDto>,
      days: days == const $CopyWithPlaceholder()
          ? _value.days
          // ignore: cast_nullable_to_non_nullable
          : days as List<HabitDayCountDto>,
    );
  }
}

extension $HabitMonthDtoCopyWith on HabitMonthDto {
  /// Returns a callable class that can be used as follows: `instanceOfHabitMonthDto.copyWith(...)` or like so:`instanceOfHabitMonthDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HabitMonthDtoCWProxy get copyWith => _$HabitMonthDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitMonthDto _$HabitMonthDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HabitMonthDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'month',
          'from',
          'to',
          'percent',
          'longestStreak',
          'mostConsistent',
          'habits',
          'days',
        ],
      );
      final val = HabitMonthDto(
        month: $checkedConvert('month', (v) => v as String),
        from: $checkedConvert('from', (v) => v as String),
        to: $checkedConvert('to', (v) => v as String),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        longestStreak: $checkedConvert(
          'longestStreak',
          (v) => v == null
              ? null
              : HabitHighlightDto.fromJson(v as Map<String, dynamic>),
        ),
        mostConsistent: $checkedConvert(
          'mostConsistent',
          (v) => v == null
              ? null
              : HabitHighlightDto.fromJson(v as Map<String, dynamic>),
        ),
        habits: $checkedConvert(
          'habits',
          (v) => (v as List<dynamic>)
              .map((e) => HabitMonthRowDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        days: $checkedConvert(
          'days',
          (v) => (v as List<dynamic>)
              .map((e) => HabitDayCountDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HabitMonthDtoToJson(HabitMonthDto instance) =>
    <String, dynamic>{
      'month': instance.month,
      'from': instance.from,
      'to': instance.to,
      'percent': instance.percent,
      'longestStreak': instance.longestStreak?.toJson(),
      'mostConsistent': instance.mostConsistent?.toJson(),
      'habits': instance.habits.map((e) => e.toJson()).toList(),
      'days': instance.days.map((e) => e.toJson()).toList(),
    };
