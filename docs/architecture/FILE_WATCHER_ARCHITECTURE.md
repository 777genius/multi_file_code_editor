# File Watcher & Hot Reload - Architecture Design

## 📋 Overview

File Watcher module provides real-time file system monitoring with automatic conflict resolution, hot reload capabilities, and external change synchronization. Built with Clean Architecture, DDD, and SOLID principles.

---

## 🎯 Core Requirements

### Functional Requirements
1. **Real-time File Monitoring**
   - Watch directories recursively
   - Detect file creation, modification, deletion, rename
   - Filter by patterns (include/exclude)
   - Debouncing for rapid changes

2. **Conflict Resolution**
   - Detect conflicts between editor state and disk state
   - Offer resolution strategies (keep editor, reload from disk, merge)
   - Preserve unsaved changes
   - Atomic file operations

3. **Hot Reload**
   - Automatic reload of modified files
   - Smart reload (only if not dirty in editor)
   - Preserve cursor position and scroll
   - Undo/Redo history preservation option

4. **External Change Synchronization**
   - Git operations (pull, checkout, merge)
   - External editor modifications
   - Build tool generated files
   - Node_modules / dependency changes

### Non-Functional Requirements
1. **Performance**: <10ms event processing, batching for bulk changes
2. **Reliability**: No missed events, guaranteed delivery
3. **Scalability**: Handle 100k+ files in workspace
4. **Resource Efficiency**: Low CPU/memory usage
5. **Testability**: 100% unit test coverage

---

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌────────────────┐  ┌───────────────┐  ┌────────────────┐ │
│  │ FileConflict   │  │  HotReload    │  │ ExternalChange │ │
│  │    Dialog      │  │   Indicator   │  │    Banner      │ │
│  └────────────────┘  └───────────────┘  └────────────────┘ │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         FileWatcherController (State Management)     │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │ uses
┌────────────────────────▼────────────────────────────────────┐
│                   APPLICATION LAYER                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                   Application Services                │   │
│  │  • FileWatcherService (orchestration)                 │   │
│  │  • ConflictResolverService (conflict logic)           │   │
│  │  • HotReloadService (reload coordination)             │   │
│  │  • FileEventAggregatorService (event batching)        │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                      Use Cases                        │   │
│  │  • StartWatchingUseCase                               │   │
│  │  • StopWatchingUseCase                                │   │
│  │  • HandleFileChangeUseCase                            │   │
│  │  • ResolveConflictUseCase                             │   │
│  │  • ReloadFileUseCase                                  │   │
│  │  • BatchReloadFilesUseCase                            │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │ depends on (interfaces only)
┌────────────────────────▼────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                   Domain Entities                     │   │
│  │  • FileWatchSession (Aggregate Root)                  │   │
│  │  • FileChangeEvent (Entity)                           │   │
│  │  • FileConflict (Entity)                              │   │
│  │  • WatchedDirectory (Entity)                          │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                   Value Objects                       │   │
│  │  • FilePath                                           │   │
│  │  • FileEventType (Created/Modified/Deleted/Renamed)   │   │
│  │  • WatchPattern (include/exclude patterns)            │   │
│  │  • ConflictResolutionStrategy                         │   │
│  │  • FileHash (content hash for change detection)       │   │
│  │  • WatchSessionId                                     │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                Repository Interfaces                  │   │
│  │  • IFileWatcherRepository (watch operations)          │   │
│  │  • IFileSystemRepository (file I/O)                   │   │
│  │  • IFileStateRepository (editor state)                │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                   Domain Events                       │   │
│  │  • FileChangedDomainEvent                             │   │
│  │  • ConflictDetectedDomainEvent                        │   │
│  │  • ConflictResolvedDomainEvent                        │   │
│  │  • WatchSessionStartedDomainEvent                     │   │
│  │  • WatchSessionStoppedDomainEvent                     │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                  Domain Services                      │   │
│  │  • FileConflictDetector                               │   │
│  │  • FileHashCalculator                                 │   │
│  │  • PatternMatcher                                     │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │ implemented by
┌────────────────────────▼────────────────────────────────────┐
│                 INFRASTRUCTURE LAYER                         │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Repository Implementations               │   │
│  │  • DartFileWatcherRepository (dart:io watcher)        │   │
│  │  • NativeFileWatcherRepository (OS events - future)   │   │
│  │  • FileSystemRepositoryImpl (dart:io File ops)        │   │
│  │  • EditorFileStateRepository (editor state access)    │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                    Adapters                           │   │
│  │  • WatcherPackageAdapter (watcher package)            │   │
│  │  • FSEventsAdapter (macOS native - future)            │   │
│  │  • INotifyAdapter (Linux native - future)             │   │
│  │  • ReadDirectoryChangesAdapter (Windows - future)     │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                Event Infrastructure                   │   │
│  │  • FileEventQueue (buffering)                         │   │
│  │  • FileEventDebouncer (timing)                        │   │
│  │  • FileEventBatcher (grouping)                        │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 Domain Layer Design

### 1. Aggregate Root: FileWatchSession

```dart
/// Aggregate root managing a file watching session
/// Invariants:
/// - Session must have at least one watched directory
/// - Cannot watch same path twice in same session
/// - Session must be started before receiving events
@freezed
class FileWatchSession with _$FileWatchSession {
  const FileWatchSession._();

  const factory FileWatchSession({
    required WatchSessionId id,
    required Set<WatchedDirectory> watchedDirectories,
    required WatchSessionState state,
    required DateTime startedAt,
    DateTime? stoppedAt,
    required WatchConfiguration configuration,
    @Default([]) List<FileChangeEvent> pendingEvents,
  }) = _FileWatchSession;

  /// Domain logic: Can this session accept new events?
  bool canAcceptEvents() {
    return state == WatchSessionState.active && stoppedAt == null;
  }

  /// Domain logic: Should this file event be processed?
  bool shouldProcessEvent(FileChangeEvent event) {
    // Check if path matches any watched directory
    final matchesWatchedDir = watchedDirectories.any(
      (dir) => event.filePath.isUnder(dir.path)
    );

    if (!matchesWatchedDir) return false;

    // Apply include/exclude patterns
    return configuration.patterns.matches(event.filePath);
  }

  /// Domain logic: Add event to pending queue
  Either<FileWatcherFailure, FileWatchSession> addPendingEvent(
    FileChangeEvent event,
  ) {
    if (!canAcceptEvents()) {
      return left(
        FileWatcherFailure.sessionNotActive(sessionId: id),
      );
    }

    if (!shouldProcessEvent(event)) {
      return right(this); // Silently ignore
    }

    return right(
      copyWith(
        pendingEvents: [...pendingEvents, event],
      ),
    );
  }

  /// Domain logic: Clear processed events
  FileWatchSession clearPendingEvents() {
    return copyWith(pendingEvents: []);
  }
}

/// Session lifecycle states
enum WatchSessionState {
  initializing,
  active,
  paused,
  stopped,
  failed,
}

/// Configuration for watch session
@freezed
class WatchConfiguration with _$WatchConfiguration {
  const factory WatchConfiguration({
    @Default(true) bool recursive,
    @Default(Duration(milliseconds: 300)) Duration debounceDelay,
    @Default(100) int batchSize,
    required WatchPatternSet patterns,
    @Default(true) bool detectConflicts,
    @Default(ConflictResolutionStrategy.prompt)
    ConflictResolutionStrategy defaultResolution,
  }) = _WatchConfiguration;
}
```

### 2. Entity: FileChangeEvent

```dart
/// Represents a file system change event
/// Entity because each event has unique identity (timestamp + path)
@freezed
class FileChangeEvent with _$FileChangeEvent {
  const FileChangeEvent._();

  const factory FileChangeEvent({
    required FileEventId id,
    required FilePath filePath,
    required FileEventType type,
    required DateTime timestamp,
    FilePath? oldPath, // For rename events
    FileHash? contentHash,
    @Default(false) bool isExternal, // From git/external editor
  }) = _FileChangeEvent;

  /// Domain logic: Is this a rename event?
  bool get isRename => type == FileEventType.renamed && oldPath != null;

  /// Domain logic: Compare events for deduplication
  bool isSameAs(FileChangeEvent other) {
    return filePath == other.filePath &&
           type == other.type &&
           contentHash == other.contentHash;
  }

  /// Domain logic: Can this event be merged with another?
  bool canMergeWith(FileChangeEvent other) {
    // Multiple modifications can be merged into one
    return filePath == other.filePath &&
           type == FileEventType.modified &&
           other.type == FileEventType.modified;
  }
}

/// File event types
enum FileEventType {
  created,
  modified,
  deleted,
  renamed,
}
```

### 3. Entity: FileConflict

```dart
/// Represents a conflict between editor state and disk state
/// Entity with rich behavior for conflict resolution
@freezed
class FileConflict with _$FileConflict {
  const FileConflict._();

  const factory FileConflict({
    required ConflictId id,
    required FilePath filePath,
    required FileChangeEvent diskEvent,
    required EditorFileState editorState,
    required DateTime detectedAt,
    required ConflictType type,
    ConflictResolutionStrategy? appliedStrategy,
    DateTime? resolvedAt,
  }) = _FileConflict;

  /// Domain logic: Is this conflict resolved?
  bool get isResolved => appliedStrategy != null && resolvedAt != null;

  /// Domain logic: Can this conflict be auto-resolved?
  bool canAutoResolve() {
    switch (type) {
      case ConflictType.diskModifiedEditorClean:
        return true; // Safe to reload
      case ConflictType.diskModifiedEditorDirty:
        return false; // Need user input
      case ConflictType.diskDeletedEditorClean:
        return true; // Safe to close
      case ConflictType.diskDeletedEditorDirty:
        return false; // Need user input
      case ConflictType.diskCreatedEditorOpen:
        return false; // Ambiguous
    }
  }

  /// Domain logic: Get recommended resolution strategy
  ConflictResolutionStrategy getRecommendedStrategy() {
    switch (type) {
      case ConflictType.diskModifiedEditorClean:
        return ConflictResolutionStrategy.useDisk;
      case ConflictType.diskDeletedEditorClean:
        return ConflictResolutionStrategy.useDisk;
      default:
        return ConflictResolutionStrategy.prompt;
    }
  }

  /// Domain logic: Apply resolution strategy
  Either<FileWatcherFailure, FileConflict> resolve(
    ConflictResolutionStrategy strategy,
  ) {
    if (isResolved) {
      return left(
        FileWatcherFailure.conflictAlreadyResolved(conflictId: id),
      );
    }

    return right(
      copyWith(
        appliedStrategy: strategy,
        resolvedAt: DateTime.now(),
      ),
    );
  }
}

/// Types of file conflicts
enum ConflictType {
  diskModifiedEditorClean,    // Safe to reload
  diskModifiedEditorDirty,    // User has unsaved changes
  diskDeletedEditorClean,     // Safe to close
  diskDeletedEditorDirty,     // User has unsaved changes
  diskCreatedEditorOpen,      // Rare: same file opened
}

/// Conflict resolution strategies
@freezed
class ConflictResolutionStrategy with _$ConflictResolutionStrategy {
  const factory ConflictResolutionStrategy.useDisk() = _UseDisk;
  const factory ConflictResolutionStrategy.useEditor() = _UseEditor;
  const factory ConflictResolutionStrategy.prompt() = _Prompt;
  const factory ConflictResolutionStrategy.merge() = _Merge;
  const factory ConflictResolutionStrategy.ignore() = _Ignore;
}
```

### 4. Entity: WatchedDirectory

```dart
/// Represents a directory being watched
@freezed
class WatchedDirectory with _$WatchedDirectory {
  const WatchedDirectory._();

  const factory WatchedDirectory({
    required DirectoryPath path,
    required bool recursive,
    required WatchPriority priority,
    required DateTime addedAt,
    @Default(0) int eventCount,
  }) = _WatchedDirectory;

  /// Domain logic: Should this directory be watched with high priority?
  bool get isHighPriority => priority == WatchPriority.high;
}

enum WatchPriority {
  low,      // node_modules, build artifacts
  normal,   // regular source files
  high,     // currently open files, git-tracked files
}
```

### 5. Value Objects

```dart
/// File path value object with validation
@freezed
class FilePath with _$FilePath {
  const FilePath._();

  const factory FilePath({
    required String path,
  }) = _FilePath;

  /// Factory with validation
  factory FilePath.create(String path) {
    if (path.isEmpty) {
      throw FilePathValidationException('Path cannot be empty');
    }

    // Normalize path (remove trailing slashes, resolve ..)
    final normalized = _normalizePath(path);

    return FilePath(path: normalized);
  }

  /// Domain logic: Is this path under another path?
  bool isUnder(DirectoryPath directory) {
    return path.startsWith(directory.path);
  }

  /// Domain logic: Get relative path from directory
  String relativeTo(DirectoryPath directory) {
    if (!isUnder(directory)) {
      throw ArgumentError('Path is not under directory');
    }
    return path.substring(directory.path.length + 1);
  }

  /// Domain logic: Get file extension
  String get extension {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1) return '';
    return path.substring(lastDot + 1);
  }

  /// Domain logic: Get file name
  String get fileName {
    final lastSeparator = path.lastIndexOf('/');
    if (lastSeparator == -1) return path;
    return path.substring(lastSeparator + 1);
  }
}

/// Directory path value object
@freezed
class DirectoryPath with _$DirectoryPath {
  const DirectoryPath._();

  const factory DirectoryPath({
    required String path,
  }) = _DirectoryPath;

  factory DirectoryPath.create(String path) {
    if (path.isEmpty) {
      throw DirectoryPathValidationException('Path cannot be empty');
    }

    final normalized = _normalizePath(path);
    return DirectoryPath(path: normalized);
  }
}

/// File content hash for change detection
@freezed
class FileHash with _$FileHash {
  const FileHash._();

  const factory FileHash({
    required String hash,
    required FileHashAlgorithm algorithm,
  }) = _FileHash;

  /// Create hash from content
  factory FileHash.fromContent(
    String content, {
    FileHashAlgorithm algorithm = FileHashAlgorithm.sha256,
  }) {
    final bytes = utf8.encode(content);
    final digest = algorithm == FileHashAlgorithm.sha256
        ? sha256.convert(bytes)
        : md5.convert(bytes);

    return FileHash(
      hash: digest.toString(),
      algorithm: algorithm,
    );
  }

  /// Domain logic: Compare hashes
  bool matches(FileHash other) {
    return hash == other.hash && algorithm == other.algorithm;
  }
}

enum FileHashAlgorithm {
  md5,      // Fast, good enough for change detection
  sha256,   // More secure, slower
}

/// Watch pattern set for include/exclude
@freezed
class WatchPatternSet with _$WatchPatternSet {
  const WatchPatternSet._();

  const factory WatchPatternSet({
    @Default([]) List<WatchPattern> includePatterns,
    @Default([]) List<WatchPattern> excludePatterns,
  }) = _WatchPatternSet;

  /// Default patterns for typical projects
  factory WatchPatternSet.defaults() {
    return WatchPatternSet(
      includePatterns: [
        WatchPattern(pattern: '**/*.dart'),
        WatchPattern(pattern: '**/*.js'),
        WatchPattern(pattern: '**/*.ts'),
        WatchPattern(pattern: '**/*.tsx'),
        WatchPattern(pattern: '**/*.json'),
        WatchPattern(pattern: '**/*.yaml'),
        WatchPattern(pattern: '**/*.md'),
      ],
      excludePatterns: [
        WatchPattern(pattern: '**/node_modules/**'),
        WatchPattern(pattern: '**/.git/**'),
        WatchPattern(pattern: '**/build/**'),
        WatchPattern(pattern: '**/.dart_tool/**'),
        WatchPattern(pattern: '**/*.g.dart'), // Generated files
        WatchPattern(pattern: '**/*.freezed.dart'),
      ],
    );
  }

  /// Domain logic: Does this path match the pattern set?
  bool matches(FilePath filePath) {
    // First check excludes (higher priority)
    for (final pattern in excludePatterns) {
      if (pattern.matches(filePath.path)) {
        return false;
      }
    }

    // Then check includes (if no includes, match all)
    if (includePatterns.isEmpty) return true;

    for (final pattern in includePatterns) {
      if (pattern.matches(filePath.path)) {
        return true;
      }
    }

    return false;
  }
}

/// Individual watch pattern (glob)
@freezed
class WatchPattern with _$WatchPattern {
  const WatchPattern._();

  const factory WatchPattern({
    required String pattern,
  }) = _WatchPattern;

  /// Domain logic: Does this path match the pattern?
  bool matches(String path) {
    final glob = Glob(pattern);
    return glob.matches(path);
  }
}

/// Unique identifiers
@freezed
class WatchSessionId with _$WatchSessionId {
  const factory WatchSessionId(String value) = _WatchSessionId;

  factory WatchSessionId.generate() {
    return WatchSessionId(const Uuid().v4());
  }
}

@freezed
class FileEventId with _$FileEventId {
  const factory FileEventId(String value) = _FileEventId;

  factory FileEventId.generate() {
    return FileEventId(const Uuid().v4());
  }
}

@freezed
class ConflictId with _$ConflictId {
  const factory ConflictId(String value) = _ConflictId;

  factory ConflictId.generate() {
    return ConflictId(const Uuid().v4());
  }
}
```

### 6. Repository Interfaces (Domain Layer)

```dart
/// Repository for file watching operations
abstract class IFileWatcherRepository {
  /// Start watching a directory
  Future<Either<FileWatcherFailure, Stream<FileChangeEvent>>> watchDirectory({
    required DirectoryPath path,
    required bool recursive,
    required WatchPatternSet patterns,
  });

  /// Stop watching a directory
  Future<Either<FileWatcherFailure, Unit>> stopWatching({
    required DirectoryPath path,
  });

  /// Check if directory is being watched
  Future<bool> isWatching(DirectoryPath path);
}

/// Repository for file system operations
abstract class IFileSystemRepository {
  /// Read file content
  Future<Either<FileSystemFailure, String>> readFile(FilePath path);

  /// Write file content
  Future<Either<FileSystemFailure, Unit>> writeFile(
    FilePath path,
    String content,
  );

  /// Get file hash
  Future<Either<FileSystemFailure, FileHash>> getFileHash(FilePath path);

  /// Check if file exists
  Future<bool> fileExists(FilePath path);

  /// Get file modification time
  Future<Either<FileSystemFailure, DateTime>> getModificationTime(
    FilePath path,
  );
}

/// Repository for editor file state
abstract class IFileStateRepository {
  /// Get editor state for file
  Future<Either<EditorFailure, EditorFileState>> getFileState(
    FilePath path,
  );

  /// Check if file is dirty (has unsaved changes)
  Future<bool> isFileDirty(FilePath path);

  /// Reload file in editor
  Future<Either<EditorFailure, Unit>> reloadFile(
    FilePath path, {
    bool preserveCursor = true,
    bool preserveScroll = true,
  });

  /// Close file in editor
  Future<Either<EditorFailure, Unit>> closeFile(FilePath path);
}

/// Editor file state
@freezed
class EditorFileState with _$EditorFileState {
  const factory EditorFileState({
    required FilePath path,
    required bool isDirty,
    required bool isOpen,
    String? content,
    CursorPosition? cursorPosition,
    ScrollPosition? scrollPosition,
    FileHash? contentHash,
  }) = _EditorFileState;
}
```

### 7. Domain Services

```dart
/// Domain service for detecting file conflicts
class FileConflictDetector {
  /// Detect conflict between disk event and editor state
  Option<FileConflict> detectConflict({
    required FileChangeEvent diskEvent,
    required EditorFileState editorState,
  }) {
    // File doesn't exist in editor - no conflict
    if (!editorState.isOpen) {
      return none();
    }

    final conflictType = _determineConflictType(diskEvent, editorState);

    // No conflict if types don't conflict
    if (conflictType == null) {
      return none();
    }

    return some(
      FileConflict(
        id: ConflictId.generate(),
        filePath: diskEvent.filePath,
        diskEvent: diskEvent,
        editorState: editorState,
        detectedAt: DateTime.now(),
        type: conflictType,
      ),
    );
  }

  ConflictType? _determineConflictType(
    FileChangeEvent diskEvent,
    EditorFileState editorState,
  ) {
    switch (diskEvent.type) {
      case FileEventType.modified:
        return editorState.isDirty
            ? ConflictType.diskModifiedEditorDirty
            : ConflictType.diskModifiedEditorClean;

      case FileEventType.deleted:
        return editorState.isDirty
            ? ConflictType.diskDeletedEditorDirty
            : ConflictType.diskDeletedEditorClean;

      case FileEventType.created:
        return editorState.isOpen
            ? ConflictType.diskCreatedEditorOpen
            : null;

      case FileEventType.renamed:
        // Treat rename as delete + create
        return editorState.isDirty
            ? ConflictType.diskDeletedEditorDirty
            : ConflictType.diskDeletedEditorClean;
    }
  }
}

/// Domain service for file hash calculation
class FileHashCalculator {
  /// Calculate hash for file content
  FileHash calculate(
    String content, {
    FileHashAlgorithm algorithm = FileHashAlgorithm.md5,
  }) {
    return FileHash.fromContent(content, algorithm: algorithm);
  }

  /// Compare two hashes
  bool areEqual(FileHash hash1, FileHash hash2) {
    return hash1.matches(hash2);
  }
}

/// Domain service for pattern matching
class PatternMatcher {
  /// Check if path matches pattern set
  bool matches(FilePath path, WatchPatternSet patterns) {
    return patterns.matches(path);
  }

  /// Get all matching files in directory
  Future<List<FilePath>> findMatching({
    required DirectoryPath directory,
    required WatchPatternSet patterns,
  }) async {
    // Implementation in infrastructure layer
    throw UnimplementedError();
  }
}
```

### 8. Domain Events

```dart
/// Base class for file watcher domain events
abstract class FileWatcherDomainEvent extends DomainEvent {
  const FileWatcherDomainEvent();
}

/// File changed event
@freezed
class FileChangedDomainEvent
    extends FileWatcherDomainEvent
    with _$FileChangedDomainEvent {
  const factory FileChangedDomainEvent({
    required FileChangeEvent changeEvent,
    required WatchSessionId sessionId,
    required DateTime occurredAt,
  }) = _FileChangedDomainEvent;
}

/// Conflict detected event
@freezed
class ConflictDetectedDomainEvent
    extends FileWatcherDomainEvent
    with _$ConflictDetectedDomainEvent {
  const factory ConflictDetectedDomainEvent({
    required FileConflict conflict,
    required WatchSessionId sessionId,
    required DateTime occurredAt,
  }) = _ConflictDetectedDomainEvent;
}

/// Conflict resolved event
@freezed
class ConflictResolvedDomainEvent
    extends FileWatcherDomainEvent
    with _$ConflictResolvedDomainEvent {
  const factory ConflictResolvedDomainEvent({
    required ConflictId conflictId,
    required ConflictResolutionStrategy strategy,
    required bool successful,
    required DateTime occurredAt,
  }) = _ConflictResolvedDomainEvent;
}

/// Watch session started event
@freezed
class WatchSessionStartedDomainEvent
    extends FileWatcherDomainEvent
    with _$WatchSessionStartedDomainEvent {
  const factory WatchSessionStartedDomainEvent({
    required WatchSessionId sessionId,
    required Set<DirectoryPath> watchedPaths,
    required DateTime occurredAt,
  }) = _WatchSessionStartedDomainEvent;
}

/// Watch session stopped event
@freezed
class WatchSessionStoppedDomainEvent
    extends FileWatcherDomainEvent
    with _$WatchSessionStoppedDomainEvent {
  const factory WatchSessionStoppedDomainEvent({
    required WatchSessionId sessionId,
    required DateTime occurredAt,
    String? reason,
  }) = _WatchSessionStoppedDomainEvent;
}
```

### 9. Domain Failures

```dart
/// Base failure class
@freezed
class FileWatcherFailure with _$FileWatcherFailure {
  const factory FileWatcherFailure.sessionNotActive({
    required WatchSessionId sessionId,
  }) = _SessionNotActive;

  const factory FileWatcherFailure.directoryNotFound({
    required DirectoryPath path,
  }) = _DirectoryNotFound;

  const factory FileWatcherFailure.permissionDenied({
    required DirectoryPath path,
  }) = _PermissionDenied;

  const factory FileWatcherFailure.alreadyWatching({
    required DirectoryPath path,
  }) = _AlreadyWatching;

  const factory FileWatcherFailure.notWatching({
    required DirectoryPath path,
  }) = _NotWatching;

  const factory FileWatcherFailure.conflictAlreadyResolved({
    required ConflictId conflictId,
  }) = _ConflictAlreadyResolved;

  const factory FileWatcherFailure.tooManyFiles({
    required int fileCount,
    required int maxFiles,
  }) = _TooManyFiles;

  const factory FileWatcherFailure.watcherUnavailable({
    required String reason,
  }) = _WatcherUnavailable;

  const factory FileWatcherFailure.unknown({
    required String message,
    Object? error,
  }) = _Unknown;
}

@freezed
class FileSystemFailure with _$FileSystemFailure {
  const factory FileSystemFailure.fileNotFound({
    required FilePath path,
  }) = _FileNotFound;

  const factory FileSystemFailure.permissionDenied({
    required FilePath path,
  }) = _PermissionDenied;

  const factory FileSystemFailure.ioError({
    required String message,
    Object? error,
  }) = _IOError;
}
```

---

## 🎯 Application Layer Design

### 1. Application Services

```dart
/// Main orchestration service for file watching
@injectable
class FileWatcherService {
  final IFileWatcherRepository _watcherRepository;
  final IFileSystemRepository _fileSystemRepository;
  final IFileStateRepository _fileStateRepository;
  final FileConflictDetector _conflictDetector;
  final HotReloadService _hotReloadService;
  final FileEventAggregatorService _eventAggregator;
  final IDomainEventBus _eventBus;

  FileWatchSession? _activeSession;
  final _eventSubscriptions = <StreamSubscription>[];

  @inject
  FileWatcherService(
    this._watcherRepository,
    this._fileSystemRepository,
    this._fileStateRepository,
    this._conflictDetector,
    this._hotReloadService,
    this._eventAggregator,
    this._eventBus,
  );

  /// Start watching workspace
  Future<Either<FileWatcherFailure, WatchSessionId>> startWatching({
    required Set<DirectoryPath> directories,
    WatchConfiguration? configuration,
  }) async {
    if (_activeSession != null) {
      await stopWatching();
    }

    final config = configuration ?? WatchConfiguration.defaults();
    final sessionId = WatchSessionId.generate();

    // Create session
    final watchedDirs = directories
        .map((path) => WatchedDirectory(
              path: path,
              recursive: config.recursive,
              priority: WatchPriority.normal,
              addedAt: DateTime.now(),
            ))
        .toSet();

    _activeSession = FileWatchSession(
      id: sessionId,
      watchedDirectories: watchedDirs,
      state: WatchSessionState.initializing,
      startedAt: DateTime.now(),
      configuration: config,
    );

    // Start watching each directory
    for (final dir in directories) {
      final result = await _watcherRepository.watchDirectory(
        path: dir,
        recursive: config.recursive,
        patterns: config.patterns,
      );

      result.fold(
        (failure) => _handleWatchFailure(failure, dir),
        (eventStream) => _subscribeToEvents(eventStream, sessionId),
      );
    }

    // Update session state
    _activeSession = _activeSession!.copyWith(
      state: WatchSessionState.active,
    );

    // Emit domain event
    _eventBus.publish(
      WatchSessionStartedDomainEvent(
        sessionId: sessionId,
        watchedPaths: directories,
        occurredAt: DateTime.now(),
      ),
    );

    return right(sessionId);
  }

  /// Stop watching
  Future<Either<FileWatcherFailure, Unit>> stopWatching() async {
    if (_activeSession == null) {
      return left(
        const FileWatcherFailure.notWatching(
          path: DirectoryPath(path: ''),
        ),
      );
    }

    // Cancel all subscriptions
    for (final subscription in _eventSubscriptions) {
      await subscription.cancel();
    }
    _eventSubscriptions.clear();

    // Stop watching directories
    for (final dir in _activeSession!.watchedDirectories) {
      await _watcherRepository.stopWatching(path: dir.path);
    }

    // Emit domain event
    _eventBus.publish(
      WatchSessionStoppedDomainEvent(
        sessionId: _activeSession!.id,
        occurredAt: DateTime.now(),
      ),
    );

    _activeSession = null;

    return right(unit);
  }

  /// Subscribe to file events
  void _subscribeToEvents(
    Stream<FileChangeEvent> eventStream,
    WatchSessionId sessionId,
  ) {
    final subscription = eventStream.listen(
      (event) => _handleFileEvent(event, sessionId),
      onError: (error) => _handleStreamError(error, sessionId),
    );

    _eventSubscriptions.add(subscription);
  }

  /// Handle individual file event
  Future<void> _handleFileEvent(
    FileChangeEvent event,
    WatchSessionId sessionId,
  ) async {
    // Add to aggregator for batching/debouncing
    await _eventAggregator.addEvent(event);

    // Check for conflicts if enabled
    if (_activeSession!.configuration.detectConflicts) {
      await _checkForConflict(event);
    }

    // Emit domain event
    _eventBus.publish(
      FileChangedDomainEvent(
        changeEvent: event,
        sessionId: sessionId,
        occurredAt: DateTime.now(),
      ),
    );
  }

  /// Check for conflict with editor state
  Future<void> _checkForConflict(FileChangeEvent event) async {
    final stateResult = await _fileStateRepository.getFileState(
      event.filePath,
    );

    stateResult.fold(
      (_) => null, // File not in editor, no conflict
      (editorState) {
        final conflictOption = _conflictDetector.detectConflict(
          diskEvent: event,
          editorState: editorState,
        );

        conflictOption.fold(
          () => null, // No conflict
          (conflict) => _handleConflict(conflict),
        );
      },
    );
  }

  /// Handle detected conflict
  Future<void> _handleConflict(FileConflict conflict) async {
    // Emit domain event
    _eventBus.publish(
      ConflictDetectedDomainEvent(
        conflict: conflict,
        sessionId: _activeSession!.id,
        occurredAt: DateTime.now(),
      ),
    );

    // Auto-resolve if possible
    if (conflict.canAutoResolve()) {
      final strategy = conflict.getRecommendedStrategy();
      await _hotReloadService.resolveConflict(
        conflict: conflict,
        strategy: strategy,
      );
    }
  }
}
```

```dart
/// Service for conflict resolution logic
@injectable
class ConflictResolverService {
  final IFileSystemRepository _fileSystemRepository;
  final IFileStateRepository _fileStateRepository;
  final IDomainEventBus _eventBus;

  @inject
  ConflictResolverService(
    this._fileSystemRepository,
    this._fileStateRepository,
    this._eventBus,
  );

  /// Resolve conflict with given strategy
  Future<Either<FileWatcherFailure, Unit>> resolveConflict({
    required FileConflict conflict,
    required ConflictResolutionStrategy strategy,
  }) async {
    return strategy.when(
      useDisk: () => _resolveWithDisk(conflict),
      useEditor: () => _resolveWithEditor(conflict),
      prompt: () => _resolveWithPrompt(conflict),
      merge: () => _resolveWithMerge(conflict),
      ignore: () => _resolveWithIgnore(conflict),
    );
  }

  /// Resolve by reloading from disk
  Future<Either<FileWatcherFailure, Unit>> _resolveWithDisk(
    FileConflict conflict,
  ) async {
    // Reload file in editor
    final reloadResult = await _fileStateRepository.reloadFile(
      conflict.filePath,
      preserveCursor: true,
      preserveScroll: true,
    );

    return reloadResult.fold(
      (failure) => left(
        FileWatcherFailure.unknown(
          message: 'Failed to reload file',
          error: failure,
        ),
      ),
      (_) {
        _emitResolutionEvent(conflict, strategy, successful: true);
        return right(unit);
      },
    );
  }

  /// Resolve by keeping editor version
  Future<Either<FileWatcherFailure, Unit>> _resolveWithEditor(
    FileConflict conflict,
  ) async {
    // Get editor content
    final stateResult = await _fileStateRepository.getFileState(
      conflict.filePath,
    );

    return stateResult.fold(
      (failure) => left(
        FileWatcherFailure.unknown(
          message: 'Failed to get editor state',
          error: failure,
        ),
      ),
      (state) async {
        // Write editor content to disk
        if (state.content == null) {
          return left(
            const FileWatcherFailure.unknown(
              message: 'Editor content is null',
            ),
          );
        }

        final writeResult = await _fileSystemRepository.writeFile(
          conflict.filePath,
          state.content!,
        );

        return writeResult.fold(
          (failure) => left(
            FileWatcherFailure.unknown(
              message: 'Failed to write file',
              error: failure,
            ),
          ),
          (_) {
            _emitResolutionEvent(conflict, strategy, successful: true);
            return right(unit);
          },
        );
      },
    );
  }

  /// Resolve by prompting user
  Future<Either<FileWatcherFailure, Unit>> _resolveWithPrompt(
    FileConflict conflict,
  ) async {
    // This will be handled by UI layer
    // Just mark as needing user input
    return right(unit);
  }

  /// Resolve by merging (3-way merge)
  Future<Either<FileWatcherFailure, Unit>> _resolveWithMerge(
    FileConflict conflict,
  ) async {
    // TODO: Implement 3-way merge algorithm
    // For now, fall back to prompt
    return _resolveWithPrompt(conflict);
  }

  /// Resolve by ignoring
  Future<Either<FileWatcherFailure, Unit>> _resolveWithIgnore(
    FileConflict conflict,
  ) async {
    _emitResolutionEvent(conflict, strategy, successful: true);
    return right(unit);
  }

  void _emitResolutionEvent(
    FileConflict conflict,
    ConflictResolutionStrategy strategy, {
    required bool successful,
  }) {
    _eventBus.publish(
      ConflictResolvedDomainEvent(
        conflictId: conflict.id,
        strategy: strategy,
        successful: successful,
        occurredAt: DateTime.now(),
      ),
    );
  }
}
```

```dart
/// Service for hot reload coordination
@injectable
class HotReloadService {
  final IFileStateRepository _fileStateRepository;
  final ConflictResolverService _conflictResolver;

  @inject
  HotReloadService(
    this._fileStateRepository,
    this._conflictResolver,
  );

  /// Reload file if safe
  Future<Either<FileWatcherFailure, Unit>> reloadIfSafe(
    FilePath filePath,
  ) async {
    // Check if file is dirty
    final isDirty = await _fileStateRepository.isFileDirty(filePath);

    if (isDirty) {
      return left(
        FileWatcherFailure.unknown(
          message: 'File has unsaved changes',
        ),
      );
    }

    // Safe to reload
    return _fileStateRepository.reloadFile(
      filePath,
      preserveCursor: true,
      preserveScroll: true,
    ).then(
      (result) => result.fold(
        (failure) => left(
          FileWatcherFailure.unknown(
            message: 'Failed to reload',
            error: failure,
          ),
        ),
        (_) => right(unit),
      ),
    );
  }

  /// Reload multiple files in batch
  Future<Either<FileWatcherFailure, Map<FilePath, bool>>> reloadBatch(
    List<FilePath> filePaths,
  ) async {
    final results = <FilePath, bool>{};

    for (final path in filePaths) {
      final result = await reloadIfSafe(path);
      results[path] = result.isRight();
    }

    return right(results);
  }

  /// Resolve conflict and apply hot reload
  Future<Either<FileWatcherFailure, Unit>> resolveConflict({
    required FileConflict conflict,
    required ConflictResolutionStrategy strategy,
  }) async {
    return _conflictResolver.resolveConflict(
      conflict: conflict,
      strategy: strategy,
    );
  }
}
```

```dart
/// Service for event aggregation (batching/debouncing)
@injectable
class FileEventAggregatorService {
  final Duration _debounceDelay;
  final int _batchSize;

  final _eventQueue = <FileChangeEvent>[];
  final _eventStreamController = StreamController<List<FileChangeEvent>>.broadcast();
  Timer? _debounceTimer;

  @inject
  FileEventAggregatorService({
    @Named('debounceDelay') Duration? debounceDelay,
    @Named('batchSize') int? batchSize,
  })  : _debounceDelay = debounceDelay ?? const Duration(milliseconds: 300),
        _batchSize = batchSize ?? 100;

  /// Stream of batched events
  Stream<List<FileChangeEvent>> get events => _eventStreamController.stream;

  /// Add event to queue
  Future<void> addEvent(FileChangeEvent event) async {
    _eventQueue.add(event);

    // Restart debounce timer
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, _processBatch);

    // Force process if batch size reached
    if (_eventQueue.length >= _batchSize) {
      await _processBatch();
    }
  }

  /// Process accumulated events
  Future<void> _processBatch() async {
    if (_eventQueue.isEmpty) return;

    // Deduplicate events
    final deduplicated = _deduplicateEvents(_eventQueue);

    // Emit batch
    _eventStreamController.add(deduplicated);

    // Clear queue
    _eventQueue.clear();
  }

  /// Remove duplicate events
  List<FileChangeEvent> _deduplicateEvents(List<FileChangeEvent> events) {
    final seen = <String, FileChangeEvent>{};

    for (final event in events) {
      final key = '${event.filePath.path}_${event.type}';

      // Keep latest event for same file+type
      if (!seen.containsKey(key) ||
          event.timestamp.isAfter(seen[key]!.timestamp)) {
        seen[key] = event;
      }
    }

    return seen.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void dispose() {
    _debounceTimer?.cancel();
    _eventStreamController.close();
  }
}
```

### 2. Use Cases

```dart
/// Use case: Start watching directories
@injectable
class StartWatchingUseCase {
  final FileWatcherService _fileWatcherService;

  @inject
  StartWatchingUseCase(this._fileWatcherService);

  Future<Either<FileWatcherFailure, WatchSessionId>> call({
    required Set<DirectoryPath> directories,
    WatchConfiguration? configuration,
  }) async {
    // Validate input
    if (directories.isEmpty) {
      return left(
        const FileWatcherFailure.unknown(
          message: 'No directories specified',
        ),
      );
    }

    // Delegate to service
    return _fileWatcherService.startWatching(
      directories: directories,
      configuration: configuration,
    );
  }
}

/// Use case: Stop watching
@injectable
class StopWatchingUseCase {
  final FileWatcherService _fileWatcherService;

  @inject
  StopWatchingUseCase(this._fileWatcherService);

  Future<Either<FileWatcherFailure, Unit>> call() async {
    return _fileWatcherService.stopWatching();
  }
}

/// Use case: Handle file change
@injectable
class HandleFileChangeUseCase {
  final HotReloadService _hotReloadService;
  final IFileStateRepository _fileStateRepository;

  @inject
  HandleFileChangeUseCase(
    this._hotReloadService,
    this._fileStateRepository,
  );

  Future<Either<FileWatcherFailure, Unit>> call({
    required FileChangeEvent event,
    bool autoReload = true,
  }) async {
    // Check if file is open in editor
    final stateResult = await _fileStateRepository.getFileState(
      event.filePath,
    );

    return stateResult.fold(
      (_) => right(unit), // Not open, nothing to do
      (state) async {
        if (!state.isOpen) {
          return right(unit);
        }

        // Handle based on event type
        switch (event.type) {
          case FileEventType.modified:
            if (autoReload) {
              return _hotReloadService.reloadIfSafe(event.filePath);
            }
            return right(unit);

          case FileEventType.deleted:
            // Close file in editor
            return _fileStateRepository.closeFile(event.filePath).then(
              (result) => result.fold(
                (failure) => left(
                  FileWatcherFailure.unknown(
                    message: 'Failed to close file',
                    error: failure,
                  ),
                ),
                (_) => right(unit),
              ),
            );

          case FileEventType.renamed:
            // Close old file, optionally open new one
            return _fileStateRepository.closeFile(event.filePath).then(
              (result) => result.fold(
                (failure) => left(
                  FileWatcherFailure.unknown(
                    message: 'Failed to close renamed file',
                    error: failure,
                  ),
                ),
                (_) => right(unit),
              ),
            );

          case FileEventType.created:
            // Nothing to do for creation
            return right(unit);
        }
      },
    );
  }
}

/// Use case: Resolve conflict
@injectable
class ResolveConflictUseCase {
  final ConflictResolverService _conflictResolver;

  @inject
  ResolveConflictUseCase(this._conflictResolver);

  Future<Either<FileWatcherFailure, Unit>> call({
    required FileConflict conflict,
    required ConflictResolutionStrategy strategy,
  }) async {
    return _conflictResolver.resolveConflict(
      conflict: conflict,
      strategy: strategy,
    );
  }
}

/// Use case: Reload file
@injectable
class ReloadFileUseCase {
  final HotReloadService _hotReloadService;

  @inject
  ReloadFileUseCase(this._hotReloadService);

  Future<Either<FileWatcherFailure, Unit>> call({
    required FilePath filePath,
  }) async {
    return _hotReloadService.reloadIfSafe(filePath);
  }
}

/// Use case: Batch reload files
@injectable
class BatchReloadFilesUseCase {
  final HotReloadService _hotReloadService;

  @inject
  BatchReloadFilesUseCase(this._hotReloadService);

  Future<Either<FileWatcherFailure, Map<FilePath, bool>>> call({
    required List<FilePath> filePaths,
  }) async {
    return _hotReloadService.reloadBatch(filePaths);
  }
}
```

---

## 🔧 Infrastructure Layer Design

### 1. Repository Implementations

```dart
/// File watcher repository using dart:io watcher package
@LazySingleton(as: IFileWatcherRepository)
class DartFileWatcherRepository implements IFileWatcherRepository {
  final _watchers = <String, DirectoryWatcher>{};
  final _eventControllers = <String, StreamController<FileChangeEvent>>{};

  @override
  Future<Either<FileWatcherFailure, Stream<FileChangeEvent>>> watchDirectory({
    required DirectoryPath path,
    required bool recursive,
    required WatchPatternSet patterns,
  }) async {
    try {
      // Check if already watching
      if (_watchers.containsKey(path.path)) {
        return left(
          FileWatcherFailure.alreadyWatching(path: path),
        );
      }

      // Check if directory exists
      final dir = Directory(path.path);
      if (!await dir.exists()) {
        return left(
          FileWatcherFailure.directoryNotFound(path: path),
        );
      }

      // Create watcher
      final watcher = DirectoryWatcher(path.path);
      _watchers[path.path] = watcher;

      // Create event stream
      final controller = StreamController<FileChangeEvent>.broadcast();
      _eventControllers[path.path] = controller;

      // Subscribe to watcher events
      watcher.events.listen(
        (event) => _handleWatcherEvent(event, patterns, controller),
        onError: (error) => _handleWatcherError(error, controller),
        onDone: () => _handleWatcherDone(path.path),
      );

      return right(controller.stream);
    } catch (e) {
      return left(
        FileWatcherFailure.unknown(
          message: 'Failed to watch directory',
          error: e,
        ),
      );
    }
  }

  void _handleWatcherEvent(
    WatchEvent event,
    WatchPatternSet patterns,
    StreamController<FileChangeEvent> controller,
  ) {
    final filePath = FilePath.create(event.path);

    // Apply patterns
    if (!patterns.matches(filePath)) {
      return;
    }

    // Convert to domain event
    final fileEvent = FileChangeEvent(
      id: FileEventId.generate(),
      filePath: filePath,
      type: _convertEventType(event.type),
      timestamp: DateTime.now(),
      isExternal: true,
    );

    controller.add(fileEvent);
  }

  FileEventType _convertEventType(ChangeType type) {
    switch (type) {
      case ChangeType.ADD:
        return FileEventType.created;
      case ChangeType.MODIFY:
        return FileEventType.modified;
      case ChangeType.REMOVE:
        return FileEventType.deleted;
    }
  }

  void _handleWatcherError(
    Object error,
    StreamController<FileChangeEvent> controller,
  ) {
    controller.addError(error);
  }

  void _handleWatcherDone(String path) {
    _watchers.remove(path);
    _eventControllers[path]?.close();
    _eventControllers.remove(path);
  }

  @override
  Future<Either<FileWatcherFailure, Unit>> stopWatching({
    required DirectoryPath path,
  }) async {
    if (!_watchers.containsKey(path.path)) {
      return left(
        FileWatcherFailure.notWatching(path: path),
      );
    }

    // Stop watcher (DirectoryWatcher doesn't have explicit close)
    _watchers.remove(path.path);

    // Close stream
    await _eventControllers[path.path]?.close();
    _eventControllers.remove(path.path);

    return right(unit);
  }

  @override
  Future<bool> isWatching(DirectoryPath path) async {
    return _watchers.containsKey(path.path);
  }
}

/// File system repository using dart:io
@LazySingleton(as: IFileSystemRepository)
class FileSystemRepositoryImpl implements IFileSystemRepository {
  @override
  Future<Either<FileSystemFailure, String>> readFile(FilePath path) async {
    try {
      final file = File(path.path);

      if (!await file.exists()) {
        return left(FileSystemFailure.fileNotFound(path: path));
      }

      final content = await file.readAsString();
      return right(content);
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 13) {
        return left(FileSystemFailure.permissionDenied(path: path));
      }
      return left(
        FileSystemFailure.ioError(
          message: 'Failed to read file',
          error: e,
        ),
      );
    } catch (e) {
      return left(
        FileSystemFailure.ioError(
          message: 'Unexpected error',
          error: e,
        ),
      );
    }
  }

  @override
  Future<Either<FileSystemFailure, Unit>> writeFile(
    FilePath path,
    String content,
  ) async {
    try {
      final file = File(path.path);
      await file.writeAsString(content);
      return right(unit);
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 13) {
        return left(FileSystemFailure.permissionDenied(path: path));
      }
      return left(
        FileSystemFailure.ioError(
          message: 'Failed to write file',
          error: e,
        ),
      );
    } catch (e) {
      return left(
        FileSystemFailure.ioError(
          message: 'Unexpected error',
          error: e,
        ),
      );
    }
  }

  @override
  Future<Either<FileSystemFailure, FileHash>> getFileHash(
    FilePath path,
  ) async {
    final contentResult = await readFile(path);

    return contentResult.fold(
      (failure) => left(failure),
      (content) => right(
        FileHash.fromContent(content, algorithm: FileHashAlgorithm.md5),
      ),
    );
  }

  @override
  Future<bool> fileExists(FilePath path) async {
    final file = File(path.path);
    return file.exists();
  }

  @override
  Future<Either<FileSystemFailure, DateTime>> getModificationTime(
    FilePath path,
  ) async {
    try {
      final file = File(path.path);

      if (!await file.exists()) {
        return left(FileSystemFailure.fileNotFound(path: path));
      }

      final stat = await file.stat();
      return right(stat.modified);
    } catch (e) {
      return left(
        FileSystemFailure.ioError(
          message: 'Failed to get modification time',
          error: e,
        ),
      );
    }
  }
}

/// Editor file state repository (integrates with editor)
@LazySingleton(as: IFileStateRepository)
class EditorFileStateRepository implements IFileStateRepository {
  final ICodeEditorRepository _editorRepository;

  @inject
  EditorFileStateRepository(this._editorRepository);

  @override
  Future<Either<EditorFailure, EditorFileState>> getFileState(
    FilePath path,
  ) async {
    // Get open documents from editor
    final openDocsResult = await _editorRepository.getOpenDocuments();

    return openDocsResult.fold(
      (failure) => left(failure),
      (documents) {
        // Find document with matching path
        final doc = documents.firstWhere(
          (d) => d.uri.path == path.path,
          orElse: () => throw StateError('Document not found'),
        );

        // Get content
        return _editorRepository.getContent().then(
          (contentResult) => contentResult.fold(
            (failure) => left(failure),
            (content) => right(
              EditorFileState(
                path: path,
                isDirty: doc.isDirty,
                isOpen: true,
                content: content,
                // TODO: Get cursor and scroll positions
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<bool> isFileDirty(FilePath path) async {
    final stateResult = await getFileState(path);
    return stateResult.fold(
      (_) => false,
      (state) => state.isDirty,
    );
  }

  @override
  Future<Either<EditorFailure, Unit>> reloadFile(
    FilePath path, {
    bool preserveCursor = true,
    bool preserveScroll = true,
  }) async {
    // TODO: Implement reload with preservation
    // For now, just reload content

    // Read file from disk
    final file = File(path.path);
    final content = await file.readAsString();

    // Set content in editor
    return _editorRepository.setContent(content);
  }

  @override
  Future<Either<EditorFailure, Unit>> closeFile(FilePath path) async {
    // TODO: Implement close file
    // This depends on editor controller implementation
    return right(unit);
  }
}
```

---

## 🎨 Presentation Layer Design

### 1. Controller (State Management)

```dart
/// State for file watcher
@freezed
class FileWatcherState with _$FileWatcherState {
  const factory FileWatcherState({
    @Default(false) bool isWatching,
    WatchSessionId? sessionId,
    @Default([]) List<FileChangeEvent> recentEvents,
    @Default([]) List<FileConflict> activeConflicts,
    @Default({}) Map<FilePath, bool> reloadStatus,
    FileWatcherFailure? lastError,
  }) = _FileWatcherState;
}

/// Controller for file watcher
class FileWatcherController extends StateNotifier<FileWatcherState> {
  final StartWatchingUseCase _startWatching;
  final StopWatchingUseCase _stopWatching;
  final HandleFileChangeUseCase _handleFileChange;
  final ResolveConflictUseCase _resolveConflict;
  final FileEventAggregatorService _eventAggregator;

  StreamSubscription? _eventSubscription;

  FileWatcherController(
    this._startWatching,
    this._stopWatching,
    this._handleFileChange,
    this._resolveConflict,
    this._eventAggregator,
  ) : super(const FileWatcherState());

  /// Start watching workspace
  Future<void> startWatching({
    required Set<DirectoryPath> directories,
    WatchConfiguration? configuration,
  }) async {
    final result = await _startWatching(
      directories: directories,
      configuration: configuration,
    );

    result.fold(
      (failure) {
        state = state.copyWith(lastError: failure);
      },
      (sessionId) {
        state = state.copyWith(
          isWatching: true,
          sessionId: sessionId,
          lastError: null,
        );

        // Subscribe to aggregated events
        _eventSubscription = _eventAggregator.events.listen(
          _handleEventBatch,
        );
      },
    );
  }

  /// Stop watching
  Future<void> stopWatching() async {
    await _eventSubscription?.cancel();
    _eventSubscription = null;

    final result = await _stopWatching();

    result.fold(
      (failure) {
        state = state.copyWith(lastError: failure);
      },
      (_) {
        state = state.copyWith(
          isWatching: false,
          sessionId: null,
          recentEvents: [],
          activeConflicts: [],
        );
      },
    );
  }

  /// Handle batch of events
  void _handleEventBatch(List<FileChangeEvent> events) {
    // Update recent events
    state = state.copyWith(
      recentEvents: [...events, ...state.recentEvents].take(50).toList(),
    );

    // Process each event
    for (final event in events) {
      _handleFileChange(event: event);
    }
  }

  /// Resolve conflict
  Future<void> resolveConflict({
    required FileConflict conflict,
    required ConflictResolutionStrategy strategy,
  }) async {
    final result = await _resolveConflict(
      conflict: conflict,
      strategy: strategy,
    );

    result.fold(
      (failure) {
        state = state.copyWith(lastError: failure);
      },
      (_) {
        // Remove from active conflicts
        state = state.copyWith(
          activeConflicts: state.activeConflicts
              .where((c) => c.id != conflict.id)
              .toList(),
        );
      },
    );
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }
}
```

### 2. UI Widgets

```dart
/// File conflict dialog
class FileConflictDialog extends StatelessWidget {
  final FileConflict conflict;
  final ValueChanged<ConflictResolutionStrategy> onResolve;

  const FileConflictDialog({
    super.key,
    required this.conflict,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('File Conflict: ${conflict.filePath.fileName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getConflictDescription()),
          const SizedBox(height: 16),
          _buildConflictDetails(),
        ],
      ),
      actions: [
        if (_canUseDisk())
          TextButton(
            onPressed: () {
              onResolve(const ConflictResolutionStrategy.useDisk());
              Navigator.of(context).pop();
            },
            child: const Text('Use Disk Version'),
          ),
        if (_canUseEditor())
          TextButton(
            onPressed: () {
              onResolve(const ConflictResolutionStrategy.useEditor());
              Navigator.of(context).pop();
            },
            child: const Text('Keep Editor Version'),
          ),
        TextButton(
          onPressed: () {
            onResolve(const ConflictResolutionStrategy.ignore());
            Navigator.of(context).pop();
          },
          child: const Text('Ignore'),
        ),
      ],
    );
  }

  String _getConflictDescription() {
    switch (conflict.type) {
      case ConflictType.diskModifiedEditorDirty:
        return 'This file was modified on disk, but you have unsaved changes in the editor.';
      case ConflictType.diskDeletedEditorDirty:
        return 'This file was deleted on disk, but you have unsaved changes in the editor.';
      case ConflictType.diskCreatedEditorOpen:
        return 'This file was created on disk while you have it open in the editor.';
      default:
        return 'File conflict detected.';
    }
  }

  Widget _buildConflictDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('File: ${conflict.filePath.path}'),
        Text('Event: ${conflict.diskEvent.type.name}'),
        Text('Editor State: ${conflict.editorState.isDirty ? "Dirty" : "Clean"}'),
        Text('Detected: ${_formatDateTime(conflict.detectedAt)}'),
      ],
    );
  }

  bool _canUseDisk() {
    return conflict.type != ConflictType.diskDeletedEditorDirty;
  }

  bool _canUseEditor() {
    return conflict.editorState.isDirty;
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.hour}:${dt.minute}:${dt.second}';
  }
}

/// Hot reload indicator
class HotReloadIndicator extends StatelessWidget {
  final bool isReloading;
  final String? fileName;

  const HotReloadIndicator({
    super.key,
    required this.isReloading,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    if (!isReloading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            fileName != null
                ? 'Reloading $fileName...'
                : 'Reloading...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// External change banner
class ExternalChangeBanner extends StatelessWidget {
  final List<FileChangeEvent> events;
  final VoidCallback onReload;
  final VoidCallback onDismiss;

  const ExternalChangeBanner({
    super.key,
    required this.events,
    required this.onReload,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return MaterialBanner(
      content: Text(
        _getChangeDescription(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      leading: const Icon(Icons.info_outline),
      actions: [
        TextButton(
          onPressed: onReload,
          child: const Text('Reload'),
        ),
        TextButton(
          onPressed: onDismiss,
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  String _getChangeDescription() {
    final count = events.length;
    if (count == 1) {
      final event = events.first;
      return '${event.filePath.fileName} was ${event.type.name} externally';
    }
    return '$count files were changed externally';
  }
}
```

---

## 🧪 Testing Strategy

### Unit Tests

```dart
void main() {
  group('FileWatchSession', () {
    test('should accept events when active', () {
      final session = FileWatchSession(
        id: WatchSessionId.generate(),
        watchedDirectories: {},
        state: WatchSessionState.active,
        startedAt: DateTime.now(),
        configuration: WatchConfiguration.defaults(),
      );

      expect(session.canAcceptEvents(), true);
    });

    test('should not accept events when stopped', () {
      final session = FileWatchSession(
        id: WatchSessionId.generate(),
        watchedDirectories: {},
        state: WatchSessionState.stopped,
        startedAt: DateTime.now(),
        configuration: WatchConfiguration.defaults(),
      );

      expect(session.canAcceptEvents(), false);
    });
  });

  group('FileConflict', () {
    test('can auto-resolve clean file conflicts', () {
      final conflict = FileConflict(
        id: ConflictId.generate(),
        filePath: FilePath.create('/test.dart'),
        diskEvent: FileChangeEvent(/* ... */),
        editorState: const EditorFileState(
          path: FilePath(path: '/test.dart'),
          isDirty: false,
          isOpen: true,
        ),
        detectedAt: DateTime.now(),
        type: ConflictType.diskModifiedEditorClean,
      );

      expect(conflict.canAutoResolve(), true);
    });
  });

  group('FileConflictDetector', () {
    test('detects conflict for dirty file modification', () {
      final detector = FileConflictDetector();

      final event = FileChangeEvent(
        id: FileEventId.generate(),
        filePath: FilePath.create('/test.dart'),
        type: FileEventType.modified,
        timestamp: DateTime.now(),
      );

      final editorState = const EditorFileState(
        path: FilePath(path: '/test.dart'),
        isDirty: true,
        isOpen: true,
      );

      final result = detector.detectConflict(
        diskEvent: event,
        editorState: editorState,
      );

      expect(result.isSome(), true);
      result.fold(
        () => fail('Should have conflict'),
        (conflict) {
          expect(
            conflict.type,
            ConflictType.diskModifiedEditorDirty,
          );
        },
      );
    });
  });
}
```

---

## 📊 Performance Considerations

### 1. Debouncing Strategy
- **Default**: 300ms debounce
- **Rapid changes** (typing): Buffer events, emit batch after delay
- **Bulk changes** (git operations): Batch size limit (100 events)

### 2. Memory Management
- **Event queue**: Max 1000 events, circular buffer
- **Recent events**: Keep last 50 for UI
- **Conflict list**: Auto-cleanup resolved conflicts after 5 min

### 3. Scalability
- **Large workspaces**: Watch only necessary directories
- **Exclude patterns**: Skip node_modules, build artifacts
- **Priority watching**: High priority for open files

---

## 🎯 Integration Points

### With Editor Core
```dart
// Get editor state
final editorState = await fileStateRepository.getFileState(filePath);

// Reload file
await fileStateRepository.reloadFile(filePath);
```

### With LSP
```dart
// Notify LSP of file changes
await lspClient.notifyFileChanged(uri, content);
```

### With Git Integration
```dart
// Listen for git events
gitService.events.listen((event) {
  if (event is GitPullCompleted) {
    // Handle external changes from git
  }
});
```

---

## 📝 Configuration Example

```yaml
# .editor/file_watcher.yaml
file_watcher:
  enabled: true
  recursive: true
  debounce_delay_ms: 300
  batch_size: 100

  patterns:
    include:
      - "**/*.dart"
      - "**/*.js"
      - "**/*.ts"
    exclude:
      - "**/node_modules/**"
      - "**/.git/**"
      - "**/build/**"

  conflict_resolution:
    default_strategy: prompt
    auto_resolve_clean: true

  hot_reload:
    enabled: true
    preserve_cursor: true
    preserve_scroll: true
```

---

This architecture provides:
- ✅ **Clean separation** of concerns (Domain, Application, Infrastructure)
- ✅ **Testability** (100% mockable interfaces)
- ✅ **Flexibility** (pluggable adapters for different OS implementations)
- ✅ **Reliability** (robust error handling, conflict detection)
- ✅ **Performance** (debouncing, batching, efficient event processing)
- ✅ **Maintainability** (SOLID, DDD, clear responsibilities)
