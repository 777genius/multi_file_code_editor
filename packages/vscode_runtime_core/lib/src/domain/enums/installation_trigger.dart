/// What triggered the installation
enum InstallationTrigger {
  /// User manually triggered installation
  manual,

  /// User manually triggered from welcome screen
  welcomeScreen,

  /// User opened a file that requires extensions
  fileOpen,

  /// User clicked install from marketplace
  marketplace,

  /// User triggered from settings
  settings,

  /// Automatic update
  autoUpdate,

  /// System requirement (dependency)
  systemRequirement,
}

extension InstallationTriggerX on InstallationTrigger {
  String get displayName {
    switch (this) {
      case InstallationTrigger.manual:
        return 'Manual';
      case InstallationTrigger.welcomeScreen:
        return 'Welcome Screen';
      case InstallationTrigger.fileOpen:
        return 'File Open';
      case InstallationTrigger.marketplace:
        return 'Marketplace';
      case InstallationTrigger.settings:
        return 'Settings';
      case InstallationTrigger.autoUpdate:
        return 'Auto Update';
      case InstallationTrigger.systemRequirement:
        return 'System Requirement';
    }
  }

  bool get isUserInitiated {
    return this != InstallationTrigger.autoUpdate &&
        this != InstallationTrigger.systemRequirement;
  }
}
