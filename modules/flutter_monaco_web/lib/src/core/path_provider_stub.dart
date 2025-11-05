// Stub for path_provider on web platform
// This file prevents compilation errors when path_provider is not available

/// Stub implementation for getApplicationSupportDirectory
/// This should never be called on web platform
Future<Directory> getApplicationSupportDirectory() {
  throw UnsupportedError(
    'getApplicationSupportDirectory is not supported on web platform',
  );
}

/// Stub Directory class for web
class Directory {
  final String path;
  Directory(this.path);

  bool existsSync() => false;
  Future<void> delete({bool recursive = false}) async {}
  Future<void> create({bool recursive = false}) async {}
  Stream<dynamic> list({bool recursive = false}) async* {}
}
