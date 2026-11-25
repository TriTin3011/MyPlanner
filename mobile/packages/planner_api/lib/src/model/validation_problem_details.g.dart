// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_problem_details.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ValidationProblemDetailsCWProxy {
  ValidationProblemDetails type(String? type);

  ValidationProblemDetails title(String? title);

  ValidationProblemDetails status(int? status);

  ValidationProblemDetails detail(String? detail);

  ValidationProblemDetails instance(String? instance);

  ValidationProblemDetails errors(Map<String, List<String>>? errors);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ValidationProblemDetails(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ValidationProblemDetails(...).copyWith(id: 12, name: "My name")
  /// ````
  ValidationProblemDetails call({
    String? type,
    String? title,
    int? status,
    String? detail,
    String? instance,
    Map<String, List<String>>? errors,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfValidationProblemDetails.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfValidationProblemDetails.copyWith.fieldName(...)`
class _$ValidationProblemDetailsCWProxyImpl
    implements _$ValidationProblemDetailsCWProxy {
  const _$ValidationProblemDetailsCWProxyImpl(this._value);

  final ValidationProblemDetails _value;

  @override
  ValidationProblemDetails type(String? type) => this(type: type);

  @override
  ValidationProblemDetails title(String? title) => this(title: title);

  @override
  ValidationProblemDetails status(int? status) => this(status: status);

  @override
  ValidationProblemDetails detail(String? detail) => this(detail: detail);

  @override
  ValidationProblemDetails instance(String? instance) =>
      this(instance: instance);

  @override
  ValidationProblemDetails errors(Map<String, List<String>>? errors) =>
      this(errors: errors);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ValidationProblemDetails(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ValidationProblemDetails(...).copyWith(id: 12, name: "My name")
  /// ````
  ValidationProblemDetails call({
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? detail = const $CopyWithPlaceholder(),
    Object? instance = const $CopyWithPlaceholder(),
    Object? errors = const $CopyWithPlaceholder(),
  }) {
    return ValidationProblemDetails(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int?,
      detail: detail == const $CopyWithPlaceholder()
          ? _value.detail
          // ignore: cast_nullable_to_non_nullable
          : detail as String?,
      instance: instance == const $CopyWithPlaceholder()
          ? _value.instance
          // ignore: cast_nullable_to_non_nullable
          : instance as String?,
      errors: errors == const $CopyWithPlaceholder()
          ? _value.errors
          // ignore: cast_nullable_to_non_nullable
          : errors as Map<String, List<String>>?,
    );
  }
}

extension $ValidationProblemDetailsCopyWith on ValidationProblemDetails {
  /// Returns a callable class that can be used as follows: `instanceOfValidationProblemDetails.copyWith(...)` or like so:`instanceOfValidationProblemDetails.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ValidationProblemDetailsCWProxy get copyWith =>
      _$ValidationProblemDetailsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationProblemDetails _$ValidationProblemDetailsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ValidationProblemDetails', json, ($checkedConvert) {
  final val = ValidationProblemDetails(
    type: $checkedConvert('type', (v) => v as String?),
    title: $checkedConvert('title', (v) => v as String?),
    status: $checkedConvert('status', (v) => (v as num?)?.toInt()),
    detail: $checkedConvert('detail', (v) => v as String?),
    instance: $checkedConvert('instance', (v) => v as String?),
    errors: $checkedConvert(
      'errors',
      (v) => (v as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    ),
  );
  return val;
});

Map<String, dynamic> _$ValidationProblemDetailsToJson(
  ValidationProblemDetails instance,
) => <String, dynamic>{
  'type': ?instance.type,
  'title': ?instance.title,
  'status': ?instance.status,
  'detail': ?instance.detail,
  'instance': ?instance.instance,
  'errors': ?instance.errors,
};
