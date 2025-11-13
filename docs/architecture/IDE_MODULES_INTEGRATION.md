# IDE Modules Integration - Complete Architecture

## 📋 Overview

This document describes how the three critical IDE modules (File Watcher, Git Integration, and Integrated Terminal) integrate with each other and with the existing editor core to create a cohesive, production-ready IDE experience.

---

## 🎯 Module Dependencies & Integration

```
┌─────────────────────────────────────────────────────────────────┐
│                         IDE APPLICATION                          │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐     │
│  │                    Editor Core                         │     │
│  │  • ICodeEditorRepository (Monaco/Native)               │     │
│  │  • Document Management                                 │     │
│  │  • LSP Integration                                     │     │
│  └──────────────┬──────────────────┬─────────────────────┘     │
│                 │                  │                             │
│  ┌──────────────▼─────┐  ┌────────▼──────────┐  ┌────────────┐ │
│  │  File Watcher      │  │  Git Integration  │  │ Terminal   │ │
│  │  ───────────────   │  │  ───────────────  │  │ ────────── │ │
│  │  • Hot Reload      │──▶│  • Status Monitor │  │ • Sessions │ │
│  │  • Conflict Detect │◀──│  • Diff Viewer    │  │ • PTY      │ │
│  │  • External Sync   │  │  • Commit/Push    │◀─│ • Commands │ │
│  └────────────────────┘  └───────────────────┘  └────────────┘ │
│         ▲                        ▲                      ▲        │
│         │                        │                      │        │
│         └────────────────────────┴──────────────────────┘        │
│                     Domain Event Bus                             │
└─────────────────────────────────────────────────────────────────┘
```

### Key Integration Points

#### 1. **File Watcher ↔ Git Integration**
- **Scenario**: Git operations (pull, checkout, merge) modify files externally
- **Flow**:
  ```
  Git Pull → Files Modified → File Watcher Detects Changes → Hot Reload
  ```
- **Implementation**:
  ```dart
  // GitService emits domain event after pull
  _eventBus.publish(ChangesPulledDomainEvent(...));

  // FileWatcherService listens to git events
  eventBus.subscribe<ChangesPulledDomainEvent>((event) {
    // Temporarily disable conflict detection during git operations
    _pauseConflictDetection();

    // Wait for git operation to complete
    await Future.delayed(Duration(milliseconds: 500));

    // Refresh all affected files
    await _refreshAffectedFiles(event.changedFiles);

    // Resume conflict detection
    _resumeConflictDetection();
  });
  ```

#### 2. **Terminal ↔ Git Integration**
- **Scenario**: User runs git commands in terminal
- **Flow**:
  ```
  Terminal: "git commit" → Git Status Changed → Update Git Panel
  ```
- **Implementation**:
  ```dart
  // TerminalService monitors git commands
  class GitCommandMonitor {
    final gitCommands = ['git', 'gco', 'gst', 'gp'];

    void monitorTerminalOutput(TerminalOutput output) {
      if (_isGitCommand(output.text)) {
        // Trigger git status refresh after command completes
        _scheduleGitRefresh();
      }
    }

    Future<void> _scheduleGitRefresh() async {
      await Future.delayed(Duration(milliseconds: 200));
      await _gitService.refreshStatus();
    }
  }
  ```

#### 3. **Terminal ↔ File Watcher**
- **Scenario**: Build tools modify files (npm install, flutter pub get)
- **Flow**:
  ```
  Terminal: "npm install" → node_modules Changes → Ignore or Reload
  ```
- **Implementation**:
  ```dart
  // FileWatcherService excludes bulk changes
  class BulkChangeDetector {
    void handleFileChanges(List<FileChangeEvent> events) {
      // Detect bulk operations
      if (events.length > 100 && _isWithinShortTimeframe(events)) {
        // Show banner instead of individual reloads
        _showBulkChangeBanner(
          message: '${events.length} files changed',
          action: () => _reloadAllAffectedFiles(events),
        );
      }
    }
  }
  ```

#### 4. **Git Diff Viewer ↔ Editor Core**
- **Scenario**: User views diff and wants to edit
- **Flow**:
  ```
  Git Diff → Click Line → Open File in Editor at Line
  ```
- **Implementation**:
  ```dart
  class DiffViewer extends StatelessWidget {
    void _handleLineClick(DiffLine line) {
      // Open file in editor at specific line
      final filePath = line.filePath;
      final lineNumber = line.newLineNumber ?? line.oldLineNumber;

      editorController.openFile(
        filePath: filePath,
        options: OpenFileOptions(
          cursorPosition: CursorPosition(line: lineNumber, column: 0),
          highlightLine: true,
        ),
      );
    }
  }
  ```

---

## 🔄 Event-Driven Architecture

### Domain Event Bus

```dart
/// Central event bus for cross-module communication
@singleton
class DomainEventBus implements IDomainEventBus {
  final _streamController = StreamController<DomainEvent>.broadcast();
  final _subscriptions = <Type, List<StreamSubscription>>{};

  @override
  void publish<T extends DomainEvent>(T event) {
    _streamController.add(event);
  }

  @override
  StreamSubscription<T> subscribe<T extends DomainEvent>(
    void Function(T event) handler,
  ) {
    final subscription = _streamController.stream
        .where((event) => event is T)
        .cast<T>()
        .listen(handler);

    _subscriptions.putIfAbsent(T, () => []).add(subscription);

    return subscription;
  }

  @override
  void dispose() {
    for (final subscriptions in _subscriptions.values) {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    }
    _streamController.close();
  }
}
```

### Event Flows

#### Event Flow 1: Git Pull → Hot Reload

```
┌──────────────┐
│ User clicks  │
│ "Pull"       │
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│ GitService.pull()    │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────────────┐
│ Git CLI: git pull origin main│
└──────┬───────────────────────┘
       │
       ▼
┌────────────────────────────────────┐
│ Emit: ChangesPulledDomainEvent     │
│ - files: [file1.dart, file2.dart] │
│ - commitCount: 3                   │
└──────┬─────────────────────────────┘
       │
       ├──────────────────┬───────────────────┐
       │                  │                   │
       ▼                  ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ File Watcher │  │ Git Panel UI │  │ LSP Service  │
│ - Pause      │  │ - Refresh    │  │ - Notify     │
│   conflicts  │  │   status     │  │   changes    │
│ - Reload     │  │ - Update     │  │              │
│   files      │  │   commits    │  │              │
└──────────────┘  └──────────────┘  └──────────────┘
```

#### Event Flow 2: External File Change → Git Status Update

```
┌────────────────┐
│ External Editor│
│ modifies file  │
└──────┬─────────┘
       │
       ▼
┌──────────────────────┐
│ OS File System Event │
└──────┬───────────────┘
       │
       ▼
┌────────────────────────────┐
│ FileWatcherService detects │
└──────┬─────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ Emit: FileChangedDomainEvent     │
│ - path: src/main.dart            │
│ - type: modified                 │
│ - isExternal: true               │
└──────┬───────────────────────────┘
       │
       ├──────────────────┬───────────────────┐
       │                  │                   │
       ▼                  ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Editor Core  │  │ Git Service  │  │ LSP Service  │
│ - Reload     │  │ - Refresh    │  │ - didChange  │
│   if clean   │  │   status     │  │   notify     │
│ - Detect     │  │ - Update     │  │              │
│   conflict   │  │   changes    │  │              │
└──────────────┘  └──────────────┘  └──────────────┘
```

#### Event Flow 3: Terminal Git Command → UI Update

```
┌────────────────┐
│ User types:    │
│ "git add ."    │
└──────┬─────────┘
       │
       ▼
┌────────────────────────┐
│ TerminalService.sendInput()│
└──────┬─────────────────┘
       │
       ▼
┌────────────────────────┐
│ PTY executes command   │
└──────┬─────────────────┘
       │
       ▼
┌────────────────────────────┐
│ GitCommandMonitor detects  │
│ git command completion     │
└──────┬─────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ Trigger: GitStatusRefreshNeeded  │
└──────┬───────────────────────────┘
       │
       ▼
┌────────────────────────┐
│ GitService.refreshStatus()│
└──────┬─────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ Emit: FilesStagedDomainEvent     │
│ - files: [src/**]                │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────┐
│ Git Panel UI │
│ - Update     │
│   staged     │
│   section    │
└──────────────┘
```

---

## 🏗️ Shared Infrastructure

### 1. Dependency Injection Container

```dart
/// Register all modules
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();

/// Main module registration
@module
abstract class AppModule {
  // ===== Core Services =====

  @singleton
  IDomainEventBus provideDomainEventBus() => DomainEventBus();

  // ===== File Watcher Module =====

  @singleton
  IFileWatcherRepository provideFileWatcherRepository() =>
      DartFileWatcherRepository();

  @singleton
  FileWatcherService provideFileWatcherService(
    IFileWatcherRepository watcherRepository,
    IFileSystemRepository fileSystemRepository,
    IFileStateRepository fileStateRepository,
    FileConflictDetector conflictDetector,
    HotReloadService hotReloadService,
    FileEventAggregatorService eventAggregator,
    IDomainEventBus eventBus,
  ) => FileWatcherService(
        watcherRepository,
        fileSystemRepository,
        fileStateRepository,
        conflictDetector,
        hotReloadService,
        eventAggregator,
        eventBus,
      );

  // ===== Git Integration Module =====

  @singleton
  IGitRepository provideGitRepository() => GitCliRepository(
        GitCommandAdapter(),
        GitParserAdapter(),
      );

  @singleton
  IDiffRepository provideDiffRepository() => DiffWasmRepository();

  @singleton
  GitService provideGitService(
    IGitRepository gitRepository,
    IDiffRepository diffRepository,
    ICredentialRepository credentialRepository,
    IDomainEventBus eventBus,
    FileWatcherService fileWatcherService,
  ) => GitService(
        gitRepository,
        diffRepository,
        credentialRepository,
        eventBus,
        fileWatcherService,
      );

  // ===== Terminal Module =====

  @singleton
  ITerminalRepository provideTerminalRepository() => DartPtyRepository();

  @singleton
  TerminalService provideTerminalService(
    ITerminalRepository terminalRepository,
    ISessionRepository sessionRepository,
    IShellRepository shellRepository,
    SessionManagerService sessionManager,
    IDomainEventBus eventBus,
  ) => TerminalService(
        terminalRepository,
        sessionRepository,
        shellRepository,
        sessionManager,
        eventBus,
      );

  // ===== Integration Services =====

  @singleton
  GitCommandMonitor provideGitCommandMonitor(
    GitService gitService,
    TerminalService terminalService,
  ) => GitCommandMonitor(gitService, terminalService);

  @singleton
  BulkChangeDetector provideBulkChangeDetector(
    FileWatcherService fileWatcherService,
  ) => BulkChangeDetector(fileWatcherService);
}
```

### 2. Shared Domain Event Bus Interface

```dart
/// Interface for domain event bus
abstract class IDomainEventBus {
  /// Publish event to all subscribers
  void publish<T extends DomainEvent>(T event);

  /// Subscribe to events of type T
  StreamSubscription<T> subscribe<T extends DomainEvent>(
    void Function(T event) handler,
  );

  /// Dispose resources
  void dispose();
}

/// Base class for all domain events
abstract class DomainEvent {
  const DomainEvent();

  DateTime get occurredAt;
}
```

---

## 🎨 UI Integration

### Main IDE Layout

```dart
class IDEScreen extends StatefulWidget {
  const IDEScreen({super.key});

  @override
  State<IDEScreen> createState() => _IDEScreenState();
}

class _IDEScreenState extends State<IDEScreen> {
  late final EditorController _editorController;
  late final GitController _gitController;
  late final TerminalController _terminalController;
  late final FileWatcherController _fileWatcherController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with DI
    _editorController = getIt<EditorController>();
    _gitController = getIt<GitController>();
    _terminalController = getIt<TerminalController>();
    _fileWatcherController = getIt<FileWatcherController>();

    // Start file watching for current workspace
    _initializeWorkspace();
  }

  Future<void> _initializeWorkspace() async {
    final workspacePath = Directory.current.path;

    // Start file watcher
    await _fileWatcherController.startWatching(
      directories: {DirectoryPath.create(workspacePath)},
    );

    // Open git repository
    await _gitController.openRepository(
      path: RepositoryPath.create(workspacePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top toolbar
          const IDEToolbar(),

          // Main content
          Expanded(
            child: Row(
              children: [
                // Left sidebar (file tree, git panel)
                SizedBox(
                  width: 300,
                  child: _buildLeftSidebar(),
                ),

                // Center (editor)
                Expanded(
                  child: EditorWidget(
                    controller: _editorController,
                  ),
                ),

                // Right sidebar (optional)
                if (_showRightSidebar)
                  SizedBox(
                    width: 300,
                    child: _buildRightSidebar(),
                  ),
              ],
            ),
          ),

          // Bottom panel (terminal)
          if (_showTerminal)
            SizedBox(
              height: 250,
              child: TerminalPanel(
                controller: _terminalController,
              ),
            ),

          // Status bar
          const IDEStatusBar(),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Column(
      children: [
        // Tab selector
        TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.folder), text: 'Files'),
            Tab(icon: Icon(Icons.source), text: 'Git'),
          ],
          controller: _sidebarTabController,
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _sidebarTabController,
            children: [
              // Files
              FileTreeWidget(
                onFileSelected: _editorController.openFile,
              ),

              // Git
              GitPanel(
                controller: _gitController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightSidebar() {
    // Could show: outline, search results, diagnostics, etc.
    return const SizedBox.shrink();
  }
}
```

### Integrated Status Bar

```dart
class IDEStatusBar extends StatelessWidget {
  const IDEStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          // Git branch
          Consumer(
            builder: (context, ref, child) {
              final gitState = ref.watch(gitControllerProvider);
              return _GitBranchIndicator(
                branch: gitState.currentBranch,
                hasChanges: gitState.hasUncommittedChanges,
              );
            },
          ),

          const VerticalDivider(),

          // File watcher status
          Consumer(
            builder: (context, ref, child) {
              final watcherState = ref.watch(fileWatcherControllerProvider);
              return _FileWatcherIndicator(
                isWatching: watcherState.isWatching,
                recentEvents: watcherState.recentEvents.length,
              );
            },
          ),

          const VerticalDivider(),

          // Terminal indicator
          Consumer(
            builder: (context, ref, child) {
              final terminalState = ref.watch(terminalControllerProvider);
              return _TerminalIndicator(
                activeSessionCount: terminalState.activeSessions.length,
              );
            },
          ),

          const Spacer(),

          // Cursor position
          Consumer(
            builder: (context, ref, child) {
              final editorState = ref.watch(editorControllerProvider);
              return _CursorPositionIndicator(
                position: editorState.cursorPosition,
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🔧 Configuration

### IDE Configuration File

```yaml
# .editor/config.yaml
ide:
  # Workspace settings
  workspace:
    auto_save: true
    auto_format: true

  # File watcher settings
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
        - "**/*.json"
        - "**/*.yaml"
      exclude:
        - "**/node_modules/**"
        - "**/.git/**"
        - "**/build/**"
        - "**/.dart_tool/**"

    conflict_resolution:
      default_strategy: prompt
      auto_resolve_clean: true

    hot_reload:
      enabled: true
      preserve_cursor: true
      preserve_scroll: true

  # Git integration settings
  git:
    enabled: true
    auto_fetch: true
    fetch_interval_minutes: 5

    diff:
      algorithm: myers
      context_lines: 3
      use_wasm: true

    commit:
      sign_commits: false
      verify_signatures: true
      conventional_commits: true

    ui:
      show_inline_blame: true
      show_gutter_changes: true
      highlight_uncommitted: true

  # Terminal settings
  terminal:
    enabled: true

    default_shell:
      # Auto-detect or specify
      type: auto  # auto, bash, zsh, fish, powershell, cmd

    appearance:
      font_family: "Menlo, Monaco, 'Courier New', monospace"
      font_size: 14
      cursor_blink: true

      theme:
        background: "#1e1e1e"
        foreground: "#d4d4d4"
        cursor: "#ffffff"
        selection: "#264f78"

    behavior:
      scrollback: 10000
      copy_on_select: false
      paste_with_right_click: true

    sessions:
      persistent: true
      restore_on_startup: true
      max_sessions: 10

    integration:
      monitor_git_commands: true
      working_directory: workspace_root
      inherit_env: true
```

### Loading Configuration

```dart
@singleton
class IDEConfiguration {
  final FileWatcherConfiguration fileWatcher;
  final GitConfiguration git;
  final TerminalConfiguration terminal;

  IDEConfiguration({
    required this.fileWatcher,
    required this.git,
    required this.terminal,
  });

  /// Load from config file
  static Future<IDEConfiguration> load() async {
    final configFile = File('.editor/config.yaml');

    if (!await configFile.exists()) {
      return IDEConfiguration.defaults();
    }

    final yamlString = await configFile.readAsString();
    final yaml = loadYaml(yamlString);

    return IDEConfiguration(
      fileWatcher: FileWatcherConfiguration.fromYaml(
        yaml['ide']['file_watcher'],
      ),
      git: GitConfiguration.fromYaml(
        yaml['ide']['git'],
      ),
      terminal: TerminalConfiguration.fromYaml(
        yaml['ide']['terminal'],
      ),
    );
  }

  /// Default configuration
  static IDEConfiguration defaults() {
    return IDEConfiguration(
      fileWatcher: FileWatcherConfiguration.defaults(),
      git: GitConfiguration.defaults(),
      terminal: TerminalConfiguration.defaults(),
    );
  }
}
```

---

## 📊 Performance Optimization

### 1. Event Batching

```dart
class EventBatcher {
  final Duration batchWindow = Duration(milliseconds: 100);
  final _pendingEvents = <DomainEvent>[];
  Timer? _batchTimer;

  void addEvent(DomainEvent event) {
    _pendingEvents.add(event);

    _batchTimer?.cancel();
    _batchTimer = Timer(batchWindow, _processBatch);
  }

  void _processBatch() {
    if (_pendingEvents.isEmpty) return;

    // Group events by type
    final eventsByType = <Type, List<DomainEvent>>{};
    for (final event in _pendingEvents) {
      eventsByType.putIfAbsent(event.runtimeType, () => []).add(event);
    }

    // Process each type
    for (final entry in eventsByType.entries) {
      _processBatchedEvents(entry.key, entry.value);
    }

    _pendingEvents.clear();
  }

  void _processBatchedEvents(Type type, List<DomainEvent> events) {
    // Deduplicate and merge events
    if (type == FileChangedDomainEvent) {
      final uniqueFiles = <String, FileChangedDomainEvent>{};

      for (final event in events.cast<FileChangedDomainEvent>()) {
        uniqueFiles[event.changeEvent.filePath.path] = event;
      }

      // Emit batch event
      eventBus.publish(
        FileChangesBatchEvent(
          changes: uniqueFiles.values.toList(),
        ),
      );
    }
  }
}
```

### 2. Lazy Loading

```dart
class LazyModuleLoader {
  bool _gitModuleLoaded = false;
  bool _terminalModuleLoaded = false;

  Future<void> loadGitModule() async {
    if (_gitModuleLoaded) return;

    // Load git module lazily
    await Future.wait([
      _loadGitRepository(),
      _loadDiffWasm(),
    ]);

    _gitModuleLoaded = true;
  }

  Future<void> loadTerminalModule() async {
    if (_terminalModuleLoaded) return;

    // Load terminal module lazily
    await Future.wait([
      _loadXtermJs(),
      _detectShells(),
    ]);

    _terminalModuleLoaded = true;
  }
}
```

---

## 🧪 Testing Strategy

### Integration Tests

```dart
void main() {
  group('IDE Module Integration Tests', () {
    late IDETestHarness harness;

    setUp(() async {
      harness = await IDETestHarness.create();
    });

    tearDown(() async {
      await harness.dispose();
    });

    test('Git pull triggers hot reload', () async {
      // Arrange
      await harness.openTestRepository();
      await harness.openFileInEditor('test.dart');

      // Make external modification (simulate git pull)
      await harness.modifyFileExternally('test.dart', 'new content');

      // Act
      await harness.git.pull();

      // Wait for events to propagate
      await harness.waitForEvents();

      // Assert
      expect(
        harness.editor.getCurrentFileContent(),
        equals('new content'),
      );
    });

    test('Terminal git command updates git panel', () async {
      // Arrange
      await harness.openTestRepository();
      await harness.terminal.createSession();

      // Act
      await harness.terminal.executeCommand('git add .');
      await harness.waitForGitRefresh();

      // Assert
      final gitState = await harness.git.getStatus();
      expect(gitState.stagedChanges, isNotEmpty);
    });

    test('External file modification shows conflict dialog', () async {
      // Arrange
      await harness.openFileInEditor('test.dart');
      await harness.editor.modifyContent('local changes');

      // Act
      await harness.modifyFileExternally('test.dart', 'external changes');
      await harness.waitForConflictDetection();

      // Assert
      expect(harness.ui.isConflictDialogVisible(), isTrue);
    });
  });
}

class IDETestHarness {
  late final EditorController editor;
  late final GitController git;
  late final TerminalController terminal;
  late final FileWatcherController fileWatcher;

  // ... test helpers
}
```

---

## 📝 Implementation Roadmap

### Phase 1: Core Infrastructure (Week 1)
- ✅ Domain Event Bus
- ✅ Shared interfaces
- ✅ DI container setup
- ✅ Configuration system

### Phase 2: File Watcher (Week 2)
- ✅ Domain layer
- ✅ Dart watcher implementation
- ✅ Hot reload service
- ✅ Conflict detection
- ✅ UI components

### Phase 3: Git Integration (Week 3-4)
- ✅ Domain layer
- ✅ Git CLI repository
- ✅ Rust WASM diff
- ✅ UI panels (status, diff, history)
- ✅ Merge conflict resolution

### Phase 4: Terminal (Week 5)
- ✅ Domain layer
- ✅ PTY implementation
- ✅ xterm.js integration
- ✅ Session management
- ✅ Shell detection

### Phase 5: Integration (Week 6)
- ✅ Cross-module events
- ✅ Git command monitoring
- ✅ Bulk change handling
- ✅ UI integration
- ✅ Status bar

### Phase 6: Polish & Testing (Week 7-8)
- ✅ Integration tests
- ✅ Performance optimization
- ✅ Error handling
- ✅ Documentation
- ✅ User feedback

---

## 🎯 Success Metrics

### Performance
- File change detection: <10ms
- Git status refresh: <100ms
- Terminal input latency: <16ms (60 FPS)
- Diff calculation (WASM): <50ms for 1000 lines

### Reliability
- No file data loss
- No missed file events
- Git operations atomic
- Terminal sessions recoverable

### UX
- Instant visual feedback
- Clear conflict resolution
- Intuitive keyboard shortcuts
- Responsive UI (no blocking)

---

This integration architecture ensures all three critical IDE modules work together seamlessly to provide a professional, production-ready development environment! 🚀

**Total Documentation**: ~16,000+ lines across 4 comprehensive architecture documents.
