import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/download_url.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('DownloadUrl', () {
    group('constructor', () {
      test('creates valid HTTP URL', () {
        final url = DownloadUrl(value: 'http://example.com/file.zip');
        expect(url.value, 'http://example.com/file.zip');
      });

      test('creates valid HTTPS URL', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip');
        expect(url.value, 'https://example.com/file.zip');
      });

      test('creates URL with port', () {
        final url = DownloadUrl(value: 'https://example.com:8080/file.zip');
        expect(url.value, 'https://example.com:8080/file.zip');
      });

      test('creates URL with path', () {
        final url = DownloadUrl(value: 'https://example.com/path/to/file.zip');
        expect(url.value, 'https://example.com/path/to/file.zip');
      });

      test('creates URL with query parameters', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip?version=1.0');
        expect(url.value, 'https://example.com/file.zip?version=1.0');
      });

      test('creates URL with fragment', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip#section');
        expect(url.value, 'https://example.com/file.zip#section');
      });

      test('throws on empty string', () {
        expect(
          () => DownloadUrl(value: ''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on invalid URL', () {
        expect(
          () => DownloadUrl(value: 'not a url'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on FTP URL', () {
        expect(
          () => DownloadUrl(value: 'ftp://example.com/file.zip'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on file URL', () {
        expect(
          () => DownloadUrl(value: 'file:///path/to/file.zip'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on URL without scheme', () {
        expect(
          () => DownloadUrl(value: 'example.com/file.zip'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on URL without host', () {
        expect(
          () => DownloadUrl(value: 'https:///file.zip'),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('uri', () {
      test('returns Uri object', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip');
        final uri = url.uri;
        expect(uri.scheme, 'https');
        expect(uri.host, 'example.com');
        expect(uri.path, '/file.zip');
      });

      test('parsed Uri has correct components', () {
        final url = DownloadUrl(value: 'https://example.com:8080/path/file.zip?v=1#top');
        final uri = url.uri;
        expect(uri.scheme, 'https');
        expect(uri.host, 'example.com');
        expect(uri.port, 8080);
        expect(uri.path, '/path/file.zip');
        expect(uri.query, 'v=1');
        expect(uri.fragment, 'top');
      });
    });

    group('filename', () {
      test('extracts filename from simple path', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip');
        expect(url.filename, 'file.zip');
      });

      test('extracts filename from nested path', () {
        final url = DownloadUrl(value: 'https://example.com/path/to/file.tar.gz');
        expect(url.filename, 'file.tar.gz');
      });

      test('extracts filename with query params', () {
        final url = DownloadUrl(value: 'https://example.com/file.zip?version=1.0');
        expect(url.filename, 'file.zip');
      });

      test('returns empty string for root path', () {
        final url = DownloadUrl(value: 'https://example.com/');
        expect(url.filename, '');
      });

      test('returns empty string for path ending with slash', () {
        final url = DownloadUrl(value: 'https://example.com/path/');
        expect(url.filename, '');
      });

      test('handles filename with special characters', () {
        final url = DownloadUrl(value: 'https://example.com/my-file_v1.0.zip');
        expect(url.filename, 'my-file_v1.0.zip');
      });
    });

    group('toString', () {
      test('returns the URL value', () {
        const urlString = 'https://example.com/file.zip';
        final url = DownloadUrl(value: urlString);
        expect(url.toString(), urlString);
      });
    });

    group('equality', () {
      test('equal URLs are equal', () {
        final url1 = DownloadUrl(value: 'https://example.com/file.zip');
        final url2 = DownloadUrl(value: 'https://example.com/file.zip');
        expect(url1, equals(url2));
        expect(url1.hashCode, equals(url2.hashCode));
      });

      test('different URLs are not equal', () {
        final url1 = DownloadUrl(value: 'https://example.com/file1.zip');
        final url2 = DownloadUrl(value: 'https://example.com/file2.zip');
        expect(url1, isNot(equals(url2)));
      });

      test('HTTP and HTTPS URLs are not equal', () {
        final url1 = DownloadUrl(value: 'http://example.com/file.zip');
        final url2 = DownloadUrl(value: 'https://example.com/file.zip');
        expect(url1, isNot(equals(url2)));
      });
    });

    group('copyWith', () {
      test('creates copy with new value', () {
        final url1 = DownloadUrl(value: 'https://example.com/file1.zip');
        final url2 = url1.copyWith(value: 'https://example.com/file2.zip');
        expect(url2.value, 'https://example.com/file2.zip');
        expect(url1.value, 'https://example.com/file1.zip');
      });
    });

    group('real-world URLs', () {
      test('accepts GitHub release URL', () {
        final url = DownloadUrl(
          value: 'https://github.com/owner/repo/releases/download/v1.0.0/file.tar.gz',
        );
        expect(url.filename, 'file.tar.gz');
      });

      test('accepts CDN URL', () {
        final url = DownloadUrl(
          value: 'https://cdn.example.com/dist/v1.0.0/runtime-linux-x64.zip',
        );
        expect(url.filename, 'runtime-linux-x64.zip');
      });

      test('accepts URL with encoded characters', () {
        final url = DownloadUrl(
          value: 'https://example.com/my%20file.zip',
        );
        expect(url.value, 'https://example.com/my%20file.zip');
      });

      test('accepts complex real-world URL', () {
        final url = DownloadUrl(
          value: 'https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.gz',
        );
        expect(url.filename, 'node-v20.10.0-linux-x64.tar.gz');
        expect(url.uri.host, 'nodejs.org');
      });
    });
  });
}
