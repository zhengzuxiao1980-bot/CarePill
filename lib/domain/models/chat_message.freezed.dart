// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatMessage {

 String get id; String get sessionId; ChatRole get role; String get content; String? get toolName; String? get toolPayload; DateTime get createdAt; int get sequence;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.toolName, _this.toolName) || other.toolName == _this.toolName)&&(identical(other.toolPayload, _this.toolPayload) || other.toolPayload == _this.toolPayload)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence));
}


@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hash(runtimeType,_this.id,_this.sessionId,_this.role,_this.content,_this.toolName,_this.toolPayload,_this.createdAt,_this.sequence);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(id: ${_this.id}, sessionId: ${_this.sessionId}, role: ${_this.role}, content: ${_this.content}, toolName: ${_this.toolName}, toolPayload: ${_this.toolPayload}, createdAt: ${_this.createdAt}, sequence: ${_this.sequence})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, ChatRole role, String content, String? toolName, String? toolPayload, DateTime createdAt, int sequence
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? role = null,Object? content = null,Object? toolName = freezed,Object? toolPayload = freezed,Object? createdAt = null,Object? sequence = null,}) {
  return _then(ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,toolPayload: freezed == toolPayload ? _self.toolPayload : toolPayload // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  ChatRole role,  String content,  String? toolName,  String? toolPayload,  DateTime createdAt,  int sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.sessionId,_that.role,_that.content,_that.toolName,_that.toolPayload,_that.createdAt,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  ChatRole role,  String content,  String? toolName,  String? toolPayload,  DateTime createdAt,  int sequence)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.sessionId,_that.role,_that.content,_that.toolName,_that.toolPayload,_that.createdAt,_that.sequence);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  ChatRole role,  String content,  String? toolName,  String? toolPayload,  DateTime createdAt,  int sequence)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.sessionId,_that.role,_that.content,_that.toolName,_that.toolPayload,_that.createdAt,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.sessionId, required this.role, required this.content, this.toolName, this.toolPayload, required this.createdAt, this.sequence = 0});
  

@override final  String id;
@override final  String sessionId;
@override final  ChatRole role;
@override final  String content;
@override final  String? toolName;
@override final  String? toolPayload;
@override final  DateTime createdAt;
@override@JsonKey() final  int sequence;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&(identical(other.toolPayload, toolPayload) || other.toolPayload == toolPayload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,sessionId,role,content,toolName,toolPayload,createdAt,sequence);
}

@override
String toString() {
    return 'ChatMessage(id: $id, sessionId: $sessionId, role: $role, content: $content, toolName: $toolName, toolPayload: $toolPayload, createdAt: $createdAt, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, ChatRole role, String content, String? toolName, String? toolPayload, DateTime createdAt, int sequence
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? role = null,Object? content = null,Object? toolName = freezed,Object? toolPayload = freezed,Object? createdAt = null,Object? sequence = null,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,toolPayload: freezed == toolPayload ? _self.toolPayload : toolPayload // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
