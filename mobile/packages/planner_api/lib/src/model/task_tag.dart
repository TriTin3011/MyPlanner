//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum TaskTag {
  @JsonValue(r'urgent')
  urgent(r'urgent'),
  @JsonValue(r'important')
  important(r'important'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const TaskTag(this.value);

  final String value;

  @override
  String toString() => value;
}
