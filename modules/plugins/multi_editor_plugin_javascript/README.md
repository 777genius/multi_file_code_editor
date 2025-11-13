# JavaScript Language Support Plugin

Modern JavaScript/ES6+ language support plugin for the Multi-File Code Editor.

## Features

- ✅ **Syntax Highlighting** - Full JavaScript syntax highlighting via Monaco Editor
- ✅ **42 Code Snippets** - Modern ES6+ snippets for faster development
- ✅ **Bracket Matching** - Automatic bracket and brace matching
- ✅ **Autocomplete** - Word-based autocomplete
- ✅ **Multi-Extension Support** - `.js`, `.jsx`, `.mjs`, `.cjs`

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  multi_editor_plugin_javascript: ^0.1.0
```

## Usage

```dart
import 'package:multi_editor_plugin_javascript/multi_editor_plugin_javascript.dart';

// Register the plugin
final jsPlugin = JavaScriptLanguagePlugin();
await pluginManager.registerPlugin(jsPlugin);
```

## Available Snippets

### Functions
- `fn` - Function declaration
- `af` - Arrow function
- `afe` - Arrow function expression
- `afn` - Async function
- `aaf` - Async arrow function

### Classes
- `class` - Class declaration
- `classex` - Class with extends
- `met` - Method
- `amet` - Async method
- `get` - Getter
- `set` - Setter

### Control Flow
- `if` - If statement
- `ife` - If-else statement
- `ter` - Ternary operator
- `for` - For loop
- `forof` - For-of loop
- `forin` - For-in loop
- `while` - While loop
- `switch` - Switch statement

### Async/Await & Promises
- `prom` - Promise constructor
- `aw` - Await expression
- `try` - Try-catch block
- `tryf` - Try-catch-finally block

### ES6+ Features
- `desa` - Array destructuring
- `deso` - Object destructuring
- `spra` - Array spread operator
- `spro` - Object spread operator
- `imp` - Named import
- `impd` - Default import
- `impa` - Import all as namespace
- `exp` - Named export
- `expd` - Default export
- `expf` - Export named function
- `expdf` - Export default function

### Array Methods
- `map` - Array.map()
- `filter` - Array.filter()
- `reduce` - Array.reduce()
- `find` - Array.find()
- `foreach` - Array.forEach()

### Console & Debugging
- `cl` - console.log()
- `ce` - console.error()
- `ct` - console.table()

## Supported File Extensions

- `.js` - Standard JavaScript
- `.jsx` - React JSX
- `.mjs` - ES6 Module
- `.cjs` - CommonJS Module

## Architecture

This plugin follows Clean Architecture principles:

- **Domain Layer** - Language rules and snippet data
- **Infrastructure Layer** - Monaco editor integration
- **No UI Dependencies** - Works in any Dart environment

## License

MIT License - see [LICENSE](../../LICENSE) file.
