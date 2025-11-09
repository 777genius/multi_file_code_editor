// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snippet_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SnippetData {

/// The prefix that triggers this snippet (e.g., 'class', 'if', 'stless').
 String get prefix;/// The label shown in autocomplete (e.g., 'if statement').
 String get label;/// The snippet body with tab stops and placeholders.
///
/// Use Monaco snippet syntax:
/// - `${1:placeholder}` - tab stop 1 with placeholder text
/// - `${2}` - tab stop 2
/// - `$0` - final cursor position
/// - `\\n` - newline
/// - `\\t` - tab
 String get body;/// Description shown in autocomplete tooltip.
 String get description;
/// Create a copy of SnippetData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetDataCopyWith<SnippetData> get copyWith => _$SnippetDataCopyWithImpl<SnippetData>(this as SnippetData, _$identity);

  /// Serializes this SnippetData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetData&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.label, label) || other.label == label)&&(identical(other.body, body) || other.body == body)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prefix,label,body,description);

@override
String toString() {
  return 'SnippetData(prefix: $prefix, label: $label, body: $body, description: $description)';
}


}

/// @nodoc
abstract mixin class $SnippetDataCopyWith<$Res>  {
  factory $SnippetDataCopyWith(SnippetData value, $Res Function(SnippetData) _then) = _$SnippetDataCopyWithImpl;
@useResult
$Res call({
 String prefix, String label, String body, String description
});




}
/// @nodoc
class _$SnippetDataCopyWithImpl<$Res>
    implements $SnippetDataCopyWith<$Res> {
  _$SnippetDataCopyWithImpl(this._self, this._then);

  final SnippetData _self;
  final $Res Function(SnippetData) _then;

/// Create a copy of SnippetData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prefix = null,Object? label = null,Object? body = null,Object? description = null,}) {
  return _then(_self.copyWith(
prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SnippetData].
extension SnippetDataPatterns on SnippetData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnippetData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnippetData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnippetData value)  $default,){
final _that = this;
switch (_that) {
case _SnippetData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnippetData value)?  $default,){
final _that = this;
switch (_that) {
case _SnippetData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String prefix,  String label,  String body,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnippetData() when $default != null:
return $default(_that.prefix,_that.label,_that.body,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String prefix,  String label,  String body,  String description)  $default,) {final _that = this;
switch (_that) {
case _SnippetData():
return $default(_that.prefix,_that.label,_that.body,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String prefix,  String label,  String body,  String description)?  $default,) {final _that = this;
switch (_that) {
case _SnippetData() when $default != null:
return $default(_that.prefix,_that.label,_that.body,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnippetData extends SnippetData {
  const _SnippetData({required this.prefix, required this.label, required this.body, required this.description}): super._();
  factory _SnippetData.fromJson(Map<String, dynamic> json) => _$SnippetDataFromJson(json);

/// The prefix that triggers this snippet (e.g., 'class', 'if', 'stless').
@override final  String prefix;
/// The label shown in autocomplete (e.g., 'if statement').
@override final  String label;
/// The snippet body with tab stops and placeholders.
///
/// Use Monaco snippet syntax:
/// - `${1:placeholder}` - tab stop 1 with placeholder text
/// - `${2}` - tab stop 2
/// - `$0` - final cursor position
/// - `\\n` - newline
/// - `\\t` - tab
@override final  String body;
/// Description shown in autocomplete tooltip.
@override final  String description;

/// Create a copy of SnippetData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnippetDataCopyWith<_SnippetData> get copyWith => __$SnippetDataCopyWithImpl<_SnippetData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnippetDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnippetData&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.label, label) || other.label == label)&&(identical(other.body, body) || other.body == body)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prefix,label,body,description);

@override
String toString() {
  return 'SnippetData(prefix: $prefix, label: $label, body: $body, description: $description)';
}


}

/// @nodoc
abstract mixin class _$SnippetDataCopyWith<$Res> implements $SnippetDataCopyWith<$Res> {
  factory _$SnippetDataCopyWith(_SnippetData value, $Res Function(_SnippetData) _then) = __$SnippetDataCopyWithImpl;
@override @useResult
$Res call({
 String prefix, String label, String body, String description
});




}
/// @nodoc
class __$SnippetDataCopyWithImpl<$Res>
    implements _$SnippetDataCopyWith<$Res> {
  __$SnippetDataCopyWithImpl(this._self, this._then);

  final _SnippetData _self;
  final $Res Function(_SnippetData) _then;

/// Create a copy of SnippetData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prefix = null,Object? label = null,Object? body = null,Object? description = null,}) {
  return _then(_SnippetData(
prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
