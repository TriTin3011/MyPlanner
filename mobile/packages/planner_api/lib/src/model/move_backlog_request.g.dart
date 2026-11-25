// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_backlog_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MoveBacklogRequestCWProxy {
  MoveBacklogRequest today(String today);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MoveBacklogRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MoveBacklogRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  MoveBacklogRequest call({String today});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMoveBacklogRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMoveBacklogRequest.copyWith.fieldName(...)`
class _$MoveBacklogRequestCWProxyImpl implements _$MoveBacklogRequestCWProxy {
  const _$MoveBacklogRequestCWProxyImpl(this._value);

  final MoveBacklogRequest _value;

  @override
  MoveBacklogRequest today(String today) => this(today: today);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MoveBacklogRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MoveBacklogRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  MoveBacklogRequest call({Object? today = const $CopyWithPlaceholder()}) {
    return MoveBacklogRequest(
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as String,
    );
  }
}

extension $MoveBacklogRequestCopyWith on MoveBacklogRequest {
  /// Returns a callable class that can be used as follows: `instanceOfMoveBacklogRequest.copyWith(...)` or like so:`instanceOfMoveBacklogRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MoveBacklogRequestCWProxy get copyWith =>
      _$MoveBacklogRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveBacklogRequest _$MoveBacklogRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MoveBacklogRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['today']);
      final val = MoveBacklogRequest(
        today: $checkedConvert('today', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MoveBacklogRequestToJson(MoveBacklogRequest instance) =>
    <String, dynamic>{'today': instance.today};
