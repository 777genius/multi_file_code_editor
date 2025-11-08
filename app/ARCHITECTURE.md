# Architecture Documentation

## Overview

This IDE application follows **Clean Architecture**, **Domain-Driven Design (DDD)**, and **SOLID** principles to ensure:

- ✅ Platform independence
- ✅ Easy testing
- ✅ Flexibility to swap implementations
- ✅ Clear separation of concerns

## Core Architectural Principles

### 1. **Dependency Rule**

Dependencies point **inward** - domain never depends on infrastructure:

```
Presentation → Application → Domain ← Infrastructure
```

- **Domain** defines interfaces (ports)
- **Infrastructure** implements interfaces (adapters)
- **Application** orchestrates use cases
- **Presentation** handles UI

### 2. **Platform Agnostic Domain**

The domain layer is **completely independent** of implementation details:

```dart
// Domain only knows about abstractions:
abstract class ICodeEditorRepository {
  Future<Either<EditorFailure, Unit>> setContent(String content);
}

// Infrastructure provides concrete implementations:
class MonacoEditorRepository implements ICodeEditorRepository { }
class NativeEditorRepository implements ICodeEditorRepository { }
```

### 3. **Ports and Adapters (Hexagonal Architecture)**

```
┌────────────────────────────────────────┐
│           Domain (Core)                │
│  ┌──────────────────────────────────┐ │
│  │  Entities, Value Objects         │ │
│  │  Business Logic                  │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  Ports (Interfaces)              │ │
│  │  - ICodeEditorRepository         │ │
│  │  - ILspClientRepository          │ │
│  └──────────────────────────────────┘ │
└───────────┬────────────────────────────┘
            │
            │ implements
            ▼
┌───────────────────────────────────────┐
│  Adapters (Infrastructure)            │
│  - MonacoEditorRepository             │
│  - WebSocketLspClientRepository       │
└───────────────────────────────────────┘
```

## Module Structure

### Editor Modules

#### **editor_core** (Domain)

**Responsibility:** Define WHAT the editor can do

**Key Components:**
- `ICodeEditorRepository` - Editor operations interface
- `EditorDocument` - Document entity
- `CursorPosition`, `TextSelection` - Value objects
- `LanguageId`, `DocumentUri` - Value objects
- `EditorTheme` - Theme entity
- `EditorFailure` - Failure types

**Dependencies:** None (pure domain)

**Example:**
```dart
// Platform-agnostic document
final document = EditorDocument(
  uri: DocumentUri.fromFilePath('/path/to/file.dart'),
  content: 'void main() {}',
  languageId: LanguageId.dart,
  lastModified: DateTime.now(),
);

// Platform-agnostic operation
await editorRepository.openDocument(document);
```

#### **editor_monaco** (Infrastructure Adapter)

**Responsibility:** Implement editor operations using Monaco

**Key Components:**
- `MonacoEditorRepository` - Implements `ICodeEditorRepository`
- `MonacoMappers` - Translates domain ↔ Monaco models

**Dependencies:**
- `editor_core` (domain abstractions)
- `flutter_monaco_crossplatform` (Monaco WebView)

**Example:**
```dart
class MonacoEditorRepository implements ICodeEditorRepository {
  final MonacoController _controller;

  @override
  Future<Either<EditorFailure, Unit>> setContent(String content) async {
    try {
      await _controller.setValue(content);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(...));
    }
  }
}
```

#### **editor_native** (Future Adapter)

**Responsibility:** Implement editor operations using Rust+Flutter

**Not yet implemented** - will look like:

```dart
class NativeEditorRepository implements ICodeEditorRepository {
  final RustEditorBridge _bridge;

  @override
  Future<Either<EditorFailure, Unit>> setContent(String content) async {
    await _bridge.setContent(content);  // Rust FFI
    return right(unit);
  }
}
```

### LSP Modules

#### **lsp_domain** (Domain)

**Responsibility:** Define WHAT LSP operations are available

**Key Components:**
- `ILspClientRepository` - LSP operations interface
- `LspSession` - Session aggregate root
- `CompletionList`, `CompletionItem` - Entities
- `Diagnostic`, `HoverInfo` - Entities
- `SessionId` - Value object
- `LspFailure` - Failure types

**Dependencies:**
- `editor_core` (shared domain types like `DocumentUri`, `CursorPosition`)

**Example:**
```dart
// Get completions (platform-agnostic)
final result = await lspRepository.getCompletions(
  sessionId: session.id,
  documentUri: DocumentUri.fromFilePath('/file.dart'),
  position: CursorPosition.create(line: 10, column: 5),
);

result.fold(
  (failure) => print('Error: $failure'),
  (completions) => print('Got ${completions.items.length} items'),
);
```

#### **lsp_application** (Application - Use Cases)

**Responsibility:** Orchestrate LSP operations

**To be implemented:**

```dart
class GetCompletionsUseCase {
  final ILspClientRepository _lspRepository;
  final ITextDocumentRepository _documentRepository;

  Future<Either<LspFailure, CompletionList>> call({
    required SessionId sessionId,
    required DocumentUri documentUri,
    required CursorPosition position,
  }) async {
    // 1. Get document content
    final documentResult = await _documentRepository.getDocument(documentUri);

    // 2. Request completions from LSP
    return documentResult.fold(
      (failure) => left(LspFailure.documentNotFound()),
      (document) => _lspRepository.getCompletions(...),
    );
  }
}
```

#### **lsp_infrastructure** (Infrastructure Adapter)

**Responsibility:** Implement LSP communication via WebSocket

**To be implemented:**

```dart
class WebSocketLspClientRepository implements ILspClientRepository {
  final WebSocketChannel _channel;
  final JsonRpcProtocolAdapter _protocol;

  @override
  Future<Either<LspFailure, CompletionList>> getCompletions(...) async {
    try {
      final response = await _protocol.sendRequest(
        method: 'textDocument/completion',
        params: {...},
      );

      return right(CompletionList.fromJson(response));
    } on LspException catch (e) {
      return left(LspFailure.requestFailed(...));
    }
  }
}
```

### External Service

#### **lsp_bridge** (Rust Server)

**Responsibility:** Bridge Flutter ↔ Native LSP servers

**Key Components:**
- `LspManager` - Manages LSP server processes
- `LspServerInstance` - Wraps individual LSP server
- `handle_client_connection` - WebSocket handler
- `JsonRpcRequest/Response` - Protocol types

**Technology:** Rust + Tokio + WebSocket

**Flow:**
```
1. Flutter connects to ws://127.0.0.1:9999
2. Sends initialize request with languageId
3. Bridge spawns LSP server process (e.g., dart analyzer)
4. Bridge forwards requests/responses
5. LSP server provides completions/diagnostics/etc.
```

## Data Flow

### Example: Get Code Completions

```
User types in Monaco Editor
         ↓
MonacoController.onContentChanged (Flutter)
         ↓
Detect completion trigger (e.g., ".")
         ↓
GetCompletionsUseCase (Application)
         ↓
ILspClientRepository.getCompletions() (Domain Interface)
         ↓
WebSocketLspClientRepository.getCompletions() (Infrastructure)
         ↓
WebSocket → Rust LSP Bridge (External Service)
         ↓
LSP Server (dart analyzer)
         ↓
Response flows back through layers
         ↓
Show completion UI in Monaco
```

## SOLID Principles Application

### Single Responsibility

Each module has one reason to change:
- `editor_core` - Changes when editor domain logic changes
- `editor_monaco` - Changes when Monaco integration changes
- `lsp_domain` - Changes when LSP domain logic changes

### Open/Closed

Open for extension, closed for modification:
- Want native editor? Create `editor_native` adapter
- Want HTTP LSP? Create `HttpLspClientRepository`
- Domain code doesn't change!

### Liskov Substitution

Any implementation of `ICodeEditorRepository` can replace another:

```dart
// Before
ICodeEditorRepository editor = MonacoEditorRepository();

// After
ICodeEditorRepository editor = NativeEditorRepository();

// Application code remains the same!
```

### Interface Segregation

Separate interfaces for different concerns:
- `ICodeEditorRepository` - Editor operations
- `ILspClientRepository` - LSP operations
- `ITextDocumentRepository` - Document storage

### Dependency Inversion

High-level modules depend on abstractions:

```dart
// High-level use case depends on interface, not implementation
class GetCompletionsUseCase {
  final ILspClientRepository _repository;  // ← abstraction

  GetCompletionsUseCase(this._repository);
}

// Dependency injection provides concrete implementation
final useCase = GetCompletionsUseCase(
  WebSocketLspClientRepository(),  // ← implementation
);
```

## DDD Tactical Patterns

### Entities

Objects with identity:
- `EditorDocument` - Identity: `DocumentUri`
- `LspSession` - Identity: `SessionId`
- `CompletionItem` - Part of aggregate

### Value Objects

Immutable objects without identity:
- `CursorPosition(line: 10, column: 5)`
- `LanguageId('dart')`
- `DocumentUri('file:///path/to/file.dart')`

### Aggregates

Consistency boundaries:
- `LspSession` (root) - Manages session lifecycle
- `CompletionList` - Collection of completion items

### Repositories (Ports)

Data access abstractions:
- `ICodeEditorRepository`
- `ILspClientRepository`

### Domain Services

Stateless operations:
- `ProtocolTranslator` - Translates LSP ↔ Domain
- `CompletionResolver` - Resolves completions

## Testing Strategy

### Unit Tests (Domain)

```dart
test('CursorPosition.isBefore works correctly', () {
  final pos1 = CursorPosition.create(line: 5, column: 10);
  final pos2 = CursorPosition.create(line: 5, column: 15);

  expect(pos1.isBefore(pos2), isTrue);
});
```

### Integration Tests (Application)

```dart
test('GetCompletionsUseCase returns completions', () async {
  final mockRepository = MockLspClientRepository();
  final useCase = GetCompletionsUseCase(mockRepository);

  when(() => mockRepository.getCompletions(...))
      .thenAnswer((_) async => right(CompletionList.empty));

  final result = await useCase(...);

  expect(result.isRight(), isTrue);
});
```

### Adapter Tests (Infrastructure)

```dart
test('MonacoEditorRepository sets content correctly', () async {
  final mockController = MockMonacoController();
  final repository = MonacoEditorRepository()..setController(mockController);

  when(() => mockController.setValue(any()))
      .thenAnswer((_) async => Future.value());

  final result = await repository.setContent('test content');

  expect(result.isRight(), isTrue);
  verify(() => mockController.setValue('test content')).called(1);
});
```

## Migration Path: Monaco → Native Rust

When ready to replace Monaco with Rust+Flutter:

1. **Create `editor_native` package**
2. **Implement `ICodeEditorRepository`**
3. **Swap in dependency injection:**

```dart
// main.dart

// Before (Monaco)
final editor = MonacoEditorRepository()..setController(monacoController);

// After (Native Rust)
final editor = NativeEditorRepository()..setBridge(rustBridge);

// Rest of the app doesn't change!
final controller = EditorController(editor);
```

**Zero changes** to:
- Domain logic
- Use cases
- UI (except widget swap)

## Performance Considerations

### Monaco (Current)

- ✅ Fast for files <10k lines
- ✅ Rich features out of the box
- ⚠️ Memory overhead (~200-400MB)
- ⚠️ Slower for very large files

### Rust+Flutter (Future)

- ✅ Fast for any file size
- ✅ Low memory (~30-100MB)
- ✅ Native performance
- ⚠️ More work to implement features

Both implementations share the **same domain logic**!

## Conclusion

This architecture provides:

- **Flexibility:** Swap Monaco with Rust without touching domain
- **Testability:** Mock repositories easily
- **Maintainability:** Clear boundaries between layers
- **Future-proof:** Add new editors/LSP clients without refactoring

**The domain layer is the heart** - it defines WHAT the IDE does, not HOW.

---

**Built with Clean Architecture, DDD, and SOLID principles** 🏛️
