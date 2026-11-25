//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'health_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthDto {
  /// Returns a new [HealthDto] instance.
  HealthDto({

    required  this.status,

    required  this.database,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'database',
    required: true,
    includeIfNull: false,
  )


  final bool database;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HealthDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            status,
            database,
        ],
        [
            other.status,
            other.database,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        status,
        database,
    ],);

  factory HealthDto.fromJson(Map<String, dynamic> json) => _$HealthDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HealthDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

