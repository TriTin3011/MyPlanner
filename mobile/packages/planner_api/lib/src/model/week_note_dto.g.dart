// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_note_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WeekNoteDtoCWProxy {
  WeekNoteDto weekKey(String weekKey);

  WeekNoteDto content(String content);

  WeekNoteDto updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekNoteDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekNoteDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekNoteDto call({String weekKey, String content, DateTime? updatedAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWeekNoteDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWeekNoteDto.copyWith.fieldName(...)`
class _$WeekNoteDtoCWProxyImpl implements _$WeekNoteDtoCWProxy {
  const _$WeekNoteDtoCWProxyImpl(this._value);

  final WeekNoteDto _value;

  @override
  WeekNoteDto weekKey(String weekKey) => this(weekKey: weekKey);

  @override
  WeekNoteDto content(String content) => this(content: content);

  @override
  WeekNoteDto updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekNoteDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekNoteDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekNoteDto call({
    Object? weekKey = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return WeekNoteDto(
      weekKey: weekKey == const $CopyWithPlaceholder()
          ? _value.weekKey
          // ignore: cast_nullable_to_non_nullable
          : weekKey as String,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $WeekNoteDtoCopyWith on WeekNoteDto {
  /// Returns a callable class that can be used as follows: `instanceOfWeekNoteDto.copyWith(...)` or like so:`instanceOfWeekNoteDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WeekNoteDtoCWProxy get copyWith => _$WeekNoteDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekNoteDto _$WeekNoteDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeekNoteDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['weekKey', 'content', 'updatedAt']);
      final val = WeekNoteDto(
        weekKey: $checkedConvert('weekKey', (v) => v as String),
        content: $checkedConvert('content', (v) => v as String),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WeekNoteDtoToJson(WeekNoteDto instance) =>
    <String, dynamic>{
      'weekKey': instance.weekKey,
      'content': instance.content,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
