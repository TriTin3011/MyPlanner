// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SubtaskDtoCWProxy {
  SubtaskDto id(String id);

  SubtaskDto title(String title);

  SubtaskDto done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubtaskDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubtaskDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SubtaskDto call({String id, String title, bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSubtaskDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSubtaskDto.copyWith.fieldName(...)`
class _$SubtaskDtoCWProxyImpl implements _$SubtaskDtoCWProxy {
  const _$SubtaskDtoCWProxyImpl(this._value);

  final SubtaskDto _value;

  @override
  SubtaskDto id(String id) => this(id: id);

  @override
  SubtaskDto title(String title) => this(title: title);

  @override
  SubtaskDto done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubtaskDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubtaskDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SubtaskDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return SubtaskDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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

extension $SubtaskDtoCopyWith on SubtaskDto {
  /// Returns a callable class that can be used as follows: `instanceOfSubtaskDto.copyWith(...)` or like so:`instanceOfSubtaskDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SubtaskDtoCWProxy get copyWith => _$SubtaskDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubtaskDto _$SubtaskDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SubtaskDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'title', 'done']);
      final val = SubtaskDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        done: $checkedConvert('done', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$SubtaskDtoToJson(SubtaskDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'done': instance.done,
    };
