/// Platform-aware WASM diff loader
///
/// Exports the correct implementation based on platform:
/// - diff_wasm_loader.dart for web
/// - diff_wasm_stub.dart for other platforms
export 'diff_wasm_stub.dart'
    if (dart.library.html) 'diff_wasm_loader.dart';
