// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_dashboard_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$YearDashboardDtoCWProxy {
  YearDashboardDto year(int year);

  YearDashboardDto keyword(String keyword);

  YearDashboardDto vision(String vision);

  YearDashboardDto done(int done);

  YearDashboardDto total(int total);

  YearDashboardDto percent(int percent);

  YearDashboardDto currentMonth(int? currentMonth);

  YearDashboardDto months(List<YearMonthDto> months);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearDashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearDashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearDashboardDto call({
    int year,
    String keyword,
    String vision,
    int done,
    int total,
    int percent,
    int? currentMonth,
    List<YearMonthDto> months,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfYearDashboardDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfYearDashboardDto.copyWith.fieldName(...)`
class _$YearDashboardDtoCWProxyImpl implements _$YearDashboardDtoCWProxy {
  const _$YearDashboardDtoCWProxyImpl(this._value);

  final YearDashboardDto _value;

  @override
  YearDashboardDto year(int year) => this(year: year);

  @override
  YearDashboardDto keyword(String keyword) => this(keyword: keyword);

  @override
  YearDashboardDto vision(String vision) => this(vision: vision);

  @override
  YearDashboardDto done(int done) => this(done: done);

  @override
  YearDashboardDto total(int total) => this(total: total);

  @override
  YearDashboardDto percent(int percent) => this(percent: percent);

  @override
  YearDashboardDto currentMonth(int? currentMonth) =>
      this(currentMonth: currentMonth);

  @override
  YearDashboardDto months(List<YearMonthDto> months) => this(months: months);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearDashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearDashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearDashboardDto call({
    Object? year = const $CopyWithPlaceholder(),
    Object? keyword = const $CopyWithPlaceholder(),
    Object? vision = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? currentMonth = const $CopyWithPlaceholder(),
    Object? months = const $CopyWithPlaceholder(),
  }) {
    return YearDashboardDto(
      year: year == const $CopyWithPlaceholder()
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      keyword: keyword == const $CopyWithPlaceholder()
          ? _value.keyword
          // ignore: cast_nullable_to_non_nullable
          : keyword as String,
      vision: vision == const $CopyWithPlaceholder()
          ? _value.vision
          // ignore: cast_nullable_to_non_nullable
          : vision as String,
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
      currentMonth: currentMonth == const $CopyWithPlaceholder()
          ? _value.currentMonth
          // ignore: cast_nullable_to_non_nullable
          : currentMonth as int?,
      months: months == const $CopyWithPlaceholder()
          ? _value.months
          // ignore: cast_nullable_to_non_nullable
          : months as List<YearMonthDto>,
    );
  }
}

extension $YearDashboardDtoCopyWith on YearDashboardDto {
  /// Returns a callable class that can be used as follows: `instanceOfYearDashboardDto.copyWith(...)` or like so:`instanceOfYearDashboardDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$YearDashboardDtoCWProxy get copyWith => _$YearDashboardDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearDashboardDto _$YearDashboardDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('YearDashboardDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'year',
          'keyword',
          'vision',
          'done',
          'total',
          'percent',
          'currentMonth',
          'months',
        ],
      );
      final val = YearDashboardDto(
        year: $checkedConvert('year', (v) => (v as num).toInt()),
        keyword: $checkedConvert('keyword', (v) => v as String),
        vision: $checkedConvert('vision', (v) => v as String),
        done: $checkedConvert('done', (v) => (v as num).toInt()),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        currentMonth: $checkedConvert(
          'currentMonth',
          (v) => (v as num?)?.toInt(),
        ),
        months: $checkedConvert(
          'months',
          (v) => (v as List<dynamic>)
              .map((e) => YearMonthDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$YearDashboardDtoToJson(YearDashboardDto instance) =>
    <String, dynamic>{
      'year': instance.year,
      'keyword': instance.keyword,
      'vision': instance.vision,
      'done': instance.done,
      'total': instance.total,
      'percent': instance.percent,
      'currentMonth': instance.currentMonth,
      'months': instance.months.map((e) => e.toJson()).toList(),
    };
