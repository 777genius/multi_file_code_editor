import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_theme.freezed.dart';

/// Represents an editor theme.
/// Platform-agnostic - can be mapped to Monaco themes, native themes, etc.
@freezed
class EditorTheme with _$EditorTheme {
  const factory EditorTheme({
    required String id,
    required String name,
    required ThemeMode mode,
  }) = _EditorTheme;

  const EditorTheme._();

  /// Predefined light theme
  static const light = EditorTheme(
    id: 'light',
    name: 'Light',
    mode: ThemeMode.light,
  );

  /// Predefined dark theme
  static const dark = EditorTheme(
    id: 'dark',
    name: 'Dark',
    mode: ThemeMode.dark,
  );

  /// High contrast theme
  static const highContrast = EditorTheme(
    id: 'high-contrast',
    name: 'High Contrast',
    mode: ThemeMode.dark,
  );

  /// List of all default themes
  static const List<EditorTheme> defaults = [
    light,
    dark,
    highContrast,
  ];
}

enum ThemeMode {
  light,
  dark,
}
