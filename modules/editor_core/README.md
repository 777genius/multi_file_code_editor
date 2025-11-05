# editor_core

Core domain layer for multi-file code editor package.

## Overview

This package contains the domain layer following Clean Architecture and DDD principles:

- **Domain Entities** - Core business objects (FileDocument, Folder, Project)
- **Value Objects** - Immutable validated values (FileName, FilePath, LanguageId)
- **Ports** - Interface definitions for repositories and services
- **Domain Failures** - Error types for domain operations

## Key Features

- ✅ Freezed immutable entities with JSON serialization
- ✅ Value objects with built-in validation
- ✅ Port interfaces for dependency inversion
- ✅ Domain-driven design patterns
- ✅ Zero UI dependencies (pure business logic)

## Architecture

```
editor_core/
├── domain/
│   ├── entities/         # Core business objects
│   ├── value_objects/    # Validated immutable values
│   └── failures/         # Domain error types
└── ports/                # Interface definitions
    ├── repositories/     # Data access interfaces
    ├── services/         # Business service interfaces
    └── events/           # Event bus interfaces
```

## Domain Entities

### FileDocument

Represents a code file with content and metadata.

```dart
final file = FileDocument(
  id: '123',
  name: 'main.dart',
  folderId: 'folder-1',
  content: 'void main() {}',
  language: 'dart',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

### Folder

Represents a folder in the file tree.

```dart
final folder = Folder(
  id: 'folder-1',
  name: 'src',
  parentId: null, // root folder
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

### FileTreeNode

Hierarchical tree structure for file navigation.

```dart
final treeNode = FileTreeNode.folder(
  id: 'folder-1',
  name: 'src',
  children: [
    FileTreeNode.file(
      id: 'file-1',
      name: 'main.dart',
      language: 'dart',
    ),
  ],
);
```

## Value Objects

Value objects provide validation and type safety:

- **FileName** - Validated file name (no special characters, max length)
- **FilePath** - Validated file path
- **LanguageId** - Supported programming language identifier
- **FileContent** - File content with size validation

## Ports (Interfaces)

### Repositories

```dart
abstract class FileRepository {
  Future<FileDocument> create({required String folderId, required String name});
  Future<FileDocument> load(String id);
  Future<void> save(FileDocument file);
  Future<void> delete(String id);
  Stream<FileDocument> watch(String id);
}
```

### Services

```dart
abstract class ValidationService {
  bool isValidFileName(String name);
  bool isValidPath(String path);
}

abstract class LanguageDetector {
  String detectLanguage(String fileName);
}
```

## Usage

This package is meant to be used as a dependency by other packages in the monorepo:

```yaml
dependencies:
  editor_core:
    path: ../editor_core
```

## Development

```bash
# Get dependencies
flutter pub get

# Run build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test
```

## License

BSD-3-Clause
