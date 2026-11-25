// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReorderRequestCWProxy {
  ReorderRequest ids(List<String> ids);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderRequest call({List<String> ids});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReorderRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReorderRequest.copyWith.fieldName(...)`
class _$ReorderRequestCWProxyImpl implements _$ReorderRequestCWProxy {
  const _$ReorderRequestCWProxyImpl(this._value);

  final ReorderRequest _value;

  @override
  ReorderRequest ids(List<String> ids) => this(ids: ids);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderRequest call({Object? ids = const $CopyWithPlaceholder()}) {
    return ReorderRequest(
      ids: ids == const $CopyWithPlaceholder()
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>,
    );
  }
}

extension $ReorderRequestCopyWith on ReorderRequest {
  /// Returns a callable class that can be used as follows: `instanceOfReorderRequest.copyWith(...)` or like so:`instanceOfReorderRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReorderRequestCWProxy get copyWith => _$ReorderRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderRequest _$ReorderRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReorderRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['ids']);
      final val = ReorderRequest(
        ids: $checkedConvert(
          'ids',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReorderRequestToJson(ReorderRequest instance) =>
    <String, dynamic>{'ids': instance.ids};
