// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_task_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecurringTaskDtoCWProxy {
  RecurringTaskDto id(String id);

  RecurringTaskDto title(String title);

  RecurringTaskDto weekdays(List<int> weekdays);

  RecurringTaskDto tags(List<TaskTag> tags);

  RecurringTaskDto active(bool active);

  RecurringTaskDto startDate(String startDate);

  RecurringTaskDto skippedDates(List<String> skippedDates);

  RecurringTaskDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecurringTaskDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecurringTaskDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RecurringTaskDto call({
    String id,
    String title,
    List<int> weekdays,
    List<TaskTag> tags,
    bool active,
    String startDate,
    List<String> skippedDates,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecurringTaskDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecurringTaskDto.copyWith.fieldName(...)`
class _$RecurringTaskDtoCWProxyImpl implements _$RecurringTaskDtoCWProxy {
  const _$RecurringTaskDtoCWProxyImpl(this._value);

  final RecurringTaskDto _value;

  @override
  RecurringTaskDto id(String id) => this(id: id);

  @override
  RecurringTaskDto title(String title) => this(title: title);

  @override
  RecurringTaskDto weekdays(List<int> weekdays) => this(weekdays: weekdays);

  @override
  RecurringTaskDto tags(List<TaskTag> tags) => this(tags: tags);

  @override
  RecurringTaskDto active(bool active) => this(active: active);

  @override
  RecurringTaskDto startDate(String startDate) => this(startDate: startDate);

  @override
  RecurringTaskDto skippedDates(List<String> skippedDates) =>
      this(skippedDates: skippedDates);

  @override
  RecurringTaskDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecurringTaskDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecurringTaskDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RecurringTaskDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? weekdays = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? skippedDates = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return RecurringTaskDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      weekdays: weekdays == const $CopyWithPlaceholder()
          ? _value.weekdays
          // ignore: cast_nullable_to_non_nullable
          : weekdays as List<int>,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<TaskTag>,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String,
      skippedDates: skippedDates == const $CopyWithPlaceholder()
          ? _value.skippedDates
          // ignore: cast_nullable_to_non_nullable
          : skippedDates as List<String>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $RecurringTaskDtoCopyWith on RecurringTaskDto {
  /// Returns a callable class that can be used as follows: `instanceOfRecurringTaskDto.copyWith(...)` or like so:`instanceOfRecurringTaskDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecurringTaskDtoCWProxy get copyWith => _$RecurringTaskDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTaskDto _$RecurringTaskDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RecurringTaskDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'title',
          'weekdays',
          'tags',
          'active',
          'startDate',
          'skippedDates',
          'createdAt',
        ],
      );
      final val = RecurringTaskDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        weekdays: $checkedConvert(
          'weekdays',
          (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
        ),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>)
              .map(
                (e) => $enumDecode(
                  _$TaskTagEnumMap,
                  e,
                  unknownValue: TaskTag.unknownDefaultOpenApi,
                ),
              )
              .toList(),
        ),
        active: $checkedConvert('active', (v) => v as bool),
        startDate: $checkedConvert('startDate', (v) => v as String),
        skippedDates: $checkedConvert(
          'skippedDates',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RecurringTaskDtoToJson(RecurringTaskDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'weekdays': instance.weekdays,
      'tags': instance.tags.map((e) => _$TaskTagEnumMap[e]!).toList(),
      'active': instance.active,
      'startDate': instance.startDate,
      'skippedDates': instance.skippedDates,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TaskTagEnumMap = {
  TaskTag.urgent: 'urgent',
  TaskTag.important: 'important',
  TaskTag.unknownDefaultOpenApi: 'unknown_default_open_api',
};
