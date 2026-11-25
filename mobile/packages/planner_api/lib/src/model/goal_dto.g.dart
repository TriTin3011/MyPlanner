// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoalDtoCWProxy {
  GoalDto id(String id);

  GoalDto title(String title);

  GoalDto area(LifeArea area);

  GoalDto status(GoalStatus status);

  GoalDto startDate(String startDate);

  GoalDto deadline(String deadline);

  GoalDto reward(String? reward);

  GoalDto why(String? why);

  GoalDto steps(List<GoalStepDto> steps);

  GoalDto createdAt(DateTime createdAt);

  GoalDto completedAt(DateTime? completedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalDto call({
    String id,
    String title,
    LifeArea area,
    GoalStatus status,
    String startDate,
    String deadline,
    String? reward,
    String? why,
    List<GoalStepDto> steps,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoalDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoalDto.copyWith.fieldName(...)`
class _$GoalDtoCWProxyImpl implements _$GoalDtoCWProxy {
  const _$GoalDtoCWProxyImpl(this._value);

  final GoalDto _value;

  @override
  GoalDto id(String id) => this(id: id);

  @override
  GoalDto title(String title) => this(title: title);

  @override
  GoalDto area(LifeArea area) => this(area: area);

  @override
  GoalDto status(GoalStatus status) => this(status: status);

  @override
  GoalDto startDate(String startDate) => this(startDate: startDate);

  @override
  GoalDto deadline(String deadline) => this(deadline: deadline);

  @override
  GoalDto reward(String? reward) => this(reward: reward);

  @override
  GoalDto why(String? why) => this(why: why);

  @override
  GoalDto steps(List<GoalStepDto> steps) => this(steps: steps);

  @override
  GoalDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  GoalDto completedAt(DateTime? completedAt) => this(completedAt: completedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? area = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? reward = const $CopyWithPlaceholder(),
    Object? why = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? completedAt = const $CopyWithPlaceholder(),
  }) {
    return GoalDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      area: area == const $CopyWithPlaceholder()
          ? _value.area
          // ignore: cast_nullable_to_non_nullable
          : area as LifeArea,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as GoalStatus,
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String,
      deadline: deadline == const $CopyWithPlaceholder()
          ? _value.deadline
          // ignore: cast_nullable_to_non_nullable
          : deadline as String,
      reward: reward == const $CopyWithPlaceholder()
          ? _value.reward
          // ignore: cast_nullable_to_non_nullable
          : reward as String?,
      why: why == const $CopyWithPlaceholder()
          ? _value.why
          // ignore: cast_nullable_to_non_nullable
          : why as String?,
      steps: steps == const $CopyWithPlaceholder()
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as List<GoalStepDto>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      completedAt: completedAt == const $CopyWithPlaceholder()
          ? _value.completedAt
          // ignore: cast_nullable_to_non_nullable
          : completedAt as DateTime?,
    );
  }
}

extension $GoalDtoCopyWith on GoalDto {
  /// Returns a callable class that can be used as follows: `instanceOfGoalDto.copyWith(...)` or like so:`instanceOfGoalDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoalDtoCWProxy get copyWith => _$GoalDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalDto _$GoalDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoalDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'title',
          'area',
          'status',
          'startDate',
          'deadline',
          'reward',
          'why',
          'steps',
          'createdAt',
          'completedAt',
        ],
      );
      final val = GoalDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        area: $checkedConvert(
          'area',
          (v) => $enumDecode(
            _$LifeAreaEnumMap,
            v,
            unknownValue: LifeArea.unknownDefaultOpenApi,
          ),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(
            _$GoalStatusEnumMap,
            v,
            unknownValue: GoalStatus.unknownDefaultOpenApi,
          ),
        ),
        startDate: $checkedConvert('startDate', (v) => v as String),
        deadline: $checkedConvert('deadline', (v) => v as String),
        reward: $checkedConvert('reward', (v) => v as String?),
        why: $checkedConvert('why', (v) => v as String?),
        steps: $checkedConvert(
          'steps',
          (v) => (v as List<dynamic>)
              .map((e) => GoalStepDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        completedAt: $checkedConvert(
          'completedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GoalDtoToJson(GoalDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'area': _$LifeAreaEnumMap[instance.area]!,
  'status': _$GoalStatusEnumMap[instance.status]!,
  'startDate': instance.startDate,
  'deadline': instance.deadline,
  'reward': instance.reward,
  'why': instance.why,
  'steps': instance.steps.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

const _$LifeAreaEnumMap = {
  LifeArea.health: 'health',
  LifeArea.finance: 'finance',
  LifeArea.career: 'career',
  LifeArea.growth: 'growth',
  LifeArea.relationship: 'relationship',
  LifeArea.learning: 'learning',
  LifeArea.family: 'family',
  LifeArea.hobby: 'hobby',
  LifeArea.unknownDefaultOpenApi: 'unknown_default_open_api',
};

const _$GoalStatusEnumMap = {
  GoalStatus.notStarted: 'not_started',
  GoalStatus.inProgress: 'in_progress',
  GoalStatus.done: 'done',
  GoalStatus.unknownDefaultOpenApi: 'unknown_default_open_api',
};
