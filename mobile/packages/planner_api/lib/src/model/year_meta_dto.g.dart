// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_meta_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$YearMetaDtoCWProxy {
  YearMetaDto year(int year);

  YearMetaDto keyword(String keyword);

  YearMetaDto vision(String vision);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearMetaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearMetaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearMetaDto call({int year, String keyword, String vision});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfYearMetaDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfYearMetaDto.copyWith.fieldName(...)`
class _$YearMetaDtoCWProxyImpl implements _$YearMetaDtoCWProxy {
  const _$YearMetaDtoCWProxyImpl(this._value);

  final YearMetaDto _value;

  @override
  YearMetaDto year(int year) => this(year: year);

  @override
  YearMetaDto keyword(String keyword) => this(keyword: keyword);

  @override
  YearMetaDto vision(String vision) => this(vision: vision);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `YearMetaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// YearMetaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  YearMetaDto call({
    Object? year = const $CopyWithPlaceholder(),
    Object? keyword = const $CopyWithPlaceholder(),
    Object? vision = const $CopyWithPlaceholder(),
  }) {
    return YearMetaDto(
      year: year == const $CopyWithPlaceholder()
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      keyword: keyword == const $CopyWithPlaceholder()
          ? _value.keyword
          // ignore: cast_nullable_to_non_nullable
          : keyword as String,
      vision: vision == const $CopyWithPlaceholder()
          ? _value.vision
          // ignore: cast_nullable_to_non_nullable
          : vision as String,
    );
  }
}

extension $YearMetaDtoCopyWith on YearMetaDto {
  /// Returns a callable class that can be used as follows: `instanceOfYearMetaDto.copyWith(...)` or like so:`instanceOfYearMetaDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$YearMetaDtoCWProxy get copyWith => _$YearMetaDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearMetaDto _$YearMetaDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('YearMetaDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['year', 'keyword', 'vision']);
      final val = YearMetaDto(
        year: $checkedConvert('year', (v) => (v as num).toInt()),
        keyword: $checkedConvert('keyword', (v) => v as String),
        vision: $checkedConvert('vision', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$YearMetaDtoToJson(YearMetaDto instance) =>
    <String, dynamic>{
      'year': instance.year,
      'keyword': instance.keyword,
      'vision': instance.vision,
    };
