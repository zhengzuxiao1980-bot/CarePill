// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiModelConfig {

 String get id; String get name; String get baseUrl; String get modelId; bool get supportsChat; bool get supportsVision; bool get supportsFunctionCalling; double? get temperature; int? get maxTokens; int get contextWindowTokens;/// 用途：对话 / 看图 / 双用（允许同一配置承担多用途）。
 ModelUsage get usage;/// 是否为"对话默认"配置；拍照识别优先用标记 vision 的配置。
 bool get isChatDefault; DateTime get createdAt;
/// Create a copy of AiModelConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelConfigCopyWith<AiModelConfig> get copyWith => _$AiModelConfigCopyWithImpl<AiModelConfig>(this as AiModelConfig, _$identity);

  /// Serializes this AiModelConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiModelConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelConfig&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.baseUrl, _this.baseUrl) || other.baseUrl == _this.baseUrl)&&(identical(other.modelId, _this.modelId) || other.modelId == _this.modelId)&&(identical(other.supportsChat, _this.supportsChat) || other.supportsChat == _this.supportsChat)&&(identical(other.supportsVision, _this.supportsVision) || other.supportsVision == _this.supportsVision)&&(identical(other.supportsFunctionCalling, _this.supportsFunctionCalling) || other.supportsFunctionCalling == _this.supportsFunctionCalling)&&(identical(other.temperature, _this.temperature) || other.temperature == _this.temperature)&&(identical(other.maxTokens, _this.maxTokens) || other.maxTokens == _this.maxTokens)&&(identical(other.contextWindowTokens, _this.contextWindowTokens) || other.contextWindowTokens == _this.contextWindowTokens)&&(identical(other.usage, _this.usage) || other.usage == _this.usage)&&(identical(other.isChatDefault, _this.isChatDefault) || other.isChatDefault == _this.isChatDefault)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiModelConfig;
  return Object.hash(runtimeType,_this.id,_this.name,_this.baseUrl,_this.modelId,_this.supportsChat,_this.supportsVision,_this.supportsFunctionCalling,_this.temperature,_this.maxTokens,_this.contextWindowTokens,_this.usage,_this.isChatDefault,_this.createdAt);
}

@override
String toString() {
  final _this = this as AiModelConfig;
  return 'AiModelConfig(id: ${_this.id}, name: ${_this.name}, baseUrl: ${_this.baseUrl}, modelId: ${_this.modelId}, supportsChat: ${_this.supportsChat}, supportsVision: ${_this.supportsVision}, supportsFunctionCalling: ${_this.supportsFunctionCalling}, temperature: ${_this.temperature}, maxTokens: ${_this.maxTokens}, contextWindowTokens: ${_this.contextWindowTokens}, usage: ${_this.usage}, isChatDefault: ${_this.isChatDefault}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AiModelConfigCopyWith<$Res>  {
  factory $AiModelConfigCopyWith(AiModelConfig value, $Res Function(AiModelConfig) _then) = _$AiModelConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, String baseUrl, String modelId, bool supportsChat, bool supportsVision, bool supportsFunctionCalling, double? temperature, int? maxTokens, int contextWindowTokens, ModelUsage usage, bool isChatDefault, DateTime createdAt
});




}
/// @nodoc
class _$AiModelConfigCopyWithImpl<$Res>
    implements $AiModelConfigCopyWith<$Res> {
  _$AiModelConfigCopyWithImpl(this._self, this._then);

  final AiModelConfig _self;
  final $Res Function(AiModelConfig) _then;

/// Create a copy of AiModelConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? baseUrl = null,Object? modelId = null,Object? supportsChat = null,Object? supportsVision = null,Object? supportsFunctionCalling = null,Object? temperature = freezed,Object? maxTokens = freezed,Object? contextWindowTokens = null,Object? usage = null,Object? isChatDefault = null,Object? createdAt = null,}) {
  return _then(AiModelConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,supportsChat: null == supportsChat ? _self.supportsChat : supportsChat // ignore: cast_nullable_to_non_nullable
as bool,supportsVision: null == supportsVision ? _self.supportsVision : supportsVision // ignore: cast_nullable_to_non_nullable
as bool,supportsFunctionCalling: null == supportsFunctionCalling ? _self.supportsFunctionCalling : supportsFunctionCalling // ignore: cast_nullable_to_non_nullable
as bool,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,maxTokens: freezed == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int?,contextWindowTokens: null == contextWindowTokens ? _self.contextWindowTokens : contextWindowTokens // ignore: cast_nullable_to_non_nullable
as int,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ModelUsage,isChatDefault: null == isChatDefault ? _self.isChatDefault : isChatDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiModelConfig].
extension AiModelConfigPatterns on AiModelConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelConfig value)  $default,){
final _that = this;
switch (_that) {
case _AiModelConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String baseUrl,  String modelId,  bool supportsChat,  bool supportsVision,  bool supportsFunctionCalling,  double? temperature,  int? maxTokens,  int contextWindowTokens,  ModelUsage usage,  bool isChatDefault,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModelConfig() when $default != null:
return $default(_that.id,_that.name,_that.baseUrl,_that.modelId,_that.supportsChat,_that.supportsVision,_that.supportsFunctionCalling,_that.temperature,_that.maxTokens,_that.contextWindowTokens,_that.usage,_that.isChatDefault,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String baseUrl,  String modelId,  bool supportsChat,  bool supportsVision,  bool supportsFunctionCalling,  double? temperature,  int? maxTokens,  int contextWindowTokens,  ModelUsage usage,  bool isChatDefault,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AiModelConfig():
return $default(_that.id,_that.name,_that.baseUrl,_that.modelId,_that.supportsChat,_that.supportsVision,_that.supportsFunctionCalling,_that.temperature,_that.maxTokens,_that.contextWindowTokens,_that.usage,_that.isChatDefault,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String baseUrl,  String modelId,  bool supportsChat,  bool supportsVision,  bool supportsFunctionCalling,  double? temperature,  int? maxTokens,  int contextWindowTokens,  ModelUsage usage,  bool isChatDefault,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AiModelConfig() when $default != null:
return $default(_that.id,_that.name,_that.baseUrl,_that.modelId,_that.supportsChat,_that.supportsVision,_that.supportsFunctionCalling,_that.temperature,_that.maxTokens,_that.contextWindowTokens,_that.usage,_that.isChatDefault,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiModelConfig implements AiModelConfig {
  const _AiModelConfig({required this.id, required this.name, required this.baseUrl, required this.modelId, this.supportsChat = true, this.supportsVision = false, this.supportsFunctionCalling = false, this.temperature, this.maxTokens, this.contextWindowTokens = 8192, required this.usage, this.isChatDefault = false, required this.createdAt});
  factory _AiModelConfig.fromJson(Map<String, dynamic> json) => _$AiModelConfigFromJson(json);

@override final  String id;
@override final  String name;
@override final  String baseUrl;
@override final  String modelId;
@override@JsonKey() final  bool supportsChat;
@override@JsonKey() final  bool supportsVision;
@override@JsonKey() final  bool supportsFunctionCalling;
@override final  double? temperature;
@override final  int? maxTokens;
@override@JsonKey() final  int contextWindowTokens;
/// 用途：对话 / 看图 / 双用（允许同一配置承担多用途）。
@override final  ModelUsage usage;
/// 是否为"对话默认"配置；拍照识别优先用标记 vision 的配置。
@override@JsonKey() final  bool isChatDefault;
@override final  DateTime createdAt;

/// Create a copy of AiModelConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelConfigCopyWith<_AiModelConfig> get copyWith => __$AiModelConfigCopyWithImpl<_AiModelConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiModelConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.supportsChat, supportsChat) || other.supportsChat == supportsChat)&&(identical(other.supportsVision, supportsVision) || other.supportsVision == supportsVision)&&(identical(other.supportsFunctionCalling, supportsFunctionCalling) || other.supportsFunctionCalling == supportsFunctionCalling)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&(identical(other.contextWindowTokens, contextWindowTokens) || other.contextWindowTokens == contextWindowTokens)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.isChatDefault, isChatDefault) || other.isChatDefault == isChatDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,baseUrl,modelId,supportsChat,supportsVision,supportsFunctionCalling,temperature,maxTokens,contextWindowTokens,usage,isChatDefault,createdAt);
}

@override
String toString() {
    return 'AiModelConfig(id: $id, name: $name, baseUrl: $baseUrl, modelId: $modelId, supportsChat: $supportsChat, supportsVision: $supportsVision, supportsFunctionCalling: $supportsFunctionCalling, temperature: $temperature, maxTokens: $maxTokens, contextWindowTokens: $contextWindowTokens, usage: $usage, isChatDefault: $isChatDefault, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AiModelConfigCopyWith<$Res> implements $AiModelConfigCopyWith<$Res> {
  factory _$AiModelConfigCopyWith(_AiModelConfig value, $Res Function(_AiModelConfig) _then) = __$AiModelConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String baseUrl, String modelId, bool supportsChat, bool supportsVision, bool supportsFunctionCalling, double? temperature, int? maxTokens, int contextWindowTokens, ModelUsage usage, bool isChatDefault, DateTime createdAt
});




}
/// @nodoc
class __$AiModelConfigCopyWithImpl<$Res>
    implements _$AiModelConfigCopyWith<$Res> {
  __$AiModelConfigCopyWithImpl(this._self, this._then);

  final _AiModelConfig _self;
  final $Res Function(_AiModelConfig) _then;

/// Create a copy of AiModelConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? baseUrl = null,Object? modelId = null,Object? supportsChat = null,Object? supportsVision = null,Object? supportsFunctionCalling = null,Object? temperature = freezed,Object? maxTokens = freezed,Object? contextWindowTokens = null,Object? usage = null,Object? isChatDefault = null,Object? createdAt = null,}) {
  return _then(_AiModelConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,supportsChat: null == supportsChat ? _self.supportsChat : supportsChat // ignore: cast_nullable_to_non_nullable
as bool,supportsVision: null == supportsVision ? _self.supportsVision : supportsVision // ignore: cast_nullable_to_non_nullable
as bool,supportsFunctionCalling: null == supportsFunctionCalling ? _self.supportsFunctionCalling : supportsFunctionCalling // ignore: cast_nullable_to_non_nullable
as bool,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,maxTokens: freezed == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int?,contextWindowTokens: null == contextWindowTokens ? _self.contextWindowTokens : contextWindowTokens // ignore: cast_nullable_to_non_nullable
as int,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ModelUsage,isChatDefault: null == isChatDefault ? _self.isChatDefault : isChatDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
