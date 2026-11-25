//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum GoalStatus {
  @JsonValue(r'not_started')
  notStarted(r'not_started'),
  @JsonValue(r'in_progress')
  inProgress(r'in_progress'),
  @JsonValue(r'done')
  done(r'done'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const GoalStatus(this.value);

  final String value;

  @override
  String toString() => value;
}
