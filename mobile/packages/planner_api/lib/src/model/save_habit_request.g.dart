// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_habit_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveHabitRequestCWProxy {
  SaveHabitRequest title(String title);

  SaveHabitRequest active(bool? active);

  SaveHabitRequest startDate(String? startDate);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveHabitRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveHabitRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveHabitRequest call({String title, bool? active, String? startDate});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveHabitRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveHabitRequest.copyWith.fieldName(...)`
class _$SaveHabitRequestCWProxyImpl implements _$SaveHabitRequestCWProxy {
  const _$SaveHabitRequestCWProxyImpl(this._value);

  final SaveHabitRequest _value;

  @override
  SaveHabitRequest title(String title) => this(title: title);

  @override
  SaveHabitRequest active(bool? active) => this(active: active);

  @override
  SaveHabitRequest startDate(String? startDate) => this(startDate: startDate);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveHabitRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveHabitRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveHabitRequest call({
    Object? title = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
  }) {
    return SaveHabitRequest(
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool?,
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String?,
    );
  }
}

extension $SaveHabitRequestCopyWith on SaveHabitRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveHabitRequest.copyWith(...)` or like so:`instanceOfSaveHabitRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveHabitRequestCWProxy get copyWith => _$SaveHabitRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveHabitRequest _$SaveHabitRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SaveHabitRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['title']);
      final val = SaveHabitRequest(
        title: $checkedConvert('title', (v) => v as String),
        active: $checkedConvert('active', (v) => v as bool? ?? true),
        startDate: $checkedConvert('startDate', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SaveHabitRequestToJson(SaveHabitRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'active': ?instance.active,
      'startDate': ?instance.startDate,
    };
