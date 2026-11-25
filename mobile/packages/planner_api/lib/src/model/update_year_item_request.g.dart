// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_year_item_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateYearItemRequestCWProxy {
  UpdateYearItemRequest month(int month);

  UpdateYearItemRequest title(String title);

  UpdateYearItemRequest done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateYearItemRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateYearItemRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateYearItemRequest call({int month, String title, bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateYearItemRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateYearItemRequest.copyWith.fieldName(...)`
class _$UpdateYearItemRequestCWProxyImpl
    implements _$UpdateYearItemRequestCWProxy {
  const _$UpdateYearItemRequestCWProxyImpl(this._value);

  final UpdateYearItemRequest _value;

  @override
  UpdateYearItemRequest month(int month) => this(month: month);

  @override
  UpdateYearItemRequest title(String title) => this(title: title);

  @override
  UpdateYearItemRequest done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateYearItemRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateYearItemRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateYearItemRequest call({
    Object? month = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return UpdateYearItemRequest(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
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

extension $UpdateYearItemRequestCopyWith on UpdateYearItemRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateYearItemRequest.copyWith(...)` or like so:`instanceOfUpdateYearItemRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateYearItemRequestCWProxy get copyWith =>
      _$UpdateYearItemRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateYearItemRequest _$UpdateYearItemRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateYearItemRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['month', 'title', 'done']);
  final val = UpdateYearItemRequest(
    month: $checkedConvert('month', (v) => (v as num).toInt()),
    title: $checkedConvert('title', (v) => v as String),
    done: $checkedConvert('done', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$UpdateYearItemRequestToJson(
  UpdateYearItemRequest instance,
) => <String, dynamic>{
  'month': instance.month,
  'title': instance.title,
  'done': instance.done,
};
