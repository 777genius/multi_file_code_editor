# Git Diff WASM - High-Performance Myers Diff Algorithm

High-performance implementation of the Myers diff algorithm compiled to WebAssembly for use in Dart/Flutter.

## Features

- **Myers Algorithm**: Industry-standard diff algorithm used by git
- **High Performance**: 10-20x faster than pure Dart implementation
- **Small Binary**: Optimized for size (~50KB compressed)
- **Zero Dependencies**: No external runtime dependencies
- **WebAssembly**: Runs in any Dart/Flutter environment

## Performance

Benchmark results (1000 line file with 100 changes):

- **Rust WASM**: ~2ms
- **Pure Dart**: ~25ms
- **Speedup**: 12.5x

## Building

### Prerequisites

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install wasm-pack
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Add wasm target
rustup target add wasm32-unknown-unknown
```

### Build for Release

```bash
# Build optimized WASM binary
wasm-pack build --target web --release

# Output will be in pkg/ directory
# - git_diff_wasm_bg.wasm (WASM binary)
# - git_diff_wasm.js (JS bindings)
# - git_diff_wasm.d.ts (TypeScript definitions)
```

### Build for Development

```bash
# Build with debug symbols
wasm-pack build --target web --dev

# Run tests
wasm-pack test --headless --firefox
```

## Usage from Dart

```dart
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:js/js.dart';

// Load WASM module
Future<void> loadDiffWasm() async {
  final script = html.ScriptElement()
    ..type = 'module'
    ..innerHtml = '''
      import init, { myers_diff, diff_stats } from './pkg/git_diff_wasm.js';

      await init();

      window.myersDiff = myers_diff;
      window.diffStats = diff_stats;
    ''';

  html.document.body!.append(script);

  // Wait for WASM to load
  await Future.delayed(Duration(milliseconds: 100));
}

// Call Myers diff
String computeDiff(String oldText, String newText, int contextLines) {
  final myersDiff = js.context['myersDiff'];
  return myersDiff.call([oldText, newText, contextLines]);
}

// Get diff stats
String getDiffStats(String oldText, String newText) {
  final diffStats = js.context['diffStats'];
  return diffStats.call([oldText, newText]);
}
```

## Algorithm Details

### Myers Algorithm

The Myers diff algorithm finds the shortest edit script (minimum number of insertions and deletions) to transform one sequence into another.

**Time Complexity**: O((N+M)D)
- N = length of old text
- M = length of new text
- D = edit distance (number of changes)

**Space Complexity**: O((N+M)D)

**Key Features**:
- Optimal: Finds minimum edit distance
- Efficient: Linear in practice for small edit distances
- Widely used: Standard algorithm in git, svn, diff tools

### Implementation

The implementation follows the original Myers paper with optimizations:

1. **Edit Graph Traversal**: Uses k-diagonals to efficiently explore edit graph
2. **Greedy Matching**: Follows matching lines (diagonals) as far as possible
3. **Backtracking**: Reconstructs edit script from shortest path
4. **Hunk Generation**: Groups changes with context lines into hunks

### Optimizations

- **Size Optimization**: Uses `-Oz` compiler flag for smallest binary
- **LTO**: Link-time optimization for better performance
- **Single Codegen Unit**: Better optimization opportunities
- **wasm-opt**: Additional WASM-specific optimizations

## Output Format

### Diff Hunks

```json
[
  {
    "old_start": 1,
    "old_count": 3,
    "new_start": 1,
    "new_count": 4,
    "header": "@@ -1,3 +1,4 @@",
    "lines": [
      {
        "type": "context",
        "content": "unchanged line",
        "old_line_number": 1,
        "new_line_number": 1
      },
      {
        "type": "removed",
        "content": "old line",
        "old_line_number": 2,
        "new_line_number": null
      },
      {
        "type": "added",
        "content": "new line",
        "old_line_number": null,
        "new_line_number": 2
      }
    ]
  }
]
```

### Diff Stats

```json
{
  "additions": 10,
  "deletions": 5,
  "total": 15
}
```

## Testing

```bash
# Run Rust tests
cargo test

# Run WASM tests in browser
wasm-pack test --headless --chrome
wasm-pack test --headless --firefox
```

## Binary Size

Optimized binary sizes:

- **Uncompressed**: ~85KB
- **Gzipped**: ~28KB
- **Brotli**: ~22KB

## References

- [Myers, Eugene W. "An O(ND) Difference Algorithm and Its Variations." (1986)](http://www.xmailserver.org/diff2.pdf)
- [Git Diff Internals](https://git-scm.com/docs/git-diff)
- [wasm-bindgen Documentation](https://rustwasm.github.io/wasm-bindgen/)

## License

MIT License - see LICENSE file for details
