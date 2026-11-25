//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'reorder_tasks_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReorderTasksRequest {
  /// Returns a new [ReorderTasksRequest] instance.
  ReorderTasksRequest({

    required  this.date,

    required  this.ids,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final String date;



  @JsonKey(
    
    name: r'ids',
    required: true,
    includeIfNull: false,
  )


  final List<String> ids;




    bool operator ==(Object other) {
      return identical(this, other) ||
      other is ReorderTasksRequest &&
      runtimeType == other.runtimeType &&
      equals(
        [
            date,
            ids,
        ],
        [
            other.date,
            other.ids,
        ]
      );
    }


    @override
    int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([
        date,
        ids,
    ],);

  factory ReorderTasksRequest.fromJson(Map<String, dynamic> json) => _$ReorderTasksRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderTasksRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

