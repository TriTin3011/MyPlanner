// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TaskDtoCWProxy {
  TaskDto id(String id);

  TaskDto title(String title);

  TaskDto date(String date);

  TaskDto originalDate(String? originalDate);

  TaskDto done(bool done);

  TaskDto doneAt(DateTime? doneAt);

  TaskDto tags(List<TaskTag> tags);

  TaskDto subtasks(List<SubtaskDto> subtasks);

  TaskDto recurringId(String? recurringId);

  TaskDto order(int order);

  TaskDto createdAt(DateTime createdAt);

  TaskDto updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TaskDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TaskDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TaskDto call({
    String id,
    String title,
    String date,
    String? originalDate,
    bool done,
    DateTime? doneAt,
    List<TaskTag> tags,
    List<SubtaskDto> subtasks,
    String? recurringId,
    int order,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTaskDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTaskDto.copyWith.fieldName(...)`
class _$TaskDtoCWProxyImpl implements _$TaskDtoCWProxy {
  const _$TaskDtoCWProxyImpl(this._value);

  final TaskDto _value;

  @override
  TaskDto id(String id) => this(id: id);

  @override
  TaskDto title(String title) => this(title: title);

  @override
  TaskDto date(String date) => this(date: date);

  @override
  TaskDto originalDate(String? originalDate) =>
      this(originalDate: originalDate);

  @override
  TaskDto done(bool done) => this(done: done);

  @override
  TaskDto doneAt(DateTime? doneAt) => this(doneAt: doneAt);

  @override
  TaskDto tags(List<TaskTag> tags) => this(tags: tags);

  @override
  TaskDto subtasks(List<SubtaskDto> subtasks) => this(subtasks: subtasks);

  @override
  TaskDto recurringId(String? recurringId) => this(recurringId: recurringId);

  @override
  TaskDto order(int order) => this(order: order);

  @override
  TaskDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  TaskDto updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TaskDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TaskDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TaskDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? originalDate = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? doneAt = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? subtasks = const $CopyWithPlaceholder(),
    Object? recurringId = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return TaskDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      originalDate: originalDate == const $CopyWithPlaceholder()
          ? _value.originalDate
          // ignore: cast_nullable_to_non_nullable
          : originalDate as String?,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
      doneAt: doneAt == const $CopyWithPlaceholder()
          ? _value.doneAt
          // ignore: cast_nullable_to_non_nullable
          : doneAt as DateTime?,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<TaskTag>,
      subtasks: subtasks == const $CopyWithPlaceholder()
          ? _value.subtasks
          // ignore: cast_nullable_to_non_nullable
          : subtasks as List<SubtaskDto>,
      recurringId: recurringId == const $CopyWithPlaceholder()
          ? _value.recurringId
          // ignore: cast_nullable_to_non_nullable
          : recurringId as String?,
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $TaskDtoCopyWith on TaskDto {
  /// Returns a callable class that can be used as follows: `instanceOfTaskDto.copyWith(...)` or like so:`instanceOfTaskDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TaskDtoCWProxy get copyWith => _$TaskDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TaskDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'title',
      'date',
      'originalDate',
      'done',
      'doneAt',
      'tags',
      'subtasks',
      'recurringId',
      'order',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = TaskDto(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    date: $checkedConvert('date', (v) => v as String),
    originalDate: $checkedConvert('originalDate', (v) => v as String?),
    done: $checkedConvert('done', (v) => v as bool),
    doneAt: $checkedConvert(
      'doneAt',
      (v) => v == null ? null : DateTime.parse(v as String),
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
    subtasks: $checkedConvert(
      'subtasks',
      (v) => (v as List<dynamic>)
          .map((e) => SubtaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    recurringId: $checkedConvert('recurringId', (v) => v as String?),
    order: $checkedConvert('order', (v) => (v as num).toInt()),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'date': instance.date,
  'originalDate': instance.originalDate,
  'done': instance.done,
  'doneAt': instance.doneAt?.toIso8601String(),
  'tags': instance.tags.map((e) => _$TaskTagEnumMap[e]!).toList(),
  'subtasks': instance.subtasks.map((e) => e.toJson()).toList(),
  'recurringId': instance.recurringId,
  'order': instance.order,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$TaskTagEnumMap = {
  TaskTag.urgent: 'urgent',
  TaskTag.important: 'important',
  TaskTag.unknownDefaultOpenApi: 'unknown_default_open_api',
};
