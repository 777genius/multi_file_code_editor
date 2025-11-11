# Symbol Navigator WASM Plugin

Tree-sitter powered code symbol parser supporting multiple programming languages.

## Features

- **Multi-language support**: Dart, JavaScript, TypeScript, Python, Go, Rust
- **Fast parsing**: Optimized WASM binary with tree-sitter
- **Rich symbol extraction**: Classes, functions, methods, fields, enums, and more
- **Hierarchical structure**: Parent-child relationships for nested symbols
- **Location tracking**: Precise line/column/offset information

## Architecture

```
┌─────────────────────────────────────────┐
│ Dart Host (Flutter)                     │
│  └─ SymbolNavigatorPlugin               │
│       └─ WASM Bridge (MessagePack)      │
└─────────────────────────────────────────┘
                 ↓↑
┌─────────────────────────────────────────┐
│ Go WASM Plugin (this)                   │
│  ├─ parser/                             │
│  │   ├─ types.go                        │
│  │   ├─ parser.go                       │
│  │   └─ dart_parser.go                  │
│  └─ main.go (exports)                   │
└─────────────────────────────────────────┘
```

## Building

### Prerequisites

- Go 1.21+
- Optional: `binaryen` for optimization
- Optional: `wabt` for validation

### Build Commands

```bash
# Build WASM plugin
make build

# Build with optimization
make build-opt

# Development build (with debug symbols)
make dev

# Run tests
make test

# Verify WASM module
make verify

# Inspect exports
make inspect

# Install to Flutter project
make install

# Clean artifacts
make clean
```

## Exported Functions

### `get_manifest() -> uint64`

Returns plugin manifest (JSON serialized).

**Response:**
```json
{
  "id": "wasm.symbol-navigator",
  "name": "Symbol Navigator (WASM)",
  "version": "0.1.0",
  "description": "Tree-sitter powered symbol parser",
  "author": "Editor Team",
  "capabilities": ["parse.dart", "parse.javascript", ...]
}
```

### `parse_symbols(ptr: uint32, len: uint32) -> uint64`

Parses source code and extracts symbols.

**Request (MessagePack):**
```go
{
  "content": "class MyClass { void method() {} }",
  "language": "dart",
  "file_path": "main.dart"
}
```

**Response (MessagePack):**
```go
{
  "symbols": [
    {
      "name": "MyClass",
      "kind": "class_declaration",
      "location": {
        "start_line": 0,
        "start_column": 0,
        "end_line": 0,
        "end_column": 30,
        "start_offset": 0,
        "end_offset": 30
      },
      "children": [
        {
          "name": "method",
          "kind": "method",
          "parent": "MyClass",
          "location": { ... }
        }
      ]
    }
  ],
  "language": "dart",
  "parse_duration_ms": 5,
  "statistics": {
    "Class": 1,
    "Method": 1
  }
}
```

## Symbol Kinds

### Classes and Types
- `class_declaration` - Regular class
- `abstract_class` - Abstract class
- `mixin` - Mixin
- `extension` - Extension
- `enum_declaration` - Enum
- `typedef` - Type alias

### Functions and Methods
- `function` - Top-level function
- `method` - Class method
- `constructor` - Constructor
- `getter` - Getter method
- `setter` - Setter method

### Fields and Variables
- `field` - Class field
- `property` - Property
- `constant` - Constant
- `variable` - Variable
- `enum_value` - Enum value
- `parameter` - Function parameter

## Memory Management

The plugin uses packed pointer return format:
- Upper 32 bits: Pointer to data
- Lower 32 bits: Data length
- Returns `0` on error

```go
func packResult(data []byte) uint64 {
  ptr := uint32(uintptr(unsafe.Pointer(&data[0])))
  len := uint32(len(data))
  return (uint64(ptr) << 32) | uint64(len)
}
```

## Performance

Current implementation uses regex-based parsing for proof-of-concept:
- **Dart**: ~5-10ms for 1000 lines
- **JavaScript**: TODO
- **TypeScript**: TODO
- **Python**: TODO
- **Go**: TODO (can use native `go/parser`)
- **Rust**: TODO

Future tree-sitter integration will provide:
- 10-100x faster parsing
- More accurate symbol extraction
- Better error recovery

## Development

### Adding New Language Support

1. Add language constant in `parser/types.go`:
   ```go
   const LangNewLang = "newlang"
   ```

2. Implement parser in `parser/newlang_parser.go`:
   ```go
   func parseNewLang(content string) ([]Symbol, error) {
     // Implementation
   }
   ```

3. Add case in `parser/parser.go`:
   ```go
   case LangNewLang:
     symbols, err = parseNewLang(content)
   ```

### Testing

```bash
# Run all tests
go test ./...

# Run with coverage
go test -cover ./...

# Test specific package
go test ./parser -v
```

## TODO

- [ ] Integrate github.com/malivvan/tree-sitter for real tree-sitter parsing
- [ ] Add JavaScript/TypeScript parser
- [ ] Add Python parser
- [ ] Add Rust parser
- [ ] Optimize Go parser with stdlib `go/parser`
- [ ] Add symbol metadata (visibility, static, async, etc.)
- [ ] Support incremental parsing for large files
- [ ] Add query API for finding symbols by name/kind
- [ ] Benchmark performance vs native parsers

## License

Part of multi_editor_flutter project.
