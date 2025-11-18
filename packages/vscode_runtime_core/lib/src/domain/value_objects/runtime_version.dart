import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';

part 'runtime_version.freezed.dart';

/// Value Object: Runtime Version
/// Immutable, self-validating semantic version
@freezed
class RuntimeVersion with _$RuntimeVersion implements Comparable<RuntimeVersion> {
  const RuntimeVersion._();

  const factory RuntimeVersion({
    required int major,
    required int minor,
    required int patch,
    String? preRelease,
    String? build,
  }) = _RuntimeVersion;

  /// Factory from string (e.g., "1.87.0" or "1.87.0-beta.1+build.123")
  factory RuntimeVersion.fromString(String version) {
    final cleanVersion = version.trim();

    if (cleanVersion.isEmpty) {
      throw FormatException('Version string cannot be empty');
    }

    // Split build metadata
    final buildSplit = cleanVersion.split('+');
    final versionPart = buildSplit[0];
    final build = buildSplit.length > 1 ? buildSplit[1] : null;

    // Split pre-release
    final preReleaseSplit = versionPart.split('-');
    final corePart = preReleaseSplit[0];
    final preRelease = preReleaseSplit.length > 1 ? preReleaseSplit[1] : null;

    // Parse core version
    final parts = corePart.split('.');
    if (parts.length < 3) {
      throw FormatException(
        'Invalid version format: $version. Expected format: major.minor.patch',
      );
    }

    try {
      return RuntimeVersion(
        major: int.parse(parts[0]),
        minor: int.parse(parts[1]),
        patch: int.parse(parts[2]),
        preRelease: preRelease,
        build: build,
      );
    } on FormatException catch (e) {
      throw FormatException('Invalid version numbers: ${e.message}');
    }
  }

  /// Validate version
  Either<String, RuntimeVersion> validate() {
    if (major < 0) {
      return left('Major version must be non-negative');
    }
    if (minor < 0) {
      return left('Minor version must be non-negative');
    }
    if (patch < 0) {
      return left('Patch version must be non-negative');
    }
    return right(this);
  }

  /// Compare versions (ignoring pre-release and build)
  bool isNewerThan(RuntimeVersion other) {
    if (major != other.major) return major > other.major;
    if (minor != other.minor) return minor > other.minor;
    return patch > other.patch;
  }

  /// Check if compatible (same major version)
  bool isCompatibleWith(RuntimeVersion other) {
    return major == other.major;
  }

  /// Check if exact match
  bool isExactMatch(RuntimeVersion other) {
    return major == other.major &&
        minor == other.minor &&
        patch == other.patch &&
        preRelease == other.preRelease;
  }

  @override
  int compareTo(RuntimeVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);

    // Compare pre-release (versions without pre-release are greater)
    if (preRelease == null && other.preRelease == null) return 0;
    if (preRelease == null) return 1;
    if (other.preRelease == null) return -1;

    return preRelease!.compareTo(other.preRelease!);
  }

  @override
  String toString() {
    final buffer = StringBuffer('$major.$minor.$patch');
    if (preRelease != null) {
      buffer.write('-$preRelease');
    }
    if (build != null) {
      buffer.write('+$build');
    }
    return buffer.toString();
  }

  /// Get core version without pre-release/build
  String get coreVersion => '$major.$minor.$patch';
}
