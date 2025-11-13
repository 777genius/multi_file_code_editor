# IDE Architecture Documentation

Comprehensive architecture documentation for the three critical IDE modules that transform the editor into a full-featured development environment.

---

## 📚 Documentation Index

### 1. [File Watcher & Hot Reload Architecture](./FILE_WATCHER_ARCHITECTURE.md)
**~5000 lines** | **Priority: 🟡 MEDIUM (6/10)**

Real-time file system monitoring with automatic conflict resolution and hot reload capabilities.

**Key Features:**
- ✅ Real-time directory watching with recursive support
- ✅ Intelligent conflict detection (editor vs disk state)
- ✅ Hot reload with cursor/scroll preservation
- ✅ Debouncing & batching for bulk changes
- ✅ Pattern-based filtering (include/exclude)
- ✅ External change synchronization (git, build tools)

**Technology:**
- **Backend**: Pure Dart (`dart:io` watcher package)
- **No Native Code**: OS-level file watching via Dart
- **Performance**: <10ms event processing

**Use Cases:**
- Git operations (pull, checkout, merge) → Auto reload
- External editor modifications → Conflict detection
- Build tool changes (npm install) → Smart reload
- Hot reload on save → Instant feedback

**Architecture Highlights:**
- Clean Architecture with DDD
- `FileWatchSession` aggregate root
- Rich conflict resolution strategies
- Event-driven with domain events

---

### 2. [Git Integration Architecture](./GIT_INTEGRATION_ARCHITECTURE.md)
**~4500 lines** | **Priority: 🔴 HIGHEST (10/10)**

Complete version control integration with visual diff, blame annotations, and merge conflict resolution.

**Key Features:**
- ✅ All git operations (init, clone, commit, push, pull, merge)
- ✅ Visual diff viewer (side-by-side, inline)
- ✅ Branch management (create, checkout, merge, rebase)
- ✅ Commit history with graph visualization
- ✅ Blame annotations (git blame)
- ✅ Merge conflict resolution (3-way merge editor)
- ✅ Remote operations (fetch, push, pull)
- ✅ Stash management

**Technology:**
- **Backend**: Git CLI via `dart:io Process` (no over-engineering)
- **Diff Engine**: Rust WASM (Myers algorithm for performance)
- **Performance**:
  - Git status: <100ms
  - Diff calculation (WASM): <50ms for 1000 lines
  - 10x faster than pure Dart for large diffs

**Use Cases:**
- Daily git workflow (stage, commit, push)
- Code review with visual diff
- Branch management and merging
- Conflict resolution with visual tools
- History exploration with blame

**Architecture Highlights:**
- `GitRepository` aggregate root with rich domain logic
- Pluggable adapter pattern (Git CLI, libgit2 future)
- Domain events for cross-module integration
- Comprehensive failure handling

**Why Rust WASM for Diff?**
- CPU-intensive algorithm (Myers diff)
- Used frequently (every file comparison)
- 10x performance improvement
- Justifiable complexity

---

### 3. [Integrated Terminal Architecture](./INTEGRATED_TERMINAL_ARCHITECTURE.md)
**~3500 lines** | **Priority: 🔴 HIGHEST (10/10)**

Full-featured terminal emulation with xterm.js integration, multiple sessions, and shell detection.

**Key Features:**
- ✅ Full VT100/xterm compatibility
- ✅ ANSI color support (16, 256, true color)
- ✅ Multiple terminal sessions (tabs, splits)
- ✅ Persistent sessions (survive IDE restart)
- ✅ Auto-detect shell (bash, zsh, fish, powershell, cmd)
- ✅ Command history
- ✅ Search in output
- ✅ Clickable links (URLs, file paths)

**Technology:**
- **Backend**: Pure Dart (`dart:io Process`)
- **Frontend**: xterm.js (battle-tested terminal emulator)
- **WebView Integration**: Flutter WebView
- **Performance**: <16ms latency (60 FPS)

**Use Cases:**
- Run commands (npm, flutter, git)
- Execute tests and builds
- Monitor logs and output
- Interactive shells (node REPL, python)

**Architecture Highlights:**
- `TerminalSession` aggregate root
- Rich domain model with `TerminalBuffer`
- ANSI parser domain service
- PTY process management

**Why xterm.js?**
- Industry standard (VS Code uses it)
- Full VT100 compatibility
- GPU-accelerated rendering
- Extensive add-on ecosystem

---

### 4. [IDE Modules Integration](./IDE_MODULES_INTEGRATION.md)
**~3000 lines** | **Integration Guide**

How all three modules work together seamlessly with the existing editor core.

**Key Integration Points:**

#### 1. **File Watcher ↔ Git Integration**
```
Git Pull → Files Modified → File Watcher Detects → Hot Reload
```
- Domain events coordinate reload timing
- Conflict detection paused during git operations
- Automatic status refresh after git changes

#### 2. **Terminal ↔ Git Integration**
```
Terminal: "git commit" → Git Status Changed → Update Git Panel
```
- Git command monitoring in terminal output
- Automatic git status refresh after terminal git commands
- Bi-directional synchronization

#### 3. **Terminal ↔ File Watcher**
```
Terminal: "npm install" → node_modules Changes → Smart Handling
```
- Bulk change detection (100+ files)
- Banner notification instead of individual reloads
- Intelligent exclusion patterns

#### 4. **All Modules ↔ Editor Core**
- Shared domain event bus
- Unified error handling
- Coordinated state management
- Cross-cutting concerns (logging, telemetry)

**Architecture Patterns:**
- Event-driven architecture with domain events
- Dependency injection (Injectable + GetIt)
- Clean Architecture across all modules
- SOLID principles throughout

**Configuration:**
- Single YAML config file (`.editor/config.yaml`)
- Per-module configuration sections
- Sensible defaults
- Runtime overrides

---

## 🏗️ Architecture Principles

### 1. **Clean Architecture**
All modules follow strict layer separation:
```
Presentation → Application → Domain ← Infrastructure
```

### 2. **Domain-Driven Design (DDD)**
- Rich domain models with behavior
- Aggregate roots with invariants
- Value objects with validation
- Domain events for side effects
- Ubiquitous language

### 3. **SOLID Principles**
- **S**ingle Responsibility: Each class has one reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Interfaces are substitutable
- **I**nterface Segregation: Focused interfaces
- **D**ependency Inversion: Depend on abstractions

### 4. **Pluggable Adapter Pattern**
```dart
// Domain defines interface
abstract class IGitRepository { ... }

// Infrastructure provides adapters
class GitCliRepository implements IGitRepository { ... }
class LibGit2Repository implements IGitRepository { ... }  // Future

// Easy swapping
final gitRepo = useLibGit2
    ? LibGit2Repository()
    : GitCliRepository();
```

### 5. **Event-Driven Architecture**
```dart
// Modules communicate via domain events
eventBus.publish(ChangesPulledDomainEvent(...));

// Other modules subscribe
eventBus.subscribe<ChangesPulledDomainEvent>((event) {
  // React to git pull
});
```

---

## 🎯 When to Use Native Code (Rust WASM)

**✅ USE Rust WASM when:**
1. **CPU-intensive algorithm** (diff, fuzzy search)
2. **Frequently used** (always visible or constant use)
3. **10x+ performance gain** (backed by benchmarks)
4. **Direct UX impact** (<50ms feels instant, >500ms sluggish)

**❌ DON'T USE Rust WASM when:**
1. **Pure I/O operations** (file read/write, network)
2. **Infrequent operations** (git commands: 1-5 seconds anyway)
3. **Already fast enough** (Dart is sufficient for most tasks)
4. **Adds complexity** without measurable benefit

**Examples in this architecture:**
- ✅ **Git Diff (Rust WASM)**: Myers algorithm is CPU-intensive, used frequently
- ❌ **Git Commands (Pure Dart)**: I/O bound, git CLI is fast enough
- ❌ **File Watcher (Pure Dart)**: OS provides fast file events via Dart
- ❌ **Terminal (Pure Dart + xterm.js)**: PTY is OS-level, no benefit from native

---

## 📊 Performance Targets

| Operation | Target | Module |
|-----------|--------|--------|
| File change detection | <10ms | File Watcher |
| Git status refresh | <100ms | Git Integration |
| Diff calculation (WASM) | <50ms (1000 lines) | Git Integration |
| Terminal input latency | <16ms (60 FPS) | Terminal |
| Hot reload | <100ms | File Watcher |
| Conflict detection | <20ms | File Watcher |

---

## 🧪 Testing Strategy

### Unit Tests
- Domain logic: 100% coverage
- Value objects: Validation tests
- Entities: Behavior tests
- Services: Algorithm tests

### Integration Tests
- Cross-module communication
- Event bus flows
- Repository implementations
- End-to-end workflows

### Example Integration Test
```dart
test('Git pull triggers hot reload', () async {
  // Arrange
  await harness.openTestRepository();
  await harness.openFileInEditor('test.dart');

  // Act: Simulate git pull
  await harness.git.pull();

  // Wait for events to propagate
  await harness.waitForEvents();

  // Assert: File was reloaded
  expect(
    harness.editor.getCurrentFileContent(),
    equals('pulled content'),
  );
});
```

---

## 📝 Implementation Roadmap

### **Phase 1: File Watcher** (Week 1-2)
- Core domain layer
- Dart watcher implementation
- Conflict detection
- Hot reload service
- UI components

**Estimated Time**: 1-2 weeks

### **Phase 2: Git Integration** (Week 3-5)
- Core domain layer
- Git CLI repository
- Rust WASM diff engine
- UI panels (status, diff, history)
- Conflict resolution

**Estimated Time**: 2-3 weeks

### **Phase 3: Terminal** (Week 6-7)
- Core domain layer
- PTY implementation
- xterm.js integration
- Session management
- Shell detection

**Estimated Time**: 1-2 weeks

### **Phase 4: Integration** (Week 8)
- Cross-module events
- Event bus implementation
- Configuration system
- Status bar integration

**Estimated Time**: 1 week

### **Total Time**: 6-8 weeks for all three modules

---

## 🚀 Quick Start Guide

### 1. Clone & Setup
```bash
git clone <repo>
cd multi_editor_flutter

# Bootstrap all packages
melos bootstrap

# Generate code (Freezed)
melos run build_runner
```

### 2. Build Rust WASM (Optional)
```bash
# Git diff WASM
cd app/modules/git_integration/rust
./build.sh

# Only needed for production builds
# Pure Dart fallback works for development
```

### 3. Run IDE
```bash
cd app
flutter run -d linux  # or windows/macos
```

---

## 📖 Further Reading

### Clean Architecture Resources
- [Clean Architecture (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [DDD Reference](https://www.domainlanguage.com/ddd/reference/)

### Flutter Architecture
- [Flutter Clean Architecture](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)
- [Injectable DI](https://pub.dev/packages/injectable)

### Git Internals
- [Pro Git Book](https://git-scm.com/book/en/v2)
- [Myers Diff Algorithm](https://neil.fraser.name/writing/diff/)

### Terminal Emulation
- [xterm.js Documentation](https://xtermjs.org/)
- [VT100 Sequences](https://vt100.net/docs/vt100-ug/chapter3.html)

---

## 🎉 Summary

This architecture documentation provides everything needed to implement three critical IDE modules:

1. **File Watcher** - Real-time file monitoring with intelligent conflict resolution
2. **Git Integration** - Complete version control with visual diff and merge tools
3. **Integrated Terminal** - Full-featured terminal emulation with xterm.js

**Key Achievements:**
- ✅ **16,000+ lines** of comprehensive architecture documentation
- ✅ **Clean Architecture** with strict layer separation
- ✅ **Domain-Driven Design** with rich domain models
- ✅ **Event-Driven** integration between modules
- ✅ **Performance-optimized** with Rust WASM where justified
- ✅ **Production-ready** with error handling and testing strategy

**Built with best practices:**
- SOLID principles
- DDD tactical patterns
- Pluggable adapter pattern
- Comprehensive error handling
- 100% testable architecture

Now you have a complete blueprint to build a professional, production-ready IDE! 🚀
