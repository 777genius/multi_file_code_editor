import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/symbol_kind.dart';
import '../value_objects/symbol_location.dart';

part 'code_symbol.freezed.dart';
part 'code_symbol.g.dart';

/// A symbol in source code (class, function, method, field, etc.)
@freezed
class CodeSymbol with _$CodeSymbol {
  const CodeSymbol._();

  const factory CodeSymbol({
    /// Symbol name
    required String name,

    /// Symbol type
    required SymbolKind kind,

    /// Location in source code
    required SymbolLocation location,

    /// Parent symbol (for nested symbols like methods in a class)
    String? parentName,

    /// Child symbols (e.g., methods in a class)
    @Default([]) List<CodeSymbol> children,

    /// Additional metadata
    @Default({}) Map<String, dynamic> metadata,
  }) = _CodeSymbol;

  factory CodeSymbol.fromJson(Map<String, dynamic> json) =>
      _$CodeSymbolFromJson(json);

  /// Check if this symbol is a container (can have children)
  bool get isContainer {
    return kind.maybeMap(
      classDeclaration: (_) => true,
      abstractClass: (_) => true,
      mixin: (_) => true,
      extension: (_) => true,
      enumDeclaration: (_) => true,
      orElse: () => false,
    );
  }

  /// Get fully qualified name (with parent)
  String get qualifiedName {
    if (parentName != null) {
      return '$parentName.$name';
    }
    return name;
  }

  /// Get summary text for UI (e.g., "method MyClass.build()")
  String get summary {
    final kindStr = kind.displayName.toLowerCase();
    return '$kindStr $qualifiedName';
  }

  /// Add a child symbol
  CodeSymbol addChild(CodeSymbol child) {
    return copyWith(
      children: [...children, child],
    );
  }

  /// Sort children by location
  CodeSymbol sortChildren() {
    final sorted = [...children]
      ..sort((a, b) => a.location.startLine.compareTo(b.location.startLine));
    return copyWith(children: sorted);
  }

  /// Get all descendants recursively
  List<CodeSymbol> getAllDescendants() {
    final result = <CodeSymbol>[];
    for (final child in children) {
      result.add(child);
      result.addAll(child.getAllDescendants());
    }
    return result;
  }

  /// Find symbol at line
  CodeSymbol? findSymbolAtLine(int line) {
    if (location.containsLine(line)) {
      // Check children first (more specific)
      for (final child in children) {
        final found = child.findSymbolAtLine(line);
        if (found != null) return found;
      }
      return this;
    }
    return null;
  }
}

/// Sorted list of symbols for a file
@freezed
class SymbolTree with _$SymbolTree {
  const SymbolTree._();

  const factory SymbolTree({
    /// File path
    required String filePath,

    /// Root symbols (top-level declarations)
    @Default([]) List<CodeSymbol> symbols,

    /// Language detected
    required String language,

    /// Parse timestamp
    required DateTime timestamp,

    /// Parse duration in milliseconds
    int? parseDurationMs,
  }) = _SymbolTree;

  factory SymbolTree.fromJson(Map<String, dynamic> json) =>
      _$SymbolTreeFromJson(json);

  /// Get all symbols (flat list)
  List<CodeSymbol> getAllSymbols() {
    final result = <CodeSymbol>[];
    for (final symbol in symbols) {
      result.add(symbol);
      result.addAll(symbol.getAllDescendants());
    }
    return result;
  }

  /// Find symbol by name
  CodeSymbol? findSymbolByName(String name) {
    for (final symbol in getAllSymbols()) {
      if (symbol.name == name || symbol.qualifiedName == name) {
        return symbol;
      }
    }
    return null;
  }

  /// Find symbol at line
  CodeSymbol? findSymbolAtLine(int line) {
    for (final symbol in symbols) {
      final found = symbol.findSymbolAtLine(line);
      if (found != null) return found;
    }
    return null;
  }

  /// Get statistics
  Map<String, int> get statistics {
    final allSymbols = getAllSymbols();
    final stats = <String, int>{};
    for (final symbol in allSymbols) {
      final kindName = symbol.kind.displayName;
      stats[kindName] = (stats[kindName] ?? 0) + 1;
    }
    return stats;
  }

  /// Total symbol count
  int get totalCount => getAllSymbols().length;
}
