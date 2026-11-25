// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_card_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoalCardDtoCWProxy {
  GoalCardDto id(String id);

  GoalCardDto title(String title);

  GoalCardDto area(LifeArea area);

  GoalCardDto status(GoalStatus status);

  GoalCardDto startDate(String startDate);

  GoalCardDto deadline(String deadline);

  GoalCardDto reward(String? reward);

  GoalCardDto daysLeft(int daysLeft);

  GoalCardDto stepsDone(int stepsDone);

  GoalCardDto stepsTotal(int stepsTotal);

  GoalCardDto overdueSteps(int overdueSteps);

  GoalCardDto stepPercent(int stepPercent);

  GoalCardDto timePercent(int timePercent);

  GoalCardDto behind(bool behind);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalCardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalCardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalCardDto call({
    String id,
    String title,
    LifeArea area,
    GoalStatus status,
    String startDate,
    String deadline,
    String? reward,
    int daysLeft,
    int stepsDone,
    int stepsTotal,
    int overdueSteps,
    int stepPercent,
    int timePercent,
    bool behind,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoalCardDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoalCardDto.copyWith.fieldName(...)`
class _$GoalCardDtoCWProxyImpl implements _$GoalCardDtoCWProxy {
  const _$GoalCardDtoCWProxyImpl(this._value);

  final GoalCardDto _value;

  @override
  GoalCardDto id(String id) => this(id: id);

  @override
  GoalCardDto title(String title) => this(title: title);

  @override
  GoalCardDto area(LifeArea area) => this(area: area);

  @override
  GoalCardDto status(GoalStatus status) => this(status: status);

  @override
  GoalCardDto startDate(String startDate) => this(startDate: startDate);

  @override
  GoalCardDto deadline(String deadline) => this(deadline: deadline);

  @override
  GoalCardDto reward(String? reward) => this(reward: reward);

  @override
  GoalCardDto daysLeft(int daysLeft) => this(daysLeft: daysLeft);

  @override
  GoalCardDto stepsDone(int stepsDone) => this(stepsDone: stepsDone);

  @override
  GoalCardDto stepsTotal(int stepsTotal) => this(stepsTotal: stepsTotal);

  @override
  GoalCardDto overdueSteps(int overdueSteps) =>
      this(overdueSteps: overdueSteps);

  @override
  GoalCardDto stepPercent(int stepPercent) => this(stepPercent: stepPercent);

  @override
  GoalCardDto timePercent(int timePercent) => this(timePercent: timePercent);

  @override
  GoalCardDto behind(bool behind) => this(behind: behind);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalCardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalCardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalCardDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? area = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? reward = const $CopyWithPlaceholder(),
    Object? daysLeft = const $CopyWithPlaceholder(),
    Object? stepsDone = const $CopyWithPlaceholder(),
    Object? stepsTotal = const $CopyWithPlaceholder(),
    Object? overdueSteps = const $CopyWithPlaceholder(),
    Object? stepPercent = const $CopyWithPlaceholder(),
    Object? timePercent = const $CopyWithPlaceholder(),
    Object? behind = const $CopyWithPlaceholder(),
  }) {
    return GoalCardDto(
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
      daysLeft: daysLeft == const $CopyWithPlaceholder()
          ? _value.daysLeft
          // ignore: cast_nullable_to_non_nullable
          : daysLeft as int,
      stepsDone: stepsDone == const $CopyWithPlaceholder()
          ? _value.stepsDone
          // ignore: cast_nullable_to_non_nullable
          : stepsDone as int,
      stepsTotal: stepsTotal == const $CopyWithPlaceholder()
          ? _value.stepsTotal
          // ignore: cast_nullable_to_non_nullable
          : stepsTotal as int,
      overdueSteps: overdueSteps == const $CopyWithPlaceholder()
          ? _value.overdueSteps
          // ignore: cast_nullable_to_non_nullable
          : overdueSteps as int,
      stepPercent: stepPercent == const $CopyWithPlaceholder()
          ? _value.stepPercent
          // ignore: cast_nullable_to_non_nullable
          : stepPercent as int,
      timePercent: timePercent == const $CopyWithPlaceholder()
          ? _value.timePercent
          // ignore: cast_nullable_to_non_nullable
          : timePercent as int,
      behind: behind == const $CopyWithPlaceholder()
          ? _value.behind
          // ignore: cast_nullable_to_non_nullable
          : behind as bool,
    );
  }
}

extension $GoalCardDtoCopyWith on GoalCardDto {
  /// Returns a callable class that can be used as follows: `instanceOfGoalCardDto.copyWith(...)` or like so:`instanceOfGoalCardDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoalCardDtoCWProxy get copyWith => _$GoalCardDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalCardDto _$GoalCardDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GoalCardDto',
  json,
  ($checkedConvert) {
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
        'daysLeft',
        'stepsDone',
        'stepsTotal',
        'overdueSteps',
        'stepPercent',
        'timePercent',
        'behind',
      ],
    );
    final val = GoalCardDto(
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
      daysLeft: $checkedConvert('daysLeft', (v) => (v as num).toInt()),
      stepsDone: $checkedConvert('stepsDone', (v) => (v as num).toInt()),
      stepsTotal: $checkedConvert('stepsTotal', (v) => (v as num).toInt()),
      overdueSteps: $checkedConvert('overdueSteps', (v) => (v as num).toInt()),
      stepPercent: $checkedConvert('stepPercent', (v) => (v as num).toInt()),
      timePercent: $checkedConvert('timePercent', (v) => (v as num).toInt()),
      behind: $checkedConvert('behind', (v) => v as bool),
    );
    return val;
  },
);

Map<String, dynamic> _$GoalCardDtoToJson(GoalCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'area': _$LifeAreaEnumMap[instance.area]!,
      'status': _$GoalStatusEnumMap[instance.status]!,
      'startDate': instance.startDate,
      'deadline': instance.deadline,
      'reward': instance.reward,
      'daysLeft': instance.daysLeft,
      'stepsDone': instance.stepsDone,
      'stepsTotal': instance.stepsTotal,
      'overdueSteps': instance.overdueSteps,
      'stepPercent': instance.stepPercent,
      'timePercent': instance.timePercent,
      'behind': instance.behind,
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
