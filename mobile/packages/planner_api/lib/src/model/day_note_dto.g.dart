// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_note_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DayNoteDtoCWProxy {
  DayNoteDto date(String date);

  DayNoteDto content(String content);

  DayNoteDto updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DayNoteDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DayNoteDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DayNoteDto call({String date, String content, DateTime? updatedAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDayNoteDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDayNoteDto.copyWith.fieldName(...)`
class _$DayNoteDtoCWProxyImpl implements _$DayNoteDtoCWProxy {
  const _$DayNoteDtoCWProxyImpl(this._value);

  final DayNoteDto _value;

  @override
  DayNoteDto date(String date) => this(date: date);

  @override
  DayNoteDto content(String content) => this(content: content);

  @override
  DayNoteDto updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DayNoteDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DayNoteDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DayNoteDto call({
    Object? date = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return DayNoteDto(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
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

extension $DayNoteDtoCopyWith on DayNoteDto {
  /// Returns a callable class that can be used as follows: `instanceOfDayNoteDto.copyWith(...)` or like so:`instanceOfDayNoteDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DayNoteDtoCWProxy get copyWith => _$DayNoteDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayNoteDto _$DayNoteDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DayNoteDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['date', 'content', 'updatedAt']);
      final val = DayNoteDto(
        date: $checkedConvert('date', (v) => v as String),
        content: $checkedConvert('content', (v) => v as String),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DayNoteDtoToJson(DayNoteDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'content': instance.content,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
