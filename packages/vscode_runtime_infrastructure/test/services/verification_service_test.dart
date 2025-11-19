import 'dart:io';
import 'package:test/test.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_infrastructure/src/services/verification_service.dart';

void main() {
  late VerificationService service;
  late Directory tempDir;

  setUp(() {
    service = VerificationService();
  });

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('verification_service_test_');
  });

  tearDownAll() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('VerificationService', () {
    group('verifyFileReadable', () {
      test('should succeed for existing readable file', () async {
        // Arrange
        final file = File('${tempDir.path}/test.txt');
        await file.writeAsString('test content');

        // Act
        final result = await service.verifyFileReadable(file);

        // Assert
        expect(result.isRight(), isTrue);

        // Cleanup
        await file.delete();
      });

      test('should fail for non-existent file', () async {
        // Arrange
        final file = File('${tempDir.path}/nonexistent.txt');

        // Act
        final result = await service.verifyFileReadable(file);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<NotFoundException>());
            expect(error.message, contains('does not exist'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should fail for empty file', () async {
        // Arrange
        final file = File('${tempDir.path}/empty.txt');
        await file.writeAsString('');

        // Act
        final result = await service.verifyFileReadable(file);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ValidationException>());
            expect(error.message, contains('empty'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await file.delete();
      });
    });

    group('computeHash', () {
      test('should compute correct SHA256 hash', () async {
        // Arrange
        final file = File('${tempDir.path}/hash_test.txt');
        await file.writeAsString('test content');

        // Act
        final result = await service.computeHash(file);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (hash) {
            expect(hash.value.length, equals(64));
            // Verify it's a valid hex string
            expect(RegExp(r'^[a-f0-9]{64}$').hasMatch(hash.value), isTrue);
          },
        );

        // Cleanup
        await file.delete();
      });

      test('should return same hash for same content', () async {
        // Arrange
        final file1 = File('${tempDir.path}/file1.txt');
        final file2 = File('${tempDir.path}/file2.txt');
        await file1.writeAsString('identical content');
        await file2.writeAsString('identical content');

        // Act
        final result1 = await service.computeHash(file1);
        final result2 = await service.computeHash(file2);

        // Assert
        expect(result1.isRight(), isTrue);
        expect(result2.isRight(), isTrue);

        final hash1 = result1.getOrElse(() => throw Exception());
        final hash2 = result2.getOrElse(() => throw Exception());

        expect(hash1.value, equals(hash2.value));

        // Cleanup
        await file1.delete();
        await file2.delete();
      });

      test('should return different hash for different content', () async {
        // Arrange
        final file1 = File('${tempDir.path}/file1.txt');
        final file2 = File('${tempDir.path}/file2.txt');
        await file1.writeAsString('content one');
        await file2.writeAsString('content two');

        // Act
        final result1 = await service.computeHash(file1);
        final result2 = await service.computeHash(file2);

        // Assert
        expect(result1.isRight(), isTrue);
        expect(result2.isRight(), isTrue);

        final hash1 = result1.getOrElse(() => throw Exception());
        final hash2 = result2.getOrElse(() => throw Exception());

        expect(hash1.value, isNot(equals(hash2.value)));

        // Cleanup
        await file1.delete();
        await file2.delete();
      });

      test('should fail for non-existent file', () async {
        // Arrange
        final file = File('${tempDir.path}/nonexistent.txt');

        // Act
        final result = await service.computeHash(file);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, isA<DomainException>()),
          (_) => fail('Should fail'),
        );
      });
    });

    group('verifyHash', () {
      test('should succeed when hashes match', () async {
        // Arrange
        final file = File('${tempDir.path}/verify_hash.txt');
        await file.writeAsString('test content');

        final computedHashResult = await service.computeHash(file);
        final computedHash = computedHashResult.getOrElse(() => throw Exception());

        // Act
        final result = await service.verifyHash(
          file: file,
          expectedHash: computedHash,
        );

        // Assert
        expect(result.isRight(), isTrue);

        // Cleanup
        await file.delete();
      });

      test('should fail when hashes do not match', () async {
        // Arrange
        final file = File('${tempDir.path}/verify_hash.txt');
        await file.writeAsString('test content');

        final wrongHash = SHA256Hash.fromString('a' * 64);

        // Act
        final result = await service.verifyHash(
          file: file,
          expectedHash: wrongHash,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Hash mismatch'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await file.delete();
      });

      test('should fail for non-existent file', () async {
        // Arrange
        final file = File('${tempDir.path}/nonexistent.txt');
        final hash = SHA256Hash.fromString('a' * 64);

        // Act
        final result = await service.verifyHash(file: file, expectedHash: hash);

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });

    group('verifySize', () {
      test('should succeed when sizes match', () async {
        // Arrange
        final file = File('${tempDir.path}/size_test.txt');
        final content = 'test content';
        await file.writeAsString(content);

        final expectedSize = ByteSize(content.length);

        // Act
        final result = await service.verifySize(
          file: file,
          expectedSize: expectedSize,
        );

        // Assert
        expect(result.isRight(), isTrue);

        // Cleanup
        await file.delete();
      });

      test('should fail when sizes do not match', () async {
        // Arrange
        final file = File('${tempDir.path}/size_test.txt');
        await file.writeAsString('test content');

        final wrongSize = ByteSize(1000);

        // Act
        final result = await service.verifySize(
          file: file,
          expectedSize: wrongSize,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Size mismatch'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await file.delete();
      });

      test('should fail for non-existent file', () async {
        // Arrange
        final file = File('${tempDir.path}/nonexistent.txt');
        final size = ByteSize(100);

        // Act
        final result = await service.verifySize(file: file, expectedSize: size);

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });

    group('verify (combined hash and size)', () {
      test('should succeed when both hash and size match', () async {
        // Arrange
        final file = File('${tempDir.path}/combined_test.txt');
        final content = 'test content for combined verification';
        await file.writeAsString(content);

        final computedHashResult = await service.computeHash(file);
        final computedHash = computedHashResult.getOrElse(() => throw Exception());
        final expectedSize = ByteSize(content.length);

        // Act
        final result = await service.verify(
          file: file,
          expectedHash: computedHash,
          expectedSize: expectedSize,
        );

        // Assert
        expect(result.isRight(), isTrue);

        // Cleanup
        await file.delete();
      });

      test('should fail when size does not match (checked first)', () async {
        // Arrange
        final file = File('${tempDir.path}/combined_test.txt');
        await file.writeAsString('test content');

        final computedHashResult = await service.computeHash(file);
        final computedHash = computedHashResult.getOrElse(() => throw Exception());
        final wrongSize = ByteSize(1000);

        // Act
        final result = await service.verify(
          file: file,
          expectedHash: computedHash,
          expectedSize: wrongSize,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Size mismatch'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await file.delete();
      });

      test('should fail when hash does not match (checked after size)', () async {
        // Arrange
        final file = File('${tempDir.path}/combined_test.txt');
        final content = 'test content';
        await file.writeAsString(content);

        final wrongHash = SHA256Hash.fromString('a' * 64);
        final expectedSize = ByteSize(content.length);

        // Act
        final result = await service.verify(
          file: file,
          expectedHash: wrongHash,
          expectedSize: expectedSize,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Hash mismatch'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await file.delete();
      });

      test('should fail when both do not match', () async {
        // Arrange
        final file = File('${tempDir.path}/combined_test.txt');
        await file.writeAsString('test content');

        final wrongHash = SHA256Hash.fromString('a' * 64);
        final wrongSize = ByteSize(1000);

        // Act
        final result = await service.verify(
          file: file,
          expectedHash: wrongHash,
          expectedSize: wrongSize,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            // Size is checked first, so should fail with size mismatch
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Size mismatch'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await file.delete();
      });
    });

    group('Real-world scenarios', () {
      test('should verify downloaded binary file', () async {
        // Arrange - Create a "binary" file with specific content
        final file = File('${tempDir.path}/binary.dat');
        final bytes = List.generate(1024, (i) => i % 256);
        await file.writeAsBytes(bytes);

        // Compute expected hash
        final hashResult = await service.computeHash(file);
        final expectedHash = hashResult.getOrElse(() => throw Exception());
        final expectedSize = ByteSize(bytes.length);

        // Act
        final result = await service.verify(
          file: file,
          expectedHash: expectedHash,
          expectedSize: expectedSize,
        );

        // Assert
        expect(result.isRight(), isTrue);

        // Cleanup
        await file.delete();
      });

      test('should detect corrupted download', () async {
        // Arrange - Simulate a corrupted download
        final file = File('${tempDir.path}/corrupted.dat');
        final originalBytes = List.generate(1024, (i) => i % 256);
        await file.writeAsBytes(originalBytes);

        // Get original hash
        final hashResult = await service.computeHash(file);
        final originalHash = hashResult.getOrElse(() => throw Exception());

        // Corrupt the file
        final corruptedBytes = List.generate(1024, (i) => (i + 1) % 256);
        await file.writeAsBytes(corruptedBytes);

        // Act - Verify with original hash
        final result = await service.verifyHash(
          file: file,
          expectedHash: originalHash,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Hash mismatch'));
          },
          (_) => fail('Should detect corruption'),
        );

        // Cleanup
        await file.delete();
      });

      test('should detect partial download (size mismatch)', () async {
        // Arrange - Simulate partial download
        final file = File('${tempDir.path}/partial.dat');
        final partialBytes = List.generate(512, (i) => i % 256);
        await file.writeAsBytes(partialBytes);

        final expectedSize = ByteSize(1024); // Expected full size

        // Act
        final result = await service.verifySize(
          file: file,
          expectedSize: expectedSize,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<VerificationException>());
            expect(error.message, contains('Size mismatch'));
          },
          (_) => fail('Should detect partial download'),
        );

        // Cleanup
        await file.delete();
      });
    });
  });
}
