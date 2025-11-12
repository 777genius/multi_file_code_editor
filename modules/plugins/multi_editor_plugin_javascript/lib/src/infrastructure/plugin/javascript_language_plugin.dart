import 'dart:async';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import '../data/javascript_snippets.dart';

/// JavaScript/ES6+ language plugin providing modern JavaScript language support.
///
/// Features:
/// - Syntax highlighting (via Monaco built-in)
/// - Bracket matching (via Monaco built-in)
/// - Modern JavaScript code snippets (42 snippets)
/// - Word-based autocomplete (via Monaco built-in)
/// - Support for ES6+ features (classes, modules, async/await, etc.)
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
/// final jsPlugin = JavaScriptLanguagePlugin();
/// await pluginManager.registerPlugin(jsPlugin);
/// ```
class JavaScriptLanguagePlugin extends LanguagePlugin {
  JavaScriptLanguagePlugin();

  EditorService? _editorService;
  Timer? _snippetRegistrationDebounce;
  bool _snippetsRegistered = false;

  @override
  PluginManifest get manifest => PluginManifestBuilder()
      .withId('javascript-language-support')
      .withName('JavaScript Language Support')
      .withVersion('1.0.0')
      .withDescription(
        'Modern JavaScript/ES6+ language support - syntax highlighting, snippets, and code completion',
      )
      .withAuthor('Multi-File Code Editor')
      .withCapability('language', 'javascript')
      .withCapability('snippets', 'true')
      .withCapability('syntax', 'true')
      .withCapability('autocomplete', 'true')
      .addActivationEvent('onLanguage:javascript')
      .build();

  @override
  String get languageId => 'javascript';

  @override
  List<String> get fileExtensions => ['.js', '.jsx', '.mjs', '.cjs'];

  @override
  Future<void> initialize(PluginContext context) async {
    print('[JavaScriptPlugin] Initializing JavaScript language support...');

    // Get EditorService from context (type-safe)
    _editorService = context.getService<EditorService>();

    if (_editorService == null) {
      print('[JavaScriptPlugin] EditorService not registered in context');
      print(
        '[JavaScriptPlugin] Snippets will be registered when editor becomes available',
      );
      return;
    }

    // Check if editor is currently available
    if (!_editorService!.isAvailable) {
      print('[JavaScriptPlugin] Editor not available yet');
      print(
        '[JavaScriptPlugin] Snippets will be registered when a file is opened',
      );
      return;
    }

    // Register snippets with editor (with debouncing)
    _scheduleSnippetRegistration();
  }

  @override
  Future<List<SnippetData>> provideSnippets() async {
    return JavaScriptSnippets.all;
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
        '[JavaScriptPlugin] Editor not available for snippet registration',
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
        '[JavaScriptPlugin] Prepared ${snippets.length} JavaScript snippets (registration pending)',
      );
    } catch (e, stack) {
      print('[JavaScriptPlugin] Error preparing snippets: $e\n$stack');
    }
  }

  @override
  void onFileOpen(FileDocument file) {
    if (supportsLanguage(file.language)) {
      print('[JavaScriptPlugin] JavaScript file opened: ${file.name}');

      // Try to register snippets if not already done (with debouncing)
      if (!_snippetsRegistered) {
        _scheduleSnippetRegistration();
      }
    }
  }

  @override
  void onFileSave(FileDocument file) {
    if (supportsLanguage(file.language)) {
      print('[JavaScriptPlugin] JavaScript file saved: ${file.name}');
    }
  }

  @override
  Future<void> dispose() async {
    print('[JavaScriptPlugin] Disposing JavaScript language support');

    // Cancel pending debounce timer
    _snippetRegistrationDebounce?.cancel();
    _snippetRegistrationDebounce = null;

    _editorService = null;
    _snippetsRegistered = false;
  }
}
