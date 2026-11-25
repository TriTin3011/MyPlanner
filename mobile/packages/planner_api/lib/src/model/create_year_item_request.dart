//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'create_year_item_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateYearItemRequest {
  /// Returns a new [CreateYearItemRequest] instance.
  CreateYearItemRequest({

    required  this.month,

    required  this.title,
  });

  @JsonKey(
    
    name: r'month',
    required: true,
    includeIfNull: false,
  )


  final int month;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is CreateYearItemRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            month,
            title,
        ],
        [
            other.month,
            other.title,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        month,
        title,
    ],);

  factory CreateYearItemRequest.fromJson(Map<String, dynamic> json) => _$CreateYearItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateYearItemRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

