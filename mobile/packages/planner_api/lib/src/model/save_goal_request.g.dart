// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_goal_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SaveGoalRequestCWProxy {
  SaveGoalRequest title(String title);

  SaveGoalRequest area(LifeArea area);

  SaveGoalRequest status(GoalStatus status);

  SaveGoalRequest startDate(String startDate);

  SaveGoalRequest deadline(String deadline);

  SaveGoalRequest reward(String? reward);

  SaveGoalRequest why(String? why);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveGoalRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveGoalRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveGoalRequest call({
    String title,
    LifeArea area,
    GoalStatus status,
    String startDate,
    String deadline,
    String? reward,
    String? why,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSaveGoalRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSaveGoalRequest.copyWith.fieldName(...)`
class _$SaveGoalRequestCWProxyImpl implements _$SaveGoalRequestCWProxy {
  const _$SaveGoalRequestCWProxyImpl(this._value);

  final SaveGoalRequest _value;

  @override
  SaveGoalRequest title(String title) => this(title: title);

  @override
  SaveGoalRequest area(LifeArea area) => this(area: area);

  @override
  SaveGoalRequest status(GoalStatus status) => this(status: status);

  @override
  SaveGoalRequest startDate(String startDate) => this(startDate: startDate);

  @override
  SaveGoalRequest deadline(String deadline) => this(deadline: deadline);

  @override
  SaveGoalRequest reward(String? reward) => this(reward: reward);

  @override
  SaveGoalRequest why(String? why) => this(why: why);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SaveGoalRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SaveGoalRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SaveGoalRequest call({
    Object? title = const $CopyWithPlaceholder(),
    Object? area = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? reward = const $CopyWithPlaceholder(),
    Object? why = const $CopyWithPlaceholder(),
  }) {
    return SaveGoalRequest(
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
    );
  }
}

extension $SaveGoalRequestCopyWith on SaveGoalRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSaveGoalRequest.copyWith(...)` or like so:`instanceOfSaveGoalRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SaveGoalRequestCWProxy get copyWith => _$SaveGoalRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveGoalRequest _$SaveGoalRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SaveGoalRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'title',
          'area',
          'status',
          'startDate',
          'deadline',
          'reward',
          'why',
        ],
      );
      final val = SaveGoalRequest(
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
      );
      return val;
    });

Map<String, dynamic> _$SaveGoalRequestToJson(SaveGoalRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'area': _$LifeAreaEnumMap[instance.area]!,
      'status': _$GoalStatusEnumMap[instance.status]!,
      'startDate': instance.startDate,
      'deadline': instance.deadline,
      'reward': instance.reward,
      'why': instance.why,
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
