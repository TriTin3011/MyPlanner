// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HabitHighlight {

 String get habitId; String get title; int get value;
/// Create a copy of HabitHighlight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitHighlightCopyWith<HabitHighlight> get copyWith => _$HabitHighlightCopyWithImpl<HabitHighlight>(this as HabitHighlight, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HabitHighlight;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitHighlight&&(identical(other.habitId, _this.habitId) || other.habitId == _this.habitId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as HabitHighlight;
  return Object.hash(runtimeType,_this.habitId,_this.title,_this.value);
}

@override
String toString() {
  final _this = this as HabitHighlight;
  return 'HabitHighlight(habitId: ${_this.habitId}, title: ${_this.title}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $HabitHighlightCopyWith<$Res>  {
  factory $HabitHighlightCopyWith(HabitHighlight value, $Res Function(HabitHighlight) _then) = _$HabitHighlightCopyWithImpl;
@useResult
$Res call({
 String habitId, String title, int value
});




}
/// @nodoc
class _$HabitHighlightCopyWithImpl<$Res>
    implements $HabitHighlightCopyWith<$Res> {
  _$HabitHighlightCopyWithImpl(this._self, this._then);

  final HabitHighlight _self;
  final $Res Function(HabitHighlight) _then;

/// Create a copy of HabitHighlight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habitId = null,Object? title = null,Object? value = null,}) {
  return _then(HabitHighlight(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitHighlight].
extension HabitHighlightPatterns on HabitHighlight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitHighlight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitHighlight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitHighlight value)  $default,){
final _that = this;
switch (_that) {
case _HabitHighlight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitHighlight value)?  $default,){
final _that = this;
switch (_that) {
case _HabitHighlight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String habitId,  String title,  int value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitHighlight() when $default != null:
return $default(_that.habitId,_that.title,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String habitId,  String title,  int value)  $default,) {final _that = this;
switch (_that) {
case _HabitHighlight():
return $default(_that.habitId,_that.title,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String habitId,  String title,  int value)?  $default,) {final _that = this;
switch (_that) {
case _HabitHighlight() when $default != null:
return $default(_that.habitId,_that.title,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _HabitHighlight implements HabitHighlight {
  const _HabitHighlight({required this.habitId, required this.title, required this.value});
  

@override final  String habitId;
@override final  String title;
@override final  int value;

/// Create a copy of HabitHighlight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitHighlightCopyWith<_HabitHighlight> get copyWith => __$HabitHighlightCopyWithImpl<_HabitHighlight>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitHighlight&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.title, title) || other.title == title)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,habitId,title,value);
}

@override
String toString() {
    return 'HabitHighlight(habitId: $habitId, title: $title, value: $value)';
}


}

/// @nodoc
abstract mixin class _$HabitHighlightCopyWith<$Res> implements $HabitHighlightCopyWith<$Res> {
  factory _$HabitHighlightCopyWith(_HabitHighlight value, $Res Function(_HabitHighlight) _then) = __$HabitHighlightCopyWithImpl;
@override @useResult
$Res call({
 String habitId, String title, int value
});




}
/// @nodoc
class __$HabitHighlightCopyWithImpl<$Res>
    implements _$HabitHighlightCopyWith<$Res> {
  __$HabitHighlightCopyWithImpl(this._self, this._then);

  final _HabitHighlight _self;
  final $Res Function(_HabitHighlight) _then;

/// Create a copy of HabitHighlight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habitId = null,Object? title = null,Object? value = null,}) {
  return _then(_HabitHighlight(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$HabitRow {

 String get id; String get title; int get order; CalendarDate get startDate; int get percent; int get currentStreak; int get longestStreak; Set<CalendarDate> get doneDates;
/// Create a copy of HabitRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitRowCopyWith<HabitRow> get copyWith => _$HabitRowCopyWithImpl<HabitRow>(this as HabitRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HabitRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitRow&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.currentStreak, _this.currentStreak) || other.currentStreak == _this.currentStreak)&&(identical(other.longestStreak, _this.longestStreak) || other.longestStreak == _this.longestStreak)&&const DeepCollectionEquality().equals(other.doneDates, _this.doneDates));
}


@override
int get hashCode {
  final _this = this as HabitRow;
  return Object.hash(runtimeType,_this.id,_this.title,_this.order,_this.startDate,_this.percent,_this.currentStreak,_this.longestStreak,const DeepCollectionEquality().hash(_this.doneDates));
}

@override
String toString() {
  final _this = this as HabitRow;
  return 'HabitRow(id: ${_this.id}, title: ${_this.title}, order: ${_this.order}, startDate: ${_this.startDate}, percent: ${_this.percent}, currentStreak: ${_this.currentStreak}, longestStreak: ${_this.longestStreak}, doneDates: ${_this.doneDates})';
}


}

/// @nodoc
abstract mixin class $HabitRowCopyWith<$Res>  {
  factory $HabitRowCopyWith(HabitRow value, $Res Function(HabitRow) _then) = _$HabitRowCopyWithImpl;
@useResult
$Res call({
 String id, String title, int order, CalendarDate startDate, int percent, int currentStreak, int longestStreak, Set<CalendarDate> doneDates
});




}
/// @nodoc
class _$HabitRowCopyWithImpl<$Res>
    implements $HabitRowCopyWith<$Res> {
  _$HabitRowCopyWithImpl(this._self, this._then);

  final HabitRow _self;
  final $Res Function(HabitRow) _then;

/// Create a copy of HabitRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? order = null,Object? startDate = null,Object? percent = null,Object? currentStreak = null,Object? longestStreak = null,Object? doneDates = null,}) {
  return _then(HabitRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,doneDates: null == doneDates ? _self.doneDates : doneDates // ignore: cast_nullable_to_non_nullable
as Set<CalendarDate>,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitRow].
extension HabitRowPatterns on HabitRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitRow value)  $default,){
final _that = this;
switch (_that) {
case _HabitRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitRow value)?  $default,){
final _that = this;
switch (_that) {
case _HabitRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int order,  CalendarDate startDate,  int percent,  int currentStreak,  int longestStreak,  Set<CalendarDate> doneDates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitRow() when $default != null:
return $default(_that.id,_that.title,_that.order,_that.startDate,_that.percent,_that.currentStreak,_that.longestStreak,_that.doneDates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int order,  CalendarDate startDate,  int percent,  int currentStreak,  int longestStreak,  Set<CalendarDate> doneDates)  $default,) {final _that = this;
switch (_that) {
case _HabitRow():
return $default(_that.id,_that.title,_that.order,_that.startDate,_that.percent,_that.currentStreak,_that.longestStreak,_that.doneDates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int order,  CalendarDate startDate,  int percent,  int currentStreak,  int longestStreak,  Set<CalendarDate> doneDates)?  $default,) {final _that = this;
switch (_that) {
case _HabitRow() when $default != null:
return $default(_that.id,_that.title,_that.order,_that.startDate,_that.percent,_that.currentStreak,_that.longestStreak,_that.doneDates);case _:
  return null;

}
}

}

/// @nodoc


class _HabitRow implements HabitRow {
  const _HabitRow({required this.id, required this.title, required this.order, required this.startDate, required this.percent, required this.currentStreak, required this.longestStreak, required  Set<CalendarDate> doneDates}): _doneDates = doneDates;
  

@override final  String id;
@override final  String title;
@override final  int order;
@override final  CalendarDate startDate;
@override final  int percent;
@override final  int currentStreak;
@override final  int longestStreak;
 final  Set<CalendarDate> _doneDates;
@override Set<CalendarDate> get doneDates {
  if (_doneDates is EqualUnmodifiableSetView) return _doneDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_doneDates);
}


/// Create a copy of HabitRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitRowCopyWith<_HabitRow> get copyWith => __$HabitRowCopyWithImpl<_HabitRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitRow&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&const DeepCollectionEquality().equals(other.doneDates, _doneDates));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,order,startDate,percent,currentStreak,longestStreak,const DeepCollectionEquality().hash(_doneDates));
}

@override
String toString() {
    return 'HabitRow(id: $id, title: $title, order: $order, startDate: $startDate, percent: $percent, currentStreak: $currentStreak, longestStreak: $longestStreak, doneDates: $doneDates)';
}


}

/// @nodoc
abstract mixin class _$HabitRowCopyWith<$Res> implements $HabitRowCopyWith<$Res> {
  factory _$HabitRowCopyWith(_HabitRow value, $Res Function(_HabitRow) _then) = __$HabitRowCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int order, CalendarDate startDate, int percent, int currentStreak, int longestStreak, Set<CalendarDate> doneDates
});




}
/// @nodoc
class __$HabitRowCopyWithImpl<$Res>
    implements _$HabitRowCopyWith<$Res> {
  __$HabitRowCopyWithImpl(this._self, this._then);

  final _HabitRow _self;
  final $Res Function(_HabitRow) _then;

/// Create a copy of HabitRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? order = null,Object? startDate = null,Object? percent = null,Object? currentStreak = null,Object? longestStreak = null,Object? doneDates = null,}) {
  return _then(_HabitRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,doneDates: null == doneDates ? _self._doneDates : doneDates // ignore: cast_nullable_to_non_nullable
as Set<CalendarDate>,
  ));
}


}

/// @nodoc
mixin _$HabitDayCount {

 CalendarDate get date; int? get done; int? get total; int? get percent;
/// Create a copy of HabitDayCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitDayCountCopyWith<HabitDayCount> get copyWith => _$HabitDayCountCopyWithImpl<HabitDayCount>(this as HabitDayCount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HabitDayCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitDayCount&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percent, _this.percent) || other.percent == _this.percent));
}


@override
int get hashCode {
  final _this = this as HabitDayCount;
  return Object.hash(runtimeType,_this.date,_this.done,_this.total,_this.percent);
}

@override
String toString() {
  final _this = this as HabitDayCount;
  return 'HabitDayCount(date: ${_this.date}, done: ${_this.done}, total: ${_this.total}, percent: ${_this.percent})';
}


}

/// @nodoc
abstract mixin class $HabitDayCountCopyWith<$Res>  {
  factory $HabitDayCountCopyWith(HabitDayCount value, $Res Function(HabitDayCount) _then) = _$HabitDayCountCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, int? done, int? total, int? percent
});




}
/// @nodoc
class _$HabitDayCountCopyWithImpl<$Res>
    implements $HabitDayCountCopyWith<$Res> {
  _$HabitDayCountCopyWithImpl(this._self, this._then);

  final HabitDayCount _self;
  final $Res Function(HabitDayCount) _then;

/// Create a copy of HabitDayCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? done = freezed,Object? total = freezed,Object? percent = freezed,}) {
  return _then(HabitDayCount(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: freezed == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,percent: freezed == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitDayCount].
extension HabitDayCountPatterns on HabitDayCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitDayCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitDayCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitDayCount value)  $default,){
final _that = this;
switch (_that) {
case _HabitDayCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitDayCount value)?  $default,){
final _that = this;
switch (_that) {
case _HabitDayCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  int? done,  int? total,  int? percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitDayCount() when $default != null:
return $default(_that.date,_that.done,_that.total,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  int? done,  int? total,  int? percent)  $default,) {final _that = this;
switch (_that) {
case _HabitDayCount():
return $default(_that.date,_that.done,_that.total,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  int? done,  int? total,  int? percent)?  $default,) {final _that = this;
switch (_that) {
case _HabitDayCount() when $default != null:
return $default(_that.date,_that.done,_that.total,_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _HabitDayCount implements HabitDayCount {
  const _HabitDayCount({required this.date, this.done, this.total, this.percent});
  

@override final  CalendarDate date;
@override final  int? done;
@override final  int? total;
@override final  int? percent;

/// Create a copy of HabitDayCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitDayCountCopyWith<_HabitDayCount> get copyWith => __$HabitDayCountCopyWithImpl<_HabitDayCount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitDayCount&&(identical(other.date, date) || other.date == date)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,done,total,percent);
}

@override
String toString() {
    return 'HabitDayCount(date: $date, done: $done, total: $total, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$HabitDayCountCopyWith<$Res> implements $HabitDayCountCopyWith<$Res> {
  factory _$HabitDayCountCopyWith(_HabitDayCount value, $Res Function(_HabitDayCount) _then) = __$HabitDayCountCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, int? done, int? total, int? percent
});




}
/// @nodoc
class __$HabitDayCountCopyWithImpl<$Res>
    implements _$HabitDayCountCopyWith<$Res> {
  __$HabitDayCountCopyWithImpl(this._self, this._then);

  final _HabitDayCount _self;
  final $Res Function(_HabitDayCount) _then;

/// Create a copy of HabitDayCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? done = freezed,Object? total = freezed,Object? percent = freezed,}) {
  return _then(_HabitDayCount(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: freezed == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,percent: freezed == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$HabitMonth {

/// `YYYY-MM`.
 String get month; CalendarDate get from; CalendarDate get to; int get percent; HabitHighlight? get longestStreak; HabitHighlight? get mostConsistent; List<HabitRow> get habits; List<HabitDayCount> get days;
/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitMonthCopyWith<HabitMonth> get copyWith => _$HabitMonthCopyWithImpl<HabitMonth>(this as HabitMonth, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HabitMonth;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitMonth&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.longestStreak, _this.longestStreak) || other.longestStreak == _this.longestStreak)&&(identical(other.mostConsistent, _this.mostConsistent) || other.mostConsistent == _this.mostConsistent)&&const DeepCollectionEquality().equals(other.habits, _this.habits)&&const DeepCollectionEquality().equals(other.days, _this.days));
}


@override
int get hashCode {
  final _this = this as HabitMonth;
  return Object.hash(runtimeType,_this.month,_this.from,_this.to,_this.percent,_this.longestStreak,_this.mostConsistent,const DeepCollectionEquality().hash(_this.habits),const DeepCollectionEquality().hash(_this.days));
}

@override
String toString() {
  final _this = this as HabitMonth;
  return 'HabitMonth(month: ${_this.month}, from: ${_this.from}, to: ${_this.to}, percent: ${_this.percent}, longestStreak: ${_this.longestStreak}, mostConsistent: ${_this.mostConsistent}, habits: ${_this.habits}, days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $HabitMonthCopyWith<$Res>  {
  factory $HabitMonthCopyWith(HabitMonth value, $Res Function(HabitMonth) _then) = _$HabitMonthCopyWithImpl;
@useResult
$Res call({
 String month, CalendarDate from, CalendarDate to, int percent, HabitHighlight? longestStreak, HabitHighlight? mostConsistent, List<HabitRow> habits, List<HabitDayCount> days
});


$HabitHighlightCopyWith<$Res>? get longestStreak;$HabitHighlightCopyWith<$Res>? get mostConsistent;

}
/// @nodoc
class _$HabitMonthCopyWithImpl<$Res>
    implements $HabitMonthCopyWith<$Res> {
  _$HabitMonthCopyWithImpl(this._self, this._then);

  final HabitMonth _self;
  final $Res Function(HabitMonth) _then;

/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? from = null,Object? to = null,Object? percent = null,Object? longestStreak = freezed,Object? mostConsistent = freezed,Object? habits = null,Object? days = null,}) {
  return _then(HabitMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,longestStreak: freezed == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as HabitHighlight?,mostConsistent: freezed == mostConsistent ? _self.mostConsistent : mostConsistent // ignore: cast_nullable_to_non_nullable
as HabitHighlight?,habits: null == habits ? _self.habits : habits // ignore: cast_nullable_to_non_nullable
as List<HabitRow>,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<HabitDayCount>,
  ));
}
/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitHighlightCopyWith<$Res>? get longestStreak {
    if (_self.longestStreak == null) {
    return null;
  }

  return $HabitHighlightCopyWith<$Res>(_self.longestStreak!, (value) {
    return _then(_self.copyWith(longestStreak: value));
  });
}/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitHighlightCopyWith<$Res>? get mostConsistent {
    if (_self.mostConsistent == null) {
    return null;
  }

  return $HabitHighlightCopyWith<$Res>(_self.mostConsistent!, (value) {
    return _then(_self.copyWith(mostConsistent: value));
  });
}
}


/// Adds pattern-matching-related methods to [HabitMonth].
extension HabitMonthPatterns on HabitMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitMonth value)  $default,){
final _that = this;
switch (_that) {
case _HabitMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitMonth value)?  $default,){
final _that = this;
switch (_that) {
case _HabitMonth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  CalendarDate from,  CalendarDate to,  int percent,  HabitHighlight? longestStreak,  HabitHighlight? mostConsistent,  List<HabitRow> habits,  List<HabitDayCount> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitMonth() when $default != null:
return $default(_that.month,_that.from,_that.to,_that.percent,_that.longestStreak,_that.mostConsistent,_that.habits,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  CalendarDate from,  CalendarDate to,  int percent,  HabitHighlight? longestStreak,  HabitHighlight? mostConsistent,  List<HabitRow> habits,  List<HabitDayCount> days)  $default,) {final _that = this;
switch (_that) {
case _HabitMonth():
return $default(_that.month,_that.from,_that.to,_that.percent,_that.longestStreak,_that.mostConsistent,_that.habits,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  CalendarDate from,  CalendarDate to,  int percent,  HabitHighlight? longestStreak,  HabitHighlight? mostConsistent,  List<HabitRow> habits,  List<HabitDayCount> days)?  $default,) {final _that = this;
switch (_that) {
case _HabitMonth() when $default != null:
return $default(_that.month,_that.from,_that.to,_that.percent,_that.longestStreak,_that.mostConsistent,_that.habits,_that.days);case _:
  return null;

}
}

}

/// @nodoc


class _HabitMonth implements HabitMonth {
  const _HabitMonth({required this.month, required this.from, required this.to, required this.percent, this.longestStreak, this.mostConsistent, required  List<HabitRow> habits, required  List<HabitDayCount> days}): _habits = habits,_days = days;
  

/// `YYYY-MM`.
@override final  String month;
@override final  CalendarDate from;
@override final  CalendarDate to;
@override final  int percent;
@override final  HabitHighlight? longestStreak;
@override final  HabitHighlight? mostConsistent;
 final  List<HabitRow> _habits;
@override List<HabitRow> get habits {
  if (_habits is EqualUnmodifiableListView) return _habits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_habits);
}

 final  List<HabitDayCount> _days;
@override List<HabitDayCount> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitMonthCopyWith<_HabitMonth> get copyWith => __$HabitMonthCopyWithImpl<_HabitMonth>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.mostConsistent, mostConsistent) || other.mostConsistent == mostConsistent)&&const DeepCollectionEquality().equals(other.habits, _habits)&&const DeepCollectionEquality().equals(other.days, _days));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,from,to,percent,longestStreak,mostConsistent,const DeepCollectionEquality().hash(_habits),const DeepCollectionEquality().hash(_days));
}

@override
String toString() {
    return 'HabitMonth(month: $month, from: $from, to: $to, percent: $percent, longestStreak: $longestStreak, mostConsistent: $mostConsistent, habits: $habits, days: $days)';
}


}

/// @nodoc
abstract mixin class _$HabitMonthCopyWith<$Res> implements $HabitMonthCopyWith<$Res> {
  factory _$HabitMonthCopyWith(_HabitMonth value, $Res Function(_HabitMonth) _then) = __$HabitMonthCopyWithImpl;
@override @useResult
$Res call({
 String month, CalendarDate from, CalendarDate to, int percent, HabitHighlight? longestStreak, HabitHighlight? mostConsistent, List<HabitRow> habits, List<HabitDayCount> days
});


@override $HabitHighlightCopyWith<$Res>? get longestStreak;@override $HabitHighlightCopyWith<$Res>? get mostConsistent;

}
/// @nodoc
class __$HabitMonthCopyWithImpl<$Res>
    implements _$HabitMonthCopyWith<$Res> {
  __$HabitMonthCopyWithImpl(this._self, this._then);

  final _HabitMonth _self;
  final $Res Function(_HabitMonth) _then;

/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? from = null,Object? to = null,Object? percent = null,Object? longestStreak = freezed,Object? mostConsistent = freezed,Object? habits = null,Object? days = null,}) {
  return _then(_HabitMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,longestStreak: freezed == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as HabitHighlight?,mostConsistent: freezed == mostConsistent ? _self.mostConsistent : mostConsistent // ignore: cast_nullable_to_non_nullable
as HabitHighlight?,habits: null == habits ? _self._habits : habits // ignore: cast_nullable_to_non_nullable
as List<HabitRow>,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<HabitDayCount>,
  ));
}

/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitHighlightCopyWith<$Res>? get longestStreak {
    if (_self.longestStreak == null) {
    return null;
  }

  return $HabitHighlightCopyWith<$Res>(_self.longestStreak!, (value) {
    return _then(_self.copyWith(longestStreak: value));
  });
}/// Create a copy of HabitMonth
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitHighlightCopyWith<$Res>? get mostConsistent {
    if (_self.mostConsistent == null) {
    return null;
  }

  return $HabitHighlightCopyWith<$Res>(_self.mostConsistent!, (value) {
    return _then(_self.copyWith(mostConsistent: value));
  });
}
}

// dart format on
