// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completion_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CompletionList {
  List<CompletionItem> get items => throw _privateConstructorUsedError;
  bool get isIncomplete => throw _privateConstructorUsedError;

  /// Create a copy of CompletionList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletionListCopyWith<CompletionList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionListCopyWith<$Res> {
  factory $CompletionListCopyWith(
    CompletionList value,
    $Res Function(CompletionList) then,
  ) = _$CompletionListCopyWithImpl<$Res, CompletionList>;
  @useResult
  $Res call({List<CompletionItem> items, bool isIncomplete});
}

/// @nodoc
class _$CompletionListCopyWithImpl<$Res, $Val extends CompletionList>
    implements $CompletionListCopyWith<$Res> {
  _$CompletionListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletionList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null, Object? isIncomplete = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CompletionItem>,
            isIncomplete: null == isIncomplete
                ? _value.isIncomplete
                : isIncomplete // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompletionListImplCopyWith<$Res>
    implements $CompletionListCopyWith<$Res> {
  factory _$$CompletionListImplCopyWith(
    _$CompletionListImpl value,
    $Res Function(_$CompletionListImpl) then,
  ) = __$$CompletionListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CompletionItem> items, bool isIncomplete});
}

/// @nodoc
class __$$CompletionListImplCopyWithImpl<$Res>
    extends _$CompletionListCopyWithImpl<$Res, _$CompletionListImpl>
    implements _$$CompletionListImplCopyWith<$Res> {
  __$$CompletionListImplCopyWithImpl(
    _$CompletionListImpl _value,
    $Res Function(_$CompletionListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompletionList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null, Object? isIncomplete = null}) {
    return _then(
      _$CompletionListImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CompletionItem>,
        isIncomplete: null == isIncomplete
            ? _value.isIncomplete
            : isIncomplete // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CompletionListImpl extends _CompletionList {
  const _$CompletionListImpl({
    required final List<CompletionItem> items,
    this.isIncomplete = false,
  }) : _items = items,
       super._();

  final List<CompletionItem> _items;
  @override
  List<CompletionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final bool isIncomplete;

  @override
  String toString() {
    return 'CompletionList(items: $items, isIncomplete: $isIncomplete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionListImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isIncomplete, isIncomplete) ||
                other.isIncomplete == isIncomplete));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    isIncomplete,
  );

  /// Create a copy of CompletionList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionListImplCopyWith<_$CompletionListImpl> get copyWith =>
      __$$CompletionListImplCopyWithImpl<_$CompletionListImpl>(
        this,
        _$identity,
      );
}

abstract class _CompletionList extends CompletionList {
  const factory _CompletionList({
    required final List<CompletionItem> items,
    final bool isIncomplete,
  }) = _$CompletionListImpl;
  const _CompletionList._() : super._();

  @override
  List<CompletionItem> get items;
  @override
  bool get isIncomplete;

  /// Create a copy of CompletionList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletionListImplCopyWith<_$CompletionListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CompletionItem {
  String get label => throw _privateConstructorUsedError;
  CompletionItemKind get kind => throw _privateConstructorUsedError;
  String? get detail => throw _privateConstructorUsedError;
  String? get documentation => throw _privateConstructorUsedError;
  String? get insertText => throw _privateConstructorUsedError;
  String? get sortText => throw _privateConstructorUsedError;
  String? get filterText => throw _privateConstructorUsedError;
  TextEdit? get textEdit => throw _privateConstructorUsedError;
  bool get preselect => throw _privateConstructorUsedError;

  /// Create a copy of CompletionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletionItemCopyWith<CompletionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionItemCopyWith<$Res> {
  factory $CompletionItemCopyWith(
    CompletionItem value,
    $Res Function(CompletionItem) then,
  ) = _$CompletionItemCopyWithImpl<$Res, CompletionItem>;
  @useResult
  $Res call({
    String label,
    CompletionItemKind kind,
    String? detail,
    String? documentation,
    String? insertText,
    String? sortText,
    String? filterText,
    TextEdit? textEdit,
    bool preselect,
  });

  $TextEditCopyWith<$Res>? get textEdit;
}

/// @nodoc
class _$CompletionItemCopyWithImpl<$Res, $Val extends CompletionItem>
    implements $CompletionItemCopyWith<$Res> {
  _$CompletionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? kind = null,
    Object? detail = freezed,
    Object? documentation = freezed,
    Object? insertText = freezed,
    Object? sortText = freezed,
    Object? filterText = freezed,
    Object? textEdit = freezed,
    Object? preselect = null,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as CompletionItemKind,
            detail: freezed == detail
                ? _value.detail
                : detail // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentation: freezed == documentation
                ? _value.documentation
                : documentation // ignore: cast_nullable_to_non_nullable
                      as String?,
            insertText: freezed == insertText
                ? _value.insertText
                : insertText // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortText: freezed == sortText
                ? _value.sortText
                : sortText // ignore: cast_nullable_to_non_nullable
                      as String?,
            filterText: freezed == filterText
                ? _value.filterText
                : filterText // ignore: cast_nullable_to_non_nullable
                      as String?,
            textEdit: freezed == textEdit
                ? _value.textEdit
                : textEdit // ignore: cast_nullable_to_non_nullable
                      as TextEdit?,
            preselect: null == preselect
                ? _value.preselect
                : preselect // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of CompletionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextEditCopyWith<$Res>? get textEdit {
    if (_value.textEdit == null) {
      return null;
    }

    return $TextEditCopyWith<$Res>(_value.textEdit!, (value) {
      return _then(_value.copyWith(textEdit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompletionItemImplCopyWith<$Res>
    implements $CompletionItemCopyWith<$Res> {
  factory _$$CompletionItemImplCopyWith(
    _$CompletionItemImpl value,
    $Res Function(_$CompletionItemImpl) then,
  ) = __$$CompletionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    CompletionItemKind kind,
    String? detail,
    String? documentation,
    String? insertText,
    String? sortText,
    String? filterText,
    TextEdit? textEdit,
    bool preselect,
  });

  @override
  $TextEditCopyWith<$Res>? get textEdit;
}

/// @nodoc
class __$$CompletionItemImplCopyWithImpl<$Res>
    extends _$CompletionItemCopyWithImpl<$Res, _$CompletionItemImpl>
    implements _$$CompletionItemImplCopyWith<$Res> {
  __$$CompletionItemImplCopyWithImpl(
    _$CompletionItemImpl _value,
    $Res Function(_$CompletionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompletionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? kind = null,
    Object? detail = freezed,
    Object? documentation = freezed,
    Object? insertText = freezed,
    Object? sortText = freezed,
    Object? filterText = freezed,
    Object? textEdit = freezed,
    Object? preselect = null,
  }) {
    return _then(
      _$CompletionItemImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as CompletionItemKind,
        detail: freezed == detail
            ? _value.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentation: freezed == documentation
            ? _value.documentation
            : documentation // ignore: cast_nullable_to_non_nullable
                  as String?,
        insertText: freezed == insertText
            ? _value.insertText
            : insertText // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortText: freezed == sortText
            ? _value.sortText
            : sortText // ignore: cast_nullable_to_non_nullable
                  as String?,
        filterText: freezed == filterText
            ? _value.filterText
            : filterText // ignore: cast_nullable_to_non_nullable
                  as String?,
        textEdit: freezed == textEdit
            ? _value.textEdit
            : textEdit // ignore: cast_nullable_to_non_nullable
                  as TextEdit?,
        preselect: null == preselect
            ? _value.preselect
            : preselect // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CompletionItemImpl implements _CompletionItem {
  const _$CompletionItemImpl({
    required this.label,
    required this.kind,
    this.detail,
    this.documentation,
    this.insertText,
    this.sortText,
    this.filterText,
    this.textEdit,
    this.preselect = false,
  });

  @override
  final String label;
  @override
  final CompletionItemKind kind;
  @override
  final String? detail;
  @override
  final String? documentation;
  @override
  final String? insertText;
  @override
  final String? sortText;
  @override
  final String? filterText;
  @override
  final TextEdit? textEdit;
  @override
  @JsonKey()
  final bool preselect;

  @override
  String toString() {
    return 'CompletionItem(label: $label, kind: $kind, detail: $detail, documentation: $documentation, insertText: $insertText, sortText: $sortText, filterText: $filterText, textEdit: $textEdit, preselect: $preselect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionItemImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.documentation, documentation) ||
                other.documentation == documentation) &&
            (identical(other.insertText, insertText) ||
                other.insertText == insertText) &&
            (identical(other.sortText, sortText) ||
                other.sortText == sortText) &&
            (identical(other.filterText, filterText) ||
                other.filterText == filterText) &&
            (identical(other.textEdit, textEdit) ||
                other.textEdit == textEdit) &&
            (identical(other.preselect, preselect) ||
                other.preselect == preselect));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    label,
    kind,
    detail,
    documentation,
    insertText,
    sortText,
    filterText,
    textEdit,
    preselect,
  );

  /// Create a copy of CompletionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionItemImplCopyWith<_$CompletionItemImpl> get copyWith =>
      __$$CompletionItemImplCopyWithImpl<_$CompletionItemImpl>(
        this,
        _$identity,
      );
}

abstract class _CompletionItem implements CompletionItem {
  const factory _CompletionItem({
    required final String label,
    required final CompletionItemKind kind,
    final String? detail,
    final String? documentation,
    final String? insertText,
    final String? sortText,
    final String? filterText,
    final TextEdit? textEdit,
    final bool preselect,
  }) = _$CompletionItemImpl;

  @override
  String get label;
  @override
  CompletionItemKind get kind;
  @override
  String? get detail;
  @override
  String? get documentation;
  @override
  String? get insertText;
  @override
  String? get sortText;
  @override
  String? get filterText;
  @override
  TextEdit? get textEdit;
  @override
  bool get preselect;

  /// Create a copy of CompletionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletionItemImplCopyWith<_$CompletionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TextEdit {
  TextSelection get range => throw _privateConstructorUsedError;
  String get newText => throw _privateConstructorUsedError;

  /// Create a copy of TextEdit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextEditCopyWith<TextEdit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextEditCopyWith<$Res> {
  factory $TextEditCopyWith(TextEdit value, $Res Function(TextEdit) then) =
      _$TextEditCopyWithImpl<$Res, TextEdit>;
  @useResult
  $Res call({TextSelection range, String newText});

  $TextSelectionCopyWith<$Res> get range;
}

/// @nodoc
class _$TextEditCopyWithImpl<$Res, $Val extends TextEdit>
    implements $TextEditCopyWith<$Res> {
  _$TextEditCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextEdit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? range = null, Object? newText = null}) {
    return _then(
      _value.copyWith(
            range: null == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as TextSelection,
            newText: null == newText
                ? _value.newText
                : newText // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of TextEdit
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
abstract class _$$TextEditImplCopyWith<$Res>
    implements $TextEditCopyWith<$Res> {
  factory _$$TextEditImplCopyWith(
    _$TextEditImpl value,
    $Res Function(_$TextEditImpl) then,
  ) = __$$TextEditImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TextSelection range, String newText});

  @override
  $TextSelectionCopyWith<$Res> get range;
}

/// @nodoc
class __$$TextEditImplCopyWithImpl<$Res>
    extends _$TextEditCopyWithImpl<$Res, _$TextEditImpl>
    implements _$$TextEditImplCopyWith<$Res> {
  __$$TextEditImplCopyWithImpl(
    _$TextEditImpl _value,
    $Res Function(_$TextEditImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TextEdit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? range = null, Object? newText = null}) {
    return _then(
      _$TextEditImpl(
        range: null == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as TextSelection,
        newText: null == newText
            ? _value.newText
            : newText // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TextEditImpl implements _TextEdit {
  const _$TextEditImpl({required this.range, required this.newText});

  @override
  final TextSelection range;
  @override
  final String newText;

  @override
  String toString() {
    return 'TextEdit(range: $range, newText: $newText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextEditImpl &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.newText, newText) || other.newText == newText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, range, newText);

  /// Create a copy of TextEdit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextEditImplCopyWith<_$TextEditImpl> get copyWith =>
      __$$TextEditImplCopyWithImpl<_$TextEditImpl>(this, _$identity);
}

abstract class _TextEdit implements TextEdit {
  const factory _TextEdit({
    required final TextSelection range,
    required final String newText,
  }) = _$TextEditImpl;

  @override
  TextSelection get range;
  @override
  String get newText;

  /// Create a copy of TextEdit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextEditImplCopyWith<_$TextEditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
