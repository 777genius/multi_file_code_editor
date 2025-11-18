import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/entities/platform_artifact.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/download_url.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/sha256_hash.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/byte_size.dart';

void main() {
  group('PlatformArtifact', () {
    late DownloadUrl testUrl;
    late SHA256Hash testHash;
    late ByteSize testSize;

    setUp(() {
      testUrl = DownloadUrl(value: 'https://example.com/file.zip');
      testHash = SHA256Hash(value: 'a' * 64);
      testSize = ByteSize.fromMB(10);
    });

    group('constructor', () {
      test('creates valid artifact', () {
        final artifact = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.url, testUrl);
        expect(artifact.hash, testHash);
        expect(artifact.size, testSize);
        expect(artifact.compressionFormat, isNull);
      });

      test('creates artifact with compression format', () {
        final artifact = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
          compressionFormat: 'zip',
        );

        expect(artifact.compressionFormat, 'zip');
      });
    });

    group('isValid', () {
      test('returns true for valid artifact', () {
        final artifact = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.isValid, isTrue);
      });

      test('returns false for zero size', () {
        final artifact = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: ByteSize(bytes: 0),
        );

        expect(artifact.isValid, isFalse);
      });
    });

    group('detectedCompressionFormat', () {
      test('returns explicit compression format when provided', () {
        final artifact = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
          compressionFormat: 'custom',
        );

        expect(artifact.detectedCompressionFormat, 'custom');
      });

      test('detects zip format from URL', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'zip');
      });

      test('detects tar.gz format from URL', () {
        final url = DownloadUrl(value: 'https://example.com/file.tar.gz');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'tar.gz');
      });

      test('detects tgz format from URL', () {
        final url = DownloadUrl(value: 'https://example.com/file.tgz');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'tar.gz');
      });

      test('detects tar.xz format from URL', () {
        final url = DownloadUrl(value: 'https://example.com/file.tar.xz');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'tar.xz');
      });

      test('detects tar.bz2 format from URL', () {
        final url = DownloadUrl(value: 'https://example.com/file.tar.bz2');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'tar.bz2');
      });

      test('returns unknown for unrecognized extension', () {
        final url = DownloadUrl(value: 'https://example.com/file.exe');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'unknown');
      });

      test('returns unknown for no extension', () {
        final url = DownloadUrl(value: 'https://example.com/file');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'unknown');
      });

      test('is case-insensitive', () {
        final url = DownloadUrl(value: 'https://example.com/file.ZIP');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.detectedCompressionFormat, 'zip');
      });
    });

    group('needsExtraction', () {
      test('returns true for zip files', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.needsExtraction, isTrue);
      });

      test('returns true for tar.gz files', () {
        final url = DownloadUrl(value: 'https://example.com/file.tar.gz');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.needsExtraction, isTrue);
      });

      test('returns false for unknown format', () {
        final url = DownloadUrl(value: 'https://example.com/file.exe');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
        );

        expect(artifact.needsExtraction, isFalse);
      });

      test('returns false for none format', () {
        final url = DownloadUrl(value: 'https://example.com/file.exe');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
          compressionFormat: 'none',
        );

        expect(artifact.needsExtraction, isFalse);
      });

      test('returns true for explicit compression format', () {
        final url = DownloadUrl(value: 'https://example.com/file');
        final artifact = PlatformArtifact(
          url: url,
          hash: testHash,
          size: testSize,
          compressionFormat: 'zip',
        );

        expect(artifact.needsExtraction, isTrue);
      });
    });

    group('equality', () {
      test('equal artifacts are equal', () {
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final artifact2 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );

        expect(artifact1, equals(artifact2));
      });

      test('different URLs make artifacts unequal', () {
        final url2 = DownloadUrl(value: 'https://example.com/other.zip');
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final artifact2 = PlatformArtifact(
          url: url2,
          hash: testHash,
          size: testSize,
        );

        expect(artifact1, isNot(equals(artifact2)));
      });

      test('different hashes make artifacts unequal', () {
        final hash2 = SHA256Hash(value: 'b' * 64);
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final artifact2 = PlatformArtifact(
          url: testUrl,
          hash: hash2,
          size: testSize,
        );

        expect(artifact1, isNot(equals(artifact2)));
      });

      test('different sizes make artifacts unequal', () {
        final size2 = ByteSize.fromMB(20);
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final artifact2 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: size2,
        );

        expect(artifact1, isNot(equals(artifact2)));
      });

      test('different compression formats make artifacts unequal', () {
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
          compressionFormat: 'zip',
        );
        final artifact2 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
          compressionFormat: 'tar.gz',
        );

        expect(artifact1, isNot(equals(artifact2)));
      });
    });

    group('copyWith', () {
      test('creates copy with new URL', () {
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final newUrl = DownloadUrl(value: 'https://example.com/new.zip');
        final artifact2 = artifact1.copyWith(url: newUrl);

        expect(artifact2.url, newUrl);
        expect(artifact2.hash, testHash);
        expect(artifact2.size, testSize);
      });

      test('creates copy with new hash', () {
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final newHash = SHA256Hash(value: 'b' * 64);
        final artifact2 = artifact1.copyWith(hash: newHash);

        expect(artifact2.url, testUrl);
        expect(artifact2.hash, newHash);
        expect(artifact2.size, testSize);
      });

      test('creates copy with new size', () {
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final newSize = ByteSize.fromMB(20);
        final artifact2 = artifact1.copyWith(size: newSize);

        expect(artifact2.url, testUrl);
        expect(artifact2.hash, testHash);
        expect(artifact2.size, newSize);
      });

      test('creates copy with new compression format', () {
        final artifact1 = PlatformArtifact(
          url: testUrl,
          hash: testHash,
          size: testSize,
        );
        final artifact2 = artifact1.copyWith(compressionFormat: 'zip');

        expect(artifact2.compressionFormat, 'zip');
      });
    });

    group('real-world scenarios', () {
      test('creates Node.js artifact', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl(value: 'https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.gz'),
          hash: SHA256Hash(value: 'a' * 64),
          size: ByteSize.fromMB(50),
        );

        expect(artifact.detectedCompressionFormat, 'tar.gz');
        expect(artifact.needsExtraction, isTrue);
        expect(artifact.isValid, isTrue);
      });

      test('creates OpenVSCode Server artifact', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl(value: 'https://github.com/gitpod-io/openvscode-server/releases/download/v1.85.0/openvscode-server-v1.85.0-linux-x64.tar.gz'),
          hash: SHA256Hash(value: 'b' * 64),
          size: ByteSize.fromMB(120),
        );

        expect(artifact.detectedCompressionFormat, 'tar.gz');
        expect(artifact.needsExtraction, isTrue);
        expect(artifact.isValid, isTrue);
      });

      test('creates Windows zip artifact', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl(value: 'https://example.com/runtime-windows-x64.zip'),
          hash: SHA256Hash(value: 'c' * 64),
          size: ByteSize.fromMB(75),
        );

        expect(artifact.detectedCompressionFormat, 'zip');
        expect(artifact.needsExtraction, isTrue);
        expect(artifact.isValid, isTrue);
      });
    });
  });
}
