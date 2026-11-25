// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_tasks_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReorderTasksRequestCWProxy {
  ReorderTasksRequest date(String date);

  ReorderTasksRequest ids(List<String> ids);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderTasksRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderTasksRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderTasksRequest call({String date, List<String> ids});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReorderTasksRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReorderTasksRequest.copyWith.fieldName(...)`
class _$ReorderTasksRequestCWProxyImpl implements _$ReorderTasksRequestCWProxy {
  const _$ReorderTasksRequestCWProxyImpl(this._value);

  final ReorderTasksRequest _value;

  @override
  ReorderTasksRequest date(String date) => this(date: date);

  @override
  ReorderTasksRequest ids(List<String> ids) => this(ids: ids);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderTasksRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderTasksRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderTasksRequest call({
    Object? date = const $CopyWithPlaceholder(),
    Object? ids = const $CopyWithPlaceholder(),
  }) {
    return ReorderTasksRequest(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      ids: ids == const $CopyWithPlaceholder()
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>,
    );
  }
}

extension $ReorderTasksRequestCopyWith on ReorderTasksRequest {
  /// Returns a callable class that can be used as follows: `instanceOfReorderTasksRequest.copyWith(...)` or like so:`instanceOfReorderTasksRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReorderTasksRequestCWProxy get copyWith =>
      _$ReorderTasksRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderTasksRequest _$ReorderTasksRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReorderTasksRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['date', 'ids']);
      final val = ReorderTasksRequest(
        date: $checkedConvert('date', (v) => v as String),
        ids: $checkedConvert(
          'ids',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReorderTasksRequestToJson(
  ReorderTasksRequest instance,
) => <String, dynamic>{'date': instance.date, 'ids': instance.ids};
