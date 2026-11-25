//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'update_year_item_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateYearItemRequest {
  /// Returns a new [UpdateYearItemRequest] instance.
  UpdateYearItemRequest({

    required  this.month,

    required  this.title,

    required  this.done,
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



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is UpdateYearItemRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            month,
            title,
            done,
        ],
        [
            other.month,
            other.title,
            other.done,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        month,
        title,
        done,
    ],);

  factory UpdateYearItemRequest.fromJson(Map<String, dynamic> json) => _$UpdateYearItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateYearItemRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

