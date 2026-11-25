// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_habit_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodayHabitDtoCWProxy {
  TodayHabitDto id(String id);

  TodayHabitDto title(String title);

  TodayHabitDto order(int order);

  TodayHabitDto done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayHabitDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayHabitDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayHabitDto call({String id, String title, int order, bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodayHabitDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodayHabitDto.copyWith.fieldName(...)`
class _$TodayHabitDtoCWProxyImpl implements _$TodayHabitDtoCWProxy {
  const _$TodayHabitDtoCWProxyImpl(this._value);

  final TodayHabitDto _value;

  @override
  TodayHabitDto id(String id) => this(id: id);

  @override
  TodayHabitDto title(String title) => this(title: title);

  @override
  TodayHabitDto order(int order) => this(order: order);

  @override
  TodayHabitDto done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayHabitDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayHabitDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayHabitDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return TodayHabitDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
    );
  }
}

extension $TodayHabitDtoCopyWith on TodayHabitDto {
  /// Returns a callable class that can be used as follows: `instanceOfTodayHabitDto.copyWith(...)` or like so:`instanceOfTodayHabitDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodayHabitDtoCWProxy get copyWith => _$TodayHabitDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayHabitDto _$TodayHabitDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TodayHabitDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'title', 'order', 'done']);
      final val = TodayHabitDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        order: $checkedConvert('order', (v) => (v as num).toInt()),
        done: $checkedConvert('done', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$TodayHabitDtoToJson(TodayHabitDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'order': instance.order,
      'done': instance.done,
    };
