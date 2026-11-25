// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_task_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveTaskRequestCWProxy {
  SaveTaskRequest title(String title);

  SaveTaskRequest date(String date);

  SaveTaskRequest tags(List<TaskTag>? tags);

  SaveTaskRequest subtasks(List<SubtaskInput>? subtasks);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveTaskRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveTaskRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveTaskRequest call({
    String title,
    String date,
    List<TaskTag>? tags,
    List<SubtaskInput>? subtasks,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveTaskRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveTaskRequest.copyWith.fieldName(...)`
class _$SaveTaskRequestCWProxyImpl implements _$SaveTaskRequestCWProxy {
  const _$SaveTaskRequestCWProxyImpl(this._value);

  final SaveTaskRequest _value;

  @override
  SaveTaskRequest title(String title) => this(title: title);

  @override
  SaveTaskRequest date(String date) => this(date: date);

  @override
  SaveTaskRequest tags(List<TaskTag>? tags) => this(tags: tags);

  @override
  SaveTaskRequest subtasks(List<SubtaskInput>? subtasks) =>
      this(subtasks: subtasks);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveTaskRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveTaskRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveTaskRequest call({
    Object? title = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? subtasks = const $CopyWithPlaceholder(),
  }) {
    return SaveTaskRequest(
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<TaskTag>?,
      subtasks: subtasks == const $CopyWithPlaceholder()
          ? _value.subtasks
          // ignore: cast_nullable_to_non_nullable
          : subtasks as List<SubtaskInput>?,
    );
  }
}

extension $SaveTaskRequestCopyWith on SaveTaskRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveTaskRequest.copyWith(...)` or like so:`instanceOfSaveTaskRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveTaskRequestCWProxy get copyWith => _$SaveTaskRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveTaskRequest _$SaveTaskRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SaveTaskRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['title', 'date', 'tags', 'subtasks'],
      );
      final val = SaveTaskRequest(
        title: $checkedConvert('title', (v) => v as String),
        date: $checkedConvert('date', (v) => v as String),
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
        subtasks: $checkedConvert(
          'subtasks',
          (v) => (v as List<dynamic>?)
              ?.map((e) => SubtaskInput.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SaveTaskRequestToJson(SaveTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date,
      'tags': instance.tags?.map((e) => _$TaskTagEnumMap[e]!).toList(),
      'subtasks': instance.subtasks?.map((e) => e.toJson()).toList(),
    };

const _$TaskTagEnumMap = {
  TaskTag.urgent: 'urgent',
  TaskTag.important: 'important',
  TaskTag.unknownDefaultOpenApi: 'unknown_default_open_api',
};
