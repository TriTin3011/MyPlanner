// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Subtask {

 String? get id; String get title; bool get done;
/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubtaskCopyWith<Subtask> get copyWith => _$SubtaskCopyWithImpl<Subtask>(this as Subtask, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Subtask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subtask&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.done, _this.done) || other.done == _this.done));
}


@override
int get hashCode {
  final _this = this as Subtask;
  return Object.hash(runtimeType,_this.id,_this.title,_this.done);
}

@override
String toString() {
  final _this = this as Subtask;
  return 'Subtask(id: ${_this.id}, title: ${_this.title}, done: ${_this.done})';
}


}

/// @nodoc
abstract mixin class $SubtaskCopyWith<$Res>  {
  factory $SubtaskCopyWith(Subtask value, $Res Function(Subtask) _then) = _$SubtaskCopyWithImpl;
@useResult
$Res call({
 String? id, String title, bool done
});




}
/// @nodoc
class _$SubtaskCopyWithImpl<$Res>
    implements $SubtaskCopyWith<$Res> {
  _$SubtaskCopyWithImpl(this._self, this._then);

  final Subtask _self;
  final $Res Function(Subtask) _then;

/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? done = null,}) {
  return _then(Subtask(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Subtask].
extension SubtaskPatterns on Subtask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subtask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subtask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subtask value)  $default,){
final _that = this;
switch (_that) {
case _Subtask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subtask value)?  $default,){
final _that = this;
switch (_that) {
case _Subtask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String title,  bool done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subtask() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String title,  bool done)  $default,) {final _that = this;
switch (_that) {
case _Subtask():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String title,  bool done)?  $default,) {final _that = this;
switch (_that) {
case _Subtask() when $default != null:
return $default(_that.id,_that.title,_that.done);case _:
  return null;

}
}

}

/// @nodoc


class _Subtask implements Subtask {
  const _Subtask({this.id, required this.title, this.done = false});
  

@override final  String? id;
@override final  String title;
@override@JsonKey() final  bool done;

/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubtaskCopyWith<_Subtask> get copyWith => __$SubtaskCopyWithImpl<_Subtask>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subtask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,done);
}

@override
String toString() {
    return 'Subtask(id: $id, title: $title, done: $done)';
}


}

/// @nodoc
abstract mixin class _$SubtaskCopyWith<$Res> implements $SubtaskCopyWith<$Res> {
  factory _$SubtaskCopyWith(_Subtask value, $Res Function(_Subtask) _then) = __$SubtaskCopyWithImpl;
@override @useResult
$Res call({
 String? id, String title, bool done
});




}
/// @nodoc
class __$SubtaskCopyWithImpl<$Res>
    implements _$SubtaskCopyWith<$Res> {
  __$SubtaskCopyWithImpl(this._self, this._then);

  final _Subtask _self;
  final $Res Function(_Subtask) _then;

/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? done = null,}) {
  return _then(_Subtask(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$Task {

 String get id; String get title; CalendarDate get date; CalendarDate? get originalDate; bool get done; List<TaskTag> get tags; List<Subtask> get subtasks; String? get recurringId; int get order;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Task;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.originalDate, _this.originalDate) || other.originalDate == _this.originalDate)&&(identical(other.done, _this.done) || other.done == _this.done)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&const DeepCollectionEquality().equals(other.subtasks, _this.subtasks)&&(identical(other.recurringId, _this.recurringId) || other.recurringId == _this.recurringId)&&(identical(other.order, _this.order) || other.order == _this.order));
}


@override
int get hashCode {
  final _this = this as Task;
  return Object.hash(runtimeType,_this.id,_this.title,_this.date,_this.originalDate,_this.done,const DeepCollectionEquality().hash(_this.tags),const DeepCollectionEquality().hash(_this.subtasks),_this.recurringId,_this.order);
}

@override
String toString() {
  final _this = this as Task;
  return 'Task(id: ${_this.id}, title: ${_this.title}, date: ${_this.date}, originalDate: ${_this.originalDate}, done: ${_this.done}, tags: ${_this.tags}, subtasks: ${_this.subtasks}, recurringId: ${_this.recurringId}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, CalendarDate date, CalendarDate? originalDate, bool done, List<TaskTag> tags, List<Subtask> subtasks, String? recurringId, int order
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,Object? originalDate = freezed,Object? done = null,Object? tags = null,Object? subtasks = null,Object? recurringId = freezed,Object? order = null,}) {
  return _then(Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,originalDate: freezed == originalDate ? _self.originalDate : originalDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TaskTag>,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Subtask>,recurringId: freezed == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  CalendarDate date,  CalendarDate? originalDate,  bool done,  List<TaskTag> tags,  List<Subtask> subtasks,  String? recurringId,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.originalDate,_that.done,_that.tags,_that.subtasks,_that.recurringId,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  CalendarDate date,  CalendarDate? originalDate,  bool done,  List<TaskTag> tags,  List<Subtask> subtasks,  String? recurringId,  int order)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.date,_that.originalDate,_that.done,_that.tags,_that.subtasks,_that.recurringId,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  CalendarDate date,  CalendarDate? originalDate,  bool done,  List<TaskTag> tags,  List<Subtask> subtasks,  String? recurringId,  int order)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.originalDate,_that.done,_that.tags,_that.subtasks,_that.recurringId,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _Task extends Task {
  const _Task({required this.id, required this.title, required this.date, this.originalDate, required this.done,  List<TaskTag> tags = const [],  List<Subtask> subtasks = const [], this.recurringId, this.order = 0}): _tags = tags,_subtasks = subtasks,super._();
  

@override final  String id;
@override final  String title;
@override final  CalendarDate date;
@override final  CalendarDate? originalDate;
@override final  bool done;
 final  List<TaskTag> _tags;
@override@JsonKey() List<TaskTag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<Subtask> _subtasks;
@override@JsonKey() List<Subtask> get subtasks {
  if (_subtasks is EqualUnmodifiableListView) return _subtasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtasks);
}

@override final  String? recurringId;
@override@JsonKey() final  int order;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.originalDate, originalDate) || other.originalDate == originalDate)&&(identical(other.done, done) || other.done == done)&&const DeepCollectionEquality().equals(other.tags, _tags)&&const DeepCollectionEquality().equals(other.subtasks, _subtasks)&&(identical(other.recurringId, recurringId) || other.recurringId == recurringId)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,date,originalDate,done,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_subtasks),recurringId,order);
}

@override
String toString() {
    return 'Task(id: $id, title: $title, date: $date, originalDate: $originalDate, done: $done, tags: $tags, subtasks: $subtasks, recurringId: $recurringId, order: $order)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, CalendarDate date, CalendarDate? originalDate, bool done, List<TaskTag> tags, List<Subtask> subtasks, String? recurringId, int order
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,Object? originalDate = freezed,Object? done = null,Object? tags = null,Object? subtasks = null,Object? recurringId = freezed,Object? order = null,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,originalDate: freezed == originalDate ? _self.originalDate : originalDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TaskTag>,subtasks: null == subtasks ? _self._subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Subtask>,recurringId: freezed == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TaskDraft {

 String get title; CalendarDate get date; List<TaskTag> get tags; List<Subtask> get subtasks;
/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDraftCopyWith<TaskDraft> get copyWith => _$TaskDraftCopyWithImpl<TaskDraft>(this as TaskDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDraft&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.date, _this.date) || other.date == _this.date)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&const DeepCollectionEquality().equals(other.subtasks, _this.subtasks));
}


@override
int get hashCode {
  final _this = this as TaskDraft;
  return Object.hash(runtimeType,_this.title,_this.date,const DeepCollectionEquality().hash(_this.tags),const DeepCollectionEquality().hash(_this.subtasks));
}

@override
String toString() {
  final _this = this as TaskDraft;
  return 'TaskDraft(title: ${_this.title}, date: ${_this.date}, tags: ${_this.tags}, subtasks: ${_this.subtasks})';
}


}

/// @nodoc
abstract mixin class $TaskDraftCopyWith<$Res>  {
  factory $TaskDraftCopyWith(TaskDraft value, $Res Function(TaskDraft) _then) = _$TaskDraftCopyWithImpl;
@useResult
$Res call({
 String title, CalendarDate date, List<TaskTag> tags, List<Subtask> subtasks
});




}
/// @nodoc
class _$TaskDraftCopyWithImpl<$Res>
    implements $TaskDraftCopyWith<$Res> {
  _$TaskDraftCopyWithImpl(this._self, this._then);

  final TaskDraft _self;
  final $Res Function(TaskDraft) _then;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? date = null,Object? tags = null,Object? subtasks = null,}) {
  return _then(TaskDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TaskTag>,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Subtask>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDraft].
extension TaskDraftPatterns on TaskDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDraft value)  $default,){
final _that = this;
switch (_that) {
case _TaskDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  CalendarDate date,  List<TaskTag> tags,  List<Subtask> subtasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
return $default(_that.title,_that.date,_that.tags,_that.subtasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  CalendarDate date,  List<TaskTag> tags,  List<Subtask> subtasks)  $default,) {final _that = this;
switch (_that) {
case _TaskDraft():
return $default(_that.title,_that.date,_that.tags,_that.subtasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  CalendarDate date,  List<TaskTag> tags,  List<Subtask> subtasks)?  $default,) {final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
return $default(_that.title,_that.date,_that.tags,_that.subtasks);case _:
  return null;

}
}

}

/// @nodoc


class _TaskDraft implements TaskDraft {
  const _TaskDraft({required this.title, required this.date,  List<TaskTag> tags = const [],  List<Subtask> subtasks = const []}): _tags = tags,_subtasks = subtasks;
  

@override final  String title;
@override final  CalendarDate date;
 final  List<TaskTag> _tags;
@override@JsonKey() List<TaskTag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<Subtask> _subtasks;
@override@JsonKey() List<Subtask> get subtasks {
  if (_subtasks is EqualUnmodifiableListView) return _subtasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtasks);
}


/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDraftCopyWith<_TaskDraft> get copyWith => __$TaskDraftCopyWithImpl<_TaskDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.tags, _tags)&&const DeepCollectionEquality().equals(other.subtasks, _subtasks));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,date,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_subtasks));
}

@override
String toString() {
    return 'TaskDraft(title: $title, date: $date, tags: $tags, subtasks: $subtasks)';
}


}

/// @nodoc
abstract mixin class _$TaskDraftCopyWith<$Res> implements $TaskDraftCopyWith<$Res> {
  factory _$TaskDraftCopyWith(_TaskDraft value, $Res Function(_TaskDraft) _then) = __$TaskDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, CalendarDate date, List<TaskTag> tags, List<Subtask> subtasks
});




}
/// @nodoc
class __$TaskDraftCopyWithImpl<$Res>
    implements _$TaskDraftCopyWith<$Res> {
  __$TaskDraftCopyWithImpl(this._self, this._then);

  final _TaskDraft _self;
  final $Res Function(_TaskDraft) _then;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? date = null,Object? tags = null,Object? subtasks = null,}) {
  return _then(_TaskDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TaskTag>,subtasks: null == subtasks ? _self._subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Subtask>,
  ));
}


}

/// @nodoc
mixin _$DayProgress {

 CalendarDate get date; int get tasksDone; int get tasksTotal; int get percent; bool get hasDeadline;
/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayProgressCopyWith<DayProgress> get copyWith => _$DayProgressCopyWithImpl<DayProgress>(this as DayProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayProgress&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.tasksDone, _this.tasksDone) || other.tasksDone == _this.tasksDone)&&(identical(other.tasksTotal, _this.tasksTotal) || other.tasksTotal == _this.tasksTotal)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.hasDeadline, _this.hasDeadline) || other.hasDeadline == _this.hasDeadline));
}


@override
int get hashCode {
  final _this = this as DayProgress;
  return Object.hash(runtimeType,_this.date,_this.tasksDone,_this.tasksTotal,_this.percent,_this.hasDeadline);
}

@override
String toString() {
  final _this = this as DayProgress;
  return 'DayProgress(date: ${_this.date}, tasksDone: ${_this.tasksDone}, tasksTotal: ${_this.tasksTotal}, percent: ${_this.percent}, hasDeadline: ${_this.hasDeadline})';
}


}

/// @nodoc
abstract mixin class $DayProgressCopyWith<$Res>  {
  factory $DayProgressCopyWith(DayProgress value, $Res Function(DayProgress) _then) = _$DayProgressCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, int tasksDone, int tasksTotal, int percent, bool hasDeadline
});




}
/// @nodoc
class _$DayProgressCopyWithImpl<$Res>
    implements $DayProgressCopyWith<$Res> {
  _$DayProgressCopyWithImpl(this._self, this._then);

  final DayProgress _self;
  final $Res Function(DayProgress) _then;

/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? tasksDone = null,Object? tasksTotal = null,Object? percent = null,Object? hasDeadline = null,}) {
  return _then(DayProgress(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,hasDeadline: null == hasDeadline ? _self.hasDeadline : hasDeadline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DayProgress].
extension DayProgressPatterns on DayProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayProgress value)  $default,){
final _that = this;
switch (_that) {
case _DayProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayProgress value)?  $default,){
final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  int tasksDone,  int tasksTotal,  int percent,  bool hasDeadline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
return $default(_that.date,_that.tasksDone,_that.tasksTotal,_that.percent,_that.hasDeadline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  int tasksDone,  int tasksTotal,  int percent,  bool hasDeadline)  $default,) {final _that = this;
switch (_that) {
case _DayProgress():
return $default(_that.date,_that.tasksDone,_that.tasksTotal,_that.percent,_that.hasDeadline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  int tasksDone,  int tasksTotal,  int percent,  bool hasDeadline)?  $default,) {final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
return $default(_that.date,_that.tasksDone,_that.tasksTotal,_that.percent,_that.hasDeadline);case _:
  return null;

}
}

}

/// @nodoc


class _DayProgress implements DayProgress {
  const _DayProgress({required this.date, required this.tasksDone, required this.tasksTotal, required this.percent, this.hasDeadline = false});
  

@override final  CalendarDate date;
@override final  int tasksDone;
@override final  int tasksTotal;
@override final  int percent;
@override@JsonKey() final  bool hasDeadline;

/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayProgressCopyWith<_DayProgress> get copyWith => __$DayProgressCopyWithImpl<_DayProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayProgress&&(identical(other.date, date) || other.date == date)&&(identical(other.tasksDone, tasksDone) || other.tasksDone == tasksDone)&&(identical(other.tasksTotal, tasksTotal) || other.tasksTotal == tasksTotal)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.hasDeadline, hasDeadline) || other.hasDeadline == hasDeadline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,tasksDone,tasksTotal,percent,hasDeadline);
}

@override
String toString() {
    return 'DayProgress(date: $date, tasksDone: $tasksDone, tasksTotal: $tasksTotal, percent: $percent, hasDeadline: $hasDeadline)';
}


}

/// @nodoc
abstract mixin class _$DayProgressCopyWith<$Res> implements $DayProgressCopyWith<$Res> {
  factory _$DayProgressCopyWith(_DayProgress value, $Res Function(_DayProgress) _then) = __$DayProgressCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, int tasksDone, int tasksTotal, int percent, bool hasDeadline
});




}
/// @nodoc
class __$DayProgressCopyWithImpl<$Res>
    implements _$DayProgressCopyWith<$Res> {
  __$DayProgressCopyWithImpl(this._self, this._then);

  final _DayProgress _self;
  final $Res Function(_DayProgress) _then;

/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? tasksDone = null,Object? tasksTotal = null,Object? percent = null,Object? hasDeadline = null,}) {
  return _then(_DayProgress(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as int,tasksTotal: null == tasksTotal ? _self.tasksTotal : tasksTotal // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,hasDeadline: null == hasDeadline ? _self.hasDeadline : hasDeadline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$RecurringTask {

 String get id; String get title;/// 1 = Thứ 2 … 7 = Chủ nhật.
 List<int> get weekdays; List<TaskTag> get tags; bool get active; CalendarDate get startDate;
/// Create a copy of RecurringTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringTaskCopyWith<RecurringTask> get copyWith => _$RecurringTaskCopyWithImpl<RecurringTask>(this as RecurringTask, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecurringTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringTask&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate));
}


@override
int get hashCode {
  final _this = this as RecurringTask;
  return Object.hash(runtimeType,_this.id,_this.title,const DeepCollectionEquality().hash(_this.weekdays),const DeepCollectionEquality().hash(_this.tags),_this.active,_this.startDate);
}

@override
String toString() {
  final _this = this as RecurringTask;
  return 'RecurringTask(id: ${_this.id}, title: ${_this.title}, weekdays: ${_this.weekdays}, tags: ${_this.tags}, active: ${_this.active}, startDate: ${_this.startDate})';
}


}

/// @nodoc
abstract mixin class $RecurringTaskCopyWith<$Res>  {
  factory $RecurringTaskCopyWith(RecurringTask value, $Res Function(RecurringTask) _then) = _$RecurringTaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<int> weekdays, List<TaskTag> tags, bool active, CalendarDate startDate
});




}
/// @nodoc
class _$RecurringTaskCopyWithImpl<$Res>
    implements $RecurringTaskCopyWith<$Res> {
  _$RecurringTaskCopyWithImpl(this._self, this._then);

  final RecurringTask _self;
  final $Res Function(RecurringTask) _then;

/// Create a copy of RecurringTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? weekdays = null,Object? tags = null,Object? active = null,Object? startDate = null,}) {
  return _then(RecurringTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TaskTag>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringTask].
extension RecurringTaskPatterns on RecurringTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringTask value)  $default,){
final _that = this;
switch (_that) {
case _RecurringTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringTask value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<int> weekdays,  List<TaskTag> tags,  bool active,  CalendarDate startDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringTask() when $default != null:
return $default(_that.id,_that.title,_that.weekdays,_that.tags,_that.active,_that.startDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<int> weekdays,  List<TaskTag> tags,  bool active,  CalendarDate startDate)  $default,) {final _that = this;
switch (_that) {
case _RecurringTask():
return $default(_that.id,_that.title,_that.weekdays,_that.tags,_that.active,_that.startDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<int> weekdays,  List<TaskTag> tags,  bool active,  CalendarDate startDate)?  $default,) {final _that = this;
switch (_that) {
case _RecurringTask() when $default != null:
return $default(_that.id,_that.title,_that.weekdays,_that.tags,_that.active,_that.startDate);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringTask implements RecurringTask {
  const _RecurringTask({required this.id, required this.title, required  List<int> weekdays,  List<TaskTag> tags = const [], required this.active, required this.startDate}): _weekdays = weekdays,_tags = tags;
  

@override final  String id;
@override final  String title;
/// 1 = Thứ 2 … 7 = Chủ nhật.
 final  List<int> _weekdays;
/// 1 = Thứ 2 … 7 = Chủ nhật.
@override List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

 final  List<TaskTag> _tags;
@override@JsonKey() List<TaskTag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  bool active;
@override final  CalendarDate startDate;

/// Create a copy of RecurringTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringTaskCopyWith<_RecurringTask> get copyWith => __$RecurringTaskCopyWithImpl<_RecurringTask>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.active, active) || other.active == active)&&(identical(other.startDate, startDate) || other.startDate == startDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_weekdays),const DeepCollectionEquality().hash(_tags),active,startDate);
}

@override
String toString() {
    return 'RecurringTask(id: $id, title: $title, weekdays: $weekdays, tags: $tags, active: $active, startDate: $startDate)';
}


}

/// @nodoc
abstract mixin class _$RecurringTaskCopyWith<$Res> implements $RecurringTaskCopyWith<$Res> {
  factory _$RecurringTaskCopyWith(_RecurringTask value, $Res Function(_RecurringTask) _then) = __$RecurringTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<int> weekdays, List<TaskTag> tags, bool active, CalendarDate startDate
});




}
/// @nodoc
class __$RecurringTaskCopyWithImpl<$Res>
    implements _$RecurringTaskCopyWith<$Res> {
  __$RecurringTaskCopyWithImpl(this._self, this._then);

  final _RecurringTask _self;
  final $Res Function(_RecurringTask) _then;

/// Create a copy of RecurringTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? weekdays = null,Object? tags = null,Object? active = null,Object? startDate = null,}) {
  return _then(_RecurringTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TaskTag>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,
  ));
}


}

// dart format on
