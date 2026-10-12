// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dose_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoseTask {

 String get id; String get scheduleId; String get medicationId;/// 应服日期（ISO yyyy-MM-dd）。
 String get scheduledDate;/// 应服时刻（HH:mm）。
 String get scheduledTime; double get plannedDose; DoseStatus get status;/// 实际打卡时间（epoch ms）。
 int? get takenAt; MarkSource? get markSource;/// 备注（AI 代办时带回的"刚才吃的"之类）。
 String? get note;
/// Create a copy of DoseTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseTaskCopyWith<DoseTask> get copyWith => _$DoseTaskCopyWithImpl<DoseTask>(this as DoseTask, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DoseTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseTask&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.scheduleId, _this.scheduleId) || other.scheduleId == _this.scheduleId)&&(identical(other.medicationId, _this.medicationId) || other.medicationId == _this.medicationId)&&(identical(other.scheduledDate, _this.scheduledDate) || other.scheduledDate == _this.scheduledDate)&&(identical(other.scheduledTime, _this.scheduledTime) || other.scheduledTime == _this.scheduledTime)&&(identical(other.plannedDose, _this.plannedDose) || other.plannedDose == _this.plannedDose)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.takenAt, _this.takenAt) || other.takenAt == _this.takenAt)&&(identical(other.markSource, _this.markSource) || other.markSource == _this.markSource)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as DoseTask;
  return Object.hash(runtimeType,_this.id,_this.scheduleId,_this.medicationId,_this.scheduledDate,_this.scheduledTime,_this.plannedDose,_this.status,_this.takenAt,_this.markSource,_this.note);
}

@override
String toString() {
  final _this = this as DoseTask;
  return 'DoseTask(id: ${_this.id}, scheduleId: ${_this.scheduleId}, medicationId: ${_this.medicationId}, scheduledDate: ${_this.scheduledDate}, scheduledTime: ${_this.scheduledTime}, plannedDose: ${_this.plannedDose}, status: ${_this.status}, takenAt: ${_this.takenAt}, markSource: ${_this.markSource}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $DoseTaskCopyWith<$Res>  {
  factory $DoseTaskCopyWith(DoseTask value, $Res Function(DoseTask) _then) = _$DoseTaskCopyWithImpl;
@useResult
$Res call({
 String id, String scheduleId, String medicationId, String scheduledDate, String scheduledTime, double plannedDose, DoseStatus status, int? takenAt, MarkSource? markSource, String? note
});




}
/// @nodoc
class _$DoseTaskCopyWithImpl<$Res>
    implements $DoseTaskCopyWith<$Res> {
  _$DoseTaskCopyWithImpl(this._self, this._then);

  final DoseTask _self;
  final $Res Function(DoseTask) _then;

/// Create a copy of DoseTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduleId = null,Object? medicationId = null,Object? scheduledDate = null,Object? scheduledTime = null,Object? plannedDose = null,Object? status = null,Object? takenAt = freezed,Object? markSource = freezed,Object? note = freezed,}) {
  return _then(DoseTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String,plannedDose: null == plannedDose ? _self.plannedDose : plannedDose // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as int?,markSource: freezed == markSource ? _self.markSource : markSource // ignore: cast_nullable_to_non_nullable
as MarkSource?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DoseTask].
extension DoseTaskPatterns on DoseTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoseTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoseTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoseTask value)  $default,){
final _that = this;
switch (_that) {
case _DoseTask():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoseTask value)?  $default,){
final _that = this;
switch (_that) {
case _DoseTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scheduleId,  String medicationId,  String scheduledDate,  String scheduledTime,  double plannedDose,  DoseStatus status,  int? takenAt,  MarkSource? markSource,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoseTask() when $default != null:
return $default(_that.id,_that.scheduleId,_that.medicationId,_that.scheduledDate,_that.scheduledTime,_that.plannedDose,_that.status,_that.takenAt,_that.markSource,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scheduleId,  String medicationId,  String scheduledDate,  String scheduledTime,  double plannedDose,  DoseStatus status,  int? takenAt,  MarkSource? markSource,  String? note)  $default,) {final _that = this;
switch (_that) {
case _DoseTask():
return $default(_that.id,_that.scheduleId,_that.medicationId,_that.scheduledDate,_that.scheduledTime,_that.plannedDose,_that.status,_that.takenAt,_that.markSource,_that.note);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scheduleId,  String medicationId,  String scheduledDate,  String scheduledTime,  double plannedDose,  DoseStatus status,  int? takenAt,  MarkSource? markSource,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _DoseTask() when $default != null:
return $default(_that.id,_that.scheduleId,_that.medicationId,_that.scheduledDate,_that.scheduledTime,_that.plannedDose,_that.status,_that.takenAt,_that.markSource,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _DoseTask implements DoseTask {
  const _DoseTask({required this.id, required this.scheduleId, required this.medicationId, required this.scheduledDate, required this.scheduledTime, required this.plannedDose, required this.status, this.takenAt, this.markSource, this.note});
  

@override final  String id;
@override final  String scheduleId;
@override final  String medicationId;
/// 应服日期（ISO yyyy-MM-dd）。
@override final  String scheduledDate;
/// 应服时刻（HH:mm）。
@override final  String scheduledTime;
@override final  double plannedDose;
@override final  DoseStatus status;
/// 实际打卡时间（epoch ms）。
@override final  int? takenAt;
@override final  MarkSource? markSource;
/// 备注（AI 代办时带回的"刚才吃的"之类）。
@override final  String? note;

/// Create a copy of DoseTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseTaskCopyWith<_DoseTask> get copyWith => __$DoseTaskCopyWithImpl<_DoseTask>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoseTask&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.plannedDose, plannedDose) || other.plannedDose == plannedDose)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.markSource, markSource) || other.markSource == markSource)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,scheduleId,medicationId,scheduledDate,scheduledTime,plannedDose,status,takenAt,markSource,note);
}

@override
String toString() {
    return 'DoseTask(id: $id, scheduleId: $scheduleId, medicationId: $medicationId, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, plannedDose: $plannedDose, status: $status, takenAt: $takenAt, markSource: $markSource, note: $note)';
}


}

/// @nodoc
abstract mixin class _$DoseTaskCopyWith<$Res> implements $DoseTaskCopyWith<$Res> {
  factory _$DoseTaskCopyWith(_DoseTask value, $Res Function(_DoseTask) _then) = __$DoseTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String scheduleId, String medicationId, String scheduledDate, String scheduledTime, double plannedDose, DoseStatus status, int? takenAt, MarkSource? markSource, String? note
});




}
/// @nodoc
class __$DoseTaskCopyWithImpl<$Res>
    implements _$DoseTaskCopyWith<$Res> {
  __$DoseTaskCopyWithImpl(this._self, this._then);

  final _DoseTask _self;
  final $Res Function(_DoseTask) _then;

/// Create a copy of DoseTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduleId = null,Object? medicationId = null,Object? scheduledDate = null,Object? scheduledTime = null,Object? plannedDose = null,Object? status = null,Object? takenAt = freezed,Object? markSource = freezed,Object? note = freezed,}) {
  return _then(_DoseTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String,plannedDose: null == plannedDose ? _self.plannedDose : plannedDose // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as int?,markSource: freezed == markSource ? _self.markSource : markSource // ignore: cast_nullable_to_non_nullable
as MarkSource?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
