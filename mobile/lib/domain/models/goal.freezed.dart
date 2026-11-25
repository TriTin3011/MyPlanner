// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AreaSummary {

 LifeArea get area; int get count; int get percent;
/// Create a copy of AreaSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaSummaryCopyWith<AreaSummary> get copyWith => _$AreaSummaryCopyWithImpl<AreaSummary>(this as AreaSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AreaSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AreaSummary&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.percent, _this.percent) || other.percent == _this.percent));
}


@override
int get hashCode {
  final _this = this as AreaSummary;
  return Object.hash(runtimeType,_this.area,_this.count,_this.percent);
}

@override
String toString() {
  final _this = this as AreaSummary;
  return 'AreaSummary(area: ${_this.area}, count: ${_this.count}, percent: ${_this.percent})';
}


}

/// @nodoc
abstract mixin class $AreaSummaryCopyWith<$Res>  {
  factory $AreaSummaryCopyWith(AreaSummary value, $Res Function(AreaSummary) _then) = _$AreaSummaryCopyWithImpl;
@useResult
$Res call({
 LifeArea area, int count, int percent
});




}
/// @nodoc
class _$AreaSummaryCopyWithImpl<$Res>
    implements $AreaSummaryCopyWith<$Res> {
  _$AreaSummaryCopyWithImpl(this._self, this._then);

  final AreaSummary _self;
  final $Res Function(AreaSummary) _then;

/// Create a copy of AreaSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = null,Object? count = null,Object? percent = null,}) {
  return _then(AreaSummary(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AreaSummary].
extension AreaSummaryPatterns on AreaSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AreaSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AreaSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AreaSummary value)  $default,){
final _that = this;
switch (_that) {
case _AreaSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AreaSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AreaSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LifeArea area,  int count,  int percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AreaSummary() when $default != null:
return $default(_that.area,_that.count,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LifeArea area,  int count,  int percent)  $default,) {final _that = this;
switch (_that) {
case _AreaSummary():
return $default(_that.area,_that.count,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LifeArea area,  int count,  int percent)?  $default,) {final _that = this;
switch (_that) {
case _AreaSummary() when $default != null:
return $default(_that.area,_that.count,_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _AreaSummary implements AreaSummary {
  const _AreaSummary({required this.area, required this.count, required this.percent});
  

@override final  LifeArea area;
@override final  int count;
@override final  int percent;

/// Create a copy of AreaSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AreaSummaryCopyWith<_AreaSummary> get copyWith => __$AreaSummaryCopyWithImpl<_AreaSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AreaSummary&&(identical(other.area, area) || other.area == area)&&(identical(other.count, count) || other.count == count)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,area,count,percent);
}

@override
String toString() {
    return 'AreaSummary(area: $area, count: $count, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$AreaSummaryCopyWith<$Res> implements $AreaSummaryCopyWith<$Res> {
  factory _$AreaSummaryCopyWith(_AreaSummary value, $Res Function(_AreaSummary) _then) = __$AreaSummaryCopyWithImpl;
@override @useResult
$Res call({
 LifeArea area, int count, int percent
});




}
/// @nodoc
class __$AreaSummaryCopyWithImpl<$Res>
    implements _$AreaSummaryCopyWith<$Res> {
  __$AreaSummaryCopyWithImpl(this._self, this._then);

  final _AreaSummary _self;
  final $Res Function(_AreaSummary) _then;

/// Create a copy of AreaSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? area = null,Object? count = null,Object? percent = null,}) {
  return _then(_AreaSummary(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$GoalCard {

 String get id; String get title; LifeArea get area; GoalStatus get status; CalendarDate get startDate; CalendarDate get deadline; String? get reward; int get daysLeft; int get stepsDone; int get stepsTotal; int get overdueSteps; int get stepPercent; int get timePercent; bool get behind;
/// Create a copy of GoalCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCardCopyWith<GoalCard> get copyWith => _$GoalCardCopyWithImpl<GoalCard>(this as GoalCard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.reward, _this.reward) || other.reward == _this.reward)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft)&&(identical(other.stepsDone, _this.stepsDone) || other.stepsDone == _this.stepsDone)&&(identical(other.stepsTotal, _this.stepsTotal) || other.stepsTotal == _this.stepsTotal)&&(identical(other.overdueSteps, _this.overdueSteps) || other.overdueSteps == _this.overdueSteps)&&(identical(other.stepPercent, _this.stepPercent) || other.stepPercent == _this.stepPercent)&&(identical(other.timePercent, _this.timePercent) || other.timePercent == _this.timePercent)&&(identical(other.behind, _this.behind) || other.behind == _this.behind));
}


@override
int get hashCode {
  final _this = this as GoalCard;
  return Object.hash(runtimeType,_this.id,_this.title,_this.area,_this.status,_this.startDate,_this.deadline,_this.reward,_this.daysLeft,_this.stepsDone,_this.stepsTotal,_this.overdueSteps,_this.stepPercent,_this.timePercent,_this.behind);
}

@override
String toString() {
  final _this = this as GoalCard;
  return 'GoalCard(id: ${_this.id}, title: ${_this.title}, area: ${_this.area}, status: ${_this.status}, startDate: ${_this.startDate}, deadline: ${_this.deadline}, reward: ${_this.reward}, daysLeft: ${_this.daysLeft}, stepsDone: ${_this.stepsDone}, stepsTotal: ${_this.stepsTotal}, overdueSteps: ${_this.overdueSteps}, stepPercent: ${_this.stepPercent}, timePercent: ${_this.timePercent}, behind: ${_this.behind})';
}


}

/// @nodoc
abstract mixin class $GoalCardCopyWith<$Res>  {
  factory $GoalCardCopyWith(GoalCard value, $Res Function(GoalCard) _then) = _$GoalCardCopyWithImpl;
@useResult
$Res call({
 String id, String title, LifeArea area, GoalStatus status, CalendarDate startDate, CalendarDate deadline, String? reward, int daysLeft, int stepsDone, int stepsTotal, int overdueSteps, int stepPercent, int timePercent, bool behind
});




}
/// @nodoc
class _$GoalCardCopyWithImpl<$Res>
    implements $GoalCardCopyWith<$Res> {
  _$GoalCardCopyWithImpl(this._self, this._then);

  final GoalCard _self;
  final $Res Function(GoalCard) _then;

/// Create a copy of GoalCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? area = null,Object? status = null,Object? startDate = null,Object? deadline = null,Object? reward = freezed,Object? daysLeft = null,Object? stepsDone = null,Object? stepsTotal = null,Object? overdueSteps = null,Object? stepPercent = null,Object? timePercent = null,Object? behind = null,}) {
  return _then(GoalCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,stepsDone: null == stepsDone ? _self.stepsDone : stepsDone // ignore: cast_nullable_to_non_nullable
as int,stepsTotal: null == stepsTotal ? _self.stepsTotal : stepsTotal // ignore: cast_nullable_to_non_nullable
as int,overdueSteps: null == overdueSteps ? _self.overdueSteps : overdueSteps // ignore: cast_nullable_to_non_nullable
as int,stepPercent: null == stepPercent ? _self.stepPercent : stepPercent // ignore: cast_nullable_to_non_nullable
as int,timePercent: null == timePercent ? _self.timePercent : timePercent // ignore: cast_nullable_to_non_nullable
as int,behind: null == behind ? _self.behind : behind // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalCard].
extension GoalCardPatterns on GoalCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalCard value)  $default,){
final _that = this;
switch (_that) {
case _GoalCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalCard value)?  $default,){
final _that = this;
switch (_that) {
case _GoalCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  int daysLeft,  int stepsDone,  int stepsTotal,  int overdueSteps,  int stepPercent,  int timePercent,  bool behind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalCard() when $default != null:
return $default(_that.id,_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.daysLeft,_that.stepsDone,_that.stepsTotal,_that.overdueSteps,_that.stepPercent,_that.timePercent,_that.behind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  int daysLeft,  int stepsDone,  int stepsTotal,  int overdueSteps,  int stepPercent,  int timePercent,  bool behind)  $default,) {final _that = this;
switch (_that) {
case _GoalCard():
return $default(_that.id,_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.daysLeft,_that.stepsDone,_that.stepsTotal,_that.overdueSteps,_that.stepPercent,_that.timePercent,_that.behind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  int daysLeft,  int stepsDone,  int stepsTotal,  int overdueSteps,  int stepPercent,  int timePercent,  bool behind)?  $default,) {final _that = this;
switch (_that) {
case _GoalCard() when $default != null:
return $default(_that.id,_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.daysLeft,_that.stepsDone,_that.stepsTotal,_that.overdueSteps,_that.stepPercent,_that.timePercent,_that.behind);case _:
  return null;

}
}

}

/// @nodoc


class _GoalCard implements GoalCard {
  const _GoalCard({required this.id, required this.title, required this.area, required this.status, required this.startDate, required this.deadline, this.reward, required this.daysLeft, required this.stepsDone, required this.stepsTotal, required this.overdueSteps, required this.stepPercent, required this.timePercent, required this.behind});
  

@override final  String id;
@override final  String title;
@override final  LifeArea area;
@override final  GoalStatus status;
@override final  CalendarDate startDate;
@override final  CalendarDate deadline;
@override final  String? reward;
@override final  int daysLeft;
@override final  int stepsDone;
@override final  int stepsTotal;
@override final  int overdueSteps;
@override final  int stepPercent;
@override final  int timePercent;
@override final  bool behind;

/// Create a copy of GoalCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalCardCopyWith<_GoalCard> get copyWith => __$GoalCardCopyWithImpl<_GoalCard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.area, area) || other.area == area)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.stepsDone, stepsDone) || other.stepsDone == stepsDone)&&(identical(other.stepsTotal, stepsTotal) || other.stepsTotal == stepsTotal)&&(identical(other.overdueSteps, overdueSteps) || other.overdueSteps == overdueSteps)&&(identical(other.stepPercent, stepPercent) || other.stepPercent == stepPercent)&&(identical(other.timePercent, timePercent) || other.timePercent == timePercent)&&(identical(other.behind, behind) || other.behind == behind));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,area,status,startDate,deadline,reward,daysLeft,stepsDone,stepsTotal,overdueSteps,stepPercent,timePercent,behind);
}

@override
String toString() {
    return 'GoalCard(id: $id, title: $title, area: $area, status: $status, startDate: $startDate, deadline: $deadline, reward: $reward, daysLeft: $daysLeft, stepsDone: $stepsDone, stepsTotal: $stepsTotal, overdueSteps: $overdueSteps, stepPercent: $stepPercent, timePercent: $timePercent, behind: $behind)';
}


}

/// @nodoc
abstract mixin class _$GoalCardCopyWith<$Res> implements $GoalCardCopyWith<$Res> {
  factory _$GoalCardCopyWith(_GoalCard value, $Res Function(_GoalCard) _then) = __$GoalCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, LifeArea area, GoalStatus status, CalendarDate startDate, CalendarDate deadline, String? reward, int daysLeft, int stepsDone, int stepsTotal, int overdueSteps, int stepPercent, int timePercent, bool behind
});




}
/// @nodoc
class __$GoalCardCopyWithImpl<$Res>
    implements _$GoalCardCopyWith<$Res> {
  __$GoalCardCopyWithImpl(this._self, this._then);

  final _GoalCard _self;
  final $Res Function(_GoalCard) _then;

/// Create a copy of GoalCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? area = null,Object? status = null,Object? startDate = null,Object? deadline = null,Object? reward = freezed,Object? daysLeft = null,Object? stepsDone = null,Object? stepsTotal = null,Object? overdueSteps = null,Object? stepPercent = null,Object? timePercent = null,Object? behind = null,}) {
  return _then(_GoalCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,stepsDone: null == stepsDone ? _self.stepsDone : stepsDone // ignore: cast_nullable_to_non_nullable
as int,stepsTotal: null == stepsTotal ? _self.stepsTotal : stepsTotal // ignore: cast_nullable_to_non_nullable
as int,overdueSteps: null == overdueSteps ? _self.overdueSteps : overdueSteps // ignore: cast_nullable_to_non_nullable
as int,stepPercent: null == stepPercent ? _self.stepPercent : stepPercent // ignore: cast_nullable_to_non_nullable
as int,timePercent: null == timePercent ? _self.timePercent : timePercent // ignore: cast_nullable_to_non_nullable
as int,behind: null == behind ? _self.behind : behind // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$GoalBoard {

 int get done; int get total; int get percent; List<AreaSummary> get areas; List<GoalCard> get goals;
/// Create a copy of GoalBoard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalBoardCopyWith<GoalBoard> get copyWith => _$GoalBoardCopyWithImpl<GoalBoard>(this as GoalBoard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalBoard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalBoard&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&const DeepCollectionEquality().equals(other.areas, _this.areas)&&const DeepCollectionEquality().equals(other.goals, _this.goals));
}


@override
int get hashCode {
  final _this = this as GoalBoard;
  return Object.hash(runtimeType,_this.done,_this.total,_this.percent,const DeepCollectionEquality().hash(_this.areas),const DeepCollectionEquality().hash(_this.goals));
}

@override
String toString() {
  final _this = this as GoalBoard;
  return 'GoalBoard(done: ${_this.done}, total: ${_this.total}, percent: ${_this.percent}, areas: ${_this.areas}, goals: ${_this.goals})';
}


}

/// @nodoc
abstract mixin class $GoalBoardCopyWith<$Res>  {
  factory $GoalBoardCopyWith(GoalBoard value, $Res Function(GoalBoard) _then) = _$GoalBoardCopyWithImpl;
@useResult
$Res call({
 int done, int total, int percent, List<AreaSummary> areas, List<GoalCard> goals
});




}
/// @nodoc
class _$GoalBoardCopyWithImpl<$Res>
    implements $GoalBoardCopyWith<$Res> {
  _$GoalBoardCopyWithImpl(this._self, this._then);

  final GoalBoard _self;
  final $Res Function(GoalBoard) _then;

/// Create a copy of GoalBoard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? done = null,Object? total = null,Object? percent = null,Object? areas = null,Object? goals = null,}) {
  return _then(GoalBoard(
done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,areas: null == areas ? _self.areas : areas // ignore: cast_nullable_to_non_nullable
as List<AreaSummary>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalCard>,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalBoard].
extension GoalBoardPatterns on GoalBoard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalBoard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalBoard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalBoard value)  $default,){
final _that = this;
switch (_that) {
case _GoalBoard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalBoard value)?  $default,){
final _that = this;
switch (_that) {
case _GoalBoard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int done,  int total,  int percent,  List<AreaSummary> areas,  List<GoalCard> goals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalBoard() when $default != null:
return $default(_that.done,_that.total,_that.percent,_that.areas,_that.goals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int done,  int total,  int percent,  List<AreaSummary> areas,  List<GoalCard> goals)  $default,) {final _that = this;
switch (_that) {
case _GoalBoard():
return $default(_that.done,_that.total,_that.percent,_that.areas,_that.goals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int done,  int total,  int percent,  List<AreaSummary> areas,  List<GoalCard> goals)?  $default,) {final _that = this;
switch (_that) {
case _GoalBoard() when $default != null:
return $default(_that.done,_that.total,_that.percent,_that.areas,_that.goals);case _:
  return null;

}
}

}

/// @nodoc


class _GoalBoard implements GoalBoard {
  const _GoalBoard({required this.done, required this.total, required this.percent, required  List<AreaSummary> areas, required  List<GoalCard> goals}): _areas = areas,_goals = goals;
  

@override final  int done;
@override final  int total;
@override final  int percent;
 final  List<AreaSummary> _areas;
@override List<AreaSummary> get areas {
  if (_areas is EqualUnmodifiableListView) return _areas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_areas);
}

 final  List<GoalCard> _goals;
@override List<GoalCard> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}


/// Create a copy of GoalBoard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalBoardCopyWith<_GoalBoard> get copyWith => __$GoalBoardCopyWithImpl<_GoalBoard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalBoard&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent)&&const DeepCollectionEquality().equals(other.areas, _areas)&&const DeepCollectionEquality().equals(other.goals, _goals));
}


@override
int get hashCode {
    return Object.hash(runtimeType,done,total,percent,const DeepCollectionEquality().hash(_areas),const DeepCollectionEquality().hash(_goals));
}

@override
String toString() {
    return 'GoalBoard(done: $done, total: $total, percent: $percent, areas: $areas, goals: $goals)';
}


}

/// @nodoc
abstract mixin class _$GoalBoardCopyWith<$Res> implements $GoalBoardCopyWith<$Res> {
  factory _$GoalBoardCopyWith(_GoalBoard value, $Res Function(_GoalBoard) _then) = __$GoalBoardCopyWithImpl;
@override @useResult
$Res call({
 int done, int total, int percent, List<AreaSummary> areas, List<GoalCard> goals
});




}
/// @nodoc
class __$GoalBoardCopyWithImpl<$Res>
    implements _$GoalBoardCopyWith<$Res> {
  __$GoalBoardCopyWithImpl(this._self, this._then);

  final _GoalBoard _self;
  final $Res Function(_GoalBoard) _then;

/// Create a copy of GoalBoard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? done = null,Object? total = null,Object? percent = null,Object? areas = null,Object? goals = null,}) {
  return _then(_GoalBoard(
done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,areas: null == areas ? _self._areas : areas // ignore: cast_nullable_to_non_nullable
as List<AreaSummary>,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalCard>,
  ));
}


}

/// @nodoc
mixin _$GoalStep {

 String get id; String get title; CalendarDate? get deadline; bool get done; int get order;
/// Create a copy of GoalStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalStepCopyWith<GoalStep> get copyWith => _$GoalStepCopyWithImpl<GoalStep>(this as GoalStep, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalStep&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.order, _this.order) || other.order == _this.order));
}


@override
int get hashCode {
  final _this = this as GoalStep;
  return Object.hash(runtimeType,_this.id,_this.title,_this.deadline,_this.done,_this.order);
}

@override
String toString() {
  final _this = this as GoalStep;
  return 'GoalStep(id: ${_this.id}, title: ${_this.title}, deadline: ${_this.deadline}, done: ${_this.done}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $GoalStepCopyWith<$Res>  {
  factory $GoalStepCopyWith(GoalStep value, $Res Function(GoalStep) _then) = _$GoalStepCopyWithImpl;
@useResult
$Res call({
 String id, String title, CalendarDate? deadline, bool done, int order
});




}
/// @nodoc
class _$GoalStepCopyWithImpl<$Res>
    implements $GoalStepCopyWith<$Res> {
  _$GoalStepCopyWithImpl(this._self, this._then);

  final GoalStep _self;
  final $Res Function(GoalStep) _then;

/// Create a copy of GoalStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? deadline = freezed,Object? done = null,Object? order = null,}) {
  return _then(GoalStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalStep].
extension GoalStepPatterns on GoalStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalStep value)  $default,){
final _that = this;
switch (_that) {
case _GoalStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalStep value)?  $default,){
final _that = this;
switch (_that) {
case _GoalStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  CalendarDate? deadline,  bool done,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalStep() when $default != null:
return $default(_that.id,_that.title,_that.deadline,_that.done,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  CalendarDate? deadline,  bool done,  int order)  $default,) {final _that = this;
switch (_that) {
case _GoalStep():
return $default(_that.id,_that.title,_that.deadline,_that.done,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  CalendarDate? deadline,  bool done,  int order)?  $default,) {final _that = this;
switch (_that) {
case _GoalStep() when $default != null:
return $default(_that.id,_that.title,_that.deadline,_that.done,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _GoalStep implements GoalStep {
  const _GoalStep({required this.id, required this.title, this.deadline, required this.done, required this.order});
  

@override final  String id;
@override final  String title;
@override final  CalendarDate? deadline;
@override final  bool done;
@override final  int order;

/// Create a copy of GoalStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalStepCopyWith<_GoalStep> get copyWith => __$GoalStepCopyWithImpl<_GoalStep>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.done, done) || other.done == done)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,deadline,done,order);
}

@override
String toString() {
    return 'GoalStep(id: $id, title: $title, deadline: $deadline, done: $done, order: $order)';
}


}

/// @nodoc
abstract mixin class _$GoalStepCopyWith<$Res> implements $GoalStepCopyWith<$Res> {
  factory _$GoalStepCopyWith(_GoalStep value, $Res Function(_GoalStep) _then) = __$GoalStepCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, CalendarDate? deadline, bool done, int order
});




}
/// @nodoc
class __$GoalStepCopyWithImpl<$Res>
    implements _$GoalStepCopyWith<$Res> {
  __$GoalStepCopyWithImpl(this._self, this._then);

  final _GoalStep _self;
  final $Res Function(_GoalStep) _then;

/// Create a copy of GoalStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? deadline = freezed,Object? done = null,Object? order = null,}) {
  return _then(_GoalStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Goal {

 String get id; String get title; LifeArea get area; GoalStatus get status; CalendarDate get startDate; CalendarDate get deadline; String? get reward; String? get why; List<GoalStep> get steps;
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCopyWith<Goal> get copyWith => _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Goal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Goal&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.reward, _this.reward) || other.reward == _this.reward)&&(identical(other.why, _this.why) || other.why == _this.why)&&const DeepCollectionEquality().equals(other.steps, _this.steps));
}


@override
int get hashCode {
  final _this = this as Goal;
  return Object.hash(runtimeType,_this.id,_this.title,_this.area,_this.status,_this.startDate,_this.deadline,_this.reward,_this.why,const DeepCollectionEquality().hash(_this.steps));
}

@override
String toString() {
  final _this = this as Goal;
  return 'Goal(id: ${_this.id}, title: ${_this.title}, area: ${_this.area}, status: ${_this.status}, startDate: ${_this.startDate}, deadline: ${_this.deadline}, reward: ${_this.reward}, why: ${_this.why}, steps: ${_this.steps})';
}


}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res>  {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) = _$GoalCopyWithImpl;
@useResult
$Res call({
 String id, String title, LifeArea area, GoalStatus status, CalendarDate startDate, CalendarDate deadline, String? reward, String? why, List<GoalStep> steps
});




}
/// @nodoc
class _$GoalCopyWithImpl<$Res>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? area = null,Object? status = null,Object? startDate = null,Object? deadline = null,Object? reward = freezed,Object? why = freezed,Object? steps = null,}) {
  return _then(Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,why: freezed == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<GoalStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Goal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Goal value)  $default,){
final _that = this;
switch (_that) {
case _Goal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Goal value)?  $default,){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  String? why,  List<GoalStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.why,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  String? why,  List<GoalStep> steps)  $default,) {final _that = this;
switch (_that) {
case _Goal():
return $default(_that.id,_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.why,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  String? why,  List<GoalStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.why,_that.steps);case _:
  return null;

}
}

}

/// @nodoc


class _Goal implements Goal {
  const _Goal({required this.id, required this.title, required this.area, required this.status, required this.startDate, required this.deadline, this.reward, this.why, required  List<GoalStep> steps}): _steps = steps;
  

@override final  String id;
@override final  String title;
@override final  LifeArea area;
@override final  GoalStatus status;
@override final  CalendarDate startDate;
@override final  CalendarDate deadline;
@override final  String? reward;
@override final  String? why;
 final  List<GoalStep> _steps;
@override List<GoalStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalCopyWith<_Goal> get copyWith => __$GoalCopyWithImpl<_Goal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.area, area) || other.area == area)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.why, why) || other.why == why)&&const DeepCollectionEquality().equals(other.steps, _steps));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,area,status,startDate,deadline,reward,why,const DeepCollectionEquality().hash(_steps));
}

@override
String toString() {
    return 'Goal(id: $id, title: $title, area: $area, status: $status, startDate: $startDate, deadline: $deadline, reward: $reward, why: $why, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) = __$GoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, LifeArea area, GoalStatus status, CalendarDate startDate, CalendarDate deadline, String? reward, String? why, List<GoalStep> steps
});




}
/// @nodoc
class __$GoalCopyWithImpl<$Res>
    implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? area = null,Object? status = null,Object? startDate = null,Object? deadline = null,Object? reward = freezed,Object? why = freezed,Object? steps = null,}) {
  return _then(_Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,why: freezed == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<GoalStep>,
  ));
}


}

/// @nodoc
mixin _$GoalDraft {

 String get title; LifeArea get area; GoalStatus get status; CalendarDate get startDate; CalendarDate get deadline; String? get reward; String? get why;
/// Create a copy of GoalDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalDraftCopyWith<GoalDraft> get copyWith => _$GoalDraftCopyWithImpl<GoalDraft>(this as GoalDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalDraft&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.reward, _this.reward) || other.reward == _this.reward)&&(identical(other.why, _this.why) || other.why == _this.why));
}


@override
int get hashCode {
  final _this = this as GoalDraft;
  return Object.hash(runtimeType,_this.title,_this.area,_this.status,_this.startDate,_this.deadline,_this.reward,_this.why);
}

@override
String toString() {
  final _this = this as GoalDraft;
  return 'GoalDraft(title: ${_this.title}, area: ${_this.area}, status: ${_this.status}, startDate: ${_this.startDate}, deadline: ${_this.deadline}, reward: ${_this.reward}, why: ${_this.why})';
}


}

/// @nodoc
abstract mixin class $GoalDraftCopyWith<$Res>  {
  factory $GoalDraftCopyWith(GoalDraft value, $Res Function(GoalDraft) _then) = _$GoalDraftCopyWithImpl;
@useResult
$Res call({
 String title, LifeArea area, GoalStatus status, CalendarDate startDate, CalendarDate deadline, String? reward, String? why
});




}
/// @nodoc
class _$GoalDraftCopyWithImpl<$Res>
    implements $GoalDraftCopyWith<$Res> {
  _$GoalDraftCopyWithImpl(this._self, this._then);

  final GoalDraft _self;
  final $Res Function(GoalDraft) _then;

/// Create a copy of GoalDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? area = null,Object? status = null,Object? startDate = null,Object? deadline = null,Object? reward = freezed,Object? why = freezed,}) {
  return _then(GoalDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,why: freezed == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalDraft].
extension GoalDraftPatterns on GoalDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalDraft value)  $default,){
final _that = this;
switch (_that) {
case _GoalDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalDraft value)?  $default,){
final _that = this;
switch (_that) {
case _GoalDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  String? why)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalDraft() when $default != null:
return $default(_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.why);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  String? why)  $default,) {final _that = this;
switch (_that) {
case _GoalDraft():
return $default(_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.why);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  LifeArea area,  GoalStatus status,  CalendarDate startDate,  CalendarDate deadline,  String? reward,  String? why)?  $default,) {final _that = this;
switch (_that) {
case _GoalDraft() when $default != null:
return $default(_that.title,_that.area,_that.status,_that.startDate,_that.deadline,_that.reward,_that.why);case _:
  return null;

}
}

}

/// @nodoc


class _GoalDraft implements GoalDraft {
  const _GoalDraft({required this.title, required this.area, required this.status, required this.startDate, required this.deadline, this.reward, this.why});
  

@override final  String title;
@override final  LifeArea area;
@override final  GoalStatus status;
@override final  CalendarDate startDate;
@override final  CalendarDate deadline;
@override final  String? reward;
@override final  String? why;

/// Create a copy of GoalDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalDraftCopyWith<_GoalDraft> get copyWith => __$GoalDraftCopyWithImpl<_GoalDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.area, area) || other.area == area)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.why, why) || other.why == why));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,area,status,startDate,deadline,reward,why);
}

@override
String toString() {
    return 'GoalDraft(title: $title, area: $area, status: $status, startDate: $startDate, deadline: $deadline, reward: $reward, why: $why)';
}


}

/// @nodoc
abstract mixin class _$GoalDraftCopyWith<$Res> implements $GoalDraftCopyWith<$Res> {
  factory _$GoalDraftCopyWith(_GoalDraft value, $Res Function(_GoalDraft) _then) = __$GoalDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, LifeArea area, GoalStatus status, CalendarDate startDate, CalendarDate deadline, String? reward, String? why
});




}
/// @nodoc
class __$GoalDraftCopyWithImpl<$Res>
    implements _$GoalDraftCopyWith<$Res> {
  __$GoalDraftCopyWithImpl(this._self, this._then);

  final _GoalDraft _self;
  final $Res Function(_GoalDraft) _then;

/// Create a copy of GoalDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? area = null,Object? status = null,Object? startDate = null,Object? deadline = null,Object? reward = freezed,Object? why = freezed,}) {
  return _then(_GoalDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LifeArea,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as CalendarDate,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as CalendarDate,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,why: freezed == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
