# TypeScript Language Support Plugin

Comprehensive TypeScript language support plugin for the Multi-File Code Editor.

## Features

- ✅ **Syntax Highlighting** - Full TypeScript syntax highlighting via Monaco Editor
- ✅ **50 Code Snippets** - Comprehensive TypeScript snippets with type annotations
- ✅ **Type System** - Interfaces, types, generics, utility types
- ✅ **Decorators** - Class, method, and property decorator snippets
- ✅ **Bracket Matching** - Automatic bracket and brace matching
- ✅ **Autocomplete** - Word-based autocomplete
- ✅ **Multi-Extension Support** - `.ts`, `.tsx`

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  multi_editor_plugin_typescript: ^0.1.0
```

## Usage

```dart
import 'package:multi_editor_plugin_typescript/multi_editor_plugin_typescript.dart';

// Register the plugin
final tsPlugin = TypeScriptLanguagePlugin();
await pluginManager.registerPlugin(tsPlugin);
```

## Available Snippets

### Functions
- `fn` - Function declaration with types
- `af` - Arrow function with types
- `afe` - Arrow function expression with types
- `afn` - Async function with Promise return type
- `aaf` - Async arrow function with Promise return type

### Types & Interfaces
- `interface` - Interface declaration
- `interfaceex` - Interface with extends
- `type` - Type alias
- `typeu` - Union type
- `typei` - Intersection type
- `enum` - Numeric enum
- `enums` - String enum

### Classes
- `class` - Class declaration with types
- `classex` - Class with extends
- `classimp` - Class implementing interface
- `met` - Method with types
- `amet` - Async method with Promise return type
- `get` - Getter with type
- `set` - Setter with type

### Generics
- `fng` - Generic function
- `classg` - Generic class
- `interfaceg` - Generic interface

### Control Flow
- `if` - If statement
- `ife` - If-else statement
- `for` - For loop with type
- `forof` - For-of loop
- `switch` - Switch statement

### Async/Await & Promises
- `prom` - Promise constructor with type
- `aw` - Await expression
- `try` - Try-catch block with typed error

### Decorators
- `decc` - Class decorator
- `decm` - Method decorator
- `decp` - Property decorator

### ES6+ Features with Types
- `desa` - Array destructuring with type
- `deso` - Object destructuring with type
- `imp` - Named import
- `impd` - Default import
- `impt` - Import type only
- `exp` - Named export
- `expd` - Default export
- `expt` - Export type only

### Utility Types
- `partial` - Partial<Type>
- `readonly` - Readonly<Type>
- `record` - Record<Key, Value>
- `pick` - Pick<Type, 'property'>
- `omit` - Omit<Type, 'property'>

### Console & Debugging
- `cl` - console.log()
- `ce` - console.error()

## Supported File Extensions

- `.ts` - TypeScript
- `.tsx` - TypeScript with JSX (React)

## TypeScript Features

This plugin provides snippets for all major TypeScript features:

### Type System
- Interfaces and type aliases
- Union and intersection types
- Generic constraints
- Utility types (Partial, Readonly, Pick, Omit, Record)

### Advanced Features
- Decorators (experimental)
- Type-only imports/exports
- Async/await with Promise types
- Typed error handling

### Object-Oriented Programming
- Classes with access modifiers (private, protected, public)
- Interface implementation
- Abstract classes and methods
- Getters and setters with types

## Architecture

This plugin follows Clean Architecture principles:

- **Domain Layer** - Language rules and snippet data with type information
- **Infrastructure Layer** - Monaco editor integration
- **No UI Dependencies** - Works in any Dart environment

## Type Safety

All snippets include proper TypeScript type annotations to help developers write type-safe code:
- Function parameters and return types
- Class properties and methods
- Generic type parameters
- Type assertions and guards

## License

MIT License - see [LICENSE](../../LICENSE) file.
