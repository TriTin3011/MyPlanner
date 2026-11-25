//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/life_area.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'area_summary_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AreaSummaryDto {
  /// Returns a new [AreaSummaryDto] instance.
  AreaSummaryDto({

    required  this.area,

    required  this.count,

    required  this.percent,
  });

  @JsonKey(
    
    name: r'area',
    required: true,
    includeIfNull: false,
  unknownEnumValue: LifeArea.unknownDefaultOpenApi,
  )


  final LifeArea area;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is AreaSummaryDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            area,
            count,
            percent,
        ],
        [
            other.area,
            other.count,
            other.percent,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        area,
        count,
        percent,
    ],);

  factory AreaSummaryDto.fromJson(Map<String, dynamic> json) => _$AreaSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AreaSummaryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

