//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'validation_problem_details.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ValidationProblemDetails {
  /// Returns a new [ValidationProblemDetails] instance.
  ValidationProblemDetails({

     this.type,

     this.title,

     this.status,

     this.detail,

     this.instance,

     this.errors,
  });

  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final String? type;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final int? status;



  @JsonKey(
    
    name: r'detail',
    required: false,
    includeIfNull: false,
  )


  final String? detail;



  @JsonKey(
    
    name: r'instance',
    required: false,
    includeIfNull: false,
  )


  final String? instance;



  @JsonKey(
    
    name: r'errors',
    required: false,
    includeIfNull: false,
  )


  final Map<String, List<String>>? errors;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is ValidationProblemDetails &&
      runtimeType == other.runtimeType &&
      equals(
        [
            type,
            title,
            status,
            detail,
            instance,
            errors,
        ],
        [
            other.type,
            other.title,
            other.status,
            other.detail,
            other.instance,
            other.errors,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        type,
        title,
        status,
        detail,
        instance,
        errors,
    ],);

  factory ValidationProblemDetails.fromJson(Map<String, dynamic> json) => _$ValidationProblemDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationProblemDetailsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

