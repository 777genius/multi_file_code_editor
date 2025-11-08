# Monaco Editor Adapter

Monaco-based implementation of the `ICodeEditorRepository` interface from `editor_core`.

## Architecture

This package is an **adapter** in the Clean Architecture sense:

```
┌──────────────────────────────────────┐
│   Domain (editor_core)               │
│   - ICodeEditorRepository (port)     │
└──────────────┬───────────────────────┘
               │ implements
               │
┌──────────────▼───────────────────────┐
│   Infrastructure (editor_monaco)     │
│   - MonacoEditorRepository (adapter) │
│   - MonacoMappers                    │
└──────────────────────────────────────┘
```

## Why This Design?

✅ **Easy to Replace:** Swap Monaco with Rust+Flutter editor by creating a new adapter
✅ **Domain Independence:** Core business logic doesn't depend on Monaco
✅ **Testability:** Mock `ICodeEditorRepository` in tests
✅ **Flexibility:** Support multiple editor backends simultaneously

## Usage

```dart
import 'package:editor_monaco/editor_monaco.dart';
import 'package:editor_core/editor_core.dart';

// Create the adapter
final editorRepository = MonacoEditorRepository();

// Initialize with Monaco controller
editorRepository.setController(monacoController);
await editorRepository.initialize();

// Use domain operations (platform-agnostic!)
final document = EditorDocument(
  uri: DocumentUri.fromFilePath('/path/to/file.dart'),
  content: 'void main() {}',
  languageId: LanguageId.dart,
  lastModified: DateTime.now(),
);

await editorRepository.openDocument(document);
await editorRepository.setTheme(EditorTheme.dark);
```

## Replacing Monaco with Rust+Flutter

To create a native editor implementation:

1. **Create `editor_native` package**
2. **Implement `ICodeEditorRepository`:**

```dart
// app/modules/editor_native/lib/src/native_editor_repository.dart
class NativeEditorRepository implements ICodeEditorRepository {
  final RustEditorBridge _bridge;

  @override
  Future<Either<EditorFailure, Unit>> setContent(String content) async {
    // Call Rust FFI
    await _bridge.setContent(content);
    return right(unit);
  }

  // Implement other methods...
}
```

3. **Swap in dependency injection:**

```dart
// Before (Monaco)
final editor = MonacoEditorRepository();

// After (Native Rust)
final editor = NativeEditorRepository();

// Application code doesn't change! Both implement ICodeEditorRepository
```

## Current Limitations

Some Monaco operations require JS bridge (not yet available in `flutter_monaco_crossplatform`):

- ❌ `getCursorPosition()` - No API exposure
- ❌ `getSelection()` - No API exposure
- ❌ `insertText()` - Requires JS bridge
- ❌ `getTheme()` - Monaco doesn't expose current theme

These will be implemented when `flutter_monaco_crossplatform` adds:
- JavaScript evaluation API
- More event streams (cursor, selection)

## Dependencies

- `editor_core` - Domain abstractions (platform-agnostic)
- `flutter_monaco_crossplatform` - Monaco WebView integration
