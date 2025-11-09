// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lsp_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LspSession {
  SessionId get id => throw _privateConstructorUsedError;
  LanguageId get languageId => throw _privateConstructorUsedError;
  SessionState get state => throw _privateConstructorUsedError;
  DocumentUri get rootUri => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get initializedAt => throw _privateConstructorUsedError;

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LspSessionCopyWith<LspSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LspSessionCopyWith<$Res> {
  factory $LspSessionCopyWith(
    LspSession value,
    $Res Function(LspSession) then,
  ) = _$LspSessionCopyWithImpl<$Res, LspSession>;
  @useResult
  $Res call({
    SessionId id,
    LanguageId languageId,
    SessionState state,
    DocumentUri rootUri,
    DateTime createdAt,
    DateTime? initializedAt,
  });

  $SessionIdCopyWith<$Res> get id;
  $LanguageIdCopyWith<$Res> get languageId;
  $DocumentUriCopyWith<$Res> get rootUri;
}

/// @nodoc
class _$LspSessionCopyWithImpl<$Res, $Val extends LspSession>
    implements $LspSessionCopyWith<$Res> {
  _$LspSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? languageId = null,
    Object? state = null,
    Object? rootUri = null,
    Object? createdAt = null,
    Object? initializedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as SessionId,
            languageId: null == languageId
                ? _value.languageId
                : languageId // ignore: cast_nullable_to_non_nullable
                      as LanguageId,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as SessionState,
            rootUri: null == rootUri
                ? _value.rootUri
                : rootUri // ignore: cast_nullable_to_non_nullable
                      as DocumentUri,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            initializedAt: freezed == initializedAt
                ? _value.initializedAt
                : initializedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionIdCopyWith<$Res> get id {
    return $SessionIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageIdCopyWith<$Res> get languageId {
    return $LanguageIdCopyWith<$Res>(_value.languageId, (value) {
      return _then(_value.copyWith(languageId: value) as $Val);
    });
  }

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentUriCopyWith<$Res> get rootUri {
    return $DocumentUriCopyWith<$Res>(_value.rootUri, (value) {
      return _then(_value.copyWith(rootUri: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LspSessionImplCopyWith<$Res>
    implements $LspSessionCopyWith<$Res> {
  factory _$$LspSessionImplCopyWith(
    _$LspSessionImpl value,
    $Res Function(_$LspSessionImpl) then,
  ) = __$$LspSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SessionId id,
    LanguageId languageId,
    SessionState state,
    DocumentUri rootUri,
    DateTime createdAt,
    DateTime? initializedAt,
  });

  @override
  $SessionIdCopyWith<$Res> get id;
  @override
  $LanguageIdCopyWith<$Res> get languageId;
  @override
  $DocumentUriCopyWith<$Res> get rootUri;
}

/// @nodoc
class __$$LspSessionImplCopyWithImpl<$Res>
    extends _$LspSessionCopyWithImpl<$Res, _$LspSessionImpl>
    implements _$$LspSessionImplCopyWith<$Res> {
  __$$LspSessionImplCopyWithImpl(
    _$LspSessionImpl _value,
    $Res Function(_$LspSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? languageId = null,
    Object? state = null,
    Object? rootUri = null,
    Object? createdAt = null,
    Object? initializedAt = freezed,
  }) {
    return _then(
      _$LspSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as SessionId,
        languageId: null == languageId
            ? _value.languageId
            : languageId // ignore: cast_nullable_to_non_nullable
                  as LanguageId,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as SessionState,
        rootUri: null == rootUri
            ? _value.rootUri
            : rootUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        initializedAt: freezed == initializedAt
            ? _value.initializedAt
            : initializedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$LspSessionImpl extends _LspSession {
  const _$LspSessionImpl({
    required this.id,
    required this.languageId,
    required this.state,
    required this.rootUri,
    required this.createdAt,
    this.initializedAt,
  }) : super._();

  @override
  final SessionId id;
  @override
  final LanguageId languageId;
  @override
  final SessionState state;
  @override
  final DocumentUri rootUri;
  @override
  final DateTime createdAt;
  @override
  final DateTime? initializedAt;

  @override
  String toString() {
    return 'LspSession(id: $id, languageId: $languageId, state: $state, rootUri: $rootUri, createdAt: $createdAt, initializedAt: $initializedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LspSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.languageId, languageId) ||
                other.languageId == languageId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.rootUri, rootUri) || other.rootUri == rootUri) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.initializedAt, initializedAt) ||
                other.initializedAt == initializedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    languageId,
    state,
    rootUri,
    createdAt,
    initializedAt,
  );

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LspSessionImplCopyWith<_$LspSessionImpl> get copyWith =>
      __$$LspSessionImplCopyWithImpl<_$LspSessionImpl>(this, _$identity);
}

abstract class _LspSession extends LspSession {
  const factory _LspSession({
    required final SessionId id,
    required final LanguageId languageId,
    required final SessionState state,
    required final DocumentUri rootUri,
    required final DateTime createdAt,
    final DateTime? initializedAt,
  }) = _$LspSessionImpl;
  const _LspSession._() : super._();

  @override
  SessionId get id;
  @override
  LanguageId get languageId;
  @override
  SessionState get state;
  @override
  DocumentUri get rootUri;
  @override
  DateTime get createdAt;
  @override
  DateTime? get initializedAt;

  /// Create a copy of LspSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LspSessionImplCopyWith<_$LspSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
