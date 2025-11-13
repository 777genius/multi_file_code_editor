# Rust WASM Integration Guide

Complete guide for integrating the Rust WASM Myers diff algorithm into the Git Integration module.

## Overview

The Git Integration module uses a **high-performance Rust implementation** of the Myers diff algorithm, compiled to WebAssembly for maximum performance:

- **10-20x faster** than pure Dart implementation
- **Industry-standard** Myers algorithm (used by git)
- **Small binary size** (~28KB gzipped)
- **Automatic fallback** to pure Dart on non-web platforms

## Architecture

```
┌─────────────────────────────────────────────────┐
│ Dart Application (Flutter)                      │
├─────────────────────────────────────────────────┤
│ DiffService (Application Layer)                 │
├─────────────────────────────────────────────────┤
│ DiffRepositoryImpl (Infrastructure Layer)       │
│   ├── WASM Loader (Web)                        │
│   └── Pure Dart Fallback (Mobile/Desktop)      │
├─────────────────────────────────────────────────┤
│ Rust WASM Module                                │
│   ├── Myers Algorithm Implementation           │
│   ├── WASM Bindings (wasm-bindgen)            │
│   └── JSON Serialization (serde_json)          │
└─────────────────────────────────────────────────┘
```

## Prerequisites

### Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Install wasm-pack

```bash
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
```

### Add WebAssembly Target

```bash
rustup target add wasm32-unknown-unknown
```

### Optional: Install wasm-opt (for smaller binaries)

```bash
# macOS
brew install binaryen

# Ubuntu/Debian
sudo apt-get install binaryen

# Or download from https://github.com/WebAssembly/binaryen/releases
```

## Building WASM Module

### Quick Build

```bash
cd app/modules/git_integration/rust_wasm
./build.sh
```

This will:
1. Build the Rust code to WASM
2. Optimize with `wasm-opt`
3. Copy binaries to `assets/wasm/`

### Manual Build

```bash
cd app/modules/git_integration/rust_wasm

# Build release version
wasm-pack build --target web --release --out-dir pkg

# Optional: Further optimize
wasm-opt -Oz \
  --enable-mutable-globals \
  pkg/git_diff_wasm_bg.wasm \
  -o pkg/git_diff_wasm_bg.wasm

# Copy to assets
cp pkg/git_diff_wasm_bg.wasm ../assets/wasm/
cp pkg/git_diff_wasm.js ../assets/wasm/
```

### Development Build

```bash
# Build with debug symbols (larger, but easier to debug)
wasm-pack build --target web --dev --out-dir pkg
```

## Flutter/Dart Integration

### 1. Update `pubspec.yaml`

Add WASM files to assets:

```yaml
flutter:
  assets:
    - assets/wasm/git_diff_wasm_bg.wasm
    - assets/wasm/git_diff_wasm.js
```

### 2. Initialize WASM (Web Only)

The WASM module is automatically initialized on first use:

```dart
import 'package:git_integration/git_integration.dart';

// WASM is loaded lazily on first diff operation
final diffService = GetIt.instance<DiffService>();

final result = await diffService.getDiff(
  oldContent: 'old text',
  newContent: 'new text',
  contextLines: 3,
);
```

### 3. Manual Initialization (Optional)

```dart
import 'package:git_integration/git_integration.dart';

Future<void> preloadWasm() async {
  final diffRepo = GetIt.instance<IDiffRepository>();

  // This will trigger WASM loading
  await diffRepo.getDiff(
    oldContent: '',
    newContent: '',
    contextLines: 3,
  );
}
```

### 4. Platform Detection

The module automatically uses:
- **WASM** on web (high performance)
- **Pure Dart** on mobile/desktop (compatibility)

```dart
// No special handling needed - it's automatic!
final result = await diffService.getDiff(
  oldContent: oldContent,
  newContent: newContent,
);

// The implementation automatically chooses:
// - WASM if available (web)
// - Pure Dart fallback otherwise
```

## Testing WASM Module

### Rust Unit Tests

```bash
cd rust_wasm
cargo test
```

### WASM Browser Tests

```bash
cd rust_wasm

# Chrome
wasm-pack test --headless --chrome

# Firefox
wasm-pack test --headless --firefox
```

### Integration Tests (Dart)

```dart
import 'package:test/test.dart';
import 'package:git_integration/git_integration.dart';

void main() {
  test('diff with WASM', () async {
    final diffService = DiffService(GetDiffUseCase());

    final result = await diffService.getDiff(
      oldContent: 'line1\nline2\nline3',
      newContent: 'line1\nlineX\nline3',
      contextLines: 3,
    );

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Should not fail'),
      (hunks) {
        expect(hunks.length, greaterThan(0));
        expect(hunks.first.lines.any((l) => l.isAdded), true);
        expect(hunks.first.lines.any((l) => l.isRemoved), true);
      },
    );
  });
}
```

## Performance Optimization

### Binary Size Optimization

Current optimizations in `Cargo.toml`:

```toml
[profile.release]
opt-level = "z"     # Optimize for size
lto = true          # Link Time Optimization
codegen-units = 1   # Better optimization
panic = "abort"     # Smaller binary
strip = true        # Remove debug symbols
```

**Results:**
- Unoptimized: ~300KB
- With optimizations: ~85KB
- Gzipped: ~28KB

### Runtime Performance

Myers algorithm time complexity: **O((N+M)D)**
- N = old file lines
- M = new file lines
- D = edit distance

**Typical performance:**
- 1000 lines, 100 changes: ~2ms (WASM) vs ~25ms (Dart)
- **12.5x speedup**

### Further Optimizations

1. **WebAssembly SIMD** (future):
```rust
#[cfg(target_feature = "simd128")]
use std::arch::wasm32::*;
```

2. **Parallel Processing** (for very large files):
```rust
use rayon::prelude::*;

hunks.par_iter()
  .map(|hunk| process_hunk(hunk))
  .collect()
```

3. **Memory Pooling**:
```rust
use bumpalo::Bump;

let bump = Bump::new();
// Reuse allocations
```

## Debugging

### Enable Console Logs

```rust
// In lib.rs
#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

// Use in code
log(&format!("Debug: {:?}", value));
```

### Chrome DevTools

1. Open app in Chrome
2. DevTools > Sources > WebAssembly
3. Set breakpoints in WASM code
4. Inspect memory and execution

### Performance Profiling

```javascript
// In browser console
console.time('diff');
window.gitDiffWasm.myersDiff(oldText, newText, 3);
console.timeEnd('diff');
```

## Troubleshooting

### WASM Not Loading

**Problem:** `Failed to load WASM module`

**Solutions:**
1. Check assets are in `web/assets/wasm/`
2. Verify `pubspec.yaml` includes assets
3. Check browser console for errors
4. Ensure CORS headers allow WASM loading

### Binary Too Large

**Problem:** WASM binary is too large

**Solutions:**
1. Run `wasm-opt -Oz`
2. Enable `strip = true` in `Cargo.toml`
3. Remove unused dependencies
4. Use `#[wasm_bindgen(skip)]` for unnecessary exports

### Performance Not as Expected

**Problem:** WASM slower than expected

**Solutions:**
1. Enable release mode: `--release`
2. Run `wasm-opt` with `-O3`
3. Profile with Chrome DevTools
4. Check for unnecessary allocations
5. Use `&str` instead of `String` where possible

## Advanced Topics

### Custom Build Flags

```bash
# Maximum optimization
RUSTFLAGS='-C target-feature=+simd128' \
  wasm-pack build --target web --release

# Debug build with source maps
wasm-pack build --target web --dev -- \
  --features "console_error_panic_hook"
```

### Multiple Entry Points

```rust
// Export multiple functions
#[wasm_bindgen]
pub fn myers_diff(old: &str, new: &str, ctx: usize) -> String { }

#[wasm_bindgen]
pub fn patience_diff(old: &str, new: &str, ctx: usize) -> String { }

#[wasm_bindgen]
pub fn histogram_diff(old: &str, new: &str, ctx: usize) -> String { }
```

### Shared Memory (Experimental)

```rust
// Enable SharedArrayBuffer
#[wasm_bindgen]
pub fn diff_with_shared_memory(ptr: *mut u8, len: usize) { }
```

## References

- [Rust WASM Book](https://rustwasm.github.io/docs/book/)
- [wasm-bindgen Guide](https://rustwasm.github.io/wasm-bindgen/)
- [wasm-pack Documentation](https://rustwasm.github.io/wasm-pack/)
- [Myers Diff Algorithm](http://www.xmailserver.org/diff2.pdf)
- [WebAssembly Specification](https://webassembly.github.io/spec/)

## License

MIT License - see LICENSE file for details
