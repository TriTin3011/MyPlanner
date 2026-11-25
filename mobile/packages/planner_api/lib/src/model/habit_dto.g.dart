// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HabitDtoCWProxy {
  HabitDto id(String id);

  HabitDto title(String title);

  HabitDto order(int order);

  HabitDto active(bool active);

  HabitDto startDate(String startDate);

  HabitDto createdAt(DateTime createdAt);

  HabitDto archivedAt(DateTime? archivedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitDto call({
    String id,
    String title,
    int order,
    bool active,
    String startDate,
    DateTime createdAt,
    DateTime? archivedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHabitDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHabitDto.copyWith.fieldName(...)`
class _$HabitDtoCWProxyImpl implements _$HabitDtoCWProxy {
  const _$HabitDtoCWProxyImpl(this._value);

  final HabitDto _value;

  @override
  HabitDto id(String id) => this(id: id);

  @override
  HabitDto title(String title) => this(title: title);

  @override
  HabitDto order(int order) => this(order: order);

  @override
  HabitDto active(bool active) => this(active: active);

  @override
  HabitDto startDate(String startDate) => this(startDate: startDate);

  @override
  HabitDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  HabitDto archivedAt(DateTime? archivedAt) => this(archivedAt: archivedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? archivedAt = const $CopyWithPlaceholder(),
  }) {
    return HabitDto(
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
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      archivedAt: archivedAt == const $CopyWithPlaceholder()
          ? _value.archivedAt
          // ignore: cast_nullable_to_non_nullable
          : archivedAt as DateTime?,
    );
  }
}

extension $HabitDtoCopyWith on HabitDto {
  /// Returns a callable class that can be used as follows: `instanceOfHabitDto.copyWith(...)` or like so:`instanceOfHabitDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HabitDtoCWProxy get copyWith => _$HabitDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitDto _$HabitDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HabitDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'title',
          'order',
          'active',
          'startDate',
          'createdAt',
          'archivedAt',
        ],
      );
      final val = HabitDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        order: $checkedConvert('order', (v) => (v as num).toInt()),
        active: $checkedConvert('active', (v) => v as bool),
        startDate: $checkedConvert('startDate', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        archivedAt: $checkedConvert(
          'archivedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HabitDtoToJson(HabitDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'order': instance.order,
  'active': instance.active,
  'startDate': instance.startDate,
  'createdAt': instance.createdAt.toIso8601String(),
  'archivedAt': instance.archivedAt?.toIso8601String(),
};
