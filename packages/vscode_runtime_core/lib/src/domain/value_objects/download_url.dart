import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_url.freezed.dart';

/// Value Object: Download URL
/// Self-validating URL for downloads
@freezed
class DownloadUrl with _$DownloadUrl {
  const DownloadUrl._();

  const factory DownloadUrl(String value) = _DownloadUrl;

  /// Factory with validation
  factory DownloadUrl.fromString(String url) {
    final trimmed = url.trim();

    if (trimmed.isEmpty) {
      throw FormatException('URL cannot be empty');
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      throw FormatException('Invalid URL format: $trimmed');
    }

    if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw FormatException('URL must use http or https scheme');
    }

    if (!uri.hasAuthority) {
      throw FormatException('URL must have a host');
    }

    return DownloadUrl(trimmed);
  }

  /// Check if HTTPS
  bool get isSecure {
    final uri = Uri.parse(value);
    return uri.scheme == 'https';
  }

  /// Get host
  String get host {
    final uri = Uri.parse(value);
    return uri.host;
  }

  /// Get filename from URL
  String get filename {
    final uri = Uri.parse(value);
    if (uri.pathSegments.isEmpty) {
      return 'download';
    }
    return uri.pathSegments.last;
  }

  /// Check if valid
  bool get isValid {
    try {
      final uri = Uri.parse(value);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadUrl &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
