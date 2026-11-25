// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MaterializeRequestCWProxy {
  MaterializeRequest from(String from);

  MaterializeRequest to(String to);

  MaterializeRequest today(String today);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MaterializeRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MaterializeRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  MaterializeRequest call({String from, String to, String today});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMaterializeRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMaterializeRequest.copyWith.fieldName(...)`
class _$MaterializeRequestCWProxyImpl implements _$MaterializeRequestCWProxy {
  const _$MaterializeRequestCWProxyImpl(this._value);

  final MaterializeRequest _value;

  @override
  MaterializeRequest from(String from) => this(from: from);

  @override
  MaterializeRequest to(String to) => this(to: to);

  @override
  MaterializeRequest today(String today) => this(today: today);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MaterializeRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MaterializeRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  MaterializeRequest call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? today = const $CopyWithPlaceholder(),
  }) {
    return MaterializeRequest(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as String,
    );
  }
}

extension $MaterializeRequestCopyWith on MaterializeRequest {
  /// Returns a callable class that can be used as follows: `instanceOfMaterializeRequest.copyWith(...)` or like so:`instanceOfMaterializeRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MaterializeRequestCWProxy get copyWith =>
      _$MaterializeRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRequest _$MaterializeRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MaterializeRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['from', 'to', 'today']);
      final val = MaterializeRequest(
        from: $checkedConvert('from', (v) => v as String),
        to: $checkedConvert('to', (v) => v as String),
        today: $checkedConvert('today', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MaterializeRequestToJson(MaterializeRequest instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'today': instance.today,
    };
