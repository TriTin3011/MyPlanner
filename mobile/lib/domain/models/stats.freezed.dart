// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StatsWeekPoint {

 WeekKey get weekKey; CalendarDate get monday; int get done; int get total; int get percent;
/// Create a copy of StatsWeekPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsWeekPointCopyWith<StatsWeekPoint> get copyWith => _$StatsWeekPointCopyWithImpl<StatsWeekPoint>(this as StatsWeekPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsWeekPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsWeekPoint&&(identical(other.weekKey, _this.weekKey) || other.weekKey == _this.weekKey)&&(identical(other.monday, _this.monday) || other.monday == _this.monday)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percent, _this.percent) || other.percent == _this.percent));
}


@override
int get hashCode {
  final _this = this as StatsWeekPoint;
  return Object.hash(runtimeType,_this.weekKey,_this.monday,_this.done,_this.total,_this.percent);
}

@override
String toString() {
  final _this = this as StatsWeekPoint;
  return 'StatsWeekPoint(weekKey: ${_this.weekKey}, monday: ${_this.monday}, done: ${_this.done}, total: ${_this.total}, percent: ${_this.percent})';
}


}

/// @nodoc
abstract mixin class $StatsWeekPointCopyWith<$Res>  {
  factory $StatsWeekPointCopyWith(StatsWeekPoint value, $Res Function(StatsWeekPoint) _then) = _$StatsWeekPointCopyWithImpl;
@useResult
$Res call({
 WeekKey weekKey, CalendarDate monday, int done, int total, int percent
});




}
/// @nodoc
class _$StatsWeekPointCopyWithImpl<$Res>
    implements $StatsWeekPointCopyWith<$Res> {
  _$StatsWeekPointCopyWithImpl(this._self, this._then);

  final StatsWeekPoint _self;
  final $Res Function(StatsWeekPoint) _then;

/// Create a copy of StatsWeekPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekKey = null,Object? monday = null,Object? done = null,Object? total = null,Object? percent = null,}) {
  return _then(StatsWeekPoint(
weekKey: null == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as WeekKey,monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsWeekPoint].
extension StatsWeekPointPatterns on StatsWeekPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsWeekPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsWeekPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsWeekPoint value)  $default,){
final _that = this;
switch (_that) {
case _StatsWeekPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsWeekPoint value)?  $default,){
final _that = this;
switch (_that) {
case _StatsWeekPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeekKey weekKey,  CalendarDate monday,  int done,  int total,  int percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsWeekPoint() when $default != null:
return $default(_that.weekKey,_that.monday,_that.done,_that.total,_that.percent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeekKey weekKey,  CalendarDate monday,  int done,  int total,  int percent)  $default,) {final _that = this;
switch (_that) {
case _StatsWeekPoint():
return $default(_that.weekKey,_that.monday,_that.done,_that.total,_that.percent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeekKey weekKey,  CalendarDate monday,  int done,  int total,  int percent)?  $default,) {final _that = this;
switch (_that) {
case _StatsWeekPoint() when $default != null:
return $default(_that.weekKey,_that.monday,_that.done,_that.total,_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _StatsWeekPoint implements StatsWeekPoint {
  const _StatsWeekPoint({required this.weekKey, required this.monday, required this.done, required this.total, required this.percent});
  

@override final  WeekKey weekKey;
@override final  CalendarDate monday;
@override final  int done;
@override final  int total;
@override final  int percent;

/// Create a copy of StatsWeekPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsWeekPointCopyWith<_StatsWeekPoint> get copyWith => __$StatsWeekPointCopyWithImpl<_StatsWeekPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsWeekPoint&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weekKey,monday,done,total,percent);
}

@override
String toString() {
    return 'StatsWeekPoint(weekKey: $weekKey, monday: $monday, done: $done, total: $total, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$StatsWeekPointCopyWith<$Res> implements $StatsWeekPointCopyWith<$Res> {
  factory _$StatsWeekPointCopyWith(_StatsWeekPoint value, $Res Function(_StatsWeekPoint) _then) = __$StatsWeekPointCopyWithImpl;
@override @useResult
$Res call({
 WeekKey weekKey, CalendarDate monday, int done, int total, int percent
});




}
/// @nodoc
class __$StatsWeekPointCopyWithImpl<$Res>
    implements _$StatsWeekPointCopyWith<$Res> {
  __$StatsWeekPointCopyWithImpl(this._self, this._then);

  final _StatsWeekPoint _self;
  final $Res Function(_StatsWeekPoint) _then;

/// Create a copy of StatsWeekPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekKey = null,Object? monday = null,Object? done = null,Object? total = null,Object? percent = null,}) {
  return _then(_StatsWeekPoint(
weekKey: null == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as WeekKey,monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StatsHero {

 int get completionPercent; int get tasksDone; int get tasksTotal; int get deltaPoints;/// 1 = Thứ 2 … 7 = Chủ nhật.
 int? get bestWeekday; List<StatsWeekPoint> get weeklySparkline;
/// Create a copy of StatsHero
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsHeroCopyWith<StatsHero> get copyWith => _$StatsHeroCopyWithImpl<StatsHero>(this as StatsHero, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsHero;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsHero&&(identical(other.completionPercent, _this.completionPercent) || other.completionPercent == _this.completionPercent)&&(identical(other.tasksDone, _this.tasksDone) || other.tasksDone == _this.tasksDone)&&(identical(other.tasksTotal, _this.tasksTotal) || other.tasksTotal == _this.tasksTotal)&&(identical(other.deltaPoints, _this.deltaPoints) || other.deltaPoints == _this.deltaPoints)&&(identical(other.bestWeekday, _this.bestWeekday) || other.bestWeekday == _this.bestWeekday)&&const DeepCollectionEquality().equals(other.weeklySparkline, _this.weeklySparkline));
}


@override
int get hashCode {
  final _this = this as StatsHero;
  return Object.hash(runtimeType,_this.completionPercent,_this.tasksDone,_this.tasksTotal,_this.deltaPoints,_this.bestWeekday,const DeepCollectionEquality().hash(_this.weeklySparkline));
}

@override
String toString() {
  final _this = this as StatsHero;
  return 'StatsHero(completionPercent: ${_this.completionPercent}, tasksDone: ${_this.tasksDone}, tasksTotal: ${_this.tasksTotal}, deltaPoints: ${_this.deltaPoints}, bestWeekday: ${_this.bestWeekday}, weeklySparkline: ${_this.weeklySparkline})';
}


}

/// @nodoc
abstract mixin class $StatsHeroCopyWith<$Res>  {
  factory $StatsHeroCopyWith(StatsHero value, $Res Function(StatsHero) _then) = _$StatsHeroCopyWithImpl;
@useResult
$Res call({
 int completionPercent, int tasksDone, int tasksTotal, int deltaPoints, int? bestWeekday, List<StatsWeekPoint> weeklySparkline
});




}
/// @nodoc
class _$StatsHeroCopyWithImpl<$Res>
    implements $StatsHeroCopyWith<$Res> {
  _$StatsHeroCopyWithImpl(this._self, this._then);

  final StatsHero _self;
  final $Res Function(StatsHero) _then;

/// Create a copy of StatsHero
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completionPercent = null,Object? tasksDone = null,Object? tasksTotal = null,Object? deltaPoints = null,Object? bestWeekday = freezed,Object? weeklySparkline = null,}) {
  return _then(StatsHero(
completionPercent: null == completionPercent ? _self.completionPercent : completionPercent // ignore: cast_nullable_to_non_nullable
as int,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,deltaPoints: null == deltaPoints ? _self.deltaPoints : deltaPoints // ignore: cast_nullable_to_non_nullable
as int,bestWeekday: freezed == bestWeekday ? _self.bestWeekday : bestWeekday // ignore: cast_nullable_to_non_nullable
as int?,weeklySparkline: null == weeklySparkline ? _self.weeklySparkline : weeklySparkline // ignore: cast_nullable_to_non_nullable
as List<StatsWeekPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsHero].
extension StatsHeroPatterns on StatsHero {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsHero value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsHero() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsHero value)  $default,){
final _that = this;
switch (_that) {
case _StatsHero():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsHero value)?  $default,){
final _that = this;
switch (_that) {
case _StatsHero() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int completionPercent,  int tasksDone,  int tasksTotal,  int deltaPoints,  int? bestWeekday,  List<StatsWeekPoint> weeklySparkline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsHero() when $default != null:
return $default(_that.completionPercent,_that.tasksDone,_that.tasksTotal,_that.deltaPoints,_that.bestWeekday,_that.weeklySparkline);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int completionPercent,  int tasksDone,  int tasksTotal,  int deltaPoints,  int? bestWeekday,  List<StatsWeekPoint> weeklySparkline)  $default,) {final _that = this;
switch (_that) {
case _StatsHero():
return $default(_that.completionPercent,_that.tasksDone,_that.tasksTotal,_that.deltaPoints,_that.bestWeekday,_that.weeklySparkline);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int completionPercent,  int tasksDone,  int tasksTotal,  int deltaPoints,  int? bestWeekday,  List<StatsWeekPoint> weeklySparkline)?  $default,) {final _that = this;
switch (_that) {
case _StatsHero() when $default != null:
return $default(_that.completionPercent,_that.tasksDone,_that.tasksTotal,_that.deltaPoints,_that.bestWeekday,_that.weeklySparkline);case _:
  return null;

}
}

}

/// @nodoc


class _StatsHero implements StatsHero {
  const _StatsHero({required this.completionPercent, required this.tasksDone, required this.tasksTotal, required this.deltaPoints, this.bestWeekday, required  List<StatsWeekPoint> weeklySparkline}): _weeklySparkline = weeklySparkline;
  

@override final  int completionPercent;
@override final  int tasksDone;
@override final  int tasksTotal;
@override final  int deltaPoints;
/// 1 = Thứ 2 … 7 = Chủ nhật.
@override final  int? bestWeekday;
 final  List<StatsWeekPoint> _weeklySparkline;
@override List<StatsWeekPoint> get weeklySparkline {
  if (_weeklySparkline is EqualUnmodifiableListView) return _weeklySparkline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklySparkline);
}


/// Create a copy of StatsHero
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsHeroCopyWith<_StatsHero> get copyWith => __$StatsHeroCopyWithImpl<_StatsHero>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsHero&&(identical(other.completionPercent, completionPercent) || other.completionPercent == completionPercent)&&(identical(other.tasksDone, tasksDone) || other.tasksDone == tasksDone)&&(identical(other.tasksTotal, tasksTotal) || other.tasksTotal == tasksTotal)&&(identical(other.deltaPoints, deltaPoints) || other.deltaPoints == deltaPoints)&&(identical(other.bestWeekday, bestWeekday) || other.bestWeekday == bestWeekday)&&const DeepCollectionEquality().equals(other.weeklySparkline, _weeklySparkline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,completionPercent,tasksDone,tasksTotal,deltaPoints,bestWeekday,const DeepCollectionEquality().hash(_weeklySparkline));
}

@override
String toString() {
    return 'StatsHero(completionPercent: $completionPercent, tasksDone: $tasksDone, tasksTotal: $tasksTotal, deltaPoints: $deltaPoints, bestWeekday: $bestWeekday, weeklySparkline: $weeklySparkline)';
}


}

/// @nodoc
abstract mixin class _$StatsHeroCopyWith<$Res> implements $StatsHeroCopyWith<$Res> {
  factory _$StatsHeroCopyWith(_StatsHero value, $Res Function(_StatsHero) _then) = __$StatsHeroCopyWithImpl;
@override @useResult
$Res call({
 int completionPercent, int tasksDone, int tasksTotal, int deltaPoints, int? bestWeekday, List<StatsWeekPoint> weeklySparkline
});




}
/// @nodoc
class __$StatsHeroCopyWithImpl<$Res>
    implements _$StatsHeroCopyWith<$Res> {
  __$StatsHeroCopyWithImpl(this._self, this._then);

  final _StatsHero _self;
  final $Res Function(_StatsHero) _then;

/// Create a copy of StatsHero
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completionPercent = null,Object? tasksDone = null,Object? tasksTotal = null,Object? deltaPoints = null,Object? bestWeekday = freezed,Object? weeklySparkline = null,}) {
  return _then(_StatsHero(
completionPercent: null == completionPercent ? _self.completionPercent : completionPercent // ignore: cast_nullable_to_non_nullable
as int,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,deltaPoints: null == deltaPoints ? _self.deltaPoints : deltaPoints // ignore: cast_nullable_to_non_nullable
as int,bestWeekday: freezed == bestWeekday ? _self.bestWeekday : bestWeekday // ignore: cast_nullable_to_non_nullable
as int?,weeklySparkline: null == weeklySparkline ? _self._weeklySparkline : weeklySparkline // ignore: cast_nullable_to_non_nullable
as List<StatsWeekPoint>,
  ));
}


}

/// @nodoc
mixin _$StatsKpis {

 int get tasksDone; int? get tasksDonePercentChange; int get activityCurrentStreak; int get activityLongestStreak; int get habitPercent; int get habitDeltaPoints;
/// Create a copy of StatsKpis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsKpisCopyWith<StatsKpis> get copyWith => _$StatsKpisCopyWithImpl<StatsKpis>(this as StatsKpis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsKpis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsKpis&&(identical(other.tasksDone, _this.tasksDone) || other.tasksDone == _this.tasksDone)&&(identical(other.tasksDonePercentChange, _this.tasksDonePercentChange) || other.tasksDonePercentChange == _this.tasksDonePercentChange)&&(identical(other.activityCurrentStreak, _this.activityCurrentStreak) || other.activityCurrentStreak == _this.activityCurrentStreak)&&(identical(other.activityLongestStreak, _this.activityLongestStreak) || other.activityLongestStreak == _this.activityLongestStreak)&&(identical(other.habitPercent, _this.habitPercent) || other.habitPercent == _this.habitPercent)&&(identical(other.habitDeltaPoints, _this.habitDeltaPoints) || other.habitDeltaPoints == _this.habitDeltaPoints));
}


@override
int get hashCode {
  final _this = this as StatsKpis;
  return Object.hash(runtimeType,_this.tasksDone,_this.tasksDonePercentChange,_this.activityCurrentStreak,_this.activityLongestStreak,_this.habitPercent,_this.habitDeltaPoints);
}

@override
String toString() {
  final _this = this as StatsKpis;
  return 'StatsKpis(tasksDone: ${_this.tasksDone}, tasksDonePercentChange: ${_this.tasksDonePercentChange}, activityCurrentStreak: ${_this.activityCurrentStreak}, activityLongestStreak: ${_this.activityLongestStreak}, habitPercent: ${_this.habitPercent}, habitDeltaPoints: ${_this.habitDeltaPoints})';
}


}

/// @nodoc
abstract mixin class $StatsKpisCopyWith<$Res>  {
  factory $StatsKpisCopyWith(StatsKpis value, $Res Function(StatsKpis) _then) = _$StatsKpisCopyWithImpl;
@useResult
$Res call({
 int tasksDone, int? tasksDonePercentChange, int activityCurrentStreak, int activityLongestStreak, int habitPercent, int habitDeltaPoints
});




}
/// @nodoc
class _$StatsKpisCopyWithImpl<$Res>
    implements $StatsKpisCopyWith<$Res> {
  _$StatsKpisCopyWithImpl(this._self, this._then);

  final StatsKpis _self;
  final $Res Function(StatsKpis) _then;

/// Create a copy of StatsKpis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasksDone = null,Object? tasksDonePercentChange = freezed,Object? activityCurrentStreak = null,Object? activityLongestStreak = null,Object? habitPercent = null,Object? habitDeltaPoints = null,}) {
  return _then(StatsKpis(
tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksDonePercentChange: freezed == tasksDonePercentChange ? _self.tasksDonePercentChange : tasksDonePercentChange // ignore: cast_nullable_to_non_nullable
as int?,activityCurrentStreak: null == activityCurrentStreak ? _self.activityCurrentStreak : activityCurrentStreak // ignore: cast_nullable_to_non_nullable
as int,activityLongestStreak: null == activityLongestStreak ? _self.activityLongestStreak : activityLongestStreak // ignore: cast_nullable_to_non_nullable
as int,habitPercent: null == habitPercent ? _self.habitPercent : habitPercent // ignore: cast_nullable_to_non_nullable
as int,habitDeltaPoints: null == habitDeltaPoints ? _self.habitDeltaPoints : habitDeltaPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsKpis].
extension StatsKpisPatterns on StatsKpis {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsKpis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsKpis() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsKpis value)  $default,){
final _that = this;
switch (_that) {
case _StatsKpis():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsKpis value)?  $default,){
final _that = this;
switch (_that) {
case _StatsKpis() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tasksDone,  int? tasksDonePercentChange,  int activityCurrentStreak,  int activityLongestStreak,  int habitPercent,  int habitDeltaPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsKpis() when $default != null:
return $default(_that.tasksDone,_that.tasksDonePercentChange,_that.activityCurrentStreak,_that.activityLongestStreak,_that.habitPercent,_that.habitDeltaPoints);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tasksDone,  int? tasksDonePercentChange,  int activityCurrentStreak,  int activityLongestStreak,  int habitPercent,  int habitDeltaPoints)  $default,) {final _that = this;
switch (_that) {
case _StatsKpis():
return $default(_that.tasksDone,_that.tasksDonePercentChange,_that.activityCurrentStreak,_that.activityLongestStreak,_that.habitPercent,_that.habitDeltaPoints);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tasksDone,  int? tasksDonePercentChange,  int activityCurrentStreak,  int activityLongestStreak,  int habitPercent,  int habitDeltaPoints)?  $default,) {final _that = this;
switch (_that) {
case _StatsKpis() when $default != null:
return $default(_that.tasksDone,_that.tasksDonePercentChange,_that.activityCurrentStreak,_that.activityLongestStreak,_that.habitPercent,_that.habitDeltaPoints);case _:
  return null;

}
}

}

/// @nodoc


class _StatsKpis implements StatsKpis {
  const _StatsKpis({required this.tasksDone, this.tasksDonePercentChange, required this.activityCurrentStreak, required this.activityLongestStreak, required this.habitPercent, required this.habitDeltaPoints});
  

@override final  int tasksDone;
@override final  int? tasksDonePercentChange;
@override final  int activityCurrentStreak;
@override final  int activityLongestStreak;
@override final  int habitPercent;
@override final  int habitDeltaPoints;

/// Create a copy of StatsKpis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsKpisCopyWith<_StatsKpis> get copyWith => __$StatsKpisCopyWithImpl<_StatsKpis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsKpis&&(identical(other.tasksDone, tasksDone) || other.tasksDone == tasksDone)&&(identical(other.tasksDonePercentChange, tasksDonePercentChange) || other.tasksDonePercentChange == tasksDonePercentChange)&&(identical(other.activityCurrentStreak, activityCurrentStreak) || other.activityCurrentStreak == activityCurrentStreak)&&(identical(other.activityLongestStreak, activityLongestStreak) || other.activityLongestStreak == activityLongestStreak)&&(identical(other.habitPercent, habitPercent) || other.habitPercent == habitPercent)&&(identical(other.habitDeltaPoints, habitDeltaPoints) || other.habitDeltaPoints == habitDeltaPoints));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tasksDone,tasksDonePercentChange,activityCurrentStreak,activityLongestStreak,habitPercent,habitDeltaPoints);
}

@override
String toString() {
    return 'StatsKpis(tasksDone: $tasksDone, tasksDonePercentChange: $tasksDonePercentChange, activityCurrentStreak: $activityCurrentStreak, activityLongestStreak: $activityLongestStreak, habitPercent: $habitPercent, habitDeltaPoints: $habitDeltaPoints)';
}


}

/// @nodoc
abstract mixin class _$StatsKpisCopyWith<$Res> implements $StatsKpisCopyWith<$Res> {
  factory _$StatsKpisCopyWith(_StatsKpis value, $Res Function(_StatsKpis) _then) = __$StatsKpisCopyWithImpl;
@override @useResult
$Res call({
 int tasksDone, int? tasksDonePercentChange, int activityCurrentStreak, int activityLongestStreak, int habitPercent, int habitDeltaPoints
});




}
/// @nodoc
class __$StatsKpisCopyWithImpl<$Res>
    implements _$StatsKpisCopyWith<$Res> {
  __$StatsKpisCopyWithImpl(this._self, this._then);

  final _StatsKpis _self;
  final $Res Function(_StatsKpis) _then;

/// Create a copy of StatsKpis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasksDone = null,Object? tasksDonePercentChange = freezed,Object? activityCurrentStreak = null,Object? activityLongestStreak = null,Object? habitPercent = null,Object? habitDeltaPoints = null,}) {
  return _then(_StatsKpis(
tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksDonePercentChange: freezed == tasksDonePercentChange ? _self.tasksDonePercentChange : tasksDonePercentChange // ignore: cast_nullable_to_non_nullable
as int?,activityCurrentStreak: null == activityCurrentStreak ? _self.activityCurrentStreak : activityCurrentStreak // ignore: cast_nullable_to_non_nullable
as int,activityLongestStreak: null == activityLongestStreak ? _self.activityLongestStreak : activityLongestStreak // ignore: cast_nullable_to_non_nullable
as int,habitPercent: null == habitPercent ? _self.habitPercent : habitPercent // ignore: cast_nullable_to_non_nullable
as int,habitDeltaPoints: null == habitDeltaPoints ? _self.habitDeltaPoints : habitDeltaPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StatsHeatmapDay {

 CalendarDate get date; int get done;/// 0–4, backend chia mức.
 int get level;
/// Create a copy of StatsHeatmapDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsHeatmapDayCopyWith<StatsHeatmapDay> get copyWith => _$StatsHeatmapDayCopyWithImpl<StatsHeatmapDay>(this as StatsHeatmapDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsHeatmapDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsHeatmapDay&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.level, _this.level) || other.level == _this.level));
}


@override
int get hashCode {
  final _this = this as StatsHeatmapDay;
  return Object.hash(runtimeType,_this.date,_this.done,_this.level);
}

@override
String toString() {
  final _this = this as StatsHeatmapDay;
  return 'StatsHeatmapDay(date: ${_this.date}, done: ${_this.done}, level: ${_this.level})';
}


}

/// @nodoc
abstract mixin class $StatsHeatmapDayCopyWith<$Res>  {
  factory $StatsHeatmapDayCopyWith(StatsHeatmapDay value, $Res Function(StatsHeatmapDay) _then) = _$StatsHeatmapDayCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, int done, int level
});




}
/// @nodoc
class _$StatsHeatmapDayCopyWithImpl<$Res>
    implements $StatsHeatmapDayCopyWith<$Res> {
  _$StatsHeatmapDayCopyWithImpl(this._self, this._then);

  final StatsHeatmapDay _self;
  final $Res Function(StatsHeatmapDay) _then;

/// Create a copy of StatsHeatmapDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? done = null,Object? level = null,}) {
  return _then(StatsHeatmapDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsHeatmapDay].
extension StatsHeatmapDayPatterns on StatsHeatmapDay {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsHeatmapDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsHeatmapDay() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsHeatmapDay value)  $default,){
final _that = this;
switch (_that) {
case _StatsHeatmapDay():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsHeatmapDay value)?  $default,){
final _that = this;
switch (_that) {
case _StatsHeatmapDay() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  int done,  int level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsHeatmapDay() when $default != null:
return $default(_that.date,_that.done,_that.level);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  int done,  int level)  $default,) {final _that = this;
switch (_that) {
case _StatsHeatmapDay():
return $default(_that.date,_that.done,_that.level);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  int done,  int level)?  $default,) {final _that = this;
switch (_that) {
case _StatsHeatmapDay() when $default != null:
return $default(_that.date,_that.done,_that.level);case _:
  return null;

}
}

}

/// @nodoc


class _StatsHeatmapDay implements StatsHeatmapDay {
  const _StatsHeatmapDay({required this.date, required this.done, required this.level});
  

@override final  CalendarDate date;
@override final  int done;
/// 0–4, backend chia mức.
@override final  int level;

/// Create a copy of StatsHeatmapDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsHeatmapDayCopyWith<_StatsHeatmapDay> get copyWith => __$StatsHeatmapDayCopyWithImpl<_StatsHeatmapDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsHeatmapDay&&(identical(other.date, date) || other.date == date)&&(identical(other.done, done) || other.done == done)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,done,level);
}

@override
String toString() {
    return 'StatsHeatmapDay(date: $date, done: $done, level: $level)';
}


}

/// @nodoc
abstract mixin class _$StatsHeatmapDayCopyWith<$Res> implements $StatsHeatmapDayCopyWith<$Res> {
  factory _$StatsHeatmapDayCopyWith(_StatsHeatmapDay value, $Res Function(_StatsHeatmapDay) _then) = __$StatsHeatmapDayCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, int done, int level
});




}
/// @nodoc
class __$StatsHeatmapDayCopyWithImpl<$Res>
    implements _$StatsHeatmapDayCopyWith<$Res> {
  __$StatsHeatmapDayCopyWithImpl(this._self, this._then);

  final _StatsHeatmapDay _self;
  final $Res Function(_StatsHeatmapDay) _then;

/// Create a copy of StatsHeatmapDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? done = null,Object? level = null,}) {
  return _then(_StatsHeatmapDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StatsWeekday {

 int get weekday; double get averageDone;
/// Create a copy of StatsWeekday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsWeekdayCopyWith<StatsWeekday> get copyWith => _$StatsWeekdayCopyWithImpl<StatsWeekday>(this as StatsWeekday, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsWeekday;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsWeekday&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.averageDone, _this.averageDone) || other.averageDone == _this.averageDone));
}


@override
int get hashCode {
  final _this = this as StatsWeekday;
  return Object.hash(runtimeType,_this.weekday,_this.averageDone);
}

@override
String toString() {
  final _this = this as StatsWeekday;
  return 'StatsWeekday(weekday: ${_this.weekday}, averageDone: ${_this.averageDone})';
}


}

/// @nodoc
abstract mixin class $StatsWeekdayCopyWith<$Res>  {
  factory $StatsWeekdayCopyWith(StatsWeekday value, $Res Function(StatsWeekday) _then) = _$StatsWeekdayCopyWithImpl;
@useResult
$Res call({
 int weekday, double averageDone
});




}
/// @nodoc
class _$StatsWeekdayCopyWithImpl<$Res>
    implements $StatsWeekdayCopyWith<$Res> {
  _$StatsWeekdayCopyWithImpl(this._self, this._then);

  final StatsWeekday _self;
  final $Res Function(StatsWeekday) _then;

/// Create a copy of StatsWeekday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? averageDone = null,}) {
  return _then(StatsWeekday(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,averageDone: null == averageDone ? _self.averageDone : averageDone // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsWeekday].
extension StatsWeekdayPatterns on StatsWeekday {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsWeekday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsWeekday() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsWeekday value)  $default,){
final _that = this;
switch (_that) {
case _StatsWeekday():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsWeekday value)?  $default,){
final _that = this;
switch (_that) {
case _StatsWeekday() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  double averageDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsWeekday() when $default != null:
return $default(_that.weekday,_that.averageDone);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  double averageDone)  $default,) {final _that = this;
switch (_that) {
case _StatsWeekday():
return $default(_that.weekday,_that.averageDone);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  double averageDone)?  $default,) {final _that = this;
switch (_that) {
case _StatsWeekday() when $default != null:
return $default(_that.weekday,_that.averageDone);case _:
  return null;

}
}

}

/// @nodoc


class _StatsWeekday implements StatsWeekday {
  const _StatsWeekday({required this.weekday, required this.averageDone});
  

@override final  int weekday;
@override final  double averageDone;

/// Create a copy of StatsWeekday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsWeekdayCopyWith<_StatsWeekday> get copyWith => __$StatsWeekdayCopyWithImpl<_StatsWeekday>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsWeekday&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.averageDone, averageDone) || other.averageDone == averageDone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weekday,averageDone);
}

@override
String toString() {
    return 'StatsWeekday(weekday: $weekday, averageDone: $averageDone)';
}


}

/// @nodoc
abstract mixin class _$StatsWeekdayCopyWith<$Res> implements $StatsWeekdayCopyWith<$Res> {
  factory _$StatsWeekdayCopyWith(_StatsWeekday value, $Res Function(_StatsWeekday) _then) = __$StatsWeekdayCopyWithImpl;
@override @useResult
$Res call({
 int weekday, double averageDone
});




}
/// @nodoc
class __$StatsWeekdayCopyWithImpl<$Res>
    implements _$StatsWeekdayCopyWith<$Res> {
  __$StatsWeekdayCopyWithImpl(this._self, this._then);

  final _StatsWeekday _self;
  final $Res Function(_StatsWeekday) _then;

/// Create a copy of StatsWeekday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? averageDone = null,}) {
  return _then(_StatsWeekday(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,averageDone: null == averageDone ? _self.averageDone : averageDone // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$StatsHabit {

 String get habitId; String get title; int get percent; int get doneDays; int get possibleDays; int get currentStreak; int get longestStreak;
/// Create a copy of StatsHabit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsHabitCopyWith<StatsHabit> get copyWith => _$StatsHabitCopyWithImpl<StatsHabit>(this as StatsHabit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsHabit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsHabit&&(identical(other.habitId, _this.habitId) || other.habitId == _this.habitId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.doneDays, _this.doneDays) || other.doneDays == _this.doneDays)&&(identical(other.possibleDays, _this.possibleDays) || other.possibleDays == _this.possibleDays)&&(identical(other.currentStreak, _this.currentStreak) || other.currentStreak == _this.currentStreak)&&(identical(other.longestStreak, _this.longestStreak) || other.longestStreak == _this.longestStreak));
}


@override
int get hashCode {
  final _this = this as StatsHabit;
  return Object.hash(runtimeType,_this.habitId,_this.title,_this.percent,_this.doneDays,_this.possibleDays,_this.currentStreak,_this.longestStreak);
}

@override
String toString() {
  final _this = this as StatsHabit;
  return 'StatsHabit(habitId: ${_this.habitId}, title: ${_this.title}, percent: ${_this.percent}, doneDays: ${_this.doneDays}, possibleDays: ${_this.possibleDays}, currentStreak: ${_this.currentStreak}, longestStreak: ${_this.longestStreak})';
}


}

/// @nodoc
abstract mixin class $StatsHabitCopyWith<$Res>  {
  factory $StatsHabitCopyWith(StatsHabit value, $Res Function(StatsHabit) _then) = _$StatsHabitCopyWithImpl;
@useResult
$Res call({
 String habitId, String title, int percent, int doneDays, int possibleDays, int currentStreak, int longestStreak
});




}
/// @nodoc
class _$StatsHabitCopyWithImpl<$Res>
    implements $StatsHabitCopyWith<$Res> {
  _$StatsHabitCopyWithImpl(this._self, this._then);

  final StatsHabit _self;
  final $Res Function(StatsHabit) _then;

/// Create a copy of StatsHabit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habitId = null,Object? title = null,Object? percent = null,Object? doneDays = null,Object? possibleDays = null,Object? currentStreak = null,Object? longestStreak = null,}) {
  return _then(StatsHabit(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,doneDays: null == doneDays ? _self.doneDays : doneDays // ignore: cast_nullable_to_non_nullable
as int,possibleDays: null == possibleDays ? _self.possibleDays : possibleDays // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsHabit].
extension StatsHabitPatterns on StatsHabit {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsHabit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsHabit() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsHabit value)  $default,){
final _that = this;
switch (_that) {
case _StatsHabit():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsHabit value)?  $default,){
final _that = this;
switch (_that) {
case _StatsHabit() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String habitId,  String title,  int percent,  int doneDays,  int possibleDays,  int currentStreak,  int longestStreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsHabit() when $default != null:
return $default(_that.habitId,_that.title,_that.percent,_that.doneDays,_that.possibleDays,_that.currentStreak,_that.longestStreak);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String habitId,  String title,  int percent,  int doneDays,  int possibleDays,  int currentStreak,  int longestStreak)  $default,) {final _that = this;
switch (_that) {
case _StatsHabit():
return $default(_that.habitId,_that.title,_that.percent,_that.doneDays,_that.possibleDays,_that.currentStreak,_that.longestStreak);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String habitId,  String title,  int percent,  int doneDays,  int possibleDays,  int currentStreak,  int longestStreak)?  $default,) {final _that = this;
switch (_that) {
case _StatsHabit() when $default != null:
return $default(_that.habitId,_that.title,_that.percent,_that.doneDays,_that.possibleDays,_that.currentStreak,_that.longestStreak);case _:
  return null;

}
}

}

/// @nodoc


class _StatsHabit implements StatsHabit {
  const _StatsHabit({required this.habitId, required this.title, required this.percent, required this.doneDays, required this.possibleDays, required this.currentStreak, required this.longestStreak});
  

@override final  String habitId;
@override final  String title;
@override final  int percent;
@override final  int doneDays;
@override final  int possibleDays;
@override final  int currentStreak;
@override final  int longestStreak;

/// Create a copy of StatsHabit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsHabitCopyWith<_StatsHabit> get copyWith => __$StatsHabitCopyWithImpl<_StatsHabit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsHabit&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.title, title) || other.title == title)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.doneDays, doneDays) || other.doneDays == doneDays)&&(identical(other.possibleDays, possibleDays) || other.possibleDays == possibleDays)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak));
}


@override
int get hashCode {
    return Object.hash(runtimeType,habitId,title,percent,doneDays,possibleDays,currentStreak,longestStreak);
}

@override
String toString() {
    return 'StatsHabit(habitId: $habitId, title: $title, percent: $percent, doneDays: $doneDays, possibleDays: $possibleDays, currentStreak: $currentStreak, longestStreak: $longestStreak)';
}


}

/// @nodoc
abstract mixin class _$StatsHabitCopyWith<$Res> implements $StatsHabitCopyWith<$Res> {
  factory _$StatsHabitCopyWith(_StatsHabit value, $Res Function(_StatsHabit) _then) = __$StatsHabitCopyWithImpl;
@override @useResult
$Res call({
 String habitId, String title, int percent, int doneDays, int possibleDays, int currentStreak, int longestStreak
});




}
/// @nodoc
class __$StatsHabitCopyWithImpl<$Res>
    implements _$StatsHabitCopyWith<$Res> {
  __$StatsHabitCopyWithImpl(this._self, this._then);

  final _StatsHabit _self;
  final $Res Function(_StatsHabit) _then;

/// Create a copy of StatsHabit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habitId = null,Object? title = null,Object? percent = null,Object? doneDays = null,Object? possibleDays = null,Object? currentStreak = null,Object? longestStreak = null,}) {
  return _then(_StatsHabit(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,doneDays: null == doneDays ? _self.doneDays : doneDays // ignore: cast_nullable_to_non_nullable
as int,possibleDays: null == possibleDays ? _self.possibleDays : possibleDays // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StatsGoalArea {

 LifeArea get area; int get done; int get total;
/// Create a copy of StatsGoalArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsGoalAreaCopyWith<StatsGoalArea> get copyWith => _$StatsGoalAreaCopyWithImpl<StatsGoalArea>(this as StatsGoalArea, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsGoalArea;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsGoalArea&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as StatsGoalArea;
  return Object.hash(runtimeType,_this.area,_this.done,_this.total);
}

@override
String toString() {
  final _this = this as StatsGoalArea;
  return 'StatsGoalArea(area: ${_this.area}, done: ${_this.done}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $StatsGoalAreaCopyWith<$Res>  {
  factory $StatsGoalAreaCopyWith(StatsGoalArea value, $Res Function(StatsGoalArea) _then) = _$StatsGoalAreaCopyWithImpl;
@useResult
$Res call({
 LifeArea area, int done, int total
});




}
/// @nodoc
class _$StatsGoalAreaCopyWithImpl<$Res>
    implements $StatsGoalAreaCopyWith<$Res> {
  _$StatsGoalAreaCopyWithImpl(this._self, this._then);

  final StatsGoalArea _self;
  final $Res Function(StatsGoalArea) _then;

/// Create a copy of StatsGoalArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = null,Object? done = null,Object? total = null,}) {
  return _then(StatsGoalArea(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsGoalArea].
extension StatsGoalAreaPatterns on StatsGoalArea {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsGoalArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsGoalArea() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsGoalArea value)  $default,){
final _that = this;
switch (_that) {
case _StatsGoalArea():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsGoalArea value)?  $default,){
final _that = this;
switch (_that) {
case _StatsGoalArea() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LifeArea area,  int done,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsGoalArea() when $default != null:
return $default(_that.area,_that.done,_that.total);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LifeArea area,  int done,  int total)  $default,) {final _that = this;
switch (_that) {
case _StatsGoalArea():
return $default(_that.area,_that.done,_that.total);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LifeArea area,  int done,  int total)?  $default,) {final _that = this;
switch (_that) {
case _StatsGoalArea() when $default != null:
return $default(_that.area,_that.done,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _StatsGoalArea implements StatsGoalArea {
  const _StatsGoalArea({required this.area, required this.done, required this.total});
  

@override final  LifeArea area;
@override final  int done;
@override final  int total;

/// Create a copy of StatsGoalArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsGoalAreaCopyWith<_StatsGoalArea> get copyWith => __$StatsGoalAreaCopyWithImpl<_StatsGoalArea>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsGoalArea&&(identical(other.area, area) || other.area == area)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,area,done,total);
}

@override
String toString() {
    return 'StatsGoalArea(area: $area, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class _$StatsGoalAreaCopyWith<$Res> implements $StatsGoalAreaCopyWith<$Res> {
  factory _$StatsGoalAreaCopyWith(_StatsGoalArea value, $Res Function(_StatsGoalArea) _then) = __$StatsGoalAreaCopyWithImpl;
@override @useResult
$Res call({
 LifeArea area, int done, int total
});




}
/// @nodoc
class __$StatsGoalAreaCopyWithImpl<$Res>
    implements _$StatsGoalAreaCopyWith<$Res> {
  __$StatsGoalAreaCopyWithImpl(this._self, this._then);

  final _StatsGoalArea _self;
  final $Res Function(_StatsGoalArea) _then;

/// Create a copy of StatsGoalArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? area = null,Object? done = null,Object? total = null,}) {
  return _then(_StatsGoalArea(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StatsGoals {

 int get total; int get percentDone; int get notStarted; int get inProgress; int get done; List<StatsGoalArea> get byArea;
/// Create a copy of StatsGoals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsGoalsCopyWith<StatsGoals> get copyWith => _$StatsGoalsCopyWithImpl<StatsGoals>(this as StatsGoals, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsGoals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsGoals&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percentDone, _this.percentDone) || other.percentDone == _this.percentDone)&&(identical(other.notStarted, _this.notStarted) || other.notStarted == _this.notStarted)&&(identical(other.inProgress, _this.inProgress) || other.inProgress == _this.inProgress)&&(identical(other.done, _this.done) || other.done == _this.done)&&const DeepCollectionEquality().equals(other.byArea, _this.byArea));
}


@override
int get hashCode {
  final _this = this as StatsGoals;
  return Object.hash(runtimeType,_this.total,_this.percentDone,_this.notStarted,_this.inProgress,_this.done,const DeepCollectionEquality().hash(_this.byArea));
}

@override
String toString() {
  final _this = this as StatsGoals;
  return 'StatsGoals(total: ${_this.total}, percentDone: ${_this.percentDone}, notStarted: ${_this.notStarted}, inProgress: ${_this.inProgress}, done: ${_this.done}, byArea: ${_this.byArea})';
}


}

/// @nodoc
abstract mixin class $StatsGoalsCopyWith<$Res>  {
  factory $StatsGoalsCopyWith(StatsGoals value, $Res Function(StatsGoals) _then) = _$StatsGoalsCopyWithImpl;
@useResult
$Res call({
 int total, int percentDone, int notStarted, int inProgress, int done, List<StatsGoalArea> byArea
});




}
/// @nodoc
class _$StatsGoalsCopyWithImpl<$Res>
    implements $StatsGoalsCopyWith<$Res> {
  _$StatsGoalsCopyWithImpl(this._self, this._then);

  final StatsGoals _self;
  final $Res Function(StatsGoals) _then;

/// Create a copy of StatsGoals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? percentDone = null,Object? notStarted = null,Object? inProgress = null,Object? done = null,Object? byArea = null,}) {
  return _then(StatsGoals(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percentDone: null == percentDone ? _self.percentDone : percentDone // ignore: cast_nullable_to_non_nullable
as int,notStarted: null == notStarted ? _self.notStarted : notStarted // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,byArea: null == byArea ? _self.byArea : byArea // ignore: cast_nullable_to_non_nullable
as List<StatsGoalArea>,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsGoals].
extension StatsGoalsPatterns on StatsGoals {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsGoals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsGoals() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsGoals value)  $default,){
final _that = this;
switch (_that) {
case _StatsGoals():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsGoals value)?  $default,){
final _that = this;
switch (_that) {
case _StatsGoals() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int percentDone,  int notStarted,  int inProgress,  int done,  List<StatsGoalArea> byArea)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsGoals() when $default != null:
return $default(_that.total,_that.percentDone,_that.notStarted,_that.inProgress,_that.done,_that.byArea);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int percentDone,  int notStarted,  int inProgress,  int done,  List<StatsGoalArea> byArea)  $default,) {final _that = this;
switch (_that) {
case _StatsGoals():
return $default(_that.total,_that.percentDone,_that.notStarted,_that.inProgress,_that.done,_that.byArea);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int percentDone,  int notStarted,  int inProgress,  int done,  List<StatsGoalArea> byArea)?  $default,) {final _that = this;
switch (_that) {
case _StatsGoals() when $default != null:
return $default(_that.total,_that.percentDone,_that.notStarted,_that.inProgress,_that.done,_that.byArea);case _:
  return null;

}
}

}

/// @nodoc


class _StatsGoals implements StatsGoals {
  const _StatsGoals({required this.total, required this.percentDone, required this.notStarted, required this.inProgress, required this.done, required  List<StatsGoalArea> byArea}): _byArea = byArea;
  

@override final  int total;
@override final  int percentDone;
@override final  int notStarted;
@override final  int inProgress;
@override final  int done;
 final  List<StatsGoalArea> _byArea;
@override List<StatsGoalArea> get byArea {
  if (_byArea is EqualUnmodifiableListView) return _byArea;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byArea);
}


/// Create a copy of StatsGoals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsGoalsCopyWith<_StatsGoals> get copyWith => __$StatsGoalsCopyWithImpl<_StatsGoals>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsGoals&&(identical(other.total, total) || other.total == total)&&(identical(other.percentDone, percentDone) || other.percentDone == percentDone)&&(identical(other.notStarted, notStarted) || other.notStarted == notStarted)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.done, done) || other.done == done)&&const DeepCollectionEquality().equals(other.byArea, _byArea));
}


@override
int get hashCode {
    return Object.hash(runtimeType,total,percentDone,notStarted,inProgress,done,const DeepCollectionEquality().hash(_byArea));
}

@override
String toString() {
    return 'StatsGoals(total: $total, percentDone: $percentDone, notStarted: $notStarted, inProgress: $inProgress, done: $done, byArea: $byArea)';
}


}

/// @nodoc
abstract mixin class _$StatsGoalsCopyWith<$Res> implements $StatsGoalsCopyWith<$Res> {
  factory _$StatsGoalsCopyWith(_StatsGoals value, $Res Function(_StatsGoals) _then) = __$StatsGoalsCopyWithImpl;
@override @useResult
$Res call({
 int total, int percentDone, int notStarted, int inProgress, int done, List<StatsGoalArea> byArea
});




}
/// @nodoc
class __$StatsGoalsCopyWithImpl<$Res>
    implements _$StatsGoalsCopyWith<$Res> {
  __$StatsGoalsCopyWithImpl(this._self, this._then);

  final _StatsGoals _self;
  final $Res Function(_StatsGoals) _then;

/// Create a copy of StatsGoals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? percentDone = null,Object? notStarted = null,Object? inProgress = null,Object? done = null,Object? byArea = null,}) {
  return _then(_StatsGoals(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percentDone: null == percentDone ? _self.percentDone : percentDone // ignore: cast_nullable_to_non_nullable
as int,notStarted: null == notStarted ? _self.notStarted : notStarted // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,byArea: null == byArea ? _self._byArea : byArea // ignore: cast_nullable_to_non_nullable
as List<StatsGoalArea>,
  ));
}


}

/// @nodoc
mixin _$Stats {

 StatsRange get range; CalendarDate get from; CalendarDate get to; StatsHero get hero; StatsKpis get kpis; int get trendAverage; List<StatsWeekPoint> get trend; List<StatsHeatmapDay> get heatmap; List<StatsWeekday> get weekdays; List<StatsHabit> get habits; StatsGoals get goals;
/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsCopyWith<Stats> get copyWith => _$StatsCopyWithImpl<Stats>(this as Stats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Stats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stats&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.hero, _this.hero) || other.hero == _this.hero)&&(identical(other.kpis, _this.kpis) || other.kpis == _this.kpis)&&(identical(other.trendAverage, _this.trendAverage) || other.trendAverage == _this.trendAverage)&&const DeepCollectionEquality().equals(other.trend, _this.trend)&&const DeepCollectionEquality().equals(other.heatmap, _this.heatmap)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&const DeepCollectionEquality().equals(other.habits, _this.habits)&&(identical(other.goals, _this.goals) || other.goals == _this.goals));
}


@override
int get hashCode {
  final _this = this as Stats;
  return Object.hash(runtimeType,_this.range,_this.from,_this.to,_this.hero,_this.kpis,_this.trendAverage,const DeepCollectionEquality().hash(_this.trend),const DeepCollectionEquality().hash(_this.heatmap),const DeepCollectionEquality().hash(_this.weekdays),const DeepCollectionEquality().hash(_this.habits),_this.goals);
}

@override
String toString() {
  final _this = this as Stats;
  return 'Stats(range: ${_this.range}, from: ${_this.from}, to: ${_this.to}, hero: ${_this.hero}, kpis: ${_this.kpis}, trendAverage: ${_this.trendAverage}, trend: ${_this.trend}, heatmap: ${_this.heatmap}, weekdays: ${_this.weekdays}, habits: ${_this.habits}, goals: ${_this.goals})';
}


}

/// @nodoc
abstract mixin class $StatsCopyWith<$Res>  {
  factory $StatsCopyWith(Stats value, $Res Function(Stats) _then) = _$StatsCopyWithImpl;
@useResult
$Res call({
 StatsRange range, CalendarDate from, CalendarDate to, StatsHero hero, StatsKpis kpis, int trendAverage, List<StatsWeekPoint> trend, List<StatsHeatmapDay> heatmap, List<StatsWeekday> weekdays, List<StatsHabit> habits, StatsGoals goals
});


$StatsHeroCopyWith<$Res> get hero;$StatsKpisCopyWith<$Res> get kpis;$StatsGoalsCopyWith<$Res> get goals;

}
/// @nodoc
class _$StatsCopyWithImpl<$Res>
    implements $StatsCopyWith<$Res> {
  _$StatsCopyWithImpl(this._self, this._then);

  final Stats _self;
  final $Res Function(Stats) _then;

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? from = null,Object? to = null,Object? hero = null,Object? kpis = null,Object? trendAverage = null,Object? trend = null,Object? heatmap = null,Object? weekdays = null,Object? habits = null,Object? goals = null,}) {
  return _then(Stats(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as StatsRange,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate,hero: null == hero ? _self.hero : hero // ignore: cast_nullable_to_non_nullable
as StatsHero,kpis: null == kpis ? _self.kpis : kpis // ignore: cast_nullable_to_non_nullable
as StatsKpis,trendAverage: null == trendAverage ? _self.trendAverage : trendAverage // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as List<StatsWeekPoint>,heatmap: null == heatmap ? _self.heatmap : heatmap // ignore: cast_nullable_to_non_nullable
as List<StatsHeatmapDay>,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<StatsWeekday>,habits: null == habits ? _self.habits : habits // ignore: cast_nullable_to_non_nullable
as List<StatsHabit>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as StatsGoals,
  ));
}
/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsHeroCopyWith<$Res> get hero {
  
  return $StatsHeroCopyWith<$Res>(_self.hero, (value) {
    return _then(_self.copyWith(hero: value));
  });
}/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsKpisCopyWith<$Res> get kpis {
  
  return $StatsKpisCopyWith<$Res>(_self.kpis, (value) {
    return _then(_self.copyWith(kpis: value));
  });
}/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsGoalsCopyWith<$Res> get goals {
  
  return $StatsGoalsCopyWith<$Res>(_self.goals, (value) {
    return _then(_self.copyWith(goals: value));
  });
}
}


/// Adds pattern-matching-related methods to [Stats].
extension StatsPatterns on Stats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stats value)  $default,){
final _that = this;
switch (_that) {
case _Stats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stats value)?  $default,){
final _that = this;
switch (_that) {
case _Stats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StatsRange range,  CalendarDate from,  CalendarDate to,  StatsHero hero,  StatsKpis kpis,  int trendAverage,  List<StatsWeekPoint> trend,  List<StatsHeatmapDay> heatmap,  List<StatsWeekday> weekdays,  List<StatsHabit> habits,  StatsGoals goals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stats() when $default != null:
return $default(_that.range,_that.from,_that.to,_that.hero,_that.kpis,_that.trendAverage,_that.trend,_that.heatmap,_that.weekdays,_that.habits,_that.goals);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StatsRange range,  CalendarDate from,  CalendarDate to,  StatsHero hero,  StatsKpis kpis,  int trendAverage,  List<StatsWeekPoint> trend,  List<StatsHeatmapDay> heatmap,  List<StatsWeekday> weekdays,  List<StatsHabit> habits,  StatsGoals goals)  $default,) {final _that = this;
switch (_that) {
case _Stats():
return $default(_that.range,_that.from,_that.to,_that.hero,_that.kpis,_that.trendAverage,_that.trend,_that.heatmap,_that.weekdays,_that.habits,_that.goals);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StatsRange range,  CalendarDate from,  CalendarDate to,  StatsHero hero,  StatsKpis kpis,  int trendAverage,  List<StatsWeekPoint> trend,  List<StatsHeatmapDay> heatmap,  List<StatsWeekday> weekdays,  List<StatsHabit> habits,  StatsGoals goals)?  $default,) {final _that = this;
switch (_that) {
case _Stats() when $default != null:
return $default(_that.range,_that.from,_that.to,_that.hero,_that.kpis,_that.trendAverage,_that.trend,_that.heatmap,_that.weekdays,_that.habits,_that.goals);case _:
  return null;

}
}

}

/// @nodoc


class _Stats implements Stats {
  const _Stats({required this.range, required this.from, required this.to, required this.hero, required this.kpis, required this.trendAverage, required  List<StatsWeekPoint> trend, required  List<StatsHeatmapDay> heatmap, required  List<StatsWeekday> weekdays, required  List<StatsHabit> habits, required this.goals}): _trend = trend,_heatmap = heatmap,_weekdays = weekdays,_habits = habits;
  

@override final  StatsRange range;
@override final  CalendarDate from;
@override final  CalendarDate to;
@override final  StatsHero hero;
@override final  StatsKpis kpis;
@override final  int trendAverage;
 final  List<StatsWeekPoint> _trend;
@override List<StatsWeekPoint> get trend {
  if (_trend is EqualUnmodifiableListView) return _trend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trend);
}

 final  List<StatsHeatmapDay> _heatmap;
@override List<StatsHeatmapDay> get heatmap {
  if (_heatmap is EqualUnmodifiableListView) return _heatmap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heatmap);
}

 final  List<StatsWeekday> _weekdays;
@override List<StatsWeekday> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

 final  List<StatsHabit> _habits;
@override List<StatsHabit> get habits {
  if (_habits is EqualUnmodifiableListView) return _habits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_habits);
}

@override final  StatsGoals goals;

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsCopyWith<_Stats> get copyWith => __$StatsCopyWithImpl<_Stats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stats&&(identical(other.range, range) || other.range == range)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.hero, hero) || other.hero == hero)&&(identical(other.kpis, kpis) || other.kpis == kpis)&&(identical(other.trendAverage, trendAverage) || other.trendAverage == trendAverage)&&const DeepCollectionEquality().equals(other.trend, _trend)&&const DeepCollectionEquality().equals(other.heatmap, _heatmap)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&const DeepCollectionEquality().equals(other.habits, _habits)&&(identical(other.goals, goals) || other.goals == goals));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,from,to,hero,kpis,trendAverage,const DeepCollectionEquality().hash(_trend),const DeepCollectionEquality().hash(_heatmap),const DeepCollectionEquality().hash(_weekdays),const DeepCollectionEquality().hash(_habits),goals);
}

@override
String toString() {
    return 'Stats(range: $range, from: $from, to: $to, hero: $hero, kpis: $kpis, trendAverage: $trendAverage, trend: $trend, heatmap: $heatmap, weekdays: $weekdays, habits: $habits, goals: $goals)';
}


}

/// @nodoc
abstract mixin class _$StatsCopyWith<$Res> implements $StatsCopyWith<$Res> {
  factory _$StatsCopyWith(_Stats value, $Res Function(_Stats) _then) = __$StatsCopyWithImpl;
@override @useResult
$Res call({
 StatsRange range, CalendarDate from, CalendarDate to, StatsHero hero, StatsKpis kpis, int trendAverage, List<StatsWeekPoint> trend, List<StatsHeatmapDay> heatmap, List<StatsWeekday> weekdays, List<StatsHabit> habits, StatsGoals goals
});


@override $StatsHeroCopyWith<$Res> get hero;@override $StatsKpisCopyWith<$Res> get kpis;@override $StatsGoalsCopyWith<$Res> get goals;

}
/// @nodoc
class __$StatsCopyWithImpl<$Res>
    implements _$StatsCopyWith<$Res> {
  __$StatsCopyWithImpl(this._self, this._then);

  final _Stats _self;
  final $Res Function(_Stats) _then;

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? from = null,Object? to = null,Object? hero = null,Object? kpis = null,Object? trendAverage = null,Object? trend = null,Object? heatmap = null,Object? weekdays = null,Object? habits = null,Object? goals = null,}) {
  return _then(_Stats(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as StatsRange,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate,hero: null == hero ? _self.hero : hero // ignore: cast_nullable_to_non_nullable
as StatsHero,kpis: null == kpis ? _self.kpis : kpis // ignore: cast_nullable_to_non_nullable
as StatsKpis,trendAverage: null == trendAverage ? _self.trendAverage : trendAverage // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self._trend : trend // ignore: cast_nullable_to_non_nullable
as List<StatsWeekPoint>,heatmap: null == heatmap ? _self._heatmap : heatmap // ignore: cast_nullable_to_non_nullable
as List<StatsHeatmapDay>,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<StatsWeekday>,habits: null == habits ? _self._habits : habits // ignore: cast_nullable_to_non_nullable
as List<StatsHabit>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as StatsGoals,
  ));
}

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsHeroCopyWith<$Res> get hero {
  
  return $StatsHeroCopyWith<$Res>(_self.hero, (value) {
    return _then(_self.copyWith(hero: value));
  });
}/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsKpisCopyWith<$Res> get kpis {
  
  return $StatsKpisCopyWith<$Res>(_self.kpis, (value) {
    return _then(_self.copyWith(kpis: value));
  });
}/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsGoalsCopyWith<$Res> get goals {
  
  return $StatsGoalsCopyWith<$Res>(_self.goals, (value) {
    return _then(_self.copyWith(goals: value));
  });
}
}

// dart format on
