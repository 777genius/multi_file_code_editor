// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EditorEvent {
  DocumentUri get documentUri => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditorEventCopyWith<EditorEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorEventCopyWith<$Res> {
  factory $EditorEventCopyWith(
    EditorEvent value,
    $Res Function(EditorEvent) then,
  ) = _$EditorEventCopyWithImpl<$Res, EditorEvent>;
  @useResult
  $Res call({DocumentUri documentUri});

  $DocumentUriCopyWith<$Res> get documentUri;
}

/// @nodoc
class _$EditorEventCopyWithImpl<$Res, $Val extends EditorEvent>
    implements $EditorEventCopyWith<$Res> {
  _$EditorEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null}) {
    return _then(
      _value.copyWith(
            documentUri: null == documentUri
                ? _value.documentUri
                : documentUri // ignore: cast_nullable_to_non_nullable
                      as DocumentUri,
          )
          as $Val,
    );
  }

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentUriCopyWith<$Res> get documentUri {
    return $DocumentUriCopyWith<$Res>(_value.documentUri, (value) {
      return _then(_value.copyWith(documentUri: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContentChangedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$ContentChangedImplCopyWith(
    _$ContentChangedImpl value,
    $Res Function(_$ContentChangedImpl) then,
  ) = __$$ContentChangedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri, String newContent});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
}

/// @nodoc
class __$$ContentChangedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$ContentChangedImpl>
    implements _$$ContentChangedImplCopyWith<$Res> {
  __$$ContentChangedImplCopyWithImpl(
    _$ContentChangedImpl _value,
    $Res Function(_$ContentChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null, Object? newContent = null}) {
    return _then(
      _$ContentChangedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        newContent: null == newContent
            ? _value.newContent
            : newContent // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ContentChangedImpl implements _ContentChanged {
  const _$ContentChangedImpl({
    required this.documentUri,
    required this.newContent,
  });

  @override
  final DocumentUri documentUri;
  @override
  final String newContent;

  @override
  String toString() {
    return 'EditorEvent.contentChanged(documentUri: $documentUri, newContent: $newContent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentChangedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri) &&
            (identical(other.newContent, newContent) ||
                other.newContent == newContent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri, newContent);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentChangedImplCopyWith<_$ContentChangedImpl> get copyWith =>
      __$$ContentChangedImplCopyWithImpl<_$ContentChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return contentChanged(documentUri, newContent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return contentChanged?.call(documentUri, newContent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (contentChanged != null) {
      return contentChanged(documentUri, newContent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return contentChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return contentChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (contentChanged != null) {
      return contentChanged(this);
    }
    return orElse();
  }
}

abstract class _ContentChanged implements EditorEvent {
  const factory _ContentChanged({
    required final DocumentUri documentUri,
    required final String newContent,
  }) = _$ContentChangedImpl;

  @override
  DocumentUri get documentUri;
  String get newContent;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentChangedImplCopyWith<_$ContentChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CursorPositionChangedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$CursorPositionChangedImplCopyWith(
    _$CursorPositionChangedImpl value,
    $Res Function(_$CursorPositionChangedImpl) then,
  ) = __$$CursorPositionChangedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri, CursorPosition position});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
  $CursorPositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$CursorPositionChangedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$CursorPositionChangedImpl>
    implements _$$CursorPositionChangedImplCopyWith<$Res> {
  __$$CursorPositionChangedImplCopyWithImpl(
    _$CursorPositionChangedImpl _value,
    $Res Function(_$CursorPositionChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null, Object? position = null}) {
    return _then(
      _$CursorPositionChangedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as CursorPosition,
      ),
    );
  }

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CursorPositionCopyWith<$Res> get position {
    return $CursorPositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value));
    });
  }
}

/// @nodoc

class _$CursorPositionChangedImpl implements _CursorPositionChanged {
  const _$CursorPositionChangedImpl({
    required this.documentUri,
    required this.position,
  });

  @override
  final DocumentUri documentUri;
  @override
  final CursorPosition position;

  @override
  String toString() {
    return 'EditorEvent.cursorPositionChanged(documentUri: $documentUri, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorPositionChangedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri, position);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursorPositionChangedImplCopyWith<_$CursorPositionChangedImpl>
  get copyWith =>
      __$$CursorPositionChangedImplCopyWithImpl<_$CursorPositionChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return cursorPositionChanged(documentUri, position);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return cursorPositionChanged?.call(documentUri, position);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (cursorPositionChanged != null) {
      return cursorPositionChanged(documentUri, position);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return cursorPositionChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return cursorPositionChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (cursorPositionChanged != null) {
      return cursorPositionChanged(this);
    }
    return orElse();
  }
}

abstract class _CursorPositionChanged implements EditorEvent {
  const factory _CursorPositionChanged({
    required final DocumentUri documentUri,
    required final CursorPosition position,
  }) = _$CursorPositionChangedImpl;

  @override
  DocumentUri get documentUri;
  CursorPosition get position;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursorPositionChangedImplCopyWith<_$CursorPositionChangedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SelectionChangedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$SelectionChangedImplCopyWith(
    _$SelectionChangedImpl value,
    $Res Function(_$SelectionChangedImpl) then,
  ) = __$$SelectionChangedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri, TextSelection selection});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
  $TextSelectionCopyWith<$Res> get selection;
}

/// @nodoc
class __$$SelectionChangedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$SelectionChangedImpl>
    implements _$$SelectionChangedImplCopyWith<$Res> {
  __$$SelectionChangedImplCopyWithImpl(
    _$SelectionChangedImpl _value,
    $Res Function(_$SelectionChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null, Object? selection = null}) {
    return _then(
      _$SelectionChangedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        selection: null == selection
            ? _value.selection
            : selection // ignore: cast_nullable_to_non_nullable
                  as TextSelection,
      ),
    );
  }

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextSelectionCopyWith<$Res> get selection {
    return $TextSelectionCopyWith<$Res>(_value.selection, (value) {
      return _then(_value.copyWith(selection: value));
    });
  }
}

/// @nodoc

class _$SelectionChangedImpl implements _SelectionChanged {
  const _$SelectionChangedImpl({
    required this.documentUri,
    required this.selection,
  });

  @override
  final DocumentUri documentUri;
  @override
  final TextSelection selection;

  @override
  String toString() {
    return 'EditorEvent.selectionChanged(documentUri: $documentUri, selection: $selection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectionChangedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri) &&
            (identical(other.selection, selection) ||
                other.selection == selection));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri, selection);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectionChangedImplCopyWith<_$SelectionChangedImpl> get copyWith =>
      __$$SelectionChangedImplCopyWithImpl<_$SelectionChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return selectionChanged(documentUri, selection);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return selectionChanged?.call(documentUri, selection);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (selectionChanged != null) {
      return selectionChanged(documentUri, selection);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return selectionChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return selectionChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (selectionChanged != null) {
      return selectionChanged(this);
    }
    return orElse();
  }
}

abstract class _SelectionChanged implements EditorEvent {
  const factory _SelectionChanged({
    required final DocumentUri documentUri,
    required final TextSelection selection,
  }) = _$SelectionChangedImpl;

  @override
  DocumentUri get documentUri;
  TextSelection get selection;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectionChangedImplCopyWith<_$SelectionChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FocusChangedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$FocusChangedImplCopyWith(
    _$FocusChangedImpl value,
    $Res Function(_$FocusChangedImpl) then,
  ) = __$$FocusChangedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri, bool hasFocus});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
}

/// @nodoc
class __$$FocusChangedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$FocusChangedImpl>
    implements _$$FocusChangedImplCopyWith<$Res> {
  __$$FocusChangedImplCopyWithImpl(
    _$FocusChangedImpl _value,
    $Res Function(_$FocusChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null, Object? hasFocus = null}) {
    return _then(
      _$FocusChangedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
        hasFocus: null == hasFocus
            ? _value.hasFocus
            : hasFocus // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FocusChangedImpl implements _FocusChanged {
  const _$FocusChangedImpl({required this.documentUri, required this.hasFocus});

  @override
  final DocumentUri documentUri;
  @override
  final bool hasFocus;

  @override
  String toString() {
    return 'EditorEvent.focusChanged(documentUri: $documentUri, hasFocus: $hasFocus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusChangedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri) &&
            (identical(other.hasFocus, hasFocus) ||
                other.hasFocus == hasFocus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri, hasFocus);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusChangedImplCopyWith<_$FocusChangedImpl> get copyWith =>
      __$$FocusChangedImplCopyWithImpl<_$FocusChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return focusChanged(documentUri, hasFocus);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return focusChanged?.call(documentUri, hasFocus);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (focusChanged != null) {
      return focusChanged(documentUri, hasFocus);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return focusChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return focusChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (focusChanged != null) {
      return focusChanged(this);
    }
    return orElse();
  }
}

abstract class _FocusChanged implements EditorEvent {
  const factory _FocusChanged({
    required final DocumentUri documentUri,
    required final bool hasFocus,
  }) = _$FocusChangedImpl;

  @override
  DocumentUri get documentUri;
  bool get hasFocus;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusChangedImplCopyWith<_$FocusChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentOpenedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$DocumentOpenedImplCopyWith(
    _$DocumentOpenedImpl value,
    $Res Function(_$DocumentOpenedImpl) then,
  ) = __$$DocumentOpenedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
}

/// @nodoc
class __$$DocumentOpenedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$DocumentOpenedImpl>
    implements _$$DocumentOpenedImplCopyWith<$Res> {
  __$$DocumentOpenedImplCopyWithImpl(
    _$DocumentOpenedImpl _value,
    $Res Function(_$DocumentOpenedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null}) {
    return _then(
      _$DocumentOpenedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
      ),
    );
  }
}

/// @nodoc

class _$DocumentOpenedImpl implements _DocumentOpened {
  const _$DocumentOpenedImpl({required this.documentUri});

  @override
  final DocumentUri documentUri;

  @override
  String toString() {
    return 'EditorEvent.documentOpened(documentUri: $documentUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentOpenedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentOpenedImplCopyWith<_$DocumentOpenedImpl> get copyWith =>
      __$$DocumentOpenedImplCopyWithImpl<_$DocumentOpenedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return documentOpened(documentUri);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return documentOpened?.call(documentUri);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (documentOpened != null) {
      return documentOpened(documentUri);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return documentOpened(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return documentOpened?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (documentOpened != null) {
      return documentOpened(this);
    }
    return orElse();
  }
}

abstract class _DocumentOpened implements EditorEvent {
  const factory _DocumentOpened({required final DocumentUri documentUri}) =
      _$DocumentOpenedImpl;

  @override
  DocumentUri get documentUri;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentOpenedImplCopyWith<_$DocumentOpenedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentClosedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$DocumentClosedImplCopyWith(
    _$DocumentClosedImpl value,
    $Res Function(_$DocumentClosedImpl) then,
  ) = __$$DocumentClosedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
}

/// @nodoc
class __$$DocumentClosedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$DocumentClosedImpl>
    implements _$$DocumentClosedImplCopyWith<$Res> {
  __$$DocumentClosedImplCopyWithImpl(
    _$DocumentClosedImpl _value,
    $Res Function(_$DocumentClosedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null}) {
    return _then(
      _$DocumentClosedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
      ),
    );
  }
}

/// @nodoc

class _$DocumentClosedImpl implements _DocumentClosed {
  const _$DocumentClosedImpl({required this.documentUri});

  @override
  final DocumentUri documentUri;

  @override
  String toString() {
    return 'EditorEvent.documentClosed(documentUri: $documentUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentClosedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentClosedImplCopyWith<_$DocumentClosedImpl> get copyWith =>
      __$$DocumentClosedImplCopyWithImpl<_$DocumentClosedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return documentClosed(documentUri);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return documentClosed?.call(documentUri);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (documentClosed != null) {
      return documentClosed(documentUri);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return documentClosed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return documentClosed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (documentClosed != null) {
      return documentClosed(this);
    }
    return orElse();
  }
}

abstract class _DocumentClosed implements EditorEvent {
  const factory _DocumentClosed({required final DocumentUri documentUri}) =
      _$DocumentClosedImpl;

  @override
  DocumentUri get documentUri;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentClosedImplCopyWith<_$DocumentClosedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentSavedImplCopyWith<$Res>
    implements $EditorEventCopyWith<$Res> {
  factory _$$DocumentSavedImplCopyWith(
    _$DocumentSavedImpl value,
    $Res Function(_$DocumentSavedImpl) then,
  ) = __$$DocumentSavedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentUri documentUri});

  @override
  $DocumentUriCopyWith<$Res> get documentUri;
}

/// @nodoc
class __$$DocumentSavedImplCopyWithImpl<$Res>
    extends _$EditorEventCopyWithImpl<$Res, _$DocumentSavedImpl>
    implements _$$DocumentSavedImplCopyWith<$Res> {
  __$$DocumentSavedImplCopyWithImpl(
    _$DocumentSavedImpl _value,
    $Res Function(_$DocumentSavedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentUri = null}) {
    return _then(
      _$DocumentSavedImpl(
        documentUri: null == documentUri
            ? _value.documentUri
            : documentUri // ignore: cast_nullable_to_non_nullable
                  as DocumentUri,
      ),
    );
  }
}

/// @nodoc

class _$DocumentSavedImpl implements _DocumentSaved {
  const _$DocumentSavedImpl({required this.documentUri});

  @override
  final DocumentUri documentUri;

  @override
  String toString() {
    return 'EditorEvent.documentSaved(documentUri: $documentUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentSavedImpl &&
            (identical(other.documentUri, documentUri) ||
                other.documentUri == documentUri));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentUri);

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentSavedImplCopyWith<_$DocumentSavedImpl> get copyWith =>
      __$$DocumentSavedImplCopyWithImpl<_$DocumentSavedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DocumentUri documentUri, String newContent)
    contentChanged,
    required TResult Function(DocumentUri documentUri, CursorPosition position)
    cursorPositionChanged,
    required TResult Function(DocumentUri documentUri, TextSelection selection)
    selectionChanged,
    required TResult Function(DocumentUri documentUri, bool hasFocus)
    focusChanged,
    required TResult Function(DocumentUri documentUri) documentOpened,
    required TResult Function(DocumentUri documentUri) documentClosed,
    required TResult Function(DocumentUri documentUri) documentSaved,
  }) {
    return documentSaved(documentUri);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult? Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult? Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult? Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult? Function(DocumentUri documentUri)? documentOpened,
    TResult? Function(DocumentUri documentUri)? documentClosed,
    TResult? Function(DocumentUri documentUri)? documentSaved,
  }) {
    return documentSaved?.call(documentUri);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DocumentUri documentUri, String newContent)?
    contentChanged,
    TResult Function(DocumentUri documentUri, CursorPosition position)?
    cursorPositionChanged,
    TResult Function(DocumentUri documentUri, TextSelection selection)?
    selectionChanged,
    TResult Function(DocumentUri documentUri, bool hasFocus)? focusChanged,
    TResult Function(DocumentUri documentUri)? documentOpened,
    TResult Function(DocumentUri documentUri)? documentClosed,
    TResult Function(DocumentUri documentUri)? documentSaved,
    required TResult orElse(),
  }) {
    if (documentSaved != null) {
      return documentSaved(documentUri);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContentChanged value) contentChanged,
    required TResult Function(_CursorPositionChanged value)
    cursorPositionChanged,
    required TResult Function(_SelectionChanged value) selectionChanged,
    required TResult Function(_FocusChanged value) focusChanged,
    required TResult Function(_DocumentOpened value) documentOpened,
    required TResult Function(_DocumentClosed value) documentClosed,
    required TResult Function(_DocumentSaved value) documentSaved,
  }) {
    return documentSaved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ContentChanged value)? contentChanged,
    TResult? Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult? Function(_SelectionChanged value)? selectionChanged,
    TResult? Function(_FocusChanged value)? focusChanged,
    TResult? Function(_DocumentOpened value)? documentOpened,
    TResult? Function(_DocumentClosed value)? documentClosed,
    TResult? Function(_DocumentSaved value)? documentSaved,
  }) {
    return documentSaved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContentChanged value)? contentChanged,
    TResult Function(_CursorPositionChanged value)? cursorPositionChanged,
    TResult Function(_SelectionChanged value)? selectionChanged,
    TResult Function(_FocusChanged value)? focusChanged,
    TResult Function(_DocumentOpened value)? documentOpened,
    TResult Function(_DocumentClosed value)? documentClosed,
    TResult Function(_DocumentSaved value)? documentSaved,
    required TResult orElse(),
  }) {
    if (documentSaved != null) {
      return documentSaved(this);
    }
    return orElse();
  }
}

abstract class _DocumentSaved implements EditorEvent {
  const factory _DocumentSaved({required final DocumentUri documentUri}) =
      _$DocumentSavedImpl;

  @override
  DocumentUri get documentUri;

  /// Create a copy of EditorEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentSavedImplCopyWith<_$DocumentSavedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
