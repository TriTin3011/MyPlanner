// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_recurring_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveRecurringRequestCWProxy {
  SaveRecurringRequest title(String title);

  SaveRecurringRequest weekdays(List<int> weekdays);

  SaveRecurringRequest tags(List<TaskTag>? tags);

  SaveRecurringRequest active(bool active);

  SaveRecurringRequest startDate(String startDate);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveRecurringRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveRecurringRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveRecurringRequest call({
    String title,
    List<int> weekdays,
    List<TaskTag>? tags,
    bool active,
    String startDate,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveRecurringRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveRecurringRequest.copyWith.fieldName(...)`
class _$SaveRecurringRequestCWProxyImpl
    implements _$SaveRecurringRequestCWProxy {
  const _$SaveRecurringRequestCWProxyImpl(this._value);

  final SaveRecurringRequest _value;

  @override
  SaveRecurringRequest title(String title) => this(title: title);

  @override
  SaveRecurringRequest weekdays(List<int> weekdays) => this(weekdays: weekdays);

  @override
  SaveRecurringRequest tags(List<TaskTag>? tags) => this(tags: tags);

  @override
  SaveRecurringRequest active(bool active) => this(active: active);

  @override
  SaveRecurringRequest startDate(String startDate) =>
      this(startDate: startDate);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveRecurringRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveRecurringRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveRecurringRequest call({
    Object? title = const $CopyWithPlaceholder(),
    Object? weekdays = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
  }) {
    return SaveRecurringRequest(
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
          : tags as List<TaskTag>?,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String,
    );
  }
}

extension $SaveRecurringRequestCopyWith on SaveRecurringRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveRecurringRequest.copyWith(...)` or like so:`instanceOfSaveRecurringRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveRecurringRequestCWProxy get copyWith =>
      _$SaveRecurringRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveRecurringRequest _$SaveRecurringRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SaveRecurringRequest', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['title', 'weekdays', 'tags', 'active', 'startDate'],
  );
  final val = SaveRecurringRequest(
    title: $checkedConvert('title', (v) => v as String),
    weekdays: $checkedConvert(
      'weekdays',
      (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    ),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>?)
          ?.map(
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
  );
  return val;
});

Map<String, dynamic> _$SaveRecurringRequestToJson(
  SaveRecurringRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'weekdays': instance.weekdays,
  'tags': instance.tags?.map((e) => _$TaskTagEnumMap[e]!).toList(),
  'active': instance.active,
  'startDate': instance.startDate,
};

const _$TaskTagEnumMap = {
  TaskTag.urgent: 'urgent',
  TaskTag.important: 'important',
  TaskTag.unknownDefaultOpenApi: 'unknown_default_open_api',
};
