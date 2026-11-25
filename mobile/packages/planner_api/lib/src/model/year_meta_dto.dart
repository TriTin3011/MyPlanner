//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'year_meta_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class YearMetaDto {
  /// Returns a new [YearMetaDto] instance.
  YearMetaDto({

    required  this.year,

    required  this.keyword,

    required  this.vision,
  });

  @JsonKey(
    
    name: r'year',
    required: true,
    includeIfNull: false,
  )


  final int year;



  @JsonKey(
    
    name: r'keyword',
    required: true,
    includeIfNull: false,
  )


  final String keyword;



  @JsonKey(
    
    name: r'vision',
    required: true,
    includeIfNull: false,
  )


  final String vision;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is YearMetaDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            year,
            keyword,
            vision,
        ],
        [
            other.year,
            other.keyword,
            other.vision,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        year,
        keyword,
        vision,
    ],);

  factory YearMetaDto.fromJson(Map<String, dynamic> json) => _$YearMetaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YearMetaDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

