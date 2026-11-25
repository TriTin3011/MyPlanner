// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_board_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoalBoardDtoCWProxy {
  GoalBoardDto done(int done);

  GoalBoardDto total(int total);

  GoalBoardDto percent(int percent);

  GoalBoardDto areas(List<AreaSummaryDto> areas);

  GoalBoardDto goals(List<GoalCardDto> goals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalBoardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalBoardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalBoardDto call({
    int done,
    int total,
    int percent,
    List<AreaSummaryDto> areas,
    List<GoalCardDto> goals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoalBoardDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoalBoardDto.copyWith.fieldName(...)`
class _$GoalBoardDtoCWProxyImpl implements _$GoalBoardDtoCWProxy {
  const _$GoalBoardDtoCWProxyImpl(this._value);

  final GoalBoardDto _value;

  @override
  GoalBoardDto done(int done) => this(done: done);

  @override
  GoalBoardDto total(int total) => this(total: total);

  @override
  GoalBoardDto percent(int percent) => this(percent: percent);

  @override
  GoalBoardDto areas(List<AreaSummaryDto> areas) => this(areas: areas);

  @override
  GoalBoardDto goals(List<GoalCardDto> goals) => this(goals: goals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoalBoardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoalBoardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  GoalBoardDto call({
    Object? done = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? areas = const $CopyWithPlaceholder(),
    Object? goals = const $CopyWithPlaceholder(),
  }) {
    return GoalBoardDto(
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as int,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      areas: areas == const $CopyWithPlaceholder()
          ? _value.areas
          // ignore: cast_nullable_to_non_nullable
          : areas as List<AreaSummaryDto>,
      goals: goals == const $CopyWithPlaceholder()
          ? _value.goals
          // ignore: cast_nullable_to_non_nullable
          : goals as List<GoalCardDto>,
    );
  }
}

extension $GoalBoardDtoCopyWith on GoalBoardDto {
  /// Returns a callable class that can be used as follows: `instanceOfGoalBoardDto.copyWith(...)` or like so:`instanceOfGoalBoardDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoalBoardDtoCWProxy get copyWith => _$GoalBoardDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalBoardDto _$GoalBoardDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoalBoardDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['done', 'total', 'percent', 'areas', 'goals'],
      );
      final val = GoalBoardDto(
        done: $checkedConvert('done', (v) => (v as num).toInt()),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        areas: $checkedConvert(
          'areas',
          (v) => (v as List<dynamic>)
              .map((e) => AreaSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        goals: $checkedConvert(
          'goals',
          (v) => (v as List<dynamic>)
              .map((e) => GoalCardDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GoalBoardDtoToJson(GoalBoardDto instance) =>
    <String, dynamic>{
      'done': instance.done,
      'total': instance.total,
      'percent': instance.percent,
      'areas': instance.areas.map((e) => e.toJson()).toList(),
      'goals': instance.goals.map((e) => e.toJson()).toList(),
    };
