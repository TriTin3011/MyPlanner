// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_highlight_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HabitHighlightDtoCWProxy {
  HabitHighlightDto habitId(String habitId);

  HabitHighlightDto title(String title);

  HabitHighlightDto value(int value);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitHighlightDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitHighlightDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitHighlightDto call({String habitId, String title, int value});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHabitHighlightDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHabitHighlightDto.copyWith.fieldName(...)`
class _$HabitHighlightDtoCWProxyImpl implements _$HabitHighlightDtoCWProxy {
  const _$HabitHighlightDtoCWProxyImpl(this._value);

  final HabitHighlightDto _value;

  @override
  HabitHighlightDto habitId(String habitId) => this(habitId: habitId);

  @override
  HabitHighlightDto title(String title) => this(title: title);

  @override
  HabitHighlightDto value(int value) => this(value: value);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitHighlightDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitHighlightDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitHighlightDto call({
    Object? habitId = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return HabitHighlightDto(
      habitId: habitId == const $CopyWithPlaceholder()
          ? _value.habitId
          // ignore: cast_nullable_to_non_nullable
          : habitId as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as int,
    );
  }
}

extension $HabitHighlightDtoCopyWith on HabitHighlightDto {
  /// Returns a callable class that can be used as follows: `instanceOfHabitHighlightDto.copyWith(...)` or like so:`instanceOfHabitHighlightDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HabitHighlightDtoCWProxy get copyWith =>
      _$HabitHighlightDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitHighlightDto _$HabitHighlightDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HabitHighlightDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['habitId', 'title', 'value']);
      final val = HabitHighlightDto(
        habitId: $checkedConvert('habitId', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        value: $checkedConvert('value', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$HabitHighlightDtoToJson(HabitHighlightDto instance) =>
    <String, dynamic>{
      'habitId': instance.habitId,
      'title': instance.title,
      'value': instance.value,
    };
