//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'count_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CountDto {
  /// Returns a new [CountDto] instance.
  CountDto({

    required  this.count,
  });

  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is CountDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            count,
        ],
        [
            other.count,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        count,
    ],);

  factory CountDto.fromJson(Map<String, dynamic> json) => _$CountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

