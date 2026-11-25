// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_month_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$YearMonthDtoCWProxy {
  YearMonthDto month(int month);

  YearMonthDto done(int done);

  YearMonthDto total(int total);

  YearMonthDto percent(int percent);

  YearMonthDto deadlines(List<DeadlineDto> deadlines);

  YearMonthDto items(List<YearPlanItemDto> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearMonthDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearMonthDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearMonthDto call({
    int month,
    int done,
    int total,
    int percent,
    List<DeadlineDto> deadlines,
    List<YearPlanItemDto> items,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfYearMonthDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfYearMonthDto.copyWith.fieldName(...)`
class _$YearMonthDtoCWProxyImpl implements _$YearMonthDtoCWProxy {
  const _$YearMonthDtoCWProxyImpl(this._value);

  final YearMonthDto _value;

  @override
  YearMonthDto month(int month) => this(month: month);

  @override
  YearMonthDto done(int done) => this(done: done);

  @override
  YearMonthDto total(int total) => this(total: total);

  @override
  YearMonthDto percent(int percent) => this(percent: percent);

  @override
  YearMonthDto deadlines(List<DeadlineDto> deadlines) =>
      this(deadlines: deadlines);

  @override
  YearMonthDto items(List<YearPlanItemDto> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearMonthDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearMonthDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearMonthDto call({
    Object? month = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? deadlines = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return YearMonthDto(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      deadlines: deadlines == const $CopyWithPlaceholder()
          ? _value.deadlines
          // ignore: cast_nullable_to_non_nullable
          : deadlines as List<DeadlineDto>,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<YearPlanItemDto>,
    );
  }
}

extension $YearMonthDtoCopyWith on YearMonthDto {
  /// Returns a callable class that can be used as follows: `instanceOfYearMonthDto.copyWith(...)` or like so:`instanceOfYearMonthDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$YearMonthDtoCWProxy get copyWith => _$YearMonthDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearMonthDto _$YearMonthDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('YearMonthDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'month',
          'done',
          'total',
          'percent',
          'deadlines',
          'items',
        ],
      );
      final val = YearMonthDto(
        month: $checkedConvert('month', (v) => (v as num).toInt()),
        done: $checkedConvert('done', (v) => (v as num).toInt()),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        deadlines: $checkedConvert(
          'deadlines',
          (v) => (v as List<dynamic>)
              .map((e) => DeadlineDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => YearPlanItemDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$YearMonthDtoToJson(YearMonthDto instance) =>
    <String, dynamic>{
      'month': instance.month,
      'done': instance.done,
      'total': instance.total,
      'percent': instance.percent,
      'deadlines': instance.deadlines.map((e) => e.toJson()).toList(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
