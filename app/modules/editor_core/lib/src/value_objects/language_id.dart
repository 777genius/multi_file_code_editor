import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_id.freezed.dart';

/// Represents a programming language identifier.
/// Platform-agnostic - can be mapped to Monaco languages, LSP languages, etc.
@freezed
class LanguageId with _$LanguageId {
  const factory LanguageId(String value) = _LanguageId;

  const LanguageId._();

  // Predefined language IDs
  static const dart = LanguageId('dart');
  static const javascript = LanguageId('javascript');
  static const typescript = LanguageId('typescript');
  static const python = LanguageId('python');
  static const rust = LanguageId('rust');
  static const go = LanguageId('go');
  static const java = LanguageId('java');
  static const cpp = LanguageId('cpp');
  static const csharp = LanguageId('csharp');
  static const html = LanguageId('html');
  static const css = LanguageId('css');
  static const json = LanguageId('json');
  static const yaml = LanguageId('yaml');
  static const markdown = LanguageId('markdown');
  static const plaintext = LanguageId('plaintext');

  /// Detects language from file extension
  static LanguageId fromFileExtension(String extension) {
    final normalized = extension.toLowerCase().replaceFirst('.', '');
    return switch (normalized) {
      'dart' => dart,
      'js' || 'mjs' => javascript,
      'ts' => typescript,
      'py' => python,
      'rs' => rust,
      'go' => go,
      'java' => java,
      'cpp' || 'cc' || 'cxx' || 'c++' => cpp,
      'cs' => csharp,
      'html' || 'htm' => html,
      'css' => css,
      'json' => json,
      'yaml' || 'yml' => yaml,
      'md' => markdown,
      _ => plaintext,
    };
  }

  /// Detects language from file name
  static LanguageId fromFileName(String fileName) {
    final parts = fileName.split('.');
    if (parts.length > 1) {
      return fromFileExtension(parts.last);
    }
    return plaintext;
  }
}
