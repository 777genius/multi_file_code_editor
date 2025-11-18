import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:platform/platform.dart' as platform_pkg;
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// Platform Service Implementation
/// Handles platform detection and system information
class PlatformService implements IPlatformService {
  final platform_pkg.Platform _platform;

  PlatformService([platform_pkg.Platform? platform])
      : _platform = platform ?? const platform_pkg.LocalPlatform();

  @override
  Future<Either<DomainException, PlatformIdentifier>> getCurrentPlatform() async {
    try {
      final os = _getOperatingSystem();
      final arch = _getArchitecture();

      final platformId = PlatformIdentifier(os: os, architecture: arch);

      return right(platformId);
    } catch (e) {
      return left(
        DomainException('Failed to get current platform: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> isPlatformSupported(
    PlatformIdentifier platform,
  ) async {
    try {
      // Check if the platform is one of the well-known supported platforms
      final supportedPlatforms = [
        PlatformIdentifier.windowsX64,
        PlatformIdentifier.linuxX64,
        PlatformIdentifier.macosX64,
        PlatformIdentifier.macosArm64,
      ];

      final isSupported = supportedPlatforms.any(
        (p) => p.os == platform.os && p.architecture == platform.architecture,
      );

      return right(isSupported);
    } catch (e) {
      return left(
        DomainException(
          'Failed to check platform support: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, PlatformInfo>> getPlatformInfo() async {
    try {
      final platformResult = await getCurrentPlatform();

      return platformResult.fold(
        (error) => left(error),
        (identifier) async {
          final osVersion = await _getOperatingSystemVersion();
          final processors = _platform.numberOfProcessors;

          final info = PlatformInfo(
            identifier: identifier,
            osName: _getOperatingSystemName(),
            osVersion: osVersion,
            architecture: identifier.architecture,
            numberOfProcessors: processors,
          );

          return right(info);
        },
      );
    } catch (e) {
      return left(
        DomainException('Failed to get platform info: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, int>> getAvailableDiskSpace() async {
    try {
      // Get installation directory to check its disk space
      final homeDir = Platform.environment['HOME'] ??
                      Platform.environment['USERPROFILE'] ??
                      '/tmp';

      int availableBytes = 0;

      if (Platform.isLinux || Platform.isMacOS) {
        final result = await Process.run('df', ['-k', homeDir]);
        if (result.exitCode == 0) {
          final lines = (result.stdout as String).split('\n');
          if (lines.length > 1) {
            final parts = lines[1].split(RegExp(r'\s+'));
            if (parts.length > 3) {
              // Available space is in KB, convert to bytes
              availableBytes = int.parse(parts[3]) * 1024;
            }
          }
        }
      } else if (Platform.isWindows) {
        // On Windows, use WMIC to get free space
        final driveLetter = homeDir.substring(0, 2); // e.g., "C:"
        final result = await Process.run(
          'wmic',
          ['logicaldisk', 'where', 'DeviceID="$driveLetter"', 'get', 'FreeSpace'],
        );

        if (result.exitCode == 0) {
          final output = (result.stdout as String).split('\n');
          if (output.length > 1) {
            final freeSpace = output[1].trim();
            if (freeSpace.isNotEmpty) {
              availableBytes = int.parse(freeSpace);
            }
          }
        }
      }

      // If we couldn't get the actual size, return a large default (100GB)
      if (availableBytes == 0) {
        availableBytes = 100 * 1024 * 1024 * 1024;
      }

      return right(availableBytes);
    } catch (e) {
      // Return a reasonable default on error
      return right(100 * 1024 * 1024 * 1024); // 100GB
    }
  }

  @override
  Future<Either<DomainException, bool>> hasRequiredPermissions() async {
    try {
      // Check if we can write to the application directory
      final testDir = Directory.systemTemp.createTempSync('vscode_runtime_test');

      try {
        final testFile = File('${testDir.path}/test.txt');
        await testFile.writeAsString('test');
        await testFile.delete();
        await testDir.delete();

        return right(true);
      } catch (e) {
        return right(false);
      }
    } catch (e) {
      return left(
        DomainException(
          'Failed to check permissions: ${e.toString()}',
        ),
      );
    }
  }

  // Private helpers

  String _getOperatingSystem() {
    if (_platform.isWindows) return 'windows';
    if (_platform.isLinux) return 'linux';
    if (_platform.isMacOS) return 'macos';
    throw UnsupportedError('Unsupported operating system');
  }

  String _getOperatingSystemName() {
    if (_platform.isWindows) return 'Windows';
    if (_platform.isLinux) return 'Linux';
    if (_platform.isMacOS) return 'macOS';
    return 'Unknown';
  }

  Future<String> _getOperatingSystemVersion() async {
    try {
      if (Platform.isLinux) {
        final result = await Process.run('uname', ['-r']);
        if (result.exitCode == 0) {
          return (result.stdout as String).trim();
        }
      } else if (Platform.isMacOS) {
        final result = await Process.run('sw_vers', ['-productVersion']);
        if (result.exitCode == 0) {
          return (result.stdout as String).trim();
        }
      } else if (Platform.isWindows) {
        final result = await Process.run('ver', []);
        if (result.exitCode == 0) {
          return (result.stdout as String).trim();
        }
      }

      return Platform.operatingSystemVersion;
    } catch (e) {
      return Platform.operatingSystemVersion;
    }
  }

  String _getArchitecture() {
    // Dart doesn't provide direct architecture detection
    // We need to infer it from the platform
    final version = Platform.version;

    // Check for ARM in the version string
    if (version.contains('arm64') || version.contains('aarch64')) {
      return 'arm64';
    }

    if (version.contains('arm')) {
      return 'arm';
    }

    // Default to x64 for most desktop platforms
    if (_platform.isWindows || _platform.isLinux || _platform.isMacOS) {
      return 'x64';
    }

    // Fallback
    return 'x64';
  }
}
