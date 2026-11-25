//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'save_year_meta_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SaveYearMetaRequest {
  /// Returns a new [SaveYearMetaRequest] instance.
  SaveYearMetaRequest({

    required  this.keyword,

    required  this.vision,
  });

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
      other is SaveYearMetaRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            keyword,
            vision,
        ],
        [
            other.keyword,
            other.vision,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        keyword,
        vision,
    ],);

  factory SaveYearMetaRequest.fromJson(Map<String, dynamic> json) => _$SaveYearMetaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveYearMetaRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

