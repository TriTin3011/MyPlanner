// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_year_items_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReorderYearItemsRequestCWProxy {
  ReorderYearItemsRequest month(int month);

  ReorderYearItemsRequest ids(List<String> ids);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderYearItemsRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderYearItemsRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderYearItemsRequest call({int month, List<String> ids});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReorderYearItemsRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReorderYearItemsRequest.copyWith.fieldName(...)`
class _$ReorderYearItemsRequestCWProxyImpl
    implements _$ReorderYearItemsRequestCWProxy {
  const _$ReorderYearItemsRequestCWProxyImpl(this._value);

  final ReorderYearItemsRequest _value;

  @override
  ReorderYearItemsRequest month(int month) => this(month: month);

  @override
  ReorderYearItemsRequest ids(List<String> ids) => this(ids: ids);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderYearItemsRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderYearItemsRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderYearItemsRequest call({
    Object? month = const $CopyWithPlaceholder(),
    Object? ids = const $CopyWithPlaceholder(),
  }) {
    return ReorderYearItemsRequest(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      ids: ids == const $CopyWithPlaceholder()
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>,
    );
  }
}

extension $ReorderYearItemsRequestCopyWith on ReorderYearItemsRequest {
  /// Returns a callable class that can be used as follows: `instanceOfReorderYearItemsRequest.copyWith(...)` or like so:`instanceOfReorderYearItemsRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReorderYearItemsRequestCWProxy get copyWith =>
      _$ReorderYearItemsRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderYearItemsRequest _$ReorderYearItemsRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReorderYearItemsRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['month', 'ids']);
  final val = ReorderYearItemsRequest(
    month: $checkedConvert('month', (v) => (v as num).toInt()),
    ids: $checkedConvert(
      'ids',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ReorderYearItemsRequestToJson(
  ReorderYearItemsRequest instance,
) => <String, dynamic>{'month': instance.month, 'ids': instance.ids};
