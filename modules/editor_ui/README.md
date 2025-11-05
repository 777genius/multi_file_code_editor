# editor_ui

UI layer for multi-file code editor package - widgets, controllers, and state management.

## Overview

This package provides the presentation layer following Clean Architecture principles:

- **State Management** - ValueNotifier-based controllers with Freezed states
- **Controllers** - EditorController, FileTreeController
- **Widgets** - Monaco code editor, File tree, Dialogs, Scaffold
- **Drag & Drop** - Multi-platform drag and drop support

## Key Features

- ✅ ValueNotifier state management (zero external dependencies)
- ✅ Freezed immutable state classes
- ✅ Monaco code editor integration
- ✅ Animated file tree with unlimited nesting
- ✅ Drag & drop file operations
- ✅ Horizontal scroll for deep folder structures
- ✅ Clean Architecture separation

## Architecture

```
editor_ui/
├── state/                # Freezed state classes
│   ├── editor_state.dart
│   └── file_tree_state.dart
├── controllers/          # ValueNotifier controllers
│   ├── editor_controller.dart
│   └── file_tree_controller.dart
└── widgets/
    ├── code_editor/      # Monaco editor widget
    ├── file_tree/        # Tree view widget
    ├── dialogs/          # Create/rename dialogs
    └── scaffold/         # Main layout scaffold
```

## State Management

We use **ValueNotifier** for state management - Flutter's native reactivity with zero dependencies.

### EditorState

```dart
sealed class EditorState with _$EditorState {
  const factory EditorState.initial() = _Initial;
  const factory EditorState.loading() = _Loading;
  const factory EditorState.loaded({
    required FileDocument file,
    @Default(false) bool isDirty,
    @Default(false) bool isSaving,
  }) = _Loaded;
  const factory EditorState.error({required String message}) = _Error;
}
```

### FileTreeState

```dart
sealed class FileTreeState with _$FileTreeState {
  const factory FileTreeState.initial() = _Initial;
  const factory FileTreeState.loading() = _Loading;
  const factory FileTreeState.loaded({
    required FileTreeNode rootNode,
    String? selectedFileId,
    @Default([]) List<String> expandedFolderIds,
  }) = _Loaded;
  const factory FileTreeState.error({required String message}) = _Error;
}
```

## Controllers

### EditorController

Manages code editor state and file operations:

```dart
final controller = EditorController(
  fileRepository: fileRepository,
  eventBus: eventBus,
);

// Load file
await controller.loadFile('file-id');

// Update content (local only)
controller.updateContent('new content');

// Save file
await controller.save();

// Close file
controller.close();
```

### FileTreeController

Manages file tree state and operations:

```dart
final controller = FileTreeController(
  folderRepository: folderRepository,
  fileRepository: fileRepository,
  eventBus: eventBus,
);

// Start watching tree
await controller.startWatching();

// Create file
await controller.createFile(folderId: 'folder-1', name: 'main.dart');

// Create folder
await controller.createFolder(name: 'src', parentId: 'root');

// Delete file/folder
await controller.deleteFile('file-id');
await controller.deleteFolder('folder-id');

// Move file
await controller.moveFile('file-id', 'target-folder-id');

// Select file
controller.selectFile('file-id');

// Toggle folder
controller.toggleFolder('folder-id');
```

## Widgets

### MonacoCodeEditor

```dart
MonacoCodeEditor(
  code: 'void main() {}',
  language: 'dart',
  onChanged: (newCode) {
    // Handle code change
  },
  readOnly: false,
  theme: MonacoTheme.dark,
)
```

### FileTreeView

```dart
FileTreeView(
  controller: fileTreeController,
  onFileSelected: (fileId) {
    // Handle file selection
  },
  onFileMoved: (fileId, targetFolderId) {
    // Handle file moved
  },
)
```

### EditorScaffold

```dart
EditorScaffold(
  fileTreeController: fileTreeController,
  editorController: editorController,
  onFileSelected: (fileId) async {
    await editorController.loadFile(fileId);
  },
)
```

## Drag & Drop

Multi-platform drag and drop support:

- **Desktop** - Uses `desktop_drop` package
- **Web** - Uses `flutter_dropzone` package
- **Mobile** - Long press + drag gesture

## Usage

Add to your pubspec.yaml:

```yaml
dependencies:
  editor_ui:
    path: ../editor_ui
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
