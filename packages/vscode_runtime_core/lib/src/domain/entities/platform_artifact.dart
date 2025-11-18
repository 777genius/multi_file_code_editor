import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/download_url.dart';
import '../value_objects/sha256_hash.dart';
import '../value_objects/byte_size.dart';

part 'platform_artifact.freezed.dart';
part 'platform_artifact.g.dart';

/// Entity: Platform Artifact
/// Platform-specific download artifact
@freezed
class PlatformArtifact with _$PlatformArtifact {
  const PlatformArtifact._();

  const factory PlatformArtifact({
    required DownloadUrl url,
    required SHA256Hash hash,
    required ByteSize size,
    String? compressionFormat,
  }) = _PlatformArtifact;

  factory PlatformArtifact.fromJson(Map<String, dynamic> json) =>
      _$PlatformArtifactFromJson(json);

  /// Validation
  bool get isValid {
    return url.isValid && size.isNonZero;
  }

  /// Get expected compression format from URL
  String get detectedCompressionFormat {
    if (compressionFormat != null) return compressionFormat!;

    final filename = url.filename.toLowerCase();
    if (filename.endsWith('.zip')) return 'zip';
    if (filename.endsWith('.tar.gz') || filename.endsWith('.tgz')) {
      return 'tar.gz';
    }
    if (filename.endsWith('.tar.xz')) return 'tar.xz';
    if (filename.endsWith('.tar.bz2')) return 'tar.bz2';

    return 'unknown';
  }

  /// Check if artifact needs extraction
  bool get needsExtraction {
    final format = detectedCompressionFormat;
    return format != 'unknown' && format != 'none';
  }
}
