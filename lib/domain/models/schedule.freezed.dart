// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeSlot {

/// HH:mm。
@JsonKey(name: 'time') String get time;@JsonKey(name: 'dose', includeIfNull: false) double? get dose;@JsonKey(name: 'meal', includeIfNull: false) MealRelation? get meal;
/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<TimeSlot> get copyWith => _$TimeSlotCopyWithImpl<TimeSlot>(this as TimeSlot, _$identity);

  /// Serializes this TimeSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimeSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSlot&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.dose, _this.dose) || other.dose == _this.dose)&&(identical(other.meal, _this.meal) || other.meal == _this.meal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimeSlot;
  return Object.hash(runtimeType,_this.time,_this.dose,_this.meal);
}

@override
String toString() {
  final _this = this as TimeSlot;
  return 'TimeSlot(time: ${_this.time}, dose: ${_this.dose}, meal: ${_this.meal})';
}


}

/// @nodoc
abstract mixin class $TimeSlotCopyWith<$Res>  {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) _then) = _$TimeSlotCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'time') String time,@JsonKey(name: 'dose', includeIfNull: false) double? dose,@JsonKey(name: 'meal', includeIfNull: false) MealRelation? meal
});




}
/// @nodoc
class _$TimeSlotCopyWithImpl<$Res>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._self, this._then);

  final TimeSlot _self;
  final $Res Function(TimeSlot) _then;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? dose = freezed,Object? meal = freezed,}) {
  return _then(TimeSlot(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,dose: freezed == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double?,meal: freezed == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealRelation?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSlot].
extension TimeSlotPatterns on TimeSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSlot value)  $default,){
final _that = this;
switch (_that) {
case _TimeSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'time')  String time, @JsonKey(name: 'dose', includeIfNull: false)  double? dose, @JsonKey(name: 'meal', includeIfNull: false)  MealRelation? meal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that.time,_that.dose,_that.meal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'time')  String time, @JsonKey(name: 'dose', includeIfNull: false)  double? dose, @JsonKey(name: 'meal', includeIfNull: false)  MealRelation? meal)  $default,) {final _that = this;
switch (_that) {
case _TimeSlot():
return $default(_that.time,_that.dose,_that.meal);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'time')  String time, @JsonKey(name: 'dose', includeIfNull: false)  double? dose, @JsonKey(name: 'meal', includeIfNull: false)  MealRelation? meal)?  $default,) {final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that.time,_that.dose,_that.meal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSlot implements TimeSlot {
  const _TimeSlot({@JsonKey(name: 'time') required this.time, @JsonKey(name: 'dose', includeIfNull: false) this.dose, @JsonKey(name: 'meal', includeIfNull: false) this.meal});
  factory _TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);

/// HH:mm。
@override@JsonKey(name: 'time') final  String time;
@override@JsonKey(name: 'dose', includeIfNull: false) final  double? dose;
@override@JsonKey(name: 'meal', includeIfNull: false) final  MealRelation? meal;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSlotCopyWith<_TimeSlot> get copyWith => __$TimeSlotCopyWithImpl<_TimeSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSlot&&(identical(other.time, time) || other.time == time)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.meal, meal) || other.meal == meal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,time,dose,meal);
}

@override
String toString() {
    return 'TimeSlot(time: $time, dose: $dose, meal: $meal)';
}


}

/// @nodoc
abstract mixin class _$TimeSlotCopyWith<$Res> implements $TimeSlotCopyWith<$Res> {
  factory _$TimeSlotCopyWith(_TimeSlot value, $Res Function(_TimeSlot) _then) = __$TimeSlotCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'time') String time,@JsonKey(name: 'dose', includeIfNull: false) double? dose,@JsonKey(name: 'meal', includeIfNull: false) MealRelation? meal
});




}
/// @nodoc
class __$TimeSlotCopyWithImpl<$Res>
    implements _$TimeSlotCopyWith<$Res> {
  __$TimeSlotCopyWithImpl(this._self, this._then);

  final _TimeSlot _self;
  final $Res Function(_TimeSlot) _then;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? dose = freezed,Object? meal = freezed,}) {
  return _then(_TimeSlot(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,dose: freezed == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double?,meal: freezed == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealRelation?,
  ));
}


}


/// @nodoc
mixin _$MedicationSchedule {

 String get id; String get medicationId; FrequencyType get frequencyType;/// frequencyType=weekdays 时用，如 [1,3,5]（周一=1）。
 List<int>? get weekdays;/// 隔 N 天，配 anchorDate 计算。
 int? get intervalDays;/// 间隔计算锚点（ISO 日期）。
 String? get anchorDate;/// 时刻数组；as_needed 为空。
@JsonKey(name: 'times') List<TimeSlot> get times;/// 计划级默认餐前/餐中/餐后（时刻级未指定时生效）。
 MealRelation? get mealRelation;/// 生效起始日（ISO 日期）。
 String get startDate;/// 疗程结束（可空=长期）。
 String? get endDate; ScheduleStatus get status; DateTime get createdAt;
/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<MedicationSchedule> get copyWith => _$MedicationScheduleCopyWithImpl<MedicationSchedule>(this as MedicationSchedule, _$identity);

  /// Serializes this MedicationSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicationSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationSchedule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.medicationId, _this.medicationId) || other.medicationId == _this.medicationId)&&(identical(other.frequencyType, _this.frequencyType) || other.frequencyType == _this.frequencyType)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&(identical(other.intervalDays, _this.intervalDays) || other.intervalDays == _this.intervalDays)&&(identical(other.anchorDate, _this.anchorDate) || other.anchorDate == _this.anchorDate)&&const DeepCollectionEquality().equals(other.times, _this.times)&&(identical(other.mealRelation, _this.mealRelation) || other.mealRelation == _this.mealRelation)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicationSchedule;
  return Object.hash(runtimeType,_this.id,_this.medicationId,_this.frequencyType,const DeepCollectionEquality().hash(_this.weekdays),_this.intervalDays,_this.anchorDate,const DeepCollectionEquality().hash(_this.times),_this.mealRelation,_this.startDate,_this.endDate,_this.status,_this.createdAt);
}

@override
String toString() {
  final _this = this as MedicationSchedule;
  return 'MedicationSchedule(id: ${_this.id}, medicationId: ${_this.medicationId}, frequencyType: ${_this.frequencyType}, weekdays: ${_this.weekdays}, intervalDays: ${_this.intervalDays}, anchorDate: ${_this.anchorDate}, times: ${_this.times}, mealRelation: ${_this.mealRelation}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, status: ${_this.status}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MedicationScheduleCopyWith<$Res>  {
  factory $MedicationScheduleCopyWith(MedicationSchedule value, $Res Function(MedicationSchedule) _then) = _$MedicationScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, FrequencyType frequencyType, List<int>? weekdays, int? intervalDays, String? anchorDate,@JsonKey(name: 'times') List<TimeSlot> times, MealRelation? mealRelation, String startDate, String? endDate, ScheduleStatus status, DateTime createdAt
});




}
/// @nodoc
class _$MedicationScheduleCopyWithImpl<$Res>
    implements $MedicationScheduleCopyWith<$Res> {
  _$MedicationScheduleCopyWithImpl(this._self, this._then);

  final MedicationSchedule _self;
  final $Res Function(MedicationSchedule) _then;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? frequencyType = null,Object? weekdays = freezed,Object? intervalDays = freezed,Object? anchorDate = freezed,Object? times = null,Object? mealRelation = freezed,Object? startDate = null,Object? endDate = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(MedicationSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,frequencyType: null == frequencyType ? _self.frequencyType : frequencyType // ignore: cast_nullable_to_non_nullable
as FrequencyType,weekdays: freezed == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>?,intervalDays: freezed == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int?,anchorDate: freezed == anchorDate ? _self.anchorDate : anchorDate // ignore: cast_nullable_to_non_nullable
as String?,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,mealRelation: freezed == mealRelation ? _self.mealRelation : mealRelation // ignore: cast_nullable_to_non_nullable
as MealRelation?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationSchedule].
extension MedicationSchedulePatterns on MedicationSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationSchedule value)  $default,){
final _that = this;
switch (_that) {
case _MedicationSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  FrequencyType frequencyType,  List<int>? weekdays,  int? intervalDays,  String? anchorDate, @JsonKey(name: 'times')  List<TimeSlot> times,  MealRelation? mealRelation,  String startDate,  String? endDate,  ScheduleStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.frequencyType,_that.weekdays,_that.intervalDays,_that.anchorDate,_that.times,_that.mealRelation,_that.startDate,_that.endDate,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  FrequencyType frequencyType,  List<int>? weekdays,  int? intervalDays,  String? anchorDate, @JsonKey(name: 'times')  List<TimeSlot> times,  MealRelation? mealRelation,  String startDate,  String? endDate,  ScheduleStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MedicationSchedule():
return $default(_that.id,_that.medicationId,_that.frequencyType,_that.weekdays,_that.intervalDays,_that.anchorDate,_that.times,_that.mealRelation,_that.startDate,_that.endDate,_that.status,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  FrequencyType frequencyType,  List<int>? weekdays,  int? intervalDays,  String? anchorDate, @JsonKey(name: 'times')  List<TimeSlot> times,  MealRelation? mealRelation,  String startDate,  String? endDate,  ScheduleStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.frequencyType,_that.weekdays,_that.intervalDays,_that.anchorDate,_that.times,_that.mealRelation,_that.startDate,_that.endDate,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationSchedule implements MedicationSchedule {
  const _MedicationSchedule({required this.id, required this.medicationId, required this.frequencyType,  List<int>? weekdays, this.intervalDays, this.anchorDate, @JsonKey(name: 'times')  List<TimeSlot> times = const [], this.mealRelation, required this.startDate, this.endDate, required this.status, required this.createdAt}): _weekdays = weekdays,_times = times;
  factory _MedicationSchedule.fromJson(Map<String, dynamic> json) => _$MedicationScheduleFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  FrequencyType frequencyType;
/// frequencyType=weekdays 时用，如 [1,3,5]（周一=1）。
 final  List<int>? _weekdays;
/// frequencyType=weekdays 时用，如 [1,3,5]（周一=1）。
@override List<int>? get weekdays {
  final value = _weekdays;
  if (value == null) return null;
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 隔 N 天，配 anchorDate 计算。
@override final  int? intervalDays;
/// 间隔计算锚点（ISO 日期）。
@override final  String? anchorDate;
/// 时刻数组；as_needed 为空。
 final  List<TimeSlot> _times;
/// 时刻数组；as_needed 为空。
@override@JsonKey(name: 'times') List<TimeSlot> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

/// 计划级默认餐前/餐中/餐后（时刻级未指定时生效）。
@override final  MealRelation? mealRelation;
/// 生效起始日（ISO 日期）。
@override final  String startDate;
/// 疗程结束（可空=长期）。
@override final  String? endDate;
@override final  ScheduleStatus status;
@override final  DateTime createdAt;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationScheduleCopyWith<_MedicationSchedule> get copyWith => __$MedicationScheduleCopyWithImpl<_MedicationSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.frequencyType, frequencyType) || other.frequencyType == frequencyType)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.anchorDate, anchorDate) || other.anchorDate == anchorDate)&&const DeepCollectionEquality().equals(other.times, _times)&&(identical(other.mealRelation, mealRelation) || other.mealRelation == mealRelation)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,medicationId,frequencyType,const DeepCollectionEquality().hash(_weekdays),intervalDays,anchorDate,const DeepCollectionEquality().hash(_times),mealRelation,startDate,endDate,status,createdAt);
}

@override
String toString() {
    return 'MedicationSchedule(id: $id, medicationId: $medicationId, frequencyType: $frequencyType, weekdays: $weekdays, intervalDays: $intervalDays, anchorDate: $anchorDate, times: $times, mealRelation: $mealRelation, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationScheduleCopyWith<$Res> implements $MedicationScheduleCopyWith<$Res> {
  factory _$MedicationScheduleCopyWith(_MedicationSchedule value, $Res Function(_MedicationSchedule) _then) = __$MedicationScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, FrequencyType frequencyType, List<int>? weekdays, int? intervalDays, String? anchorDate,@JsonKey(name: 'times') List<TimeSlot> times, MealRelation? mealRelation, String startDate, String? endDate, ScheduleStatus status, DateTime createdAt
});




}
/// @nodoc
class __$MedicationScheduleCopyWithImpl<$Res>
    implements _$MedicationScheduleCopyWith<$Res> {
  __$MedicationScheduleCopyWithImpl(this._self, this._then);

  final _MedicationSchedule _self;
  final $Res Function(_MedicationSchedule) _then;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? frequencyType = null,Object? weekdays = freezed,Object? intervalDays = freezed,Object? anchorDate = freezed,Object? times = null,Object? mealRelation = freezed,Object? startDate = null,Object? endDate = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_MedicationSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,frequencyType: null == frequencyType ? _self.frequencyType : frequencyType // ignore: cast_nullable_to_non_nullable
as FrequencyType,weekdays: freezed == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>?,intervalDays: freezed == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int?,anchorDate: freezed == anchorDate ? _self.anchorDate : anchorDate // ignore: cast_nullable_to_non_nullable
as String?,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,mealRelation: freezed == mealRelation ? _self.mealRelation : mealRelation // ignore: cast_nullable_to_non_nullable
as MealRelation?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
