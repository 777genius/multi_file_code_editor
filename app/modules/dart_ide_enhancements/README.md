
# Dart IDE Enhancements

Dart and Flutter-specific IDE enhancements for the Multi-Editor IDE application.

## Overview

This module provides language-specific tools and workflows for Dart/Flutter development:

- ✅ **Pub Package Management** - pub get, upgrade, outdated, add, remove
- ✅ **Code Quality Tools** - analyze, format
- ✅ **SDK Information** - Dart/Flutter version detection
- ✅ **UI Integration** - Command panel widget for IDE
- ✅ **Pure Dart** - No native dependencies

## Architecture

This module follows Clean Architecture and integrates with the IDE's existing layers:

```
dart_ide_enhancements (Application Layer)
    ↓ uses
editor_core, lsp_domain (Domain Layers)
    ↓ used by
ide_presentation (Presentation Layer)
```

**Key Principles:**
- No native code (pure Dart)
- Works WITH existing infrastructure
- Provides Dart-specific workflows
- Simple and focused

## Features

### Pub Commands

Execute pub commands programmatically:

```dart
import 'package:dart_ide_enhancements/dart_ide_enhancements.dart';

final pubCommands = PubCommands(projectRoot: '/path/to/project');

// Get dependencies
final result = await pubCommands.pubGet(useFlutter: true);
result.fold(
  (error) => print('Error: $error'),
  (output) => print('Success: $output'),
);

// Add package
await pubCommands.addPackage(
  packageName: 'http',
  version: '^1.0.0',
  isDev: false,
);

// Remove package
await pubCommands.removePackage(packageName: 'http');

// Check outdated packages
await pubCommands.pubOutdated();

// Analyze code
await pubCommands.analyze();

// Format code
await pubCommands.format(fix: true);
```

### UI Panel

Integrate into IDE UI:

```dart
import 'package:dart_ide_enhancements/dart_ide_enhancements.dart';

// In your IDE UI
PubCommandsPanel(
  projectRoot: currentProjectRoot,
  isFlutterProject: true, // Auto-detected or configured
)
```

## Available Commands

| Command | Description | Flutter Support |
|---------|-------------|----------------|
| `pubGet()` | Download dependencies | ✅ |
| `pubUpgrade()` | Upgrade dependencies | ✅ |
| `pubOutdated()` | Check outdated packages | ✅ |
| `addPackage()` | Add package to pubspec | ✅ |
| `removePackage()` | Remove package from pubspec | ✅ |
| `analyze()` | Run Dart analyzer | ✅ |
| `format()` | Format code | ✅ |
| `getDartVersion()` | Get Dart SDK version | ✅ |
| `getFlutterVersion()` | Get Flutter SDK version | ✅ |

## Integration with IDE

### 1. Add to IDE Dependencies

```yaml
dependencies:
  dart_ide_enhancements:
    path: modules/dart_ide_enhancements
```

### 2. Register Commands

```dart
// In IDE command registry
final dartCommands = PubCommands(projectRoot: currentProject);

commandRegistry.register('dart.pubGet', () async {
  await dartCommands.pubGet();
});
```

### 3. Add UI Panel

```dart
// In IDE layout
if (currentLanguage == LanguageId.dart) {
  PubCommandsPanel(
    projectRoot: currentProject,
    isFlutterProject: detectFlutterProject(),
  )
}
```

## Design Decisions

### Why Pure Dart?

- **No Over-Engineering**: Dart Process API is sufficient for executing pub commands
- **Platform Agnostic**: Works on all platforms without native code
- **Simple**: Easy to maintain and extend
- **Reliable**: Uses official Dart/Flutter CLI tools

### Why Not Native Code?

- Pub commands are already fast (~1-5 seconds)
- No performance bottleneck that requires native optimization
- Adds complexity without significant benefit
- Follows user's guidance: "не делай over инженеринг"

### Integration with LSP

This module is **complementary** to LSP, not a replacement:

- **LSP**: Provides real-time code intelligence (completions, diagnostics, hover)
- **dart_ide_enhancements**: Provides project-level tooling (package management, formatting)

Both work together for a complete Dart IDE experience.

## Future Enhancements

Potential additions (only if needed):

- [ ] Flutter DevTools integration
- [ ] Hot reload/restart commands
- [ ] Build/run configurations
- [ ] Test runner integration
- [ ] Coverage visualization

**Note**: Only add features that provide real value and don't duplicate existing functionality.

## License

MIT License - part of the Multi-Editor IDE application.
