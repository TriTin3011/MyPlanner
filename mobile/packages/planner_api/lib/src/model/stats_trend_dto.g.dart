// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_trend_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsTrendDtoCWProxy {
  StatsTrendDto averagePercent(int averagePercent);

  StatsTrendDto points(List<StatsWeekPointDto> points);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsTrendDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsTrendDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsTrendDto call({int averagePercent, List<StatsWeekPointDto> points});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsTrendDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsTrendDto.copyWith.fieldName(...)`
class _$StatsTrendDtoCWProxyImpl implements _$StatsTrendDtoCWProxy {
  const _$StatsTrendDtoCWProxyImpl(this._value);

  final StatsTrendDto _value;

  @override
  StatsTrendDto averagePercent(int averagePercent) =>
      this(averagePercent: averagePercent);

  @override
  StatsTrendDto points(List<StatsWeekPointDto> points) => this(points: points);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsTrendDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsTrendDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsTrendDto call({
    Object? averagePercent = const $CopyWithPlaceholder(),
    Object? points = const $CopyWithPlaceholder(),
  }) {
    return StatsTrendDto(
      averagePercent: averagePercent == const $CopyWithPlaceholder()
          ? _value.averagePercent
          // ignore: cast_nullable_to_non_nullable
          : averagePercent as int,
      points: points == const $CopyWithPlaceholder()
          ? _value.points
          // ignore: cast_nullable_to_non_nullable
          : points as List<StatsWeekPointDto>,
    );
  }
}

extension $StatsTrendDtoCopyWith on StatsTrendDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsTrendDto.copyWith(...)` or like so:`instanceOfStatsTrendDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsTrendDtoCWProxy get copyWith => _$StatsTrendDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsTrendDto _$StatsTrendDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsTrendDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['averagePercent', 'points']);
      final val = StatsTrendDto(
        averagePercent: $checkedConvert(
          'averagePercent',
          (v) => (v as num).toInt(),
        ),
        points: $checkedConvert(
          'points',
          (v) => (v as List<dynamic>)
              .map((e) => StatsWeekPointDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StatsTrendDtoToJson(StatsTrendDto instance) =>
    <String, dynamic>{
      'averagePercent': instance.averagePercent,
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
