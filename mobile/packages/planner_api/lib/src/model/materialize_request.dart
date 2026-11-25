//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'materialize_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MaterializeRequest {
  /// Returns a new [MaterializeRequest] instance.
  MaterializeRequest({

    required  this.from,

    required  this.to,

    required  this.today,
  });

  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final String from;



  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final String to;



  @JsonKey(
    
    name: r'today',
    required: true,
    includeIfNull: false,
  )


  final String today;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is MaterializeRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            from,
            to,
            today,
        ],
        [
            other.from,
            other.to,
            other.today,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        from,
        to,
        today,
    ],);

  factory MaterializeRequest.fromJson(Map<String, dynamic> json) => _$MaterializeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MaterializeRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

