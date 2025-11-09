// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugin_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PluginManifest {

 String get id; String get name; String get version; String? get description; String? get author; List<String> get dependencies; Map<String, String> get capabilities; List<String> get activationEvents; Map<String, dynamic> get metadata;
/// Create a copy of PluginManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PluginManifestCopyWith<PluginManifest> get copyWith => _$PluginManifestCopyWithImpl<PluginManifest>(this as PluginManifest, _$identity);

  /// Serializes this PluginManifest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PluginManifest&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.capabilities, capabilities)&&const DeepCollectionEquality().equals(other.activationEvents, activationEvents)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,version,description,author,const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(capabilities),const DeepCollectionEquality().hash(activationEvents),const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'PluginManifest(id: $id, name: $name, version: $version, description: $description, author: $author, dependencies: $dependencies, capabilities: $capabilities, activationEvents: $activationEvents, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $PluginManifestCopyWith<$Res>  {
  factory $PluginManifestCopyWith(PluginManifest value, $Res Function(PluginManifest) _then) = _$PluginManifestCopyWithImpl;
@useResult
$Res call({
 String id, String name, String version, String? description, String? author, List<String> dependencies, Map<String, String> capabilities, List<String> activationEvents, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$PluginManifestCopyWithImpl<$Res>
    implements $PluginManifestCopyWith<$Res> {
  _$PluginManifestCopyWithImpl(this._self, this._then);

  final PluginManifest _self;
  final $Res Function(PluginManifest) _then;

/// Create a copy of PluginManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? version = null,Object? description = freezed,Object? author = freezed,Object? dependencies = null,Object? capabilities = null,Object? activationEvents = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as Map<String, String>,activationEvents: null == activationEvents ? _self.activationEvents : activationEvents // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [PluginManifest].
extension PluginManifestPatterns on PluginManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PluginManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PluginManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PluginManifest value)  $default,){
final _that = this;
switch (_that) {
case _PluginManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PluginManifest value)?  $default,){
final _that = this;
switch (_that) {
case _PluginManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String version,  String? description,  String? author,  List<String> dependencies,  Map<String, String> capabilities,  List<String> activationEvents,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PluginManifest() when $default != null:
return $default(_that.id,_that.name,_that.version,_that.description,_that.author,_that.dependencies,_that.capabilities,_that.activationEvents,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String version,  String? description,  String? author,  List<String> dependencies,  Map<String, String> capabilities,  List<String> activationEvents,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _PluginManifest():
return $default(_that.id,_that.name,_that.version,_that.description,_that.author,_that.dependencies,_that.capabilities,_that.activationEvents,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String version,  String? description,  String? author,  List<String> dependencies,  Map<String, String> capabilities,  List<String> activationEvents,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _PluginManifest() when $default != null:
return $default(_that.id,_that.name,_that.version,_that.description,_that.author,_that.dependencies,_that.capabilities,_that.activationEvents,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PluginManifest extends PluginManifest {
  const _PluginManifest({required this.id, required this.name, required this.version, this.description, this.author, final  List<String> dependencies = const [], final  Map<String, String> capabilities = const {}, final  List<String> activationEvents = const [], final  Map<String, dynamic> metadata = const {}}): _dependencies = dependencies,_capabilities = capabilities,_activationEvents = activationEvents,_metadata = metadata,super._();
  factory _PluginManifest.fromJson(Map<String, dynamic> json) => _$PluginManifestFromJson(json);

@override final  String id;
@override final  String name;
@override final  String version;
@override final  String? description;
@override final  String? author;
 final  List<String> _dependencies;
@override@JsonKey() List<String> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

 final  Map<String, String> _capabilities;
@override@JsonKey() Map<String, String> get capabilities {
  if (_capabilities is EqualUnmodifiableMapView) return _capabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_capabilities);
}

 final  List<String> _activationEvents;
@override@JsonKey() List<String> get activationEvents {
  if (_activationEvents is EqualUnmodifiableListView) return _activationEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activationEvents);
}

 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of PluginManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PluginManifestCopyWith<_PluginManifest> get copyWith => __$PluginManifestCopyWithImpl<_PluginManifest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PluginManifestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PluginManifest&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies)&&const DeepCollectionEquality().equals(other._capabilities, _capabilities)&&const DeepCollectionEquality().equals(other._activationEvents, _activationEvents)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,version,description,author,const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_capabilities),const DeepCollectionEquality().hash(_activationEvents),const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'PluginManifest(id: $id, name: $name, version: $version, description: $description, author: $author, dependencies: $dependencies, capabilities: $capabilities, activationEvents: $activationEvents, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$PluginManifestCopyWith<$Res> implements $PluginManifestCopyWith<$Res> {
  factory _$PluginManifestCopyWith(_PluginManifest value, $Res Function(_PluginManifest) _then) = __$PluginManifestCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String version, String? description, String? author, List<String> dependencies, Map<String, String> capabilities, List<String> activationEvents, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$PluginManifestCopyWithImpl<$Res>
    implements _$PluginManifestCopyWith<$Res> {
  __$PluginManifestCopyWithImpl(this._self, this._then);

  final _PluginManifest _self;
  final $Res Function(_PluginManifest) _then;

/// Create a copy of PluginManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? version = null,Object? description = freezed,Object? author = freezed,Object? dependencies = null,Object? capabilities = null,Object? activationEvents = null,Object? metadata = null,}) {
  return _then(_PluginManifest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,capabilities: null == capabilities ? _self._capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as Map<String, String>,activationEvents: null == activationEvents ? _self._activationEvents : activationEvents // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
