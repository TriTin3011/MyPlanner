// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeekDashboard {

 WeekKey get weekKey; CalendarDate get from; CalendarDate get to; int get tasksDone; int get tasksTotal; int get habitPercent; int get todayRemaining; String get comment; List<DayProgress> get days; List<String> get insights;
/// Create a copy of WeekDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekDashboardCopyWith<WeekDashboard> get copyWith => _$WeekDashboardCopyWithImpl<WeekDashboard>(this as WeekDashboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeekDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekDashboard&&(identical(other.weekKey, _this.weekKey) || other.weekKey == _this.weekKey)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.tasksDone, _this.tasksDone) || other.tasksDone == _this.tasksDone)&&(identical(other.tasksTotal, _this.tasksTotal) || other.tasksTotal == _this.tasksTotal)&&(identical(other.habitPercent, _this.habitPercent) || other.habitPercent == _this.habitPercent)&&(identical(other.todayRemaining, _this.todayRemaining) || other.todayRemaining == _this.todayRemaining)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&const DeepCollectionEquality().equals(other.days, _this.days)&&const DeepCollectionEquality().equals(other.insights, _this.insights));
}


@override
int get hashCode {
  final _this = this as WeekDashboard;
  return Object.hash(runtimeType,_this.weekKey,_this.from,_this.to,_this.tasksDone,_this.tasksTotal,_this.habitPercent,_this.todayRemaining,_this.comment,const DeepCollectionEquality().hash(_this.days),const DeepCollectionEquality().hash(_this.insights));
}

@override
String toString() {
  final _this = this as WeekDashboard;
  return 'WeekDashboard(weekKey: ${_this.weekKey}, from: ${_this.from}, to: ${_this.to}, tasksDone: ${_this.tasksDone}, tasksTotal: ${_this.tasksTotal}, habitPercent: ${_this.habitPercent}, todayRemaining: ${_this.todayRemaining}, comment: ${_this.comment}, days: ${_this.days}, insights: ${_this.insights})';
}


}

/// @nodoc
abstract mixin class $WeekDashboardCopyWith<$Res>  {
  factory $WeekDashboardCopyWith(WeekDashboard value, $Res Function(WeekDashboard) _then) = _$WeekDashboardCopyWithImpl;
@useResult
$Res call({
 WeekKey weekKey, CalendarDate from, CalendarDate to, int tasksDone, int tasksTotal, int habitPercent, int todayRemaining, String comment, List<DayProgress> days, List<String> insights
});




}
/// @nodoc
class _$WeekDashboardCopyWithImpl<$Res>
    implements $WeekDashboardCopyWith<$Res> {
  _$WeekDashboardCopyWithImpl(this._self, this._then);

  final WeekDashboard _self;
  final $Res Function(WeekDashboard) _then;

/// Create a copy of WeekDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekKey = null,Object? from = null,Object? to = null,Object? tasksDone = null,Object? tasksTotal = null,Object? habitPercent = null,Object? todayRemaining = null,Object? comment = null,Object? days = null,Object? insights = null,}) {
  return _then(WeekDashboard(
weekKey: null == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as WeekKey,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,habitPercent: null == habitPercent ? _self.habitPercent : habitPercent // ignore: cast_nullable_to_non_nullable
as int,todayRemaining: null == todayRemaining ? _self.todayRemaining : todayRemaining // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DayProgress>,insights: null == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekDashboard].
extension WeekDashboardPatterns on WeekDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekDashboard value)  $default,){
final _that = this;
switch (_that) {
case _WeekDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _WeekDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeekKey weekKey,  CalendarDate from,  CalendarDate to,  int tasksDone,  int tasksTotal,  int habitPercent,  int todayRemaining,  String comment,  List<DayProgress> days,  List<String> insights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekDashboard() when $default != null:
return $default(_that.weekKey,_that.from,_that.to,_that.tasksDone,_that.tasksTotal,_that.habitPercent,_that.todayRemaining,_that.comment,_that.days,_that.insights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeekKey weekKey,  CalendarDate from,  CalendarDate to,  int tasksDone,  int tasksTotal,  int habitPercent,  int todayRemaining,  String comment,  List<DayProgress> days,  List<String> insights)  $default,) {final _that = this;
switch (_that) {
case _WeekDashboard():
return $default(_that.weekKey,_that.from,_that.to,_that.tasksDone,_that.tasksTotal,_that.habitPercent,_that.todayRemaining,_that.comment,_that.days,_that.insights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeekKey weekKey,  CalendarDate from,  CalendarDate to,  int tasksDone,  int tasksTotal,  int habitPercent,  int todayRemaining,  String comment,  List<DayProgress> days,  List<String> insights)?  $default,) {final _that = this;
switch (_that) {
case _WeekDashboard() when $default != null:
return $default(_that.weekKey,_that.from,_that.to,_that.tasksDone,_that.tasksTotal,_that.habitPercent,_that.todayRemaining,_that.comment,_that.days,_that.insights);case _:
  return null;

}
}

}

/// @nodoc


class _WeekDashboard implements WeekDashboard {
  const _WeekDashboard({required this.weekKey, required this.from, required this.to, required this.tasksDone, required this.tasksTotal, required this.habitPercent, required this.todayRemaining, required this.comment, required  List<DayProgress> days,  List<String> insights = const []}): _days = days,_insights = insights;
  

@override final  WeekKey weekKey;
@override final  CalendarDate from;
@override final  CalendarDate to;
@override final  int tasksDone;
@override final  int tasksTotal;
@override final  int habitPercent;
@override final  int todayRemaining;
@override final  String comment;
 final  List<DayProgress> _days;
@override List<DayProgress> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

 final  List<String> _insights;
@override@JsonKey() List<String> get insights {
  if (_insights is EqualUnmodifiableListView) return _insights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_insights);
}


/// Create a copy of WeekDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekDashboardCopyWith<_WeekDashboard> get copyWith => __$WeekDashboardCopyWithImpl<_WeekDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekDashboard&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.tasksDone, tasksDone) || other.tasksDone == tasksDone)&&(identical(other.tasksTotal, tasksTotal) || other.tasksTotal == tasksTotal)&&(identical(other.habitPercent, habitPercent) || other.habitPercent == habitPercent)&&(identical(other.todayRemaining, todayRemaining) || other.todayRemaining == todayRemaining)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.days, _days)&&const DeepCollectionEquality().equals(other.insights, _insights));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weekKey,from,to,tasksDone,tasksTotal,habitPercent,todayRemaining,comment,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_insights));
}

@override
String toString() {
    return 'WeekDashboard(weekKey: $weekKey, from: $from, to: $to, tasksDone: $tasksDone, tasksTotal: $tasksTotal, habitPercent: $habitPercent, todayRemaining: $todayRemaining, comment: $comment, days: $days, insights: $insights)';
}


}

/// @nodoc
abstract mixin class _$WeekDashboardCopyWith<$Res> implements $WeekDashboardCopyWith<$Res> {
  factory _$WeekDashboardCopyWith(_WeekDashboard value, $Res Function(_WeekDashboard) _then) = __$WeekDashboardCopyWithImpl;
@override @useResult
$Res call({
 WeekKey weekKey, CalendarDate from, CalendarDate to, int tasksDone, int tasksTotal, int habitPercent, int todayRemaining, String comment, List<DayProgress> days, List<String> insights
});




}
/// @nodoc
class __$WeekDashboardCopyWithImpl<$Res>
    implements _$WeekDashboardCopyWith<$Res> {
  __$WeekDashboardCopyWithImpl(this._self, this._then);

  final _WeekDashboard _self;
  final $Res Function(_WeekDashboard) _then;

/// Create a copy of WeekDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekKey = null,Object? from = null,Object? to = null,Object? tasksDone = null,Object? tasksTotal = null,Object? habitPercent = null,Object? todayRemaining = null,Object? comment = null,Object? days = null,Object? insights = null,}) {
  return _then(_WeekDashboard(
weekKey: null == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as WeekKey,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,habitPercent: null == habitPercent ? _self.habitPercent : habitPercent // ignore: cast_nullable_to_non_nullable
as int,todayRemaining: null == todayRemaining ? _self.todayRemaining : todayRemaining // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DayProgress>,insights: null == insights ? _self._insights : insights // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$WeekProgress {

 WeekKey get weekKey; CalendarDate get monday; int get tasksDone; int get tasksTotal; int get percent;
/// Create a copy of WeekProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekProgressCopyWith<WeekProgress> get copyWith => _$WeekProgressCopyWithImpl<WeekProgress>(this as WeekProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeekProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekProgress&&(identical(other.weekKey, _this.weekKey) || other.weekKey == _this.weekKey)&&(identical(other.monday, _this.monday) || other.monday == _this.monday)&&(identical(other.tasksDone, _this.tasksDone) || other.tasksDone == _this.tasksDone)&&(identical(other.tasksTotal, _this.tasksTotal) || other.tasksTotal == _this.tasksTotal)&&(identical(other.percent, _this.percent) || other.percent == _this.percent));
}


@override
int get hashCode {
  final _this = this as WeekProgress;
  return Object.hash(runtimeType,_this.weekKey,_this.monday,_this.tasksDone,_this.tasksTotal,_this.percent);
}

@override
String toString() {
  final _this = this as WeekProgress;
  return 'WeekProgress(weekKey: ${_this.weekKey}, monday: ${_this.monday}, tasksDone: ${_this.tasksDone}, tasksTotal: ${_this.tasksTotal}, percent: ${_this.percent})';
}


}

/// @nodoc
abstract mixin class $WeekProgressCopyWith<$Res>  {
  factory $WeekProgressCopyWith(WeekProgress value, $Res Function(WeekProgress) _then) = _$WeekProgressCopyWithImpl;
@useResult
$Res call({
 WeekKey weekKey, CalendarDate monday, int tasksDone, int tasksTotal, int percent
});




}
/// @nodoc
class _$WeekProgressCopyWithImpl<$Res>
    implements $WeekProgressCopyWith<$Res> {
  _$WeekProgressCopyWithImpl(this._self, this._then);

  final WeekProgress _self;
  final $Res Function(WeekProgress) _then;

/// Create a copy of WeekProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekKey = null,Object? monday = null,Object? tasksDone = null,Object? tasksTotal = null,Object? percent = null,}) {
  return _then(WeekProgress(
weekKey: null == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as WeekKey,monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekProgress].
extension WeekProgressPatterns on WeekProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekProgress value)  $default,){
final _that = this;
switch (_that) {
case _WeekProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekProgress value)?  $default,){
final _that = this;
switch (_that) {
case _WeekProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeekKey weekKey,  CalendarDate monday,  int tasksDone,  int tasksTotal,  int percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekProgress() when $default != null:
return $default(_that.weekKey,_that.monday,_that.tasksDone,_that.tasksTotal,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeekKey weekKey,  CalendarDate monday,  int tasksDone,  int tasksTotal,  int percent)  $default,) {final _that = this;
switch (_that) {
case _WeekProgress():
return $default(_that.weekKey,_that.monday,_that.tasksDone,_that.tasksTotal,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeekKey weekKey,  CalendarDate monday,  int tasksDone,  int tasksTotal,  int percent)?  $default,) {final _that = this;
switch (_that) {
case _WeekProgress() when $default != null:
return $default(_that.weekKey,_that.monday,_that.tasksDone,_that.tasksTotal,_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _WeekProgress implements WeekProgress {
  const _WeekProgress({required this.weekKey, required this.monday, required this.tasksDone, required this.tasksTotal, required this.percent});
  

@override final  WeekKey weekKey;
@override final  CalendarDate monday;
@override final  int tasksDone;
@override final  int tasksTotal;
@override final  int percent;

/// Create a copy of WeekProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekProgressCopyWith<_WeekProgress> get copyWith => __$WeekProgressCopyWithImpl<_WeekProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekProgress&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.tasksDone, tasksDone) || other.tasksDone == tasksDone)&&(identical(other.tasksTotal, tasksTotal) || other.tasksTotal == tasksTotal)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weekKey,monday,tasksDone,tasksTotal,percent);
}

@override
String toString() {
    return 'WeekProgress(weekKey: $weekKey, monday: $monday, tasksDone: $tasksDone, tasksTotal: $tasksTotal, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$WeekProgressCopyWith<$Res> implements $WeekProgressCopyWith<$Res> {
  factory _$WeekProgressCopyWith(_WeekProgress value, $Res Function(_WeekProgress) _then) = __$WeekProgressCopyWithImpl;
@override @useResult
$Res call({
 WeekKey weekKey, CalendarDate monday, int tasksDone, int tasksTotal, int percent
});




}
/// @nodoc
class __$WeekProgressCopyWithImpl<$Res>
    implements _$WeekProgressCopyWith<$Res> {
  __$WeekProgressCopyWithImpl(this._self, this._then);

  final _WeekProgress _self;
  final $Res Function(_WeekProgress) _then;

/// Create a copy of WeekProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekKey = null,Object? monday = null,Object? tasksDone = null,Object? tasksTotal = null,Object? percent = null,}) {
  return _then(_WeekProgress(
weekKey: null == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as WeekKey,monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Deadline {

 CalendarDate get date; DeadlineKind get kind; String get goalId; String get goalTitle; String get title; bool get done; bool get overdue;
/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadlineCopyWith<Deadline> get copyWith => _$DeadlineCopyWithImpl<Deadline>(this as Deadline, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Deadline;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Deadline&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.goalId, _this.goalId) || other.goalId == _this.goalId)&&(identical(other.goalTitle, _this.goalTitle) || other.goalTitle == _this.goalTitle)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue));
}


@override
int get hashCode {
  final _this = this as Deadline;
  return Object.hash(runtimeType,_this.date,_this.kind,_this.goalId,_this.goalTitle,_this.title,_this.done,_this.overdue);
}

@override
String toString() {
  final _this = this as Deadline;
  return 'Deadline(date: ${_this.date}, kind: ${_this.kind}, goalId: ${_this.goalId}, goalTitle: ${_this.goalTitle}, title: ${_this.title}, done: ${_this.done}, overdue: ${_this.overdue})';
}


}

/// @nodoc
abstract mixin class $DeadlineCopyWith<$Res>  {
  factory $DeadlineCopyWith(Deadline value, $Res Function(Deadline) _then) = _$DeadlineCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, DeadlineKind kind, String goalId, String goalTitle, String title, bool done, bool overdue
});




}
/// @nodoc
class _$DeadlineCopyWithImpl<$Res>
    implements $DeadlineCopyWith<$Res> {
  _$DeadlineCopyWithImpl(this._self, this._then);

  final Deadline _self;
  final $Res Function(Deadline) _then;

/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? kind = null,Object? goalId = null,Object? goalTitle = null,Object? title = null,Object? done = null,Object? overdue = null,}) {
  return _then(Deadline(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeadlineKind,goalId: null == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String,goalTitle: null == goalTitle ? _self.goalTitle : goalTitle // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Deadline].
extension DeadlinePatterns on Deadline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Deadline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Deadline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Deadline value)  $default,){
final _that = this;
switch (_that) {
case _Deadline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Deadline value)?  $default,){
final _that = this;
switch (_that) {
case _Deadline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  DeadlineKind kind,  String goalId,  String goalTitle,  String title,  bool done,  bool overdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Deadline() when $default != null:
return $default(_that.date,_that.kind,_that.goalId,_that.goalTitle,_that.title,_that.done,_that.overdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  DeadlineKind kind,  String goalId,  String goalTitle,  String title,  bool done,  bool overdue)  $default,) {final _that = this;
switch (_that) {
case _Deadline():
return $default(_that.date,_that.kind,_that.goalId,_that.goalTitle,_that.title,_that.done,_that.overdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  DeadlineKind kind,  String goalId,  String goalTitle,  String title,  bool done,  bool overdue)?  $default,) {final _that = this;
switch (_that) {
case _Deadline() when $default != null:
return $default(_that.date,_that.kind,_that.goalId,_that.goalTitle,_that.title,_that.done,_that.overdue);case _:
  return null;

}
}

}

/// @nodoc


class _Deadline implements Deadline {
  const _Deadline({required this.date, required this.kind, required this.goalId, required this.goalTitle, required this.title, required this.done, required this.overdue});
  

@override final  CalendarDate date;
@override final  DeadlineKind kind;
@override final  String goalId;
@override final  String goalTitle;
@override final  String title;
@override final  bool done;
@override final  bool overdue;

/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeadlineCopyWith<_Deadline> get copyWith => __$DeadlineCopyWithImpl<_Deadline>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deadline&&(identical(other.date, date) || other.date == date)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.goalTitle, goalTitle) || other.goalTitle == goalTitle)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done)&&(identical(other.overdue, overdue) || other.overdue == overdue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,kind,goalId,goalTitle,title,done,overdue);
}

@override
String toString() {
    return 'Deadline(date: $date, kind: $kind, goalId: $goalId, goalTitle: $goalTitle, title: $title, done: $done, overdue: $overdue)';
}


}

/// @nodoc
abstract mixin class _$DeadlineCopyWith<$Res> implements $DeadlineCopyWith<$Res> {
  factory _$DeadlineCopyWith(_Deadline value, $Res Function(_Deadline) _then) = __$DeadlineCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, DeadlineKind kind, String goalId, String goalTitle, String title, bool done, bool overdue
});




}
/// @nodoc
class __$DeadlineCopyWithImpl<$Res>
    implements _$DeadlineCopyWith<$Res> {
  __$DeadlineCopyWithImpl(this._self, this._then);

  final _Deadline _self;
  final $Res Function(_Deadline) _then;

/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? kind = null,Object? goalId = null,Object? goalTitle = null,Object? title = null,Object? done = null,Object? overdue = null,}) {
  return _then(_Deadline(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeadlineKind,goalId: null == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String,goalTitle: null == goalTitle ? _self.goalTitle : goalTitle // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$WeekDeleteResult {

 int get tasks; int get habitLogs; int get notes;
/// Create a copy of WeekDeleteResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekDeleteResultCopyWith<WeekDeleteResult> get copyWith => _$WeekDeleteResultCopyWithImpl<WeekDeleteResult>(this as WeekDeleteResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeekDeleteResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekDeleteResult&&(identical(other.tasks, _this.tasks) || other.tasks == _this.tasks)&&(identical(other.habitLogs, _this.habitLogs) || other.habitLogs == _this.habitLogs)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as WeekDeleteResult;
  return Object.hash(runtimeType,_this.tasks,_this.habitLogs,_this.notes);
}

@override
String toString() {
  final _this = this as WeekDeleteResult;
  return 'WeekDeleteResult(tasks: ${_this.tasks}, habitLogs: ${_this.habitLogs}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $WeekDeleteResultCopyWith<$Res>  {
  factory $WeekDeleteResultCopyWith(WeekDeleteResult value, $Res Function(WeekDeleteResult) _then) = _$WeekDeleteResultCopyWithImpl;
@useResult
$Res call({
 int tasks, int habitLogs, int notes
});




}
/// @nodoc
class _$WeekDeleteResultCopyWithImpl<$Res>
    implements $WeekDeleteResultCopyWith<$Res> {
  _$WeekDeleteResultCopyWithImpl(this._self, this._then);

  final WeekDeleteResult _self;
  final $Res Function(WeekDeleteResult) _then;

/// Create a copy of WeekDeleteResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? habitLogs = null,Object? notes = null,}) {
  return _then(WeekDeleteResult(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as int,habitLogs: null == habitLogs ? _self.habitLogs : habitLogs // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekDeleteResult].
extension WeekDeleteResultPatterns on WeekDeleteResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekDeleteResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekDeleteResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekDeleteResult value)  $default,){
final _that = this;
switch (_that) {
case _WeekDeleteResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekDeleteResult value)?  $default,){
final _that = this;
switch (_that) {
case _WeekDeleteResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tasks,  int habitLogs,  int notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekDeleteResult() when $default != null:
return $default(_that.tasks,_that.habitLogs,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tasks,  int habitLogs,  int notes)  $default,) {final _that = this;
switch (_that) {
case _WeekDeleteResult():
return $default(_that.tasks,_that.habitLogs,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tasks,  int habitLogs,  int notes)?  $default,) {final _that = this;
switch (_that) {
case _WeekDeleteResult() when $default != null:
return $default(_that.tasks,_that.habitLogs,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _WeekDeleteResult implements WeekDeleteResult {
  const _WeekDeleteResult({required this.tasks, required this.habitLogs, required this.notes});
  

@override final  int tasks;
@override final  int habitLogs;
@override final  int notes;

/// Create a copy of WeekDeleteResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekDeleteResultCopyWith<_WeekDeleteResult> get copyWith => __$WeekDeleteResultCopyWithImpl<_WeekDeleteResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekDeleteResult&&(identical(other.tasks, tasks) || other.tasks == tasks)&&(identical(other.habitLogs, habitLogs) || other.habitLogs == habitLogs)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tasks,habitLogs,notes);
}

@override
String toString() {
    return 'WeekDeleteResult(tasks: $tasks, habitLogs: $habitLogs, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$WeekDeleteResultCopyWith<$Res> implements $WeekDeleteResultCopyWith<$Res> {
  factory _$WeekDeleteResultCopyWith(_WeekDeleteResult value, $Res Function(_WeekDeleteResult) _then) = __$WeekDeleteResultCopyWithImpl;
@override @useResult
$Res call({
 int tasks, int habitLogs, int notes
});




}
/// @nodoc
class __$WeekDeleteResultCopyWithImpl<$Res>
    implements _$WeekDeleteResultCopyWith<$Res> {
  __$WeekDeleteResultCopyWithImpl(this._self, this._then);

  final _WeekDeleteResult _self;
  final $Res Function(_WeekDeleteResult) _then;

/// Create a copy of WeekDeleteResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? habitLogs = null,Object? notes = null,}) {
  return _then(_WeekDeleteResult(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as int,habitLogs: null == habitLogs ? _self.habitLogs : habitLogs // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
