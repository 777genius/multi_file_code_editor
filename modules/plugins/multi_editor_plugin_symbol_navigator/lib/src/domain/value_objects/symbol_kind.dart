import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbol_kind.freezed.dart';

/// Type of code symbol
@freezed
class SymbolKind with _$SymbolKind {
  const SymbolKind._();

  // Classes and types
  const factory SymbolKind.classDeclaration() = _ClassDeclaration;
  const factory SymbolKind.abstractClass() = _AbstractClass;
  const factory SymbolKind.mixin() = _Mixin;
  const factory SymbolKind.extension() = _Extension;
  const factory SymbolKind.enumDeclaration() = _EnumDeclaration;
  const factory SymbolKind.typedef() = _Typedef;

  // Functions and methods
  const factory SymbolKind.function() = _Function;
  const factory SymbolKind.method() = _Method;
  const factory SymbolKind.constructor() = _Constructor;
  const factory SymbolKind.getter() = _Getter;
  const factory SymbolKind.setter() = _Setter;

  // Fields and variables
  const factory SymbolKind.field() = _Field;
  const factory SymbolKind.property() = _Property;
  const factory SymbolKind.constant() = _Constant;
  const factory SymbolKind.variable() = _Variable;

  // Other
  const factory SymbolKind.enumValue() = _EnumValue;
  const factory SymbolKind.parameter() = _Parameter;

  /// Get icon code for Material Icons
  int get iconCode {
    return map(
      classDeclaration: (_) => 0xe3af, // Icons.class_
      abstractClass: (_) => 0xe3af, // Icons.class_
      mixin: (_) => 0xe8d4, // Icons.merge_type
      extension: (_) => 0xe5c5, // Icons.extension
      enumDeclaration: (_) => 0xe241, // Icons.format_list_numbered
      typedef: (_) => 0xe8de, // Icons.mode
      function: (_) => 0xe24d, // Icons.functions
      method: (_) => 0xe8f4, // Icons.flash_on
      constructor: (_) => 0xe869, // Icons.build
      getter: (_) => 0xe896, // Icons.arrow_downward
      setter: (_) => 0xe5c8, // Icons.arrow_upward
      field: (_) => 0xe14d, // Icons.square
      property: (_) => 0xe14d, // Icons.square
      constant: (_) => 0xe897, // Icons.brightness_low
      variable: (_) => 0xe86f, // Icons.data_object
      enumValue: (_) => 0xe5ca, // Icons.label
      parameter: (_) => 0xe3c9, // Icons.input
    );
  }

  /// Display name for UI
  String get displayName {
    return map(
      classDeclaration: (_) => 'Class',
      abstractClass: (_) => 'Abstract Class',
      mixin: (_) => 'Mixin',
      extension: (_) => 'Extension',
      enumDeclaration: (_) => 'Enum',
      typedef: (_) => 'Typedef',
      function: (_) => 'Function',
      method: (_) => 'Method',
      constructor: (_) => 'Constructor',
      getter: (_) => 'Getter',
      setter: (_) => 'Setter',
      field: (_) => 'Field',
      property: (_) => 'Property',
      constant: (_) => 'Constant',
      variable: (_) => 'Variable',
      enumValue: (_) => 'Enum Value',
      parameter: (_) => 'Parameter',
    );
  }

  /// Priority for sorting (lower = higher priority)
  int get priority {
    return map(
      classDeclaration: (_) => 1,
      abstractClass: (_) => 1,
      mixin: (_) => 2,
      extension: (_) => 3,
      enumDeclaration: (_) => 4,
      typedef: (_) => 5,
      constructor: (_) => 6,
      method: (_) => 7,
      getter: (_) => 8,
      setter: (_) => 9,
      function: (_) => 10,
      field: (_) => 11,
      property: (_) => 12,
      constant: (_) => 13,
      variable: (_) => 14,
      enumValue: (_) => 15,
      parameter: (_) => 16,
    );
  }
}
