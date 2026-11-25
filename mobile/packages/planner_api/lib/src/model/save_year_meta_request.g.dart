// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_year_meta_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveYearMetaRequestCWProxy {
  SaveYearMetaRequest keyword(String keyword);

  SaveYearMetaRequest vision(String vision);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveYearMetaRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveYearMetaRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveYearMetaRequest call({String keyword, String vision});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveYearMetaRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveYearMetaRequest.copyWith.fieldName(...)`
class _$SaveYearMetaRequestCWProxyImpl implements _$SaveYearMetaRequestCWProxy {
  const _$SaveYearMetaRequestCWProxyImpl(this._value);

  final SaveYearMetaRequest _value;

  @override
  SaveYearMetaRequest keyword(String keyword) => this(keyword: keyword);

  @override
  SaveYearMetaRequest vision(String vision) => this(vision: vision);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveYearMetaRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveYearMetaRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveYearMetaRequest call({
    Object? keyword = const $CopyWithPlaceholder(),
    Object? vision = const $CopyWithPlaceholder(),
  }) {
    return SaveYearMetaRequest(
      keyword: keyword == const $CopyWithPlaceholder()
          ? _value.keyword
          // ignore: cast_nullable_to_non_nullable
          : keyword as String,
      vision: vision == const $CopyWithPlaceholder()
          ? _value.vision
          // ignore: cast_nullable_to_non_nullable
          : vision as String,
    );
  }
}

extension $SaveYearMetaRequestCopyWith on SaveYearMetaRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveYearMetaRequest.copyWith(...)` or like so:`instanceOfSaveYearMetaRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveYearMetaRequestCWProxy get copyWith =>
      _$SaveYearMetaRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveYearMetaRequest _$SaveYearMetaRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SaveYearMetaRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['keyword', 'vision']);
      final val = SaveYearMetaRequest(
        keyword: $checkedConvert('keyword', (v) => v as String),
        vision: $checkedConvert('vision', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SaveYearMetaRequestToJson(
  SaveYearMetaRequest instance,
) => <String, dynamic>{'keyword': instance.keyword, 'vision': instance.vision};
