// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_summary_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AreaSummaryDtoCWProxy {
  AreaSummaryDto area(LifeArea area);

  AreaSummaryDto count(int count);

  AreaSummaryDto percent(int percent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AreaSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AreaSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AreaSummaryDto call({LifeArea area, int count, int percent});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAreaSummaryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAreaSummaryDto.copyWith.fieldName(...)`
class _$AreaSummaryDtoCWProxyImpl implements _$AreaSummaryDtoCWProxy {
  const _$AreaSummaryDtoCWProxyImpl(this._value);

  final AreaSummaryDto _value;

  @override
  AreaSummaryDto area(LifeArea area) => this(area: area);

  @override
  AreaSummaryDto count(int count) => this(count: count);

  @override
  AreaSummaryDto percent(int percent) => this(percent: percent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AreaSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AreaSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AreaSummaryDto call({
    Object? area = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
  }) {
    return AreaSummaryDto(
      area: area == const $CopyWithPlaceholder()
          ? _value.area
          // ignore: cast_nullable_to_non_nullable
          : area as LifeArea,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
    );
  }
}

extension $AreaSummaryDtoCopyWith on AreaSummaryDto {
  /// Returns a callable class that can be used as follows: `instanceOfAreaSummaryDto.copyWith(...)` or like so:`instanceOfAreaSummaryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AreaSummaryDtoCWProxy get copyWith => _$AreaSummaryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaSummaryDto _$AreaSummaryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AreaSummaryDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['area', 'count', 'percent']);
      final val = AreaSummaryDto(
        area: $checkedConvert(
          'area',
          (v) => $enumDecode(
            _$LifeAreaEnumMap,
            v,
            unknownValue: LifeArea.unknownDefaultOpenApi,
          ),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AreaSummaryDtoToJson(AreaSummaryDto instance) =>
    <String, dynamic>{
      'area': _$LifeAreaEnumMap[instance.area]!,
      'count': instance.count,
      'percent': instance.percent,
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
