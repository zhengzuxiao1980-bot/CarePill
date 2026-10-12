// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Medication {

 String get id; String get name; MedicationForm get form;/// 规格，如 "5mg×30片"。
 String? get spec;/// 打卡剂量单位：片/粒/毫升/喷/支。
 String get doseUnit;/// 备注（医嘱原文等）。
 String? get notes;/// 药盒照片（本地文件路径）。
 String? get photoPath; MedicationSource get source;/// AI 识别原始输出（纠错与回溯用）。
 String? get aiExtractJson; MedicationStatus get status; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Medication;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.form, _this.form) || other.form == _this.form)&&(identical(other.spec, _this.spec) || other.spec == _this.spec)&&(identical(other.doseUnit, _this.doseUnit) || other.doseUnit == _this.doseUnit)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.aiExtractJson, _this.aiExtractJson) || other.aiExtractJson == _this.aiExtractJson)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Medication;
  return Object.hash(runtimeType,_this.id,_this.name,_this.form,_this.spec,_this.doseUnit,_this.notes,_this.photoPath,_this.source,_this.aiExtractJson,_this.status,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Medication;
  return 'Medication(id: ${_this.id}, name: ${_this.name}, form: ${_this.form}, spec: ${_this.spec}, doseUnit: ${_this.doseUnit}, notes: ${_this.notes}, photoPath: ${_this.photoPath}, source: ${_this.source}, aiExtractJson: ${_this.aiExtractJson}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 String id, String name, MedicationForm form, String? spec, String doseUnit, String? notes, String? photoPath, MedicationSource source, String? aiExtractJson, MedicationStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? form = null,Object? spec = freezed,Object? doseUnit = null,Object? notes = freezed,Object? photoPath = freezed,Object? source = null,Object? aiExtractJson = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,spec: freezed == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as String?,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MedicationSource,aiExtractJson: freezed == aiExtractJson ? _self.aiExtractJson : aiExtractJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  MedicationForm form,  String? spec,  String doseUnit,  String? notes,  String? photoPath,  MedicationSource source,  String? aiExtractJson,  MedicationStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.form,_that.spec,_that.doseUnit,_that.notes,_that.photoPath,_that.source,_that.aiExtractJson,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  MedicationForm form,  String? spec,  String doseUnit,  String? notes,  String? photoPath,  MedicationSource source,  String? aiExtractJson,  MedicationStatus status,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.name,_that.form,_that.spec,_that.doseUnit,_that.notes,_that.photoPath,_that.source,_that.aiExtractJson,_that.status,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  MedicationForm form,  String? spec,  String doseUnit,  String? notes,  String? photoPath,  MedicationSource source,  String? aiExtractJson,  MedicationStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.form,_that.spec,_that.doseUnit,_that.notes,_that.photoPath,_that.source,_that.aiExtractJson,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Medication implements Medication {
  const _Medication({required this.id, required this.name, required this.form, this.spec, required this.doseUnit, this.notes, this.photoPath, required this.source, this.aiExtractJson, required this.status, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String name;
@override final  MedicationForm form;
/// 规格，如 "5mg×30片"。
@override final  String? spec;
/// 打卡剂量单位：片/粒/毫升/喷/支。
@override final  String doseUnit;
/// 备注（医嘱原文等）。
@override final  String? notes;
/// 药盒照片（本地文件路径）。
@override final  String? photoPath;
@override final  MedicationSource source;
/// AI 识别原始输出（纠错与回溯用）。
@override final  String? aiExtractJson;
@override final  MedicationStatus status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.form, form) || other.form == form)&&(identical(other.spec, spec) || other.spec == spec)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.source, source) || other.source == source)&&(identical(other.aiExtractJson, aiExtractJson) || other.aiExtractJson == aiExtractJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,form,spec,doseUnit,notes,photoPath,source,aiExtractJson,status,createdAt,updatedAt);
}

@override
String toString() {
    return 'Medication(id: $id, name: $name, form: $form, spec: $spec, doseUnit: $doseUnit, notes: $notes, photoPath: $photoPath, source: $source, aiExtractJson: $aiExtractJson, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, MedicationForm form, String? spec, String doseUnit, String? notes, String? photoPath, MedicationSource source, String? aiExtractJson, MedicationStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? form = null,Object? spec = freezed,Object? doseUnit = null,Object? notes = freezed,Object? photoPath = freezed,Object? source = null,Object? aiExtractJson = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,spec: freezed == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as String?,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MedicationSource,aiExtractJson: freezed == aiExtractJson ? _self.aiExtractJson : aiExtractJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
