import 'dart:io';
import 'package:git_integration/git_integration.dart';

/// Benchmark for comparing WASM vs Pure Dart diff performance
void main() async {
  print('🚀 Git Diff Performance Benchmark\n');

  // Generate test data
  final testCases = [
    _TestCase(
      name: 'Small file (100 lines, 10 changes)',
      oldContent: _generateFile(100, seed: 1),
      newContent: _generateFile(100, seed: 2),
    ),
    _TestCase(
      name: 'Medium file (500 lines, 50 changes)',
      oldContent: _generateFile(500, seed: 1),
      newContent: _generateFile(500, seed: 3),
    ),
    _TestCase(
      name: 'Large file (1000 lines, 100 changes)',
      oldContent: _generateFile(1000, seed: 1),
      newContent: _generateFile(1000, seed: 4),
    ),
    _TestCase(
      name: 'Very large file (5000 lines, 500 changes)',
      oldContent: _generateFile(5000, seed: 1),
      newContent: _generateFile(5000, seed: 5),
    ),
  ];

  // Initialize diff service
  configureDependencies();
  final diffService = DiffService(GetDiffUseCase());

  // Run benchmarks
  for (final testCase in testCases) {
    print('📊 ${testCase.name}');
    print('─' * 60);

    // Warm up
    await diffService.getDiff(
      oldContent: testCase.oldContent,
      newContent: testCase.newContent,
      contextLines: 3,
      useCache: false,
    );

    // Measure WASM performance
    final wasmTimes = <int>[];
    for (var i = 0; i < 10; i++) {
      final stopwatch = Stopwatch()..start();
      await diffService.getDiff(
        oldContent: testCase.oldContent,
        newContent: testCase.newContent,
        contextLines: 3,
        useCache: false,
      );
      stopwatch.stop();
      wasmTimes.add(stopwatch.elapsedMicroseconds);
    }

    // Calculate statistics
    final wasmAvg = wasmTimes.reduce((a, b) => a + b) / wasmTimes.length;
    final wasmMin = wasmTimes.reduce((a, b) => a < b ? a : b);
    final wasmMax = wasmTimes.reduce((a, b) => a > b ? a : b);

    print('WASM (Rust Myers):');
    print('  Average: ${(wasmAvg / 1000).toStringAsFixed(2)} ms');
    print('  Min:     ${(wasmMin / 1000).toStringAsFixed(2)} ms');
    print('  Max:     ${(wasmMax / 1000).toStringAsFixed(2)} ms');

    // Note: Pure Dart benchmark would need fallback implementation
    // For now, showing WASM results only

    print('');
  }

  print('✅ Benchmark complete!');
  exit(0);
}

class _TestCase {
  final String name;
  final String oldContent;
  final String newContent;

  _TestCase({
    required this.name,
    required this.oldContent,
    required this.newContent,
  });
}

/// Generate test file content
String _generateFile(int lines, {int seed = 1}) {
  final buffer = StringBuffer();
  final random = Random(seed);

  for (var i = 0; i < lines; i++) {
    // Generate realistic code-like lines
    final indent = '  ' * random.nextInt(4);
    final lineTypes = [
      'function ${_randomWord(random)}() {',
      'const ${_randomWord(random)} = ${random.nextInt(100)};',
      'if (${_randomWord(random)} === ${random.nextInt(10)}) {',
      '  return ${_randomWord(random)};',
      '}',
      '// Comment: ${_randomWord(random)} ${_randomWord(random)}',
      'console.log("${_randomWord(random)}");',
    ];

    buffer.writeln(indent + lineTypes[random.nextInt(lineTypes.length)]);
  }

  return buffer.toString();
}

String _randomWord(Random random) {
  const words = [
    'data',
    'value',
    'result',
    'item',
    'element',
    'object',
    'array',
    'string',
    'number',
    'boolean',
    'function',
    'method',
    'property',
    'variable',
    'constant',
    'parameter',
  ];
  return words[random.nextInt(words.length)];
}

class Random {
  int _seed;

  Random(this._seed);

  int nextInt(int max) {
    _seed = ((_seed * 1103515245) + 12345) & 0x7fffffff;
    return _seed % max;
  }
}
