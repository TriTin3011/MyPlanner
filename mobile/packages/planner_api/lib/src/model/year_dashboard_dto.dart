//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:planner_api/src/model/year_month_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'year_dashboard_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class YearDashboardDto {
  /// Returns a new [YearDashboardDto] instance.
  YearDashboardDto({

    required  this.year,

    required  this.keyword,

    required  this.vision,

    required  this.done,

    required  this.total,

    required  this.percent,

    required  this.currentMonth,

    required  this.months,
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



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final int done;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final int total;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



  @JsonKey(
    
    name: r'currentMonth',
    required: true,
    includeIfNull: true,
  )


  final int? currentMonth;



  @JsonKey(
    
    name: r'months',
    required: true,
    includeIfNull: false,
  )


  final List<YearMonthDto> months;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is YearDashboardDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            year,
            keyword,
            vision,
            done,
            total,
            percent,
            currentMonth,
            months,
        ],
        [
            other.year,
            other.keyword,
            other.vision,
            other.done,
            other.total,
            other.percent,
            other.currentMonth,
            other.months,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        year,
        keyword,
        vision,
        done,
        total,
        percent,
        currentMonth,
        months,
    ],);

  factory YearDashboardDto.fromJson(Map<String, dynamic> json) => _$YearDashboardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YearDashboardDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

