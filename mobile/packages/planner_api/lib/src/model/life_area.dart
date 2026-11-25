//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum LifeArea {
  @JsonValue(r'health')
  health(r'health'),
  @JsonValue(r'finance')
  finance(r'finance'),
  @JsonValue(r'career')
  career(r'career'),
  @JsonValue(r'growth')
  growth(r'growth'),
  @JsonValue(r'relationship')
  relationship(r'relationship'),
  @JsonValue(r'learning')
  learning(r'learning'),
  @JsonValue(r'family')
  family(r'family'),
  @JsonValue(r'hobby')
  hobby(r'hobby'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const LifeArea(this.value);

  final String value;

  @override
  String toString() => value;
}
