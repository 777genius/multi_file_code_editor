// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnostic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Diagnostic {
  TextSelection get range => throw _privateConstructorUsedError;
  DiagnosticSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  List<DiagnosticRelatedInformation>? get relatedInformation =>
      throw _privateConstructorUsedError;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticCopyWith<Diagnostic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticCopyWith<$Res> {
  factory $DiagnosticCopyWith(
    Diagnostic value,
    $Res Function(Diagnostic) then,
  ) = _$DiagnosticCopyWithImpl<$Res, Diagnostic>;
  @useResult
  $Res call({
    TextSelection range,
    DiagnosticSeverity severity,
    String message,
    String? code,
    String? source,
    List<DiagnosticRelatedInformation>? relatedInformation,
  });

  $TextSelectionCopyWith<$Res> get range;
}

/// @nodoc
class _$DiagnosticCopyWithImpl<$Res, $Val extends Diagnostic>
    implements $DiagnosticCopyWith<$Res> {
  _$DiagnosticCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? range = null,
    Object? severity = null,
    Object? message = null,
    Object? code = freezed,
    Object? source = freezed,
    Object? relatedInformation = freezed,
  }) {
    return _then(
      _value.copyWith(
            range: null == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as TextSelection,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as DiagnosticSeverity,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            relatedInformation: freezed == relatedInformation
                ? _value.relatedInformation
                : relatedInformation // ignore: cast_nullable_to_non_nullable
                      as List<DiagnosticRelatedInformation>?,
          )
          as $Val,
    );
  }

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextSelectionCopyWith<$Res> get range {
    return $TextSelectionCopyWith<$Res>(_value.range, (value) {
      return _then(_value.copyWith(range: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiagnosticImplCopyWith<$Res>
    implements $DiagnosticCopyWith<$Res> {
  factory _$$DiagnosticImplCopyWith(
    _$DiagnosticImpl value,
    $Res Function(_$DiagnosticImpl) then,
  ) = __$$DiagnosticImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TextSelection range,
    DiagnosticSeverity severity,
    String message,
    String? code,
    String? source,
    List<DiagnosticRelatedInformation>? relatedInformation,
  });

  @override
  $TextSelectionCopyWith<$Res> get range;
}

/// @nodoc
class __$$DiagnosticImplCopyWithImpl<$Res>
    extends _$DiagnosticCopyWithImpl<$Res, _$DiagnosticImpl>
    implements _$$DiagnosticImplCopyWith<$Res> {
  __$$DiagnosticImplCopyWithImpl(
    _$DiagnosticImpl _value,
    $Res Function(_$DiagnosticImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? range = null,
    Object? severity = null,
    Object? message = null,
    Object? code = freezed,
    Object? source = freezed,
    Object? relatedInformation = freezed,
  }) {
    return _then(
      _$DiagnosticImpl(
        range: null == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as TextSelection,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as DiagnosticSeverity,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        relatedInformation: freezed == relatedInformation
            ? _value._relatedInformation
            : relatedInformation // ignore: cast_nullable_to_non_nullable
                  as List<DiagnosticRelatedInformation>?,
      ),
    );
  }
}

/// @nodoc

class _$DiagnosticImpl extends _Diagnostic {
  const _$DiagnosticImpl({
    required this.range,
    required this.severity,
    required this.message,
    this.code,
    this.source,
    final List<DiagnosticRelatedInformation>? relatedInformation,
  }) : _relatedInformation = relatedInformation,
       super._();

  @override
  final TextSelection range;
  @override
  final DiagnosticSeverity severity;
  @override
  final String message;
  @override
  final String? code;
  @override
  final String? source;
  final List<DiagnosticRelatedInformation>? _relatedInformation;
  @override
  List<DiagnosticRelatedInformation>? get relatedInformation {
    final value = _relatedInformation;
    if (value == null) return null;
    if (_relatedInformation is EqualUnmodifiableListView)
      return _relatedInformation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Diagnostic(range: $range, severity: $severity, message: $message, code: $code, source: $source, relatedInformation: $relatedInformation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticImpl &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(
              other._relatedInformation,
              _relatedInformation,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    range,
    severity,
    message,
    code,
    source,
    const DeepCollectionEquality().hash(_relatedInformation),
  );

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticImplCopyWith<_$DiagnosticImpl> get copyWith =>
      __$$DiagnosticImplCopyWithImpl<_$DiagnosticImpl>(this, _$identity);
}

abstract class _Diagnostic extends Diagnostic {
  const factory _Diagnostic({
    required final TextSelection range,
    required final DiagnosticSeverity severity,
    required final String message,
    final String? code,
    final String? source,
    final List<DiagnosticRelatedInformation>? relatedInformation,
  }) = _$DiagnosticImpl;
  const _Diagnostic._() : super._();

  @override
  TextSelection get range;
  @override
  DiagnosticSeverity get severity;
  @override
  String get message;
  @override
  String? get code;
  @override
  String? get source;
  @override
  List<DiagnosticRelatedInformation>? get relatedInformation;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticImplCopyWith<_$DiagnosticImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DiagnosticRelatedInformation {
  DocumentUri get uri => throw _privateConstructorUsedError;
  TextSelection get range => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticRelatedInformationCopyWith<DiagnosticRelatedInformation>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticRelatedInformationCopyWith<$Res> {
  factory $DiagnosticRelatedInformationCopyWith(
    DiagnosticRelatedInformation value,
    $Res Function(DiagnosticRelatedInformation) then,
  ) =
      _$DiagnosticRelatedInformationCopyWithImpl<
        $Res,
        DiagnosticRelatedInformation
      >;
  @useResult
  $Res call({DocumentUri uri, TextSelection range, String message});

  $DocumentUriCopyWith<$Res> get uri;
  $TextSelectionCopyWith<$Res> get range;
}

/// @nodoc
class _$DiagnosticRelatedInformationCopyWithImpl<
  $Res,
  $Val extends DiagnosticRelatedInformation
>
    implements $DiagnosticRelatedInformationCopyWith<$Res> {
  _$DiagnosticRelatedInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? range = null,
    Object? message = null,
  }) {
    return _then(
      _value.copyWith(
            uri: null == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as DocumentUri,
            range: null == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as TextSelection,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentUriCopyWith<$Res> get uri {
    return $DocumentUriCopyWith<$Res>(_value.uri, (value) {
      return _then(_value.copyWith(uri: value) as $Val);
    });
  }

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextSelectionCopyWith<$Res> get range {
    return $TextSelectionCopyWith<$Res>(_value.range, (value) {
      return _then(_value.copyWith(range: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiagnosticRelatedInformationImplCopyWith<$Res>
    implements $DiagnosticRelatedInformationCopyWith<$Res> {
  factory _$$DiagnosticRelatedInformationImplCopyWith(
    _$DiagnosticRelatedInformationImpl value,
    $Res Function(_$DiagnosticRelatedInformationImpl) then,
  ) = __$$DiagnosticRelatedInformationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri uri, TextSelection range, String message});

  @override
  $DocumentUriCopyWith<$Res> get uri;
  @override
  $TextSelectionCopyWith<$Res> get range;
}

/// @nodoc
class __$$DiagnosticRelatedInformationImplCopyWithImpl<$Res>
    extends
        _$DiagnosticRelatedInformationCopyWithImpl<
          $Res,
          _$DiagnosticRelatedInformationImpl
        >
    implements _$$DiagnosticRelatedInformationImplCopyWith<$Res> {
  __$$DiagnosticRelatedInformationImplCopyWithImpl(
    _$DiagnosticRelatedInformationImpl _value,
    $Res Function(_$DiagnosticRelatedInformationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? range = null,
    Object? message = null,
  }) {
    return _then(
      _$DiagnosticRelatedInformationImpl(
        uri: null == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        range: null == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as TextSelection,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DiagnosticRelatedInformationImpl
    implements _DiagnosticRelatedInformation {
  const _$DiagnosticRelatedInformationImpl({
    required this.uri,
    required this.range,
    required this.message,
  });

  @override
  final DocumentUri uri;
  @override
  final TextSelection range;
  @override
  final String message;

  @override
  String toString() {
    return 'DiagnosticRelatedInformation(uri: $uri, range: $range, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticRelatedInformationImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uri, range, message);

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticRelatedInformationImplCopyWith<
    _$DiagnosticRelatedInformationImpl
  >
  get copyWith =>
      __$$DiagnosticRelatedInformationImplCopyWithImpl<
        _$DiagnosticRelatedInformationImpl
      >(this, _$identity);
}

abstract class _DiagnosticRelatedInformation
    implements DiagnosticRelatedInformation {
  const factory _DiagnosticRelatedInformation({
    required final DocumentUri uri,
    required final TextSelection range,
    required final String message,
  }) = _$DiagnosticRelatedInformationImpl;

  @override
  DocumentUri get uri;
  @override
  TextSelection get range;
  @override
  String get message;

  /// Create a copy of DiagnosticRelatedInformation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticRelatedInformationImplCopyWith<
    _$DiagnosticRelatedInformationImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
