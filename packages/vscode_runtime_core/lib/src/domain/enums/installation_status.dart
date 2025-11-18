/// Status of runtime installation
enum InstallationStatus {
  /// Installation pending (not started)
  pending,

  /// Installation in progress
  inProgress,

  /// Installation completed successfully
  completed,

  /// Installation failed
  failed,

  /// Installation cancelled
  cancelled,
}

extension InstallationStatusX on InstallationStatus {
  bool get isTerminal {
    return this == InstallationStatus.completed ||
        this == InstallationStatus.failed ||
        this == InstallationStatus.cancelled;
  }

  bool get isActive {
    return this == InstallationStatus.inProgress;
  }

  bool get canStart {
    return this == InstallationStatus.pending;
  }

  bool get canCancel {
    return this == InstallationStatus.inProgress;
  }

  String get displayName {
    switch (this) {
      case InstallationStatus.pending:
        return 'Pending';
      case InstallationStatus.inProgress:
        return 'In Progress';
      case InstallationStatus.completed:
        return 'Completed';
      case InstallationStatus.failed:
        return 'Failed';
      case InstallationStatus.cancelled:
        return 'Cancelled';
    }
  }
}
