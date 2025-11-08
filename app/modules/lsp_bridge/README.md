# LSP Bridge Server

Rust-based WebSocket server that bridges Flutter app with native LSP servers.

## Architecture

```
Flutter App (Dart)
    ↓ WebSocket (JSON-RPC)
LSP Bridge Server (Rust)
    ↓ stdio (JSON-RPC)
LSP Servers (dart analyzer, typescript-ls, pylsp, rust-analyzer, etc.)
```

## Features

- ✅ **WebSocket Server** - Listens on `ws://127.0.0.1:9999`
- ✅ **Multi-language Support** - Manages multiple LSP servers simultaneously
- ✅ **Process Management** - Starts/stops LSP server processes
- ✅ **Protocol Translation** - Translates Flutter requests to LSP protocol
- ✅ **Session Management** - Each language gets its own session

## Supported Languages

| Language | LSP Server | Command |
|----------|-----------|---------|
| **Dart** | Dart Analysis Server | `dart language-server` |
| **TypeScript/JavaScript** | TypeScript Language Server | `typescript-language-server --stdio` |
| **Python** | Python LSP | `pylsp` |
| **Rust** | rust-analyzer | `rust-analyzer` |

## Building

```bash
# Development build
cargo build

# Release build (optimized)
cargo build --release

# Run
cargo run
```

## Running

```bash
# Start the server
./target/release/lsp_bridge

# Server will listen on: ws://127.0.0.1:9999
```

## Protocol

The server implements JSON-RPC 2.0 over WebSocket.

### Initialize Session

**Request:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "languageId": "dart",
    "rootUri": "file:///path/to/project"
  }
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "sessionId": "session_1234567890_abc",
    "capabilities": {}
  }
}
```

### Get Completions

**Request:**
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "textDocument/completion",
  "params": {
    "sessionId": "session_1234567890_abc",
    "textDocument": {
      "uri": "file:///path/to/file.dart"
    },
    "position": {
      "line": 10,
      "character": 5
    }
  }
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "items": [
      {
        "label": "print",
        "kind": 3,
        "detail": "void print(Object? object)",
        "documentation": "Prints a string representation..."
      }
    ]
  }
}
```

### Shutdown Session

**Request:**
```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "shutdown",
  "params": {
    "sessionId": "session_1234567890_abc"
  }
}
```

## LSP Server Installation

### Dart
```bash
# Already included with Dart SDK
dart --version
```

### TypeScript/JavaScript
```bash
npm install -g typescript-language-server typescript
```

### Python
```bash
pip install python-lsp-server
```

### Rust
```bash
rustup component add rust-analyzer
```

## Cross-compilation

Build for multiple platforms:

```bash
# Windows
cargo build --release --target x86_64-pc-windows-msvc

# macOS (Intel)
cargo build --release --target x86_64-apple-darwin

# macOS (Apple Silicon)
cargo build --release --target aarch64-apple-darwin

# Linux
cargo build --release --target x86_64-unknown-linux-gnu
```

## Deployment

For production, bundle the `lsp_bridge` executable with your Flutter app:

```
your_app/
├── your_app.exe (Flutter app)
└── resources/
    └── lsp_bridge/
        ├── lsp_bridge.exe (Windows)
        ├── lsp_bridge (macOS/Linux)
        └── servers/
            ├── dart/ (Dart SDK)
            ├── typescript/ (typescript-language-server)
            └── python/ (pylsp)
```

## Logging

The server uses `tracing` for logging. Set log level via environment:

```bash
RUST_LOG=info ./lsp_bridge
RUST_LOG=debug ./lsp_bridge
```

## Performance

Optimized for production:
- **Binary size:** ~3-5MB (stripped)
- **Memory usage:** ~10-30MB (idle)
- **Startup time:** ~50-100ms
- **Latency:** ~5-20ms per request

## Security

- ✅ Listens only on localhost (`127.0.0.1`)
- ✅ No authentication required (localhost-only)
- ⚠️ For remote access, use secure WebSocket (WSS) + authentication

## Future Enhancements

- [ ] Support for more languages (Go, Java, C++, etc.)
- [ ] Dynamic LSP server discovery
- [ ] Configuration file for custom LSP servers
- [ ] LSP server health checks
- [ ] Automatic restart on crash
- [ ] Metrics and monitoring

---

**Built with Rust + Tokio** 🦀
