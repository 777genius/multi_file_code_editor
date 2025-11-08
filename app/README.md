# Multi-Editor IDE Application

Full-featured IDE application built with Clean Architecture, DDD, and SOLID principles.

## 🏗️ Architecture Overview

This application follows **Clean Architecture** with strict layer separation:

```
┌────────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                        │
│                  (Flutter Widgets, UI)                      │
└──────────────────────┬─────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────┐
│                  APPLICATION LAYER                          │
│              (Use Cases, App Services)                      │
└──────────────────────┬─────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────┐
│                    DOMAIN LAYER                             │
│    (Entities, Value Objects, Repository Interfaces)        │
└──────────────────────┬─────────────────────────────────────┘
                       │ implements
┌──────────────────────▼─────────────────────────────────────┐
│                INFRASTRUCTURE LAYER                         │
│           (Adapters, External Services)                     │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Modular Structure

All modules are independent and follow Clean Architecture:

### Core Editor Modules

#### **editor_core** (Domain Layer)
- **Purpose:** Platform-agnostic editor abstractions
- **Key Interface:** `ICodeEditorRepository`
- **No Dependencies** on Monaco, Rust, or any specific implementation
- **Location:** `app/modules/editor_core`

**Why?** You can swap Monaco with Rust+Flutter native editor without changing domain logic!

```dart
// Domain only knows about this interface:
abstract class ICodeEditorRepository {
  Future<Either<EditorFailure, Unit>> setContent(String content);
  Future<Either<EditorFailure, String>> getContent();
  Future<Either<EditorFailure, Unit>> setLanguage(LanguageId languageId);
  // ... more operations
}
```

#### **editor_monaco** (Infrastructure - Monaco Adapter)
- **Purpose:** Implements `ICodeEditorRepository` using Monaco Editor
- **Dependencies:** `editor_core`, `flutter_monaco_crossplatform`
- **Location:** `app/modules/editor_monaco`

```dart
class MonacoEditorRepository implements ICodeEditorRepository {
  // Translates domain operations to Monaco calls
}
```

#### **editor_native** (Infrastructure - Future Rust Adapter)
- **Purpose:** Implements `ICodeEditorRepository` using native Rust+Flutter
- **Location:** `app/modules/editor_native` (not yet created)

```dart
class NativeEditorRepository implements ICodeEditorRepository {
  // Translates domain operations to Rust FFI calls
}
```

### LSP Modules

#### **lsp_domain** (Domain Layer)
- **Purpose:** LSP abstractions (completions, diagnostics, hover)
- **Key Interface:** `ILspClientRepository`
- **Location:** `app/modules/lsp_domain`

```dart
abstract class ILspClientRepository {
  Future<Either<LspFailure, CompletionList>> getCompletions(...);
  Future<Either<LspFailure, HoverInfo>> getHoverInfo(...);
  Future<Either<LspFailure, List<Diagnostic>>> getDiagnostics(...);
}
```

#### **lsp_application** (Application Layer)
- **Purpose:** LSP use cases and application services
- **Location:** `app/modules/lsp_application` (to be created)

```dart
class GetCompletionsUseCase {
  Future<Either<LspFailure, CompletionList>> call(...);
}

class LspSessionService {
  // Manages LSP sessions lifecycle
}
```

#### **lsp_infrastructure** (Infrastructure Layer)
- **Purpose:** LSP client implementation (WebSocket, JSON-RPC)
- **Location:** `app/modules/lsp_infrastructure` (to be created)

```dart
class WebSocketLspClientRepository implements ILspClientRepository {
  // Communicates with Rust LSP Bridge via WebSocket
}
```

## 🔑 Key Architectural Principles

### 1. **Dependency Inversion Principle (DIP)**

Domain defines interfaces, infrastructure implements them:

```
editor_core (Domain)
    ↑ depends on
    |
editor_monaco (Infrastructure)
```

### 2. **Platform Agnostic Domain**

Domain models work with ANY editor implementation:

```dart
// This code works with Monaco, Rust, or any future editor:
final document = EditorDocument(
  uri: DocumentUri.fromFilePath('/path/to/file.dart'),
  content: 'void main() {}',
  languageId: LanguageId.dart,
);

await editorRepository.openDocument(document);
```

### 3. **Easy Swapping**

To replace Monaco with Rust:

```dart
// Before:
final editor = MonacoEditorRepository();

// After:
final editor = NativeEditorRepository();

// Application code doesn't change!
```

## 🚀 Benefits

✅ **Testability:** Mock repositories in tests
✅ **Flexibility:** Swap implementations easily
✅ **Maintainability:** Clear separation of concerns
✅ **Future-proof:** Add new editors without changing domain
✅ **Type Safety:** Freezed sealed classes, compile-time guarantees

## 📖 Module Dependencies

```
lsp_application
    ↓ depends on
lsp_domain ← implements ← lsp_infrastructure
    ↓
editor_core ← implements ← editor_monaco
```

## 🔧 External Services

### Rust LSP Bridge Server

Separate Rust server managing LSP server processes:

- **Location:** `app/modules/lsp_bridge` (Rust project)
- **Purpose:** Bridge between Flutter and native LSP servers
- **Protocol:** WebSocket (JSON-RPC)

```
Flutter App
    ↓ WebSocket
Rust LSP Bridge
    ↓ stdio/TCP
LSP Servers (dart analyzer, typescript-ls, etc.)
```

## 📝 Development

```bash
# Bootstrap all modules
melos bootstrap

# Run build_runner for freezed
melos run build_runner

# Analyze all modules
melos run analyze

# Run tests
melos run test
```

## 🎯 Next Steps

1. ✅ Create editor_core (Domain)
2. ✅ Create editor_monaco (Adapter)
3. ✅ Create lsp_domain (Domain)
4. ⏳ Create lsp_application (Use Cases)
5. ⏳ Create lsp_infrastructure (LSP Client)
6. ⏳ Create Rust LSP Bridge server
7. ⏳ Create main IDE application

---

**Built with Clean Architecture, DDD, and SOLID principles** 🏛️
