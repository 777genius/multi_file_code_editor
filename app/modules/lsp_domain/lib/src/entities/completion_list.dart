import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:editor_core/editor_core.dart';

part 'completion_list.freezed.dart';

/// Represents a list of completion items from LSP.
@freezed
class CompletionList with _$CompletionList {
  const factory CompletionList({
    required List<CompletionItem> items,
    @Default(false) bool isIncomplete,
  }) = _CompletionList;

  const CompletionList._();

  /// Empty completion list
  static const empty = CompletionList(items: []);

  /// Filters completions by prefix
  CompletionList filterByPrefix(String prefix) {
    if (prefix.isEmpty) return this;

    final filtered = items.where((item) =>
        item.label.toLowerCase().startsWith(prefix.toLowerCase())).toList();

    return copyWith(items: filtered);
  }

  /// Sorts completions by relevance
  CompletionList sortByRelevance() {
    final sorted = [...items]..sort((a, b) {
      // Sort by sortText if available, otherwise by label
      final aSort = a.sortText ?? a.label;
      final bSort = b.sortText ?? b.label;
      return aSort.compareTo(bSort);
    });

    return copyWith(items: sorted);
  }
}

@freezed
class CompletionItem with _$CompletionItem {
  const factory CompletionItem({
    required String label,
    required CompletionItemKind kind,
    String? detail,
    String? documentation,
    String? insertText,
    String? sortText,
    String? filterText,
    TextEdit? textEdit,
    @Default(false) bool preselect,
  }) = _CompletionItem;
}

enum CompletionItemKind {
  text,
  method,
  function,
  constructor,
  field,
  variable,
  class_,
  interface,
  module,
  property,
  unit,
  value,
  enum_,
  keyword,
  snippet,
  color,
  file,
  reference,
  folder,
  enumMember,
  constant,
  struct,
  event,
  operator,
  typeParameter,
}

@freezed
class TextEdit with _$TextEdit {
  const factory TextEdit({
    required TextSelection range,
    required String newText,
  }) = _TextEdit;
}
