//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'habit_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HabitDto {
  /// Returns a new [HabitDto] instance.
  HabitDto({

    required  this.id,

    required  this.title,

    required  this.order,

    required  this.active,

    required  this.startDate,

    required  this.createdAt,

    required  this.archivedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final int order;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    
    name: r'startDate',
    required: true,
    includeIfNull: false,
  )


  final String startDate;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'archivedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? archivedAt;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is HabitDto &&
      runtimeType == other.runtimeType &&
      equals(
        [
            id,
            title,
            order,
            active,
            startDate,
            createdAt,
            archivedAt,
        ],
        [
            other.id,
            other.title,
            other.order,
            other.active,
            other.startDate,
            other.createdAt,
            other.archivedAt,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        id,
        title,
        order,
        active,
        startDate,
        createdAt,
        archivedAt,
    ],);

  factory HabitDto.fromJson(Map<String, dynamic> json) => _$HabitDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HabitDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

