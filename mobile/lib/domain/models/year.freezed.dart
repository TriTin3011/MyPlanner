// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$YearPlanItem {

 String get id; int get month; String get title; bool get done; int get order;
/// Create a copy of YearPlanItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearPlanItemCopyWith<YearPlanItem> get copyWith => _$YearPlanItemCopyWithImpl<YearPlanItem>(this as YearPlanItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as YearPlanItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearPlanItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.order, _this.order) || other.order == _this.order));
}


@override
int get hashCode {
  final _this = this as YearPlanItem;
  return Object.hash(runtimeType,_this.id,_this.month,_this.title,_this.done,_this.order);
}

@override
String toString() {
  final _this = this as YearPlanItem;
  return 'YearPlanItem(id: ${_this.id}, month: ${_this.month}, title: ${_this.title}, done: ${_this.done}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $YearPlanItemCopyWith<$Res>  {
  factory $YearPlanItemCopyWith(YearPlanItem value, $Res Function(YearPlanItem) _then) = _$YearPlanItemCopyWithImpl;
@useResult
$Res call({
 String id, int month, String title, bool done, int order
});




}
/// @nodoc
class _$YearPlanItemCopyWithImpl<$Res>
    implements $YearPlanItemCopyWith<$Res> {
  _$YearPlanItemCopyWithImpl(this._self, this._then);

  final YearPlanItem _self;
  final $Res Function(YearPlanItem) _then;

/// Create a copy of YearPlanItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? month = null,Object? title = null,Object? done = null,Object? order = null,}) {
  return _then(YearPlanItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YearPlanItem].
extension YearPlanItemPatterns on YearPlanItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearPlanItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearPlanItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearPlanItem value)  $default,){
final _that = this;
switch (_that) {
case _YearPlanItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearPlanItem value)?  $default,){
final _that = this;
switch (_that) {
case _YearPlanItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int month,  String title,  bool done,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearPlanItem() when $default != null:
return $default(_that.id,_that.month,_that.title,_that.done,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int month,  String title,  bool done,  int order)  $default,) {final _that = this;
switch (_that) {
case _YearPlanItem():
return $default(_that.id,_that.month,_that.title,_that.done,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int month,  String title,  bool done,  int order)?  $default,) {final _that = this;
switch (_that) {
case _YearPlanItem() when $default != null:
return $default(_that.id,_that.month,_that.title,_that.done,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _YearPlanItem implements YearPlanItem {
  const _YearPlanItem({required this.id, required this.month, required this.title, required this.done, required this.order});
  

@override final  String id;
@override final  int month;
@override final  String title;
@override final  bool done;
@override final  int order;

/// Create a copy of YearPlanItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearPlanItemCopyWith<_YearPlanItem> get copyWith => __$YearPlanItemCopyWithImpl<_YearPlanItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearPlanItem&&(identical(other.id, id) || other.id == id)&&(identical(other.month, month) || other.month == month)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,month,title,done,order);
}

@override
String toString() {
    return 'YearPlanItem(id: $id, month: $month, title: $title, done: $done, order: $order)';
}


}

/// @nodoc
abstract mixin class _$YearPlanItemCopyWith<$Res> implements $YearPlanItemCopyWith<$Res> {
  factory _$YearPlanItemCopyWith(_YearPlanItem value, $Res Function(_YearPlanItem) _then) = __$YearPlanItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int month, String title, bool done, int order
});




}
/// @nodoc
class __$YearPlanItemCopyWithImpl<$Res>
    implements _$YearPlanItemCopyWith<$Res> {
  __$YearPlanItemCopyWithImpl(this._self, this._then);

  final _YearPlanItem _self;
  final $Res Function(_YearPlanItem) _then;

/// Create a copy of YearPlanItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? month = null,Object? title = null,Object? done = null,Object? order = null,}) {
  return _then(_YearPlanItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$YearMonth {

 int get month; int get done; int get total; int get percent; List<Deadline> get deadlines; List<YearPlanItem> get items;
/// Create a copy of YearMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearMonthCopyWith<YearMonth> get copyWith => _$YearMonthCopyWithImpl<YearMonth>(this as YearMonth, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as YearMonth;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearMonth&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&const DeepCollectionEquality().equals(other.deadlines, _this.deadlines)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as YearMonth;
  return Object.hash(runtimeType,_this.month,_this.done,_this.total,_this.percent,const DeepCollectionEquality().hash(_this.deadlines),const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as YearMonth;
  return 'YearMonth(month: ${_this.month}, done: ${_this.done}, total: ${_this.total}, percent: ${_this.percent}, deadlines: ${_this.deadlines}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $YearMonthCopyWith<$Res>  {
  factory $YearMonthCopyWith(YearMonth value, $Res Function(YearMonth) _then) = _$YearMonthCopyWithImpl;
@useResult
$Res call({
 int month, int done, int total, int percent, List<Deadline> deadlines, List<YearPlanItem> items
});




}
/// @nodoc
class _$YearMonthCopyWithImpl<$Res>
    implements $YearMonthCopyWith<$Res> {
  _$YearMonthCopyWithImpl(this._self, this._then);

  final YearMonth _self;
  final $Res Function(YearMonth) _then;

/// Create a copy of YearMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? done = null,Object? total = null,Object? percent = null,Object? deadlines = null,Object? items = null,}) {
  return _then(YearMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,deadlines: null == deadlines ? _self.deadlines : deadlines // ignore: cast_nullable_to_non_nullable
as List<Deadline>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<YearPlanItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearMonth].
extension YearMonthPatterns on YearMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearMonth value)  $default,){
final _that = this;
switch (_that) {
case _YearMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearMonth value)?  $default,){
final _that = this;
switch (_that) {
case _YearMonth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int month,  int done,  int total,  int percent,  List<Deadline> deadlines,  List<YearPlanItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearMonth() when $default != null:
return $default(_that.month,_that.done,_that.total,_that.percent,_that.deadlines,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int month,  int done,  int total,  int percent,  List<Deadline> deadlines,  List<YearPlanItem> items)  $default,) {final _that = this;
switch (_that) {
case _YearMonth():
return $default(_that.month,_that.done,_that.total,_that.percent,_that.deadlines,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int month,  int done,  int total,  int percent,  List<Deadline> deadlines,  List<YearPlanItem> items)?  $default,) {final _that = this;
switch (_that) {
case _YearMonth() when $default != null:
return $default(_that.month,_that.done,_that.total,_that.percent,_that.deadlines,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _YearMonth implements YearMonth {
  const _YearMonth({required this.month, required this.done, required this.total, required this.percent, required  List<Deadline> deadlines, required  List<YearPlanItem> items}): _deadlines = deadlines,_items = items;
  

@override final  int month;
@override final  int done;
@override final  int total;
@override final  int percent;
 final  List<Deadline> _deadlines;
@override List<Deadline> get deadlines {
  if (_deadlines is EqualUnmodifiableListView) return _deadlines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deadlines);
}

 final  List<YearPlanItem> _items;
@override List<YearPlanItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of YearMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearMonthCopyWith<_YearMonth> get copyWith => __$YearMonthCopyWithImpl<_YearMonth>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent)&&const DeepCollectionEquality().equals(other.deadlines, _deadlines)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,done,total,percent,const DeepCollectionEquality().hash(_deadlines),const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'YearMonth(month: $month, done: $done, total: $total, percent: $percent, deadlines: $deadlines, items: $items)';
}


}

/// @nodoc
abstract mixin class _$YearMonthCopyWith<$Res> implements $YearMonthCopyWith<$Res> {
  factory _$YearMonthCopyWith(_YearMonth value, $Res Function(_YearMonth) _then) = __$YearMonthCopyWithImpl;
@override @useResult
$Res call({
 int month, int done, int total, int percent, List<Deadline> deadlines, List<YearPlanItem> items
});




}
/// @nodoc
class __$YearMonthCopyWithImpl<$Res>
    implements _$YearMonthCopyWith<$Res> {
  __$YearMonthCopyWithImpl(this._self, this._then);

  final _YearMonth _self;
  final $Res Function(_YearMonth) _then;

/// Create a copy of YearMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? done = null,Object? total = null,Object? percent = null,Object? deadlines = null,Object? items = null,}) {
  return _then(_YearMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,deadlines: null == deadlines ? _self._deadlines : deadlines // ignore: cast_nullable_to_non_nullable
as List<Deadline>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<YearPlanItem>,
  ));
}


}

/// @nodoc
mixin _$YearDashboard {

 int get year; String get keyword; String get vision; int get done; int get total; int get percent; int? get currentMonth; List<YearMonth> get months;
/// Create a copy of YearDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearDashboardCopyWith<YearDashboard> get copyWith => _$YearDashboardCopyWithImpl<YearDashboard>(this as YearDashboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as YearDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearDashboard&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.keyword, _this.keyword) || other.keyword == _this.keyword)&&(identical(other.vision, _this.vision) || other.vision == _this.vision)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.currentMonth, _this.currentMonth) || other.currentMonth == _this.currentMonth)&&const DeepCollectionEquality().equals(other.months, _this.months));
}


@override
int get hashCode {
  final _this = this as YearDashboard;
  return Object.hash(runtimeType,_this.year,_this.keyword,_this.vision,_this.done,_this.total,_this.percent,_this.currentMonth,const DeepCollectionEquality().hash(_this.months));
}

@override
String toString() {
  final _this = this as YearDashboard;
  return 'YearDashboard(year: ${_this.year}, keyword: ${_this.keyword}, vision: ${_this.vision}, done: ${_this.done}, total: ${_this.total}, percent: ${_this.percent}, currentMonth: ${_this.currentMonth}, months: ${_this.months})';
}


}

/// @nodoc
abstract mixin class $YearDashboardCopyWith<$Res>  {
  factory $YearDashboardCopyWith(YearDashboard value, $Res Function(YearDashboard) _then) = _$YearDashboardCopyWithImpl;
@useResult
$Res call({
 int year, String keyword, String vision, int done, int total, int percent, int? currentMonth, List<YearMonth> months
});




}
/// @nodoc
class _$YearDashboardCopyWithImpl<$Res>
    implements $YearDashboardCopyWith<$Res> {
  _$YearDashboardCopyWithImpl(this._self, this._then);

  final YearDashboard _self;
  final $Res Function(YearDashboard) _then;

/// Create a copy of YearDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? keyword = null,Object? vision = null,Object? done = null,Object? total = null,Object? percent = null,Object? currentMonth = freezed,Object? months = null,}) {
  return _then(YearDashboard(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,vision: null == vision ? _self.vision : vision // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,currentMonth: freezed == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as int?,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as List<YearMonth>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearDashboard].
extension YearDashboardPatterns on YearDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearDashboard value)  $default,){
final _that = this;
switch (_that) {
case _YearDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _YearDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  String keyword,  String vision,  int done,  int total,  int percent,  int? currentMonth,  List<YearMonth> months)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearDashboard() when $default != null:
return $default(_that.year,_that.keyword,_that.vision,_that.done,_that.total,_that.percent,_that.currentMonth,_that.months);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  String keyword,  String vision,  int done,  int total,  int percent,  int? currentMonth,  List<YearMonth> months)  $default,) {final _that = this;
switch (_that) {
case _YearDashboard():
return $default(_that.year,_that.keyword,_that.vision,_that.done,_that.total,_that.percent,_that.currentMonth,_that.months);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  String keyword,  String vision,  int done,  int total,  int percent,  int? currentMonth,  List<YearMonth> months)?  $default,) {final _that = this;
switch (_that) {
case _YearDashboard() when $default != null:
return $default(_that.year,_that.keyword,_that.vision,_that.done,_that.total,_that.percent,_that.currentMonth,_that.months);case _:
  return null;

}
}

}

/// @nodoc


class _YearDashboard implements YearDashboard {
  const _YearDashboard({required this.year, required this.keyword, required this.vision, required this.done, required this.total, required this.percent, this.currentMonth, required  List<YearMonth> months}): _months = months;
  

@override final  int year;
@override final  String keyword;
@override final  String vision;
@override final  int done;
@override final  int total;
@override final  int percent;
@override final  int? currentMonth;
 final  List<YearMonth> _months;
@override List<YearMonth> get months {
  if (_months is EqualUnmodifiableListView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_months);
}


/// Create a copy of YearDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearDashboardCopyWith<_YearDashboard> get copyWith => __$YearDashboardCopyWithImpl<_YearDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearDashboard&&(identical(other.year, year) || other.year == year)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.vision, vision) || other.vision == vision)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&const DeepCollectionEquality().equals(other.months, _months));
}


@override
int get hashCode {
    return Object.hash(runtimeType,year,keyword,vision,done,total,percent,currentMonth,const DeepCollectionEquality().hash(_months));
}

@override
String toString() {
    return 'YearDashboard(year: $year, keyword: $keyword, vision: $vision, done: $done, total: $total, percent: $percent, currentMonth: $currentMonth, months: $months)';
}


}

/// @nodoc
abstract mixin class _$YearDashboardCopyWith<$Res> implements $YearDashboardCopyWith<$Res> {
  factory _$YearDashboardCopyWith(_YearDashboard value, $Res Function(_YearDashboard) _then) = __$YearDashboardCopyWithImpl;
@override @useResult
$Res call({
 int year, String keyword, String vision, int done, int total, int percent, int? currentMonth, List<YearMonth> months
});




}
/// @nodoc
class __$YearDashboardCopyWithImpl<$Res>
    implements _$YearDashboardCopyWith<$Res> {
  __$YearDashboardCopyWithImpl(this._self, this._then);

  final _YearDashboard _self;
  final $Res Function(_YearDashboard) _then;

/// Create a copy of YearDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? keyword = null,Object? vision = null,Object? done = null,Object? total = null,Object? percent = null,Object? currentMonth = freezed,Object? months = null,}) {
  return _then(_YearDashboard(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,vision: null == vision ? _self.vision : vision // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,currentMonth: freezed == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as int?,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as List<YearMonth>,
  ));
}


}

// dart format on
