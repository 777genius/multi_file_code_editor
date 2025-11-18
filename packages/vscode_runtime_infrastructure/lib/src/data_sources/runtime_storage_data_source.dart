import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/runtime_installation_dto.dart';

/// Runtime Storage Data Source
/// Handles persistence of installation state to local storage
class RuntimeStorageDataSource {
  final Directory _storageDirectory;

  RuntimeStorageDataSource(this._storageDirectory);

  static const String _installationFileName = 'installation.json';
  static const String _installedVersionFileName = 'installed_version.txt';

  /// Save installation state
  Future<void> saveInstallation(RuntimeInstallationDto installation) async {
    final file = File(
      path.join(_storageDirectory.path, _installationFileName),
    );

    await file.parent.create(recursive: true);

    final json = jsonEncode(installation.toJson());
    await file.writeAsString(json);
  }

  /// Load installation state
  Future<RuntimeInstallationDto?> loadInstallation() async {
    final file = File(
      path.join(_storageDirectory.path, _installationFileName),
    );

    if (!await file.exists()) {
      return null;
    }

    try {
      final json = await file.readAsString();
      final data = jsonDecode(json) as Map<String, dynamic>;

      return RuntimeInstallationDto.fromJson(data);
    } catch (e) {
      // If file is corrupted, return null
      return null;
    }
  }

  /// Delete installation state
  Future<void> deleteInstallation() async {
    final file = File(
      path.join(_storageDirectory.path, _installationFileName),
    );

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Save installed runtime version
  Future<void> saveInstalledVersion(String version) async {
    final file = File(
      path.join(_storageDirectory.path, _installedVersionFileName),
    );

    await file.parent.create(recursive: true);
    await file.writeAsString(version);
  }

  /// Get installed runtime version
  Future<String?> getInstalledVersion() async {
    final file = File(
      path.join(_storageDirectory.path, _installedVersionFileName),
    );

    if (!await file.exists()) {
      return null;
    }

    try {
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  /// Check if a module is installed
  Future<bool> isModuleInstalled(String moduleId) async {
    final moduleMarkerFile = File(
      path.join(_storageDirectory.path, 'modules', moduleId, '.installed'),
    );

    return moduleMarkerFile.exists();
  }

  /// Mark module as installed
  Future<void> markModuleInstalled(String moduleId) async {
    final moduleMarkerFile = File(
      path.join(_storageDirectory.path, 'modules', moduleId, '.installed'),
    );

    await moduleMarkerFile.parent.create(recursive: true);
    await moduleMarkerFile.writeAsString(DateTime.now().toIso8601String());
  }

  /// Unmark module as installed
  Future<void> unmarkModuleInstalled(String moduleId) async {
    final moduleMarkerFile = File(
      path.join(_storageDirectory.path, 'modules', moduleId, '.installed'),
    );

    if (await moduleMarkerFile.exists()) {
      await moduleMarkerFile.delete();
    }
  }
}
