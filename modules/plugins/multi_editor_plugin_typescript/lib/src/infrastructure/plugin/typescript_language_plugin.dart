import 'dart:async';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import '../data/typescript_snippets.dart';

/// TypeScript language plugin providing comprehensive TypeScript language support.
///
/// Features:
/// - Syntax highlighting (via Monaco built-in)
/// - Bracket matching (via Monaco built-in)
/// - TypeScript code snippets (50 snippets)
/// - Word-based autocomplete (via Monaco built-in)
/// - Support for types, interfaces, generics, decorators
///
/// This plugin has NO Flutter dependencies and works in any Dart environment.
///
/// ## Architecture:
/// - Uses PluginManifestBuilder for cleaner manifest definition
/// - Debounces snippet registration to avoid redundant calls
/// - Clean separation from UI concerns
///
/// ## Usage:
/// ```dart
/// final tsPlugin = TypeScriptLanguagePlugin();
/// await pluginManager.registerPlugin(tsPlugin);
/// ```
class TypeScriptLanguagePlugin extends LanguagePlugin {
  TypeScriptLanguagePlugin();

  EditorService? _editorService;
  Timer? _snippetRegistrationDebounce;
  bool _snippetsRegistered = false;

  @override
  PluginManifest get manifest => PluginManifestBuilder()
      .withId('typescript-language-support')
      .withName('TypeScript Language Support')
      .withVersion('1.0.0')
      .withDescription(
        'Comprehensive TypeScript language support - syntax highlighting, types, interfaces, generics, and code completion',
      )
      .withAuthor('Multi-File Code Editor')
      .withCapability('language', 'typescript')
      .withCapability('snippets', 'true')
      .withCapability('syntax', 'true')
      .withCapability('autocomplete', 'true')
      .addActivationEvent('onLanguage:typescript')
      .build();

  @override
  String get languageId => 'typescript';

  @override
  List<String> get fileExtensions => ['.ts', '.tsx'];

  @override
  Future<void> initialize(PluginContext context) async {
    print('[TypeScriptPlugin] Initializing TypeScript language support...');

    // Get EditorService from context (type-safe)
    _editorService = context.getService<EditorService>();

    if (_editorService == null) {
      print('[TypeScriptPlugin] EditorService not registered in context');
      print(
        '[TypeScriptPlugin] Snippets will be registered when editor becomes available',
      );
      return;
    }

    // Check if editor is currently available
    if (!_editorService!.isAvailable) {
      print('[TypeScriptPlugin] Editor not available yet');
      print(
        '[TypeScriptPlugin] Snippets will be registered when a file is opened',
      );
      return;
    }

    // Register snippets with editor (with debouncing)
    _scheduleSnippetRegistration();
  }

  @override
  Future<List<SnippetData>> provideSnippets() async {
    return TypeScriptSnippets.all;
  }

  /// Schedule snippet registration with debouncing to avoid redundant calls
  void _scheduleSnippetRegistration() {
    // Cancel existing timer if any
    _snippetRegistrationDebounce?.cancel();

    // Schedule new registration after 300ms delay
    _snippetRegistrationDebounce = Timer(
      const Duration(milliseconds: 300),
      () async {
        await _registerSnippets();
      },
    );
  }

  /// Register snippets with Monaco editor
  Future<void> _registerSnippets() async {
    // Skip if already registered or service unavailable
    if (_snippetsRegistered || _editorService == null) return;

    // Check if editor is available
    if (!_editorService!.isAvailable) {
      print(
        '[TypeScriptPlugin] Editor not available for snippet registration',
      );
      return;
    }

    try {
      final snippets = await provideSnippets();

      // Note: registerSnippets removed in flutter_monaco_crossplatform v1.0.1
      // TODO: Implement snippet registration using Monaco's completion API
      // See: https://microsoft.github.io/monaco-editor/api/interfaces/monaco.languages.CompletionItemProvider.html
      // await _editorService!.registerSnippets(languageId, snippets);

      _snippetsRegistered = true;
      print(
        '[TypeScriptPlugin] Prepared ${snippets.length} TypeScript snippets (registration pending)',
      );
    } catch (e, stack) {
      print('[TypeScriptPlugin] Error preparing snippets: $e\n$stack');
    }
  }

  @override
  void onFileOpen(FileDocument file) {
    if (supportsLanguage(file.language)) {
      print('[TypeScriptPlugin] TypeScript file opened: ${file.name}');

      // Try to register snippets if not already done (with debouncing)
      if (!_snippetsRegistered) {
        _scheduleSnippetRegistration();
      }
    }
  }

  @override
  void onFileSave(FileDocument file) {
    if (supportsLanguage(file.language)) {
      print('[TypeScriptPlugin] TypeScript file saved: ${file.name}');
    }
  }

  @override
  Future<void> dispose() async {
    print('[TypeScriptPlugin] Disposing TypeScript language support');

    // Cancel pending debounce timer
    _snippetRegistrationDebounce?.cancel();
    _snippetRegistrationDebounce = null;

    _editorService = null;
    _snippetsRegistered = false;
  }
}
