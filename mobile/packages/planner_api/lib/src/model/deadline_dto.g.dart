// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deadline_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeadlineDtoCWProxy {
  DeadlineDto date(String date);

  DeadlineDto kind(DeadlineKind kind);

  DeadlineDto goalId(String goalId);

  DeadlineDto goalTitle(String goalTitle);

  DeadlineDto title(String title);

  DeadlineDto done(bool done);

  DeadlineDto overdue(bool overdue);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeadlineDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeadlineDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DeadlineDto call({
    String date,
    DeadlineKind kind,
    String goalId,
    String goalTitle,
    String title,
    bool done,
    bool overdue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeadlineDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeadlineDto.copyWith.fieldName(...)`
class _$DeadlineDtoCWProxyImpl implements _$DeadlineDtoCWProxy {
  const _$DeadlineDtoCWProxyImpl(this._value);

  final DeadlineDto _value;

  @override
  DeadlineDto date(String date) => this(date: date);

  @override
  DeadlineDto kind(DeadlineKind kind) => this(kind: kind);

  @override
  DeadlineDto goalId(String goalId) => this(goalId: goalId);

  @override
  DeadlineDto goalTitle(String goalTitle) => this(goalTitle: goalTitle);

  @override
  DeadlineDto title(String title) => this(title: title);

  @override
  DeadlineDto done(bool done) => this(done: done);

  @override
  DeadlineDto overdue(bool overdue) => this(overdue: overdue);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeadlineDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeadlineDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DeadlineDto call({
    Object? date = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? goalId = const $CopyWithPlaceholder(),
    Object? goalTitle = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? overdue = const $CopyWithPlaceholder(),
  }) {
    return DeadlineDto(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as DeadlineKind,
      goalId: goalId == const $CopyWithPlaceholder()
          ? _value.goalId
          // ignore: cast_nullable_to_non_nullable
          : goalId as String,
      goalTitle: goalTitle == const $CopyWithPlaceholder()
          ? _value.goalTitle
          // ignore: cast_nullable_to_non_nullable
          : goalTitle as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
      overdue: overdue == const $CopyWithPlaceholder()
          ? _value.overdue
          // ignore: cast_nullable_to_non_nullable
          : overdue as bool,
    );
  }
}

extension $DeadlineDtoCopyWith on DeadlineDto {
  /// Returns a callable class that can be used as follows: `instanceOfDeadlineDto.copyWith(...)` or like so:`instanceOfDeadlineDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeadlineDtoCWProxy get copyWith => _$DeadlineDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeadlineDto _$DeadlineDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeadlineDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'date',
          'kind',
          'goalId',
          'goalTitle',
          'title',
          'done',
          'overdue',
        ],
      );
      final val = DeadlineDto(
        date: $checkedConvert('date', (v) => v as String),
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(
            _$DeadlineKindEnumMap,
            v,
            unknownValue: DeadlineKind.unknownDefaultOpenApi,
          ),
        ),
        goalId: $checkedConvert('goalId', (v) => v as String),
        goalTitle: $checkedConvert('goalTitle', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        done: $checkedConvert('done', (v) => v as bool),
        overdue: $checkedConvert('overdue', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$DeadlineDtoToJson(DeadlineDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'kind': _$DeadlineKindEnumMap[instance.kind]!,
      'goalId': instance.goalId,
      'goalTitle': instance.goalTitle,
      'title': instance.title,
      'done': instance.done,
      'overdue': instance.overdue,
    };

const _$DeadlineKindEnumMap = {
  DeadlineKind.step: 'step',
  DeadlineKind.goal: 'goal',
  DeadlineKind.unknownDefaultOpenApi: 'unknown_default_open_api',
};
