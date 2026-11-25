// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HabitLogDtoCWProxy {
  HabitLogDto habitId(String habitId);

  HabitLogDto date(String date);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitLogDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitLogDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitLogDto call({String habitId, String date});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHabitLogDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHabitLogDto.copyWith.fieldName(...)`
class _$HabitLogDtoCWProxyImpl implements _$HabitLogDtoCWProxy {
  const _$HabitLogDtoCWProxyImpl(this._value);

  final HabitLogDto _value;

  @override
  HabitLogDto habitId(String habitId) => this(habitId: habitId);

  @override
  HabitLogDto date(String date) => this(date: date);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitLogDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitLogDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitLogDto call({
    Object? habitId = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
  }) {
    return HabitLogDto(
      habitId: habitId == const $CopyWithPlaceholder()
          ? _value.habitId
          // ignore: cast_nullable_to_non_nullable
          : habitId as String,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
    );
  }
}

extension $HabitLogDtoCopyWith on HabitLogDto {
  /// Returns a callable class that can be used as follows: `instanceOfHabitLogDto.copyWith(...)` or like so:`instanceOfHabitLogDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HabitLogDtoCWProxy get copyWith => _$HabitLogDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitLogDto _$HabitLogDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HabitLogDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['habitId', 'date']);
      final val = HabitLogDto(
        habitId: $checkedConvert('habitId', (v) => v as String),
        date: $checkedConvert('date', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HabitLogDtoToJson(HabitLogDto instance) =>
    <String, dynamic>{'habitId': instance.habitId, 'date': instance.date};
