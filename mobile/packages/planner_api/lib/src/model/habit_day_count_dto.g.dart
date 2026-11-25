// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_day_count_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HabitDayCountDtoCWProxy {
  HabitDayCountDto date(String date);

  HabitDayCountDto done(int? done);

  HabitDayCountDto total(int? total);

  HabitDayCountDto percent(int? percent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitDayCountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitDayCountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitDayCountDto call({String date, int? done, int? total, int? percent});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHabitDayCountDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHabitDayCountDto.copyWith.fieldName(...)`
class _$HabitDayCountDtoCWProxyImpl implements _$HabitDayCountDtoCWProxy {
  const _$HabitDayCountDtoCWProxyImpl(this._value);

  final HabitDayCountDto _value;

  @override
  HabitDayCountDto date(String date) => this(date: date);

  @override
  HabitDayCountDto done(int? done) => this(done: done);

  @override
  HabitDayCountDto total(int? total) => this(total: total);

  @override
  HabitDayCountDto percent(int? percent) => this(percent: percent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitDayCountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitDayCountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitDayCountDto call({
    Object? date = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
  }) {
    return HabitDayCountDto(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int?,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int?,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int?,
    );
  }
}

extension $HabitDayCountDtoCopyWith on HabitDayCountDto {
  /// Returns a callable class that can be used as follows: `instanceOfHabitDayCountDto.copyWith(...)` or like so:`instanceOfHabitDayCountDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HabitDayCountDtoCWProxy get copyWith => _$HabitDayCountDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitDayCountDto _$HabitDayCountDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HabitDayCountDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['date', 'done', 'total', 'percent'],
      );
      final val = HabitDayCountDto(
        date: $checkedConvert('date', (v) => v as String),
        done: $checkedConvert('done', (v) => (v as num?)?.toInt()),
        total: $checkedConvert('total', (v) => (v as num?)?.toInt()),
        percent: $checkedConvert('percent', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$HabitDayCountDtoToJson(HabitDayCountDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'done': instance.done,
      'total': instance.total,
      'percent': instance.percent,
    };
