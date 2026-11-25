// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_goal_step_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveGoalStepRequestCWProxy {
  SaveGoalStepRequest title(String title);

  SaveGoalStepRequest deadline(String? deadline);

  SaveGoalStepRequest done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveGoalStepRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveGoalStepRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveGoalStepRequest call({String title, String? deadline, bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveGoalStepRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveGoalStepRequest.copyWith.fieldName(...)`
class _$SaveGoalStepRequestCWProxyImpl implements _$SaveGoalStepRequestCWProxy {
  const _$SaveGoalStepRequestCWProxyImpl(this._value);

  final SaveGoalStepRequest _value;

  @override
  SaveGoalStepRequest title(String title) => this(title: title);

  @override
  SaveGoalStepRequest deadline(String? deadline) => this(deadline: deadline);

  @override
  SaveGoalStepRequest done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveGoalStepRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveGoalStepRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveGoalStepRequest call({
    Object? title = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return SaveGoalStepRequest(
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
    );
  }
}

extension $SaveGoalStepRequestCopyWith on SaveGoalStepRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveGoalStepRequest.copyWith(...)` or like so:`instanceOfSaveGoalStepRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveGoalStepRequestCWProxy get copyWith =>
      _$SaveGoalStepRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveGoalStepRequest _$SaveGoalStepRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SaveGoalStepRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['title', 'deadline', 'done']);
      final val = SaveGoalStepRequest(
        title: $checkedConvert('title', (v) => v as String),
        deadline: $checkedConvert('deadline', (v) => v as String?),
        done: $checkedConvert('done', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$SaveGoalStepRequestToJson(
  SaveGoalStepRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'deadline': instance.deadline,
  'done': instance.done,
};
