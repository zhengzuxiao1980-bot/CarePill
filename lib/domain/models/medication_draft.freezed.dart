// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationDraftPayload {

@JsonKey(name: 'name') String? get name;@JsonKey(name: 'form') MedicationForm? get form;@JsonKey(name: 'spec') String? get spec;@JsonKey(name: 'dose_unit') String? get doseUnit;/// 用法用量原文——必须原样保留并在确认页展示，供对照原图核对。
@JsonKey(name: 'usage_text') String? get usageText;@JsonKey(name: 'per_dose') double? get perDose;@JsonKey(name: 'times') List<TimeSlot> get times;/// 频次原文，如"每日两次"。
@JsonKey(name: 'frequency_hint') String? get frequencyHint;/// 注意事项原文。
@JsonKey(name: 'notes') String? get notes;/// 置信存疑字段名列表，确认页高亮"请核对"（docs/03 §6）。
@JsonKey(name: 'uncertain') List<String> get uncertain;
/// Create a copy of MedicationDraftPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationDraftPayloadCopyWith<MedicationDraftPayload> get copyWith => _$MedicationDraftPayloadCopyWithImpl<MedicationDraftPayload>(this as MedicationDraftPayload, _$identity);

  /// Serializes this MedicationDraftPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicationDraftPayload;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationDraftPayload&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.form, _this.form) || other.form == _this.form)&&(identical(other.spec, _this.spec) || other.spec == _this.spec)&&(identical(other.doseUnit, _this.doseUnit) || other.doseUnit == _this.doseUnit)&&(identical(other.usageText, _this.usageText) || other.usageText == _this.usageText)&&(identical(other.perDose, _this.perDose) || other.perDose == _this.perDose)&&const DeepCollectionEquality().equals(other.times, _this.times)&&(identical(other.frequencyHint, _this.frequencyHint) || other.frequencyHint == _this.frequencyHint)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.uncertain, _this.uncertain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicationDraftPayload;
  return Object.hash(runtimeType,_this.name,_this.form,_this.spec,_this.doseUnit,_this.usageText,_this.perDose,const DeepCollectionEquality().hash(_this.times),_this.frequencyHint,_this.notes,const DeepCollectionEquality().hash(_this.uncertain));
}

@override
String toString() {
  final _this = this as MedicationDraftPayload;
  return 'MedicationDraftPayload(name: ${_this.name}, form: ${_this.form}, spec: ${_this.spec}, doseUnit: ${_this.doseUnit}, usageText: ${_this.usageText}, perDose: ${_this.perDose}, times: ${_this.times}, frequencyHint: ${_this.frequencyHint}, notes: ${_this.notes}, uncertain: ${_this.uncertain})';
}


}

/// @nodoc
abstract mixin class $MedicationDraftPayloadCopyWith<$Res>  {
  factory $MedicationDraftPayloadCopyWith(MedicationDraftPayload value, $Res Function(MedicationDraftPayload) _then) = _$MedicationDraftPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'form') MedicationForm? form,@JsonKey(name: 'spec') String? spec,@JsonKey(name: 'dose_unit') String? doseUnit,@JsonKey(name: 'usage_text') String? usageText,@JsonKey(name: 'per_dose') double? perDose,@JsonKey(name: 'times') List<TimeSlot> times,@JsonKey(name: 'frequency_hint') String? frequencyHint,@JsonKey(name: 'notes') String? notes,@JsonKey(name: 'uncertain') List<String> uncertain
});




}
/// @nodoc
class _$MedicationDraftPayloadCopyWithImpl<$Res>
    implements $MedicationDraftPayloadCopyWith<$Res> {
  _$MedicationDraftPayloadCopyWithImpl(this._self, this._then);

  final MedicationDraftPayload _self;
  final $Res Function(MedicationDraftPayload) _then;

/// Create a copy of MedicationDraftPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? form = freezed,Object? spec = freezed,Object? doseUnit = freezed,Object? usageText = freezed,Object? perDose = freezed,Object? times = null,Object? frequencyHint = freezed,Object? notes = freezed,Object? uncertain = null,}) {
  return _then(MedicationDraftPayload(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,form: freezed == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm?,spec: freezed == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as String?,doseUnit: freezed == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String?,usageText: freezed == usageText ? _self.usageText : usageText // ignore: cast_nullable_to_non_nullable
as String?,perDose: freezed == perDose ? _self.perDose : perDose // ignore: cast_nullable_to_non_nullable
as double?,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,frequencyHint: freezed == frequencyHint ? _self.frequencyHint : frequencyHint // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,uncertain: null == uncertain ? _self.uncertain : uncertain // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationDraftPayload].
extension MedicationDraftPayloadPatterns on MedicationDraftPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationDraftPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationDraftPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationDraftPayload value)  $default,){
final _that = this;
switch (_that) {
case _MedicationDraftPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationDraftPayload value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationDraftPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'form')  MedicationForm? form, @JsonKey(name: 'spec')  String? spec, @JsonKey(name: 'dose_unit')  String? doseUnit, @JsonKey(name: 'usage_text')  String? usageText, @JsonKey(name: 'per_dose')  double? perDose, @JsonKey(name: 'times')  List<TimeSlot> times, @JsonKey(name: 'frequency_hint')  String? frequencyHint, @JsonKey(name: 'notes')  String? notes, @JsonKey(name: 'uncertain')  List<String> uncertain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationDraftPayload() when $default != null:
return $default(_that.name,_that.form,_that.spec,_that.doseUnit,_that.usageText,_that.perDose,_that.times,_that.frequencyHint,_that.notes,_that.uncertain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'form')  MedicationForm? form, @JsonKey(name: 'spec')  String? spec, @JsonKey(name: 'dose_unit')  String? doseUnit, @JsonKey(name: 'usage_text')  String? usageText, @JsonKey(name: 'per_dose')  double? perDose, @JsonKey(name: 'times')  List<TimeSlot> times, @JsonKey(name: 'frequency_hint')  String? frequencyHint, @JsonKey(name: 'notes')  String? notes, @JsonKey(name: 'uncertain')  List<String> uncertain)  $default,) {final _that = this;
switch (_that) {
case _MedicationDraftPayload():
return $default(_that.name,_that.form,_that.spec,_that.doseUnit,_that.usageText,_that.perDose,_that.times,_that.frequencyHint,_that.notes,_that.uncertain);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'form')  MedicationForm? form, @JsonKey(name: 'spec')  String? spec, @JsonKey(name: 'dose_unit')  String? doseUnit, @JsonKey(name: 'usage_text')  String? usageText, @JsonKey(name: 'per_dose')  double? perDose, @JsonKey(name: 'times')  List<TimeSlot> times, @JsonKey(name: 'frequency_hint')  String? frequencyHint, @JsonKey(name: 'notes')  String? notes, @JsonKey(name: 'uncertain')  List<String> uncertain)?  $default,) {final _that = this;
switch (_that) {
case _MedicationDraftPayload() when $default != null:
return $default(_that.name,_that.form,_that.spec,_that.doseUnit,_that.usageText,_that.perDose,_that.times,_that.frequencyHint,_that.notes,_that.uncertain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationDraftPayload implements MedicationDraftPayload {
  const _MedicationDraftPayload({@JsonKey(name: 'name') this.name, @JsonKey(name: 'form') this.form, @JsonKey(name: 'spec') this.spec, @JsonKey(name: 'dose_unit') this.doseUnit, @JsonKey(name: 'usage_text') this.usageText, @JsonKey(name: 'per_dose') this.perDose, @JsonKey(name: 'times')  List<TimeSlot> times = const [], @JsonKey(name: 'frequency_hint') this.frequencyHint, @JsonKey(name: 'notes') this.notes, @JsonKey(name: 'uncertain')  List<String> uncertain = const []}): _times = times,_uncertain = uncertain;
  factory _MedicationDraftPayload.fromJson(Map<String, dynamic> json) => _$MedicationDraftPayloadFromJson(json);

@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'form') final  MedicationForm? form;
@override@JsonKey(name: 'spec') final  String? spec;
@override@JsonKey(name: 'dose_unit') final  String? doseUnit;
/// 用法用量原文——必须原样保留并在确认页展示，供对照原图核对。
@override@JsonKey(name: 'usage_text') final  String? usageText;
@override@JsonKey(name: 'per_dose') final  double? perDose;
 final  List<TimeSlot> _times;
@override@JsonKey(name: 'times') List<TimeSlot> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

/// 频次原文，如"每日两次"。
@override@JsonKey(name: 'frequency_hint') final  String? frequencyHint;
/// 注意事项原文。
@override@JsonKey(name: 'notes') final  String? notes;
/// 置信存疑字段名列表，确认页高亮"请核对"（docs/03 §6）。
 final  List<String> _uncertain;
/// 置信存疑字段名列表，确认页高亮"请核对"（docs/03 §6）。
@override@JsonKey(name: 'uncertain') List<String> get uncertain {
  if (_uncertain is EqualUnmodifiableListView) return _uncertain;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uncertain);
}


/// Create a copy of MedicationDraftPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationDraftPayloadCopyWith<_MedicationDraftPayload> get copyWith => __$MedicationDraftPayloadCopyWithImpl<_MedicationDraftPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationDraftPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationDraftPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.form, form) || other.form == form)&&(identical(other.spec, spec) || other.spec == spec)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.usageText, usageText) || other.usageText == usageText)&&(identical(other.perDose, perDose) || other.perDose == perDose)&&const DeepCollectionEquality().equals(other.times, _times)&&(identical(other.frequencyHint, frequencyHint) || other.frequencyHint == frequencyHint)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.uncertain, _uncertain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,form,spec,doseUnit,usageText,perDose,const DeepCollectionEquality().hash(_times),frequencyHint,notes,const DeepCollectionEquality().hash(_uncertain));
}

@override
String toString() {
    return 'MedicationDraftPayload(name: $name, form: $form, spec: $spec, doseUnit: $doseUnit, usageText: $usageText, perDose: $perDose, times: $times, frequencyHint: $frequencyHint, notes: $notes, uncertain: $uncertain)';
}


}

/// @nodoc
abstract mixin class _$MedicationDraftPayloadCopyWith<$Res> implements $MedicationDraftPayloadCopyWith<$Res> {
  factory _$MedicationDraftPayloadCopyWith(_MedicationDraftPayload value, $Res Function(_MedicationDraftPayload) _then) = __$MedicationDraftPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'form') MedicationForm? form,@JsonKey(name: 'spec') String? spec,@JsonKey(name: 'dose_unit') String? doseUnit,@JsonKey(name: 'usage_text') String? usageText,@JsonKey(name: 'per_dose') double? perDose,@JsonKey(name: 'times') List<TimeSlot> times,@JsonKey(name: 'frequency_hint') String? frequencyHint,@JsonKey(name: 'notes') String? notes,@JsonKey(name: 'uncertain') List<String> uncertain
});




}
/// @nodoc
class __$MedicationDraftPayloadCopyWithImpl<$Res>
    implements _$MedicationDraftPayloadCopyWith<$Res> {
  __$MedicationDraftPayloadCopyWithImpl(this._self, this._then);

  final _MedicationDraftPayload _self;
  final $Res Function(_MedicationDraftPayload) _then;

/// Create a copy of MedicationDraftPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? form = freezed,Object? spec = freezed,Object? doseUnit = freezed,Object? usageText = freezed,Object? perDose = freezed,Object? times = null,Object? frequencyHint = freezed,Object? notes = freezed,Object? uncertain = null,}) {
  return _then(_MedicationDraftPayload(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,form: freezed == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm?,spec: freezed == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as String?,doseUnit: freezed == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String?,usageText: freezed == usageText ? _self.usageText : usageText // ignore: cast_nullable_to_non_nullable
as String?,perDose: freezed == perDose ? _self.perDose : perDose // ignore: cast_nullable_to_non_nullable
as double?,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,frequencyHint: freezed == frequencyHint ? _self.frequencyHint : frequencyHint // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,uncertain: null == uncertain ? _self._uncertain : uncertain // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$VisionExtractResult {

@JsonKey(name: 'not_readable') bool get notReadable;@JsonKey(name: 'medication') MedicationDraftPayload? get medication;
/// Create a copy of VisionExtractResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionExtractResultCopyWith<VisionExtractResult> get copyWith => _$VisionExtractResultCopyWithImpl<VisionExtractResult>(this as VisionExtractResult, _$identity);

  /// Serializes this VisionExtractResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VisionExtractResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionExtractResult&&(identical(other.notReadable, _this.notReadable) || other.notReadable == _this.notReadable)&&(identical(other.medication, _this.medication) || other.medication == _this.medication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VisionExtractResult;
  return Object.hash(runtimeType,_this.notReadable,_this.medication);
}

@override
String toString() {
  final _this = this as VisionExtractResult;
  return 'VisionExtractResult(notReadable: ${_this.notReadable}, medication: ${_this.medication})';
}


}

/// @nodoc
abstract mixin class $VisionExtractResultCopyWith<$Res>  {
  factory $VisionExtractResultCopyWith(VisionExtractResult value, $Res Function(VisionExtractResult) _then) = _$VisionExtractResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'not_readable') bool notReadable,@JsonKey(name: 'medication') MedicationDraftPayload? medication
});


$MedicationDraftPayloadCopyWith<$Res>? get medication;

}
/// @nodoc
class _$VisionExtractResultCopyWithImpl<$Res>
    implements $VisionExtractResultCopyWith<$Res> {
  _$VisionExtractResultCopyWithImpl(this._self, this._then);

  final VisionExtractResult _self;
  final $Res Function(VisionExtractResult) _then;

/// Create a copy of VisionExtractResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notReadable = null,Object? medication = freezed,}) {
  return _then(VisionExtractResult(
notReadable: null == notReadable ? _self.notReadable : notReadable // ignore: cast_nullable_to_non_nullable
as bool,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as MedicationDraftPayload?,
  ));
}
/// Create a copy of VisionExtractResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDraftPayloadCopyWith<$Res>? get medication {
    if (_self.medication == null) {
    return null;
  }

  return $MedicationDraftPayloadCopyWith<$Res>(_self.medication!, (value) {
    return _then(_self.copyWith(medication: value));
  });
}
}


/// Adds pattern-matching-related methods to [VisionExtractResult].
extension VisionExtractResultPatterns on VisionExtractResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisionExtractResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisionExtractResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisionExtractResult value)  $default,){
final _that = this;
switch (_that) {
case _VisionExtractResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisionExtractResult value)?  $default,){
final _that = this;
switch (_that) {
case _VisionExtractResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'not_readable')  bool notReadable, @JsonKey(name: 'medication')  MedicationDraftPayload? medication)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisionExtractResult() when $default != null:
return $default(_that.notReadable,_that.medication);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'not_readable')  bool notReadable, @JsonKey(name: 'medication')  MedicationDraftPayload? medication)  $default,) {final _that = this;
switch (_that) {
case _VisionExtractResult():
return $default(_that.notReadable,_that.medication);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'not_readable')  bool notReadable, @JsonKey(name: 'medication')  MedicationDraftPayload? medication)?  $default,) {final _that = this;
switch (_that) {
case _VisionExtractResult() when $default != null:
return $default(_that.notReadable,_that.medication);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisionExtractResult implements VisionExtractResult {
  const _VisionExtractResult({@JsonKey(name: 'not_readable') this.notReadable = false, @JsonKey(name: 'medication') this.medication});
  factory _VisionExtractResult.fromJson(Map<String, dynamic> json) => _$VisionExtractResultFromJson(json);

@override@JsonKey(name: 'not_readable') final  bool notReadable;
@override@JsonKey(name: 'medication') final  MedicationDraftPayload? medication;

/// Create a copy of VisionExtractResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisionExtractResultCopyWith<_VisionExtractResult> get copyWith => __$VisionExtractResultCopyWithImpl<_VisionExtractResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisionExtractResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisionExtractResult&&(identical(other.notReadable, notReadable) || other.notReadable == notReadable)&&(identical(other.medication, medication) || other.medication == medication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,notReadable,medication);
}

@override
String toString() {
    return 'VisionExtractResult(notReadable: $notReadable, medication: $medication)';
}


}

/// @nodoc
abstract mixin class _$VisionExtractResultCopyWith<$Res> implements $VisionExtractResultCopyWith<$Res> {
  factory _$VisionExtractResultCopyWith(_VisionExtractResult value, $Res Function(_VisionExtractResult) _then) = __$VisionExtractResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'not_readable') bool notReadable,@JsonKey(name: 'medication') MedicationDraftPayload? medication
});


@override $MedicationDraftPayloadCopyWith<$Res>? get medication;

}
/// @nodoc
class __$VisionExtractResultCopyWithImpl<$Res>
    implements _$VisionExtractResultCopyWith<$Res> {
  __$VisionExtractResultCopyWithImpl(this._self, this._then);

  final _VisionExtractResult _self;
  final $Res Function(_VisionExtractResult) _then;

/// Create a copy of VisionExtractResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notReadable = null,Object? medication = freezed,}) {
  return _then(_VisionExtractResult(
notReadable: null == notReadable ? _self.notReadable : notReadable // ignore: cast_nullable_to_non_nullable
as bool,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as MedicationDraftPayload?,
  ));
}

/// Create a copy of VisionExtractResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDraftPayloadCopyWith<$Res>? get medication {
    if (_self.medication == null) {
    return null;
  }

  return $MedicationDraftPayloadCopyWith<$Res>(_self.medication!, (value) {
    return _then(_self.copyWith(medication: value));
  });
}
}

/// @nodoc
mixin _$MedicationDraft {

 String get id; DraftSource get source; MedicationDraftPayload get payload; String? get photoPath; DraftStatus get status; DateTime get createdAt;
/// Create a copy of MedicationDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationDraftCopyWith<MedicationDraft> get copyWith => _$MedicationDraftCopyWithImpl<MedicationDraft>(this as MedicationDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MedicationDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationDraft&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.payload, _this.payload) || other.payload == _this.payload)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as MedicationDraft;
  return Object.hash(runtimeType,_this.id,_this.source,_this.payload,_this.photoPath,_this.status,_this.createdAt);
}

@override
String toString() {
  final _this = this as MedicationDraft;
  return 'MedicationDraft(id: ${_this.id}, source: ${_this.source}, payload: ${_this.payload}, photoPath: ${_this.photoPath}, status: ${_this.status}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MedicationDraftCopyWith<$Res>  {
  factory $MedicationDraftCopyWith(MedicationDraft value, $Res Function(MedicationDraft) _then) = _$MedicationDraftCopyWithImpl;
@useResult
$Res call({
 String id, DraftSource source, MedicationDraftPayload payload, String? photoPath, DraftStatus status, DateTime createdAt
});


$MedicationDraftPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class _$MedicationDraftCopyWithImpl<$Res>
    implements $MedicationDraftCopyWith<$Res> {
  _$MedicationDraftCopyWithImpl(this._self, this._then);

  final MedicationDraft _self;
  final $Res Function(MedicationDraft) _then;

/// Create a copy of MedicationDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? payload = null,Object? photoPath = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(MedicationDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DraftSource,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as MedicationDraftPayload,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of MedicationDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDraftPayloadCopyWith<$Res> get payload {
  
  return $MedicationDraftPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicationDraft].
extension MedicationDraftPatterns on MedicationDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationDraft value)  $default,){
final _that = this;
switch (_that) {
case _MedicationDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationDraft value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DraftSource source,  MedicationDraftPayload payload,  String? photoPath,  DraftStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationDraft() when $default != null:
return $default(_that.id,_that.source,_that.payload,_that.photoPath,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DraftSource source,  MedicationDraftPayload payload,  String? photoPath,  DraftStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MedicationDraft():
return $default(_that.id,_that.source,_that.payload,_that.photoPath,_that.status,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DraftSource source,  MedicationDraftPayload payload,  String? photoPath,  DraftStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicationDraft() when $default != null:
return $default(_that.id,_that.source,_that.payload,_that.photoPath,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationDraft implements MedicationDraft {
  const _MedicationDraft({required this.id, required this.source, required this.payload, this.photoPath, required this.status, required this.createdAt});
  

@override final  String id;
@override final  DraftSource source;
@override final  MedicationDraftPayload payload;
@override final  String? photoPath;
@override final  DraftStatus status;
@override final  DateTime createdAt;

/// Create a copy of MedicationDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationDraftCopyWith<_MedicationDraft> get copyWith => __$MedicationDraftCopyWithImpl<_MedicationDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,source,payload,photoPath,status,createdAt);
}

@override
String toString() {
    return 'MedicationDraft(id: $id, source: $source, payload: $payload, photoPath: $photoPath, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationDraftCopyWith<$Res> implements $MedicationDraftCopyWith<$Res> {
  factory _$MedicationDraftCopyWith(_MedicationDraft value, $Res Function(_MedicationDraft) _then) = __$MedicationDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, DraftSource source, MedicationDraftPayload payload, String? photoPath, DraftStatus status, DateTime createdAt
});


@override $MedicationDraftPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class __$MedicationDraftCopyWithImpl<$Res>
    implements _$MedicationDraftCopyWith<$Res> {
  __$MedicationDraftCopyWithImpl(this._self, this._then);

  final _MedicationDraft _self;
  final $Res Function(_MedicationDraft) _then;

/// Create a copy of MedicationDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? payload = null,Object? photoPath = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_MedicationDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DraftSource,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as MedicationDraftPayload,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of MedicationDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDraftPayloadCopyWith<$Res> get payload {
  
  return $MedicationDraftPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}

// dart format on
