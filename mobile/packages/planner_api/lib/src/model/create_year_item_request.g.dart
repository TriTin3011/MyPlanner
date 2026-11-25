// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_year_item_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateYearItemRequestCWProxy {
  CreateYearItemRequest month(int month);

  CreateYearItemRequest title(String title);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateYearItemRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateYearItemRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateYearItemRequest call({int month, String title});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateYearItemRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateYearItemRequest.copyWith.fieldName(...)`
class _$CreateYearItemRequestCWProxyImpl
    implements _$CreateYearItemRequestCWProxy {
  const _$CreateYearItemRequestCWProxyImpl(this._value);

  final CreateYearItemRequest _value;

  @override
  CreateYearItemRequest month(int month) => this(month: month);

  @override
  CreateYearItemRequest title(String title) => this(title: title);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateYearItemRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateYearItemRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateYearItemRequest call({
    Object? month = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
  }) {
    return CreateYearItemRequest(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
    );
  }
}

extension $CreateYearItemRequestCopyWith on CreateYearItemRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateYearItemRequest.copyWith(...)` or like so:`instanceOfCreateYearItemRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateYearItemRequestCWProxy get copyWith =>
      _$CreateYearItemRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateYearItemRequest _$CreateYearItemRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateYearItemRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['month', 'title']);
  final val = CreateYearItemRequest(
    month: $checkedConvert('month', (v) => (v as num).toInt()),
    title: $checkedConvert('title', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$CreateYearItemRequestToJson(
  CreateYearItemRequest instance,
) => <String, dynamic>{'month': instance.month, 'title': instance.title};
