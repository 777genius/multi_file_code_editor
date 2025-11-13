# JavaScript/TypeScript IDE Enhancements

JavaScript and TypeScript-specific IDE enhancements for the Multi-Editor IDE application.

## Overview

This module provides language-specific tools and workflows for JavaScript/TypeScript development:

- ✅ **Package Management** - npm, yarn, pnpm support
- ✅ **Package Operations** - install, add, remove, update, outdated
- ✅ **Script Runner** - Execute package.json scripts
- ✅ **Auto-Detection** - Detects package manager from lock files
- ✅ **SDK Information** - Node.js and package manager versions
- ✅ **UI Integration** - Command panel widget for IDE
- ✅ **Pure Dart** - No native dependencies

## Architecture

This module follows Clean Architecture and integrates with the IDE's existing layers:

```
js_ts_ide_enhancements (Application Layer)
    ↓ uses
editor_core, lsp_domain (Domain Layers)
    ↓ used by
ide_presentation (Presentation Layer)
```

**Key Principles:**
- No native code (pure Dart)
- Works WITH existing infrastructure
- Provides JS/TS-specific workflows
- Simple and focused

## Features

### Package Manager Support

Supports all major JavaScript package managers:

- **npm** - Node Package Manager (default)
- **yarn** - Yarn Package Manager
- **pnpm** - Performant npm

Auto-detects package manager from lock files:
- `package-lock.json` → npm
- `yarn.lock` → yarn
- `pnpm-lock.yaml` → pnpm

### NPM Commands

Execute package manager commands programmatically:

```dart
import 'package:js_ts_ide_enhancements/js_ts_ide_enhancements.dart';

final npmCommands = NpmCommands(
  projectRoot: '/path/to/project',
  packageManager: PackageManager.npm,
);

// Auto-detect package manager
final detected = await npmCommands.detectPackageManager();
npmCommands.setPackageManager(detected);

// Install dependencies
final result = await npmCommands.install();
result.fold(
  (error) => print('Error: $error'),
  (output) => print('Success: $output'),
);

// Add package
await npmCommands.addPackage(
  packageName: 'axios',
  version: '^1.0.0',
  isDev: false,
);

// Remove package
await npmCommands.removePackage(packageName: 'axios');

// Update packages
await npmCommands.update();

// Check outdated
await npmCommands.outdated();

// Run script
await npmCommands.runScript(scriptName: 'build');

// Get available scripts
final scripts = await npmCommands.getAvailableScripts();
```

### UI Panel

Integrate into IDE UI:

```dart
import 'package:js_ts_ide_enhancements/js_ts_ide_enhancements.dart';

// In your IDE UI
NpmCommandsPanel(
  projectRoot: currentProjectRoot,
)
```

The panel automatically:
- Detects package manager
- Lists available scripts
- Provides command buttons
- Shows command output

## Available Commands

| Command | npm | yarn | pnpm |
|---------|-----|------|------|
| `install()` | ✅ | ✅ | ✅ |
| `addPackage()` | ✅ | ✅ | ✅ |
| `removePackage()` | ✅ | ✅ | ✅ |
| `update()` | ✅ | ✅ | ✅ |
| `outdated()` | ✅ | ✅ | ✅ |
| `runScript()` | ✅ | ✅ | ✅ |
| `getAvailableScripts()` | ✅ | ✅ | ✅ |
| `getNodeVersion()` | ✅ | ✅ | ✅ |
| `getPackageManagerVersion()` | ✅ | ✅ | ✅ |

## Integration with IDE

### 1. Add to IDE Dependencies

```yaml
dependencies:
  js_ts_ide_enhancements:
    path: modules/js_ts_ide_enhancements
```

### 2. Register Commands

```dart
// In IDE command registry
final npmCommands = NpmCommands(projectRoot: currentProject);

commandRegistry.register('npm.install', () async {
  await npmCommands.install();
});

commandRegistry.register('npm.runScript', (scriptName) async {
  await npmCommands.runScript(scriptName: scriptName);
});
```

### 3. Add UI Panel

```dart
// In IDE layout
if (currentLanguage == LanguageId.javascript ||
    currentLanguage == LanguageId.typescript) {
  NpmCommandsPanel(
    projectRoot: currentProject,
  )
}
```

## Design Decisions

### Why Pure Dart?

- **No Over-Engineering**: Dart Process API is sufficient for executing npm commands
- **Platform Agnostic**: Works on all platforms without native code
- **Simple**: Easy to maintain and extend
- **Reliable**: Uses official npm/yarn/pnpm CLI tools

### Why Not Native Code?

- npm commands are already fast (~1-5 seconds for most operations)
- No performance bottleneck that requires native optimization
- Adds complexity without significant benefit
- Follows user's guidance: "не делай over инженеринг"

### Multi-Package Manager Support

Supporting npm, yarn, and pnpm requires minimal additional code:
- Different command syntax (handled via switch statements)
- Auto-detection from lock files
- User can manually switch package managers

This provides significant value without over-engineering.

### Integration with LSP

This module is **complementary** to LSP, not a replacement:

- **LSP**: Provides real-time code intelligence (completions, diagnostics, hover)
- **js_ts_ide_enhancements**: Provides project-level tooling (package management, scripts)

Both work together for a complete JavaScript/TypeScript IDE experience.

## Common Use Cases

### 1. Install Dependencies After Cloning

```dart
await npmCommands.install();
```

### 2. Add Package from UI

```dart
// User types package name in UI
await npmCommands.addPackage(
  packageName: userInput,
  isDev: isDevDependency,
);
```

### 3. Run Build Script

```dart
// Get available scripts
final scripts = await npmCommands.getAvailableScripts();

// Run selected script
if (scripts.contains('build')) {
  await npmCommands.runScript(scriptName: 'build');
}
```

### 4. Check for Outdated Packages

```dart
final result = await npmCommands.outdated();
// Display outdated packages in UI
```

## Future Enhancements

Potential additions (only if needed):

- [ ] TypeScript compiler integration (tsc commands)
- [ ] ESLint/Prettier integration
- [ ] Webpack/Vite configuration support
- [ ] Package vulnerability scanning
- [ ] Node.js version management (nvm integration)

**Note**: Only add features that provide real value and don't duplicate existing functionality.

## License

MIT License - part of the Multi-Editor IDE application.
