// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SubtaskInputCWProxy {
  SubtaskInput id(String? id);

  SubtaskInput title(String title);

  SubtaskInput done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubtaskInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubtaskInput(...).copyWith(id: 12, name: "My name")
  /// ````
  SubtaskInput call({String? id, String title, bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSubtaskInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSubtaskInput.copyWith.fieldName(...)`
class _$SubtaskInputCWProxyImpl implements _$SubtaskInputCWProxy {
  const _$SubtaskInputCWProxyImpl(this._value);

  final SubtaskInput _value;

  @override
  SubtaskInput id(String? id) => this(id: id);

  @override
  SubtaskInput title(String title) => this(title: title);

  @override
  SubtaskInput done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubtaskInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubtaskInput(...).copyWith(id: 12, name: "My name")
  /// ````
  SubtaskInput call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return SubtaskInput(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
    );
  }
}

extension $SubtaskInputCopyWith on SubtaskInput {
  /// Returns a callable class that can be used as follows: `instanceOfSubtaskInput.copyWith(...)` or like so:`instanceOfSubtaskInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SubtaskInputCWProxy get copyWith => _$SubtaskInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubtaskInput _$SubtaskInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SubtaskInput', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'title', 'done']);
      final val = SubtaskInput(
        id: $checkedConvert('id', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as String),
        done: $checkedConvert('done', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$SubtaskInputToJson(SubtaskInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'done': instance.done,
    };
