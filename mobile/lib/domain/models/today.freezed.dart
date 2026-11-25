// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayHabit {

 String get id; String get title; bool get done;
/// Create a copy of TodayHabit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayHabitCopyWith<TodayHabit> get copyWith => _$TodayHabitCopyWithImpl<TodayHabit>(this as TodayHabit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TodayHabit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayHabit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.done, _this.done) || other.done == _this.done));
}


@override
int get hashCode {
  final _this = this as TodayHabit;
  return Object.hash(runtimeType,_this.id,_this.title,_this.done);
}

@override
String toString() {
  final _this = this as TodayHabit;
  return 'TodayHabit(id: ${_this.id}, title: ${_this.title}, done: ${_this.done})';
}


}

/// @nodoc
abstract mixin class $TodayHabitCopyWith<$Res>  {
  factory $TodayHabitCopyWith(TodayHabit value, $Res Function(TodayHabit) _then) = _$TodayHabitCopyWithImpl;
@useResult
$Res call({
 String id, String title, bool done
});




}
/// @nodoc
class _$TodayHabitCopyWithImpl<$Res>
    implements $TodayHabitCopyWith<$Res> {
  _$TodayHabitCopyWithImpl(this._self, this._then);

  final TodayHabit _self;
  final $Res Function(TodayHabit) _then;

/// Create a copy of TodayHabit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? done = null,}) {
  return _then(TodayHabit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayHabit].
extension TodayHabitPatterns on TodayHabit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayHabit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayHabit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayHabit value)  $default,){
final _that = this;
switch (_that) {
case _TodayHabit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayHabit value)?  $default,){
final _that = this;
switch (_that) {
case _TodayHabit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  bool done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayHabit() when $default != null:
return $default(_that.id,_that.title,_that.done);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  bool done)  $default,) {final _that = this;
switch (_that) {
case _TodayHabit():
return $default(_that.id,_that.title,_that.done);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  bool done)?  $default,) {final _that = this;
switch (_that) {
case _TodayHabit() when $default != null:
return $default(_that.id,_that.title,_that.done);case _:
  return null;

}
}

}

/// @nodoc


class _TodayHabit implements TodayHabit {
  const _TodayHabit({required this.id, required this.title, required this.done});
  

@override final  String id;
@override final  String title;
@override final  bool done;

/// Create a copy of TodayHabit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayHabitCopyWith<_TodayHabit> get copyWith => __$TodayHabitCopyWithImpl<_TodayHabit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayHabit&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,done);
}

@override
String toString() {
    return 'TodayHabit(id: $id, title: $title, done: $done)';
}


}

/// @nodoc
abstract mixin class _$TodayHabitCopyWith<$Res> implements $TodayHabitCopyWith<$Res> {
  factory _$TodayHabitCopyWith(_TodayHabit value, $Res Function(_TodayHabit) _then) = __$TodayHabitCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, bool done
});




}
/// @nodoc
class __$TodayHabitCopyWithImpl<$Res>
    implements _$TodayHabitCopyWith<$Res> {
  __$TodayHabitCopyWithImpl(this._self, this._then);

  final _TodayHabit _self;
  final $Res Function(_TodayHabit) _then;

/// Create a copy of TodayHabit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? done = null,}) {
  return _then(_TodayHabit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$TodayDashboard {

 CalendarDate get date; int get percent; int get tasksDone; int get tasksTotal; int get habitsDone; int get habitsTotal; List<Task> get tasks; List<Task> get backlog; List<TodayHabit> get habits; String get note;
/// Create a copy of TodayDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayDashboardCopyWith<TodayDashboard> get copyWith => _$TodayDashboardCopyWithImpl<TodayDashboard>(this as TodayDashboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TodayDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayDashboard&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.tasksDone, _this.tasksDone) || other.tasksDone == _this.tasksDone)&&(identical(other.tasksTotal, _this.tasksTotal) || other.tasksTotal == _this.tasksTotal)&&(identical(other.habitsDone, _this.habitsDone) || other.habitsDone == _this.habitsDone)&&(identical(other.habitsTotal, _this.habitsTotal) || other.habitsTotal == _this.habitsTotal)&&const DeepCollectionEquality().equals(other.tasks, _this.tasks)&&const DeepCollectionEquality().equals(other.backlog, _this.backlog)&&const DeepCollectionEquality().equals(other.habits, _this.habits)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as TodayDashboard;
  return Object.hash(runtimeType,_this.date,_this.percent,_this.tasksDone,_this.tasksTotal,_this.habitsDone,_this.habitsTotal,const DeepCollectionEquality().hash(_this.tasks),const DeepCollectionEquality().hash(_this.backlog),const DeepCollectionEquality().hash(_this.habits),_this.note);
}

@override
String toString() {
  final _this = this as TodayDashboard;
  return 'TodayDashboard(date: ${_this.date}, percent: ${_this.percent}, tasksDone: ${_this.tasksDone}, tasksTotal: ${_this.tasksTotal}, habitsDone: ${_this.habitsDone}, habitsTotal: ${_this.habitsTotal}, tasks: ${_this.tasks}, backlog: ${_this.backlog}, habits: ${_this.habits}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $TodayDashboardCopyWith<$Res>  {
  factory $TodayDashboardCopyWith(TodayDashboard value, $Res Function(TodayDashboard) _then) = _$TodayDashboardCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, int percent, int tasksDone, int tasksTotal, int habitsDone, int habitsTotal, List<Task> tasks, List<Task> backlog, List<TodayHabit> habits, String note
});




}
/// @nodoc
class _$TodayDashboardCopyWithImpl<$Res>
    implements $TodayDashboardCopyWith<$Res> {
  _$TodayDashboardCopyWithImpl(this._self, this._then);

  final TodayDashboard _self;
  final $Res Function(TodayDashboard) _then;

/// Create a copy of TodayDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? percent = null,Object? tasksDone = null,Object? tasksTotal = null,Object? habitsDone = null,Object? habitsTotal = null,Object? tasks = null,Object? backlog = null,Object? habits = null,Object? note = null,}) {
  return _then(TodayDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,habitsDone: null == habitsDone ? _self.habitsDone : habitsDone // ignore: cast_nullable_to_non_nullable
as int,habitsTotal: null == habitsTotal ? _self.habitsTotal : habitsTotal // ignore: cast_nullable_to_non_nullable
as int,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,backlog: null == backlog ? _self.backlog : backlog // ignore: cast_nullable_to_non_nullable
as List<Task>,habits: null == habits ? _self.habits : habits // ignore: cast_nullable_to_non_nullable
as List<TodayHabit>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayDashboard].
extension TodayDashboardPatterns on TodayDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayDashboard value)  $default,){
final _that = this;
switch (_that) {
case _TodayDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _TodayDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  int percent,  int tasksDone,  int tasksTotal,  int habitsDone,  int habitsTotal,  List<Task> tasks,  List<Task> backlog,  List<TodayHabit> habits,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayDashboard() when $default != null:
return $default(_that.date,_that.percent,_that.tasksDone,_that.tasksTotal,_that.habitsDone,_that.habitsTotal,_that.tasks,_that.backlog,_that.habits,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  int percent,  int tasksDone,  int tasksTotal,  int habitsDone,  int habitsTotal,  List<Task> tasks,  List<Task> backlog,  List<TodayHabit> habits,  String note)  $default,) {final _that = this;
switch (_that) {
case _TodayDashboard():
return $default(_that.date,_that.percent,_that.tasksDone,_that.tasksTotal,_that.habitsDone,_that.habitsTotal,_that.tasks,_that.backlog,_that.habits,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  int percent,  int tasksDone,  int tasksTotal,  int habitsDone,  int habitsTotal,  List<Task> tasks,  List<Task> backlog,  List<TodayHabit> habits,  String note)?  $default,) {final _that = this;
switch (_that) {
case _TodayDashboard() when $default != null:
return $default(_that.date,_that.percent,_that.tasksDone,_that.tasksTotal,_that.habitsDone,_that.habitsTotal,_that.tasks,_that.backlog,_that.habits,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _TodayDashboard implements TodayDashboard {
  const _TodayDashboard({required this.date, required this.percent, required this.tasksDone, required this.tasksTotal, required this.habitsDone, required this.habitsTotal, required  List<Task> tasks, required  List<Task> backlog, required  List<TodayHabit> habits, this.note = ''}): _tasks = tasks,_backlog = backlog,_habits = habits;
  

@override final  CalendarDate date;
@override final  int percent;
@override final  int tasksDone;
@override final  int tasksTotal;
@override final  int habitsDone;
@override final  int habitsTotal;
 final  List<Task> _tasks;
@override List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

 final  List<Task> _backlog;
@override List<Task> get backlog {
  if (_backlog is EqualUnmodifiableListView) return _backlog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backlog);
}

 final  List<TodayHabit> _habits;
@override List<TodayHabit> get habits {
  if (_habits is EqualUnmodifiableListView) return _habits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_habits);
}

@override@JsonKey() final  String note;

/// Create a copy of TodayDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayDashboardCopyWith<_TodayDashboard> get copyWith => __$TodayDashboardCopyWithImpl<_TodayDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.tasksDone, tasksDone) || other.tasksDone == tasksDone)&&(identical(other.tasksTotal, tasksTotal) || other.tasksTotal == tasksTotal)&&(identical(other.habitsDone, habitsDone) || other.habitsDone == habitsDone)&&(identical(other.habitsTotal, habitsTotal) || other.habitsTotal == habitsTotal)&&const DeepCollectionEquality().equals(other.tasks, _tasks)&&const DeepCollectionEquality().equals(other.backlog, _backlog)&&const DeepCollectionEquality().equals(other.habits, _habits)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,percent,tasksDone,tasksTotal,habitsDone,habitsTotal,const DeepCollectionEquality().hash(_tasks),const DeepCollectionEquality().hash(_backlog),const DeepCollectionEquality().hash(_habits),note);
}

@override
String toString() {
    return 'TodayDashboard(date: $date, percent: $percent, tasksDone: $tasksDone, tasksTotal: $tasksTotal, habitsDone: $habitsDone, habitsTotal: $habitsTotal, tasks: $tasks, backlog: $backlog, habits: $habits, note: $note)';
}


}

/// @nodoc
abstract mixin class _$TodayDashboardCopyWith<$Res> implements $TodayDashboardCopyWith<$Res> {
  factory _$TodayDashboardCopyWith(_TodayDashboard value, $Res Function(_TodayDashboard) _then) = __$TodayDashboardCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, int percent, int tasksDone, int tasksTotal, int habitsDone, int habitsTotal, List<Task> tasks, List<Task> backlog, List<TodayHabit> habits, String note
});




}
/// @nodoc
class __$TodayDashboardCopyWithImpl<$Res>
    implements _$TodayDashboardCopyWith<$Res> {
  __$TodayDashboardCopyWithImpl(this._self, this._then);

  final _TodayDashboard _self;
  final $Res Function(_TodayDashboard) _then;

/// Create a copy of TodayDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? percent = null,Object? tasksDone = null,Object? tasksTotal = null,Object? habitsDone = null,Object? habitsTotal = null,Object? tasks = null,Object? backlog = null,Object? habits = null,Object? note = null,}) {
  return _then(_TodayDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,habitsDone: null == habitsDone ? _self.habitsDone : habitsDone // ignore: cast_nullable_to_non_nullable
as int,habitsTotal: null == habitsTotal ? _self.habitsTotal : habitsTotal // ignore: cast_nullable_to_non_nullable
as int,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,backlog: null == backlog ? _self._backlog : backlog // ignore: cast_nullable_to_non_nullable
as List<Task>,habits: null == habits ? _self._habits : habits // ignore: cast_nullable_to_non_nullable
as List<TodayHabit>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
