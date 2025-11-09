// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorConfig {

 double get fontSize; String get fontFamily; bool get showMinimap; bool get wordWrap; int get tabSize; bool get showLineNumbers; bool get bracketPairColorization; bool get showStatusBar; bool get autoSave; int get autoSaveDelay;
/// Create a copy of EditorConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorConfigCopyWith<EditorConfig> get copyWith => _$EditorConfigCopyWithImpl<EditorConfig>(this as EditorConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorConfig&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.showMinimap, showMinimap) || other.showMinimap == showMinimap)&&(identical(other.wordWrap, wordWrap) || other.wordWrap == wordWrap)&&(identical(other.tabSize, tabSize) || other.tabSize == tabSize)&&(identical(other.showLineNumbers, showLineNumbers) || other.showLineNumbers == showLineNumbers)&&(identical(other.bracketPairColorization, bracketPairColorization) || other.bracketPairColorization == bracketPairColorization)&&(identical(other.showStatusBar, showStatusBar) || other.showStatusBar == showStatusBar)&&(identical(other.autoSave, autoSave) || other.autoSave == autoSave)&&(identical(other.autoSaveDelay, autoSaveDelay) || other.autoSaveDelay == autoSaveDelay));
}


@override
int get hashCode => Object.hash(runtimeType,fontSize,fontFamily,showMinimap,wordWrap,tabSize,showLineNumbers,bracketPairColorization,showStatusBar,autoSave,autoSaveDelay);

@override
String toString() {
  return 'EditorConfig(fontSize: $fontSize, fontFamily: $fontFamily, showMinimap: $showMinimap, wordWrap: $wordWrap, tabSize: $tabSize, showLineNumbers: $showLineNumbers, bracketPairColorization: $bracketPairColorization, showStatusBar: $showStatusBar, autoSave: $autoSave, autoSaveDelay: $autoSaveDelay)';
}


}

/// @nodoc
abstract mixin class $EditorConfigCopyWith<$Res>  {
  factory $EditorConfigCopyWith(EditorConfig value, $Res Function(EditorConfig) _then) = _$EditorConfigCopyWithImpl;
@useResult
$Res call({
 double fontSize, String fontFamily, bool showMinimap, bool wordWrap, int tabSize, bool showLineNumbers, bool bracketPairColorization, bool showStatusBar, bool autoSave, int autoSaveDelay
});




}
/// @nodoc
class _$EditorConfigCopyWithImpl<$Res>
    implements $EditorConfigCopyWith<$Res> {
  _$EditorConfigCopyWithImpl(this._self, this._then);

  final EditorConfig _self;
  final $Res Function(EditorConfig) _then;

/// Create a copy of EditorConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fontSize = null,Object? fontFamily = null,Object? showMinimap = null,Object? wordWrap = null,Object? tabSize = null,Object? showLineNumbers = null,Object? bracketPairColorization = null,Object? showStatusBar = null,Object? autoSave = null,Object? autoSaveDelay = null,}) {
  return _then(_self.copyWith(
fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,showMinimap: null == showMinimap ? _self.showMinimap : showMinimap // ignore: cast_nullable_to_non_nullable
as bool,wordWrap: null == wordWrap ? _self.wordWrap : wordWrap // ignore: cast_nullable_to_non_nullable
as bool,tabSize: null == tabSize ? _self.tabSize : tabSize // ignore: cast_nullable_to_non_nullable
as int,showLineNumbers: null == showLineNumbers ? _self.showLineNumbers : showLineNumbers // ignore: cast_nullable_to_non_nullable
as bool,bracketPairColorization: null == bracketPairColorization ? _self.bracketPairColorization : bracketPairColorization // ignore: cast_nullable_to_non_nullable
as bool,showStatusBar: null == showStatusBar ? _self.showStatusBar : showStatusBar // ignore: cast_nullable_to_non_nullable
as bool,autoSave: null == autoSave ? _self.autoSave : autoSave // ignore: cast_nullable_to_non_nullable
as bool,autoSaveDelay: null == autoSaveDelay ? _self.autoSaveDelay : autoSaveDelay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EditorConfig].
extension EditorConfigPatterns on EditorConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorConfig value)  $default,){
final _that = this;
switch (_that) {
case _EditorConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorConfig value)?  $default,){
final _that = this;
switch (_that) {
case _EditorConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double fontSize,  String fontFamily,  bool showMinimap,  bool wordWrap,  int tabSize,  bool showLineNumbers,  bool bracketPairColorization,  bool showStatusBar,  bool autoSave,  int autoSaveDelay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorConfig() when $default != null:
return $default(_that.fontSize,_that.fontFamily,_that.showMinimap,_that.wordWrap,_that.tabSize,_that.showLineNumbers,_that.bracketPairColorization,_that.showStatusBar,_that.autoSave,_that.autoSaveDelay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double fontSize,  String fontFamily,  bool showMinimap,  bool wordWrap,  int tabSize,  bool showLineNumbers,  bool bracketPairColorization,  bool showStatusBar,  bool autoSave,  int autoSaveDelay)  $default,) {final _that = this;
switch (_that) {
case _EditorConfig():
return $default(_that.fontSize,_that.fontFamily,_that.showMinimap,_that.wordWrap,_that.tabSize,_that.showLineNumbers,_that.bracketPairColorization,_that.showStatusBar,_that.autoSave,_that.autoSaveDelay);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double fontSize,  String fontFamily,  bool showMinimap,  bool wordWrap,  int tabSize,  bool showLineNumbers,  bool bracketPairColorization,  bool showStatusBar,  bool autoSave,  int autoSaveDelay)?  $default,) {final _that = this;
switch (_that) {
case _EditorConfig() when $default != null:
return $default(_that.fontSize,_that.fontFamily,_that.showMinimap,_that.wordWrap,_that.tabSize,_that.showLineNumbers,_that.bracketPairColorization,_that.showStatusBar,_that.autoSave,_that.autoSaveDelay);case _:
  return null;

}
}

}

/// @nodoc


class _EditorConfig extends EditorConfig {
  const _EditorConfig({this.fontSize = 14.0, this.fontFamily = 'Consolas, Monaco, monospace', this.showMinimap = false, this.wordWrap = true, this.tabSize = 2, this.showLineNumbers = true, this.bracketPairColorization = true, this.showStatusBar = true, this.autoSave = true, this.autoSaveDelay = 2}): super._();
  

@override@JsonKey() final  double fontSize;
@override@JsonKey() final  String fontFamily;
@override@JsonKey() final  bool showMinimap;
@override@JsonKey() final  bool wordWrap;
@override@JsonKey() final  int tabSize;
@override@JsonKey() final  bool showLineNumbers;
@override@JsonKey() final  bool bracketPairColorization;
@override@JsonKey() final  bool showStatusBar;
@override@JsonKey() final  bool autoSave;
@override@JsonKey() final  int autoSaveDelay;

/// Create a copy of EditorConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorConfigCopyWith<_EditorConfig> get copyWith => __$EditorConfigCopyWithImpl<_EditorConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorConfig&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.showMinimap, showMinimap) || other.showMinimap == showMinimap)&&(identical(other.wordWrap, wordWrap) || other.wordWrap == wordWrap)&&(identical(other.tabSize, tabSize) || other.tabSize == tabSize)&&(identical(other.showLineNumbers, showLineNumbers) || other.showLineNumbers == showLineNumbers)&&(identical(other.bracketPairColorization, bracketPairColorization) || other.bracketPairColorization == bracketPairColorization)&&(identical(other.showStatusBar, showStatusBar) || other.showStatusBar == showStatusBar)&&(identical(other.autoSave, autoSave) || other.autoSave == autoSave)&&(identical(other.autoSaveDelay, autoSaveDelay) || other.autoSaveDelay == autoSaveDelay));
}


@override
int get hashCode => Object.hash(runtimeType,fontSize,fontFamily,showMinimap,wordWrap,tabSize,showLineNumbers,bracketPairColorization,showStatusBar,autoSave,autoSaveDelay);

@override
String toString() {
  return 'EditorConfig(fontSize: $fontSize, fontFamily: $fontFamily, showMinimap: $showMinimap, wordWrap: $wordWrap, tabSize: $tabSize, showLineNumbers: $showLineNumbers, bracketPairColorization: $bracketPairColorization, showStatusBar: $showStatusBar, autoSave: $autoSave, autoSaveDelay: $autoSaveDelay)';
}


}

/// @nodoc
abstract mixin class _$EditorConfigCopyWith<$Res> implements $EditorConfigCopyWith<$Res> {
  factory _$EditorConfigCopyWith(_EditorConfig value, $Res Function(_EditorConfig) _then) = __$EditorConfigCopyWithImpl;
@override @useResult
$Res call({
 double fontSize, String fontFamily, bool showMinimap, bool wordWrap, int tabSize, bool showLineNumbers, bool bracketPairColorization, bool showStatusBar, bool autoSave, int autoSaveDelay
});




}
/// @nodoc
class __$EditorConfigCopyWithImpl<$Res>
    implements _$EditorConfigCopyWith<$Res> {
  __$EditorConfigCopyWithImpl(this._self, this._then);

  final _EditorConfig _self;
  final $Res Function(_EditorConfig) _then;

/// Create a copy of EditorConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fontSize = null,Object? fontFamily = null,Object? showMinimap = null,Object? wordWrap = null,Object? tabSize = null,Object? showLineNumbers = null,Object? bracketPairColorization = null,Object? showStatusBar = null,Object? autoSave = null,Object? autoSaveDelay = null,}) {
  return _then(_EditorConfig(
fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,showMinimap: null == showMinimap ? _self.showMinimap : showMinimap // ignore: cast_nullable_to_non_nullable
as bool,wordWrap: null == wordWrap ? _self.wordWrap : wordWrap // ignore: cast_nullable_to_non_nullable
as bool,tabSize: null == tabSize ? _self.tabSize : tabSize // ignore: cast_nullable_to_non_nullable
as int,showLineNumbers: null == showLineNumbers ? _self.showLineNumbers : showLineNumbers // ignore: cast_nullable_to_non_nullable
as bool,bracketPairColorization: null == bracketPairColorization ? _self.bracketPairColorization : bracketPairColorization // ignore: cast_nullable_to_non_nullable
as bool,showStatusBar: null == showStatusBar ? _self.showStatusBar : showStatusBar // ignore: cast_nullable_to_non_nullable
as bool,autoSave: null == autoSave ? _self.autoSave : autoSave // ignore: cast_nullable_to_non_nullable
as bool,autoSaveDelay: null == autoSaveDelay ? _self.autoSaveDelay : autoSaveDelay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
