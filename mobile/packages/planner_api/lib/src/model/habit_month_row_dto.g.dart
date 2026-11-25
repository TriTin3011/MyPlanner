// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_month_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HabitMonthRowDtoCWProxy {
  HabitMonthRowDto id(String id);

  HabitMonthRowDto title(String title);

  HabitMonthRowDto order(int order);

  HabitMonthRowDto startDate(String startDate);

  HabitMonthRowDto percent(int percent);

  HabitMonthRowDto currentStreak(int currentStreak);

  HabitMonthRowDto longestStreak(int longestStreak);

  HabitMonthRowDto doneDates(List<String> doneDates);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitMonthRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitMonthRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitMonthRowDto call({
    String id,
    String title,
    int order,
    String startDate,
    int percent,
    int currentStreak,
    int longestStreak,
    List<String> doneDates,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHabitMonthRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHabitMonthRowDto.copyWith.fieldName(...)`
class _$HabitMonthRowDtoCWProxyImpl implements _$HabitMonthRowDtoCWProxy {
  const _$HabitMonthRowDtoCWProxyImpl(this._value);

  final HabitMonthRowDto _value;

  @override
  HabitMonthRowDto id(String id) => this(id: id);

  @override
  HabitMonthRowDto title(String title) => this(title: title);

  @override
  HabitMonthRowDto order(int order) => this(order: order);

  @override
  HabitMonthRowDto startDate(String startDate) => this(startDate: startDate);

  @override
  HabitMonthRowDto percent(int percent) => this(percent: percent);

  @override
  HabitMonthRowDto currentStreak(int currentStreak) =>
      this(currentStreak: currentStreak);

  @override
  HabitMonthRowDto longestStreak(int longestStreak) =>
      this(longestStreak: longestStreak);

  @override
  HabitMonthRowDto doneDates(List<String> doneDates) =>
      this(doneDates: doneDates);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HabitMonthRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HabitMonthRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HabitMonthRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? currentStreak = const $CopyWithPlaceholder(),
    Object? longestStreak = const $CopyWithPlaceholder(),
    Object? doneDates = const $CopyWithPlaceholder(),
  }) {
    return HabitMonthRowDto(
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
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      currentStreak: currentStreak == const $CopyWithPlaceholder()
          ? _value.currentStreak
          // ignore: cast_nullable_to_non_nullable
          : currentStreak as int,
      longestStreak: longestStreak == const $CopyWithPlaceholder()
          ? _value.longestStreak
          // ignore: cast_nullable_to_non_nullable
          : longestStreak as int,
      doneDates: doneDates == const $CopyWithPlaceholder()
          ? _value.doneDates
          // ignore: cast_nullable_to_non_nullable
          : doneDates as List<String>,
    );
  }
}

extension $HabitMonthRowDtoCopyWith on HabitMonthRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfHabitMonthRowDto.copyWith(...)` or like so:`instanceOfHabitMonthRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HabitMonthRowDtoCWProxy get copyWith => _$HabitMonthRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitMonthRowDto _$HabitMonthRowDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HabitMonthRowDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'title',
      'order',
      'startDate',
      'percent',
      'currentStreak',
      'longestStreak',
      'doneDates',
    ],
  );
  final val = HabitMonthRowDto(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    order: $checkedConvert('order', (v) => (v as num).toInt()),
    startDate: $checkedConvert('startDate', (v) => v as String),
    percent: $checkedConvert('percent', (v) => (v as num).toInt()),
    currentStreak: $checkedConvert('currentStreak', (v) => (v as num).toInt()),
    longestStreak: $checkedConvert('longestStreak', (v) => (v as num).toInt()),
    doneDates: $checkedConvert(
      'doneDates',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$HabitMonthRowDtoToJson(HabitMonthRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'order': instance.order,
      'startDate': instance.startDate,
      'percent': instance.percent,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'doneDates': instance.doneDates,
    };
