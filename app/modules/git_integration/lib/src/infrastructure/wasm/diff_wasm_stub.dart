import 'dart:async';

/// WASM diff loader stub for non-web platforms
///
/// This is a stub implementation that throws UnsupportedError.
/// The real implementation is in diff_wasm_loader.dart for web.
class DiffWasmLoader {
  static DiffWasmLoader? _instance;

  DiffWasmLoader._();

  /// Get singleton instance
  static DiffWasmLoader get instance {
    _instance ??= DiffWasmLoader._();
    return _instance!;
  }

  /// Check if WASM is supported (always false on non-web)
  bool get isSupported => false;

  /// Check if WASM is initialized (always false on non-web)
  bool get isInitialized => false;

  /// Load and initialize WASM module (throws on non-web)
  Future<void> initialize() async {
    throw UnsupportedError(
      'WASM is only supported on web platform. '
      'Use pure Dart fallback implementation instead.',
    );
  }

  /// Compute diff using Myers algorithm (throws on non-web)
  String myersDiff({
    required String oldText,
    required String newText,
    int contextLines = 3,
  }) {
    throw UnsupportedError(
      'WASM is only supported on web platform. '
      'Use pure Dart fallback implementation instead.',
    );
  }

  /// Get diff statistics (throws on non-web)
  String diffStats({
    required String oldText,
    required String newText,
  }) {
    throw UnsupportedError(
      'WASM is only supported on web platform. '
      'Use pure Dart fallback implementation instead.',
    );
  }

  /// Parse diff result from JSON
  Map<String, dynamic> parseDiffResult(String json) {
    throw UnsupportedError('WASM is not supported on this platform');
  }

  /// Parse diff stats from JSON
  Map<String, int> parseDiffStats(String json) {
    throw UnsupportedError('WASM is not supported on this platform');
  }
}
