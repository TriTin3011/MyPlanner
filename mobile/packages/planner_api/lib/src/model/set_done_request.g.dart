// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_done_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SetDoneRequestCWProxy {
  SetDoneRequest done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetDoneRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetDoneRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SetDoneRequest call({bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetDoneRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetDoneRequest.copyWith.fieldName(...)`
class _$SetDoneRequestCWProxyImpl implements _$SetDoneRequestCWProxy {
  const _$SetDoneRequestCWProxyImpl(this._value);

  final SetDoneRequest _value;

  @override
  SetDoneRequest done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetDoneRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetDoneRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SetDoneRequest call({Object? done = const $CopyWithPlaceholder()}) {
    return SetDoneRequest(
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
    );
  }
}

extension $SetDoneRequestCopyWith on SetDoneRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSetDoneRequest.copyWith(...)` or like so:`instanceOfSetDoneRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SetDoneRequestCWProxy get copyWith => _$SetDoneRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetDoneRequest _$SetDoneRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetDoneRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['done']);
      final val = SetDoneRequest(
        done: $checkedConvert('done', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$SetDoneRequestToJson(SetDoneRequest instance) =>
    <String, dynamic>{'done': instance.done};
