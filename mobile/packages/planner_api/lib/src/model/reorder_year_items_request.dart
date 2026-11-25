//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'reorder_year_items_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReorderYearItemsRequest {
  /// Returns a new [ReorderYearItemsRequest] instance.
  ReorderYearItemsRequest({

    required  this.month,

    required  this.ids,
  });

  @JsonKey(
    
    name: r'month',
    required: true,
    includeIfNull: false,
  )


  final int month;



  @JsonKey(
    
    name: r'ids',
    required: true,
    includeIfNull: false,
  )


  final List<String> ids;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is ReorderYearItemsRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            month,
            ids,
        ],
        [
            other.month,
            other.ids,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        month,
        ids,
    ],);

  factory ReorderYearItemsRequest.fromJson(Map<String, dynamic> json) => _$ReorderYearItemsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderYearItemsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

