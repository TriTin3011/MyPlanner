// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_plan_item_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$YearPlanItemDtoCWProxy {
  YearPlanItemDto id(String id);

  YearPlanItemDto year(int year);

  YearPlanItemDto month(int month);

  YearPlanItemDto title(String title);

  YearPlanItemDto done(bool done);

  YearPlanItemDto order(int order);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearPlanItemDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearPlanItemDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearPlanItemDto call({
    String id,
    int year,
    int month,
    String title,
    bool done,
    int order,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfYearPlanItemDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfYearPlanItemDto.copyWith.fieldName(...)`
class _$YearPlanItemDtoCWProxyImpl implements _$YearPlanItemDtoCWProxy {
  const _$YearPlanItemDtoCWProxyImpl(this._value);

  final YearPlanItemDto _value;

  @override
  YearPlanItemDto id(String id) => this(id: id);

  @override
  YearPlanItemDto year(int year) => this(year: year);

  @override
  YearPlanItemDto month(int month) => this(month: month);

  @override
  YearPlanItemDto title(String title) => this(title: title);

  @override
  YearPlanItemDto done(bool done) => this(done: done);

  @override
  YearPlanItemDto order(int order) => this(order: order);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearPlanItemDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearPlanItemDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearPlanItemDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
  }) {
    return YearPlanItemDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      year: year == const $CopyWithPlaceholder()
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
    );
  }
}

extension $YearPlanItemDtoCopyWith on YearPlanItemDto {
  /// Returns a callable class that can be used as follows: `instanceOfYearPlanItemDto.copyWith(...)` or like so:`instanceOfYearPlanItemDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$YearPlanItemDtoCWProxy get copyWith => _$YearPlanItemDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearPlanItemDto _$YearPlanItemDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('YearPlanItemDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'year', 'month', 'title', 'done', 'order'],
      );
      final val = YearPlanItemDto(
        id: $checkedConvert('id', (v) => v as String),
        year: $checkedConvert('year', (v) => (v as num).toInt()),
        month: $checkedConvert('month', (v) => (v as num).toInt()),
        title: $checkedConvert('title', (v) => v as String),
        done: $checkedConvert('done', (v) => v as bool),
        order: $checkedConvert('order', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$YearPlanItemDtoToJson(YearPlanItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'title': instance.title,
      'done': instance.done,
      'order': instance.order,
    };
