# Dart Language Support Plugin

Pure Dart language support plugin for the Multi-File Code Editor.

## Features

- ✅ **Syntax Highlighting** - Full Dart syntax highlighting via Monaco Editor
- ✅ **14 Code Snippets** - Core Dart language snippets for faster development
- ✅ **Bracket Matching** - Automatic bracket and brace matching
- ✅ **Autocomplete** - Word-based autocomplete
- ✅ **Pure Dart** - No Flutter dependencies

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  multi_editor_plugin_dart: ^0.1.0
```

## Usage

```dart
import 'package:multi_editor_plugin_dart/multi_editor_plugin_dart.dart';

// Register the plugin
final dartPlugin = DartLanguagePlugin();
await pluginManager.registerPlugin(dartPlugin);
```

## Available Snippets

### Basic Constructs
- `main` - Main entry point
- `maina` - Async main entry point
- `class` - Class declaration
- `absclass` - Abstract class declaration
- `enum` - Enum declaration

### Control Flow
- `if` - If statement
- `ifelse` - If-else statement
- `for` - For loop
- `forin` - For-in loop
- `while` - While loop

### Error Handling
- `try` - Try-catch block
- `tryf` - Try-catch-finally block

### Functions
- `fun` - Function declaration
- `funa` - Async function with Future return type

## Supported File Extensions

- `.dart` - Dart source files

## Architecture

This plugin follows Clean Architecture principles:

- **Domain Layer** - Language rules and snippet data
- **Infrastructure Layer** - Monaco editor integration
- **No UI Dependencies** - Pure Dart, works in any environment

## License

MIT License - see [LICENSE](../../LICENSE) file.
