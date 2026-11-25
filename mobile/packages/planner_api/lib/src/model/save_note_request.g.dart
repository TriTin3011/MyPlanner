// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_note_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveNoteRequestCWProxy {
  SaveNoteRequest content(String content);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveNoteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveNoteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveNoteRequest call({String content});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveNoteRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveNoteRequest.copyWith.fieldName(...)`
class _$SaveNoteRequestCWProxyImpl implements _$SaveNoteRequestCWProxy {
  const _$SaveNoteRequestCWProxyImpl(this._value);

  final SaveNoteRequest _value;

  @override
  SaveNoteRequest content(String content) => this(content: content);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveNoteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveNoteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveNoteRequest call({Object? content = const $CopyWithPlaceholder()}) {
    return SaveNoteRequest(
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String,
    );
  }
}

extension $SaveNoteRequestCopyWith on SaveNoteRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveNoteRequest.copyWith(...)` or like so:`instanceOfSaveNoteRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveNoteRequestCWProxy get copyWith => _$SaveNoteRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveNoteRequest _$SaveNoteRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SaveNoteRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['content']);
      final val = SaveNoteRequest(
        content: $checkedConvert('content', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SaveNoteRequestToJson(SaveNoteRequest instance) =>
    <String, dynamic>{'content': instance.content};
