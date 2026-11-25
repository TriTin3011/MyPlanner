//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum DeadlineKind {
  @JsonValue(r'step')
  step(r'step'),
  @JsonValue(r'goal')
  goal(r'goal'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const DeadlineKind(this.value);

  final String value;

  @override
  String toString() => value;
}
