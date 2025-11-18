/// Type of runtime module
enum ModuleType {
  /// Node.js runtime
  runtime,

  /// OpenVSCode Server
  server,

  /// Extension pack
  extensions,

  /// Language server
  languageServer,

  /// Debug adapter
  debugAdapter,
}

extension ModuleTypeX on ModuleType {
  String get displayName {
    switch (this) {
      case ModuleType.runtime:
        return 'Runtime';
      case ModuleType.server:
        return 'Server';
      case ModuleType.extensions:
        return 'Extensions';
      case ModuleType.languageServer:
        return 'Language Server';
      case ModuleType.debugAdapter:
        return 'Debug Adapter';
    }
  }

  bool get isCritical {
    return this == ModuleType.runtime || this == ModuleType.server;
  }
}
