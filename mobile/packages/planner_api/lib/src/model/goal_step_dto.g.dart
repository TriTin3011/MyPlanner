// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_step_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoalStepDtoCWProxy {
  GoalStepDto id(String id);

  GoalStepDto title(String title);

  GoalStepDto deadline(String? deadline);

  GoalStepDto done(bool done);

  GoalStepDto doneAt(DateTime? doneAt);

  GoalStepDto order(int order);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalStepDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalStepDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalStepDto call({
    String id,
    String title,
    String? deadline,
    bool done,
    DateTime? doneAt,
    int order,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoalStepDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoalStepDto.copyWith.fieldName(...)`
class _$GoalStepDtoCWProxyImpl implements _$GoalStepDtoCWProxy {
  const _$GoalStepDtoCWProxyImpl(this._value);

  final GoalStepDto _value;

  @override
  GoalStepDto id(String id) => this(id: id);

  @override
  GoalStepDto title(String title) => this(title: title);

  @override
  GoalStepDto deadline(String? deadline) => this(deadline: deadline);

  @override
  GoalStepDto done(bool done) => this(done: done);

  @override
  GoalStepDto doneAt(DateTime? doneAt) => this(doneAt: doneAt);

  @override
  GoalStepDto order(int order) => this(order: order);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalStepDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalStepDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalStepDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? doneAt = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
  }) {
    return GoalStepDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      deadline: deadline == const $CopyWithPlaceholder()
          ? _value.deadline
          // ignore: cast_nullable_to_non_nullable
          : deadline as String?,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
      doneAt: doneAt == const $CopyWithPlaceholder()
          ? _value.doneAt
          // ignore: cast_nullable_to_non_nullable
          : doneAt as DateTime?,
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
    );
  }
}

extension $GoalStepDtoCopyWith on GoalStepDto {
  /// Returns a callable class that can be used as follows: `instanceOfGoalStepDto.copyWith(...)` or like so:`instanceOfGoalStepDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoalStepDtoCWProxy get copyWith => _$GoalStepDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalStepDto _$GoalStepDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoalStepDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'title',
          'deadline',
          'done',
          'doneAt',
          'order',
        ],
      );
      final val = GoalStepDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        deadline: $checkedConvert('deadline', (v) => v as String?),
        done: $checkedConvert('done', (v) => v as bool),
        doneAt: $checkedConvert(
          'doneAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        order: $checkedConvert('order', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$GoalStepDtoToJson(GoalStepDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'deadline': instance.deadline,
      'done': instance.done,
      'doneAt': instance.doneAt?.toIso8601String(),
      'order': instance.order,
    };
