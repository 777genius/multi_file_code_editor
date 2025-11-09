// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EditorDocument {
  DocumentUri get uri => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  LanguageId get languageId => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;
  bool get isDirty => throw _privateConstructorUsedError;
  bool get isReadOnly => throw _privateConstructorUsedError;

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditorDocumentCopyWith<EditorDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorDocumentCopyWith<$Res> {
  factory $EditorDocumentCopyWith(
    EditorDocument value,
    $Res Function(EditorDocument) then,
  ) = _$EditorDocumentCopyWithImpl<$Res, EditorDocument>;
  @useResult
  $Res call({
    DocumentUri uri,
    String content,
    LanguageId languageId,
    DateTime lastModified,
    bool isDirty,
    bool isReadOnly,
  });

  $DocumentUriCopyWith<$Res> get uri;
  $LanguageIdCopyWith<$Res> get languageId;
}

/// @nodoc
class _$EditorDocumentCopyWithImpl<$Res, $Val extends EditorDocument>
    implements $EditorDocumentCopyWith<$Res> {
  _$EditorDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? content = null,
    Object? languageId = null,
    Object? lastModified = null,
    Object? isDirty = null,
    Object? isReadOnly = null,
  }) {
    return _then(
      _value.copyWith(
            uri: null == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as DocumentUri,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            languageId: null == languageId
                ? _value.languageId
                : languageId // ignore: cast_nullable_to_non_nullable
                      as LanguageId,
            lastModified: null == lastModified
                ? _value.lastModified
                : lastModified // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isDirty: null == isDirty
                ? _value.isDirty
                : isDirty // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReadOnly: null == isReadOnly
                ? _value.isReadOnly
                : isReadOnly // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentUriCopyWith<$Res> get uri {
    return $DocumentUriCopyWith<$Res>(_value.uri, (value) {
      return _then(_value.copyWith(uri: value) as $Val);
    });
  }

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageIdCopyWith<$Res> get languageId {
    return $LanguageIdCopyWith<$Res>(_value.languageId, (value) {
      return _then(_value.copyWith(languageId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EditorDocumentImplCopyWith<$Res>
    implements $EditorDocumentCopyWith<$Res> {
  factory _$$EditorDocumentImplCopyWith(
    _$EditorDocumentImpl value,
    $Res Function(_$EditorDocumentImpl) then,
  ) = __$$EditorDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DocumentUri uri,
    String content,
    LanguageId languageId,
    DateTime lastModified,
    bool isDirty,
    bool isReadOnly,
  });

  @override
  $DocumentUriCopyWith<$Res> get uri;
  @override
  $LanguageIdCopyWith<$Res> get languageId;
}

/// @nodoc
class __$$EditorDocumentImplCopyWithImpl<$Res>
    extends _$EditorDocumentCopyWithImpl<$Res, _$EditorDocumentImpl>
    implements _$$EditorDocumentImplCopyWith<$Res> {
  __$$EditorDocumentImplCopyWithImpl(
    _$EditorDocumentImpl _value,
    $Res Function(_$EditorDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? content = null,
    Object? languageId = null,
    Object? lastModified = null,
    Object? isDirty = null,
    Object? isReadOnly = null,
  }) {
    return _then(
      _$EditorDocumentImpl(
        uri: null == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        languageId: null == languageId
            ? _value.languageId
            : languageId // ignore: cast_nullable_to_non_nullable
                  as LanguageId,
        lastModified: null == lastModified
            ? _value.lastModified
            : lastModified // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isDirty: null == isDirty
            ? _value.isDirty
            : isDirty // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReadOnly: null == isReadOnly
            ? _value.isReadOnly
            : isReadOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$EditorDocumentImpl extends _EditorDocument {
  const _$EditorDocumentImpl({
    required this.uri,
    required this.content,
    required this.languageId,
    required this.lastModified,
    this.isDirty = false,
    this.isReadOnly = false,
  }) : super._();

  @override
  final DocumentUri uri;
  @override
  final String content;
  @override
  final LanguageId languageId;
  @override
  final DateTime lastModified;
  @override
  @JsonKey()
  final bool isDirty;
  @override
  @JsonKey()
  final bool isReadOnly;

  @override
  String toString() {
    return 'EditorDocument(uri: $uri, content: $content, languageId: $languageId, lastModified: $lastModified, isDirty: $isDirty, isReadOnly: $isReadOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditorDocumentImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.languageId, languageId) ||
                other.languageId == languageId) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.isDirty, isDirty) || other.isDirty == isDirty) &&
            (identical(other.isReadOnly, isReadOnly) ||
                other.isReadOnly == isReadOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uri,
    content,
    languageId,
    lastModified,
    isDirty,
    isReadOnly,
  );

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditorDocumentImplCopyWith<_$EditorDocumentImpl> get copyWith =>
      __$$EditorDocumentImplCopyWithImpl<_$EditorDocumentImpl>(
        this,
        _$identity,
      );
}

abstract class _EditorDocument extends EditorDocument {
  const factory _EditorDocument({
    required final DocumentUri uri,
    required final String content,
    required final LanguageId languageId,
    required final DateTime lastModified,
    final bool isDirty,
    final bool isReadOnly,
  }) = _$EditorDocumentImpl;
  const _EditorDocument._() : super._();

  @override
  DocumentUri get uri;
  @override
  String get content;
  @override
  LanguageId get languageId;
  @override
  DateTime get lastModified;
  @override
  bool get isDirty;
  @override
  bool get isReadOnly;

  /// Create a copy of EditorDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditorDocumentImplCopyWith<_$EditorDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
