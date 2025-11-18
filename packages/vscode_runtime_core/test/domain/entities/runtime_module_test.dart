import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/src/domain/entities/runtime_module.dart';
import 'package:vscode_runtime_core/src/domain/entities/platform_artifact.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/module_id.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/runtime_version.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/platform_identifier.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/download_url.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/sha256_hash.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/byte_size.dart';
import 'package:vscode_runtime_core/src/domain/enums/module_type.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('RuntimeModule', () {
    late ModuleId testId;
    late RuntimeVersion testVersion;
    late Map<PlatformIdentifier, PlatformArtifact> testArtifacts;

    setUp(() {
      testId = ModuleId('test-module');
      testVersion = RuntimeVersion(major: 1, minor: 2, patch: 3);

      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      testArtifacts = {
        PlatformIdentifier.linuxX64: artifact,
        PlatformIdentifier.windowsX64: artifact,
      };
    });

    group('constructor', () {
      test('creates valid module', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        expect(module.id, testId);
        expect(module.name, 'Test Module');
        expect(module.description, 'A test module');
        expect(module.type, ModuleType.runtime);
        expect(module.version, testVersion);
        expect(module.platformArtifacts, testArtifacts);
        expect(module.dependencies, isEmpty);
        expect(module.isOptional, isFalse);
        expect(module.metadata, isNull);
      });

      test('creates module with dependencies', () {
        final dependencies = [
          ModuleId('dep1'),
          ModuleId('dep2'),
        ];
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          dependencies: dependencies,
        );

        expect(module.dependencies, dependencies);
        expect(module.hasDependencies, isTrue);
      });

      test('creates optional module', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          isOptional: true,
        );

        expect(module.isOptional, isTrue);
        expect(module.isCritical, isFalse);
      });

      test('creates module with metadata', () {
        final metadata = {'key1': 'value1', 'key2': 42};
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          metadata: metadata,
        );

        expect(module.metadata, metadata);
      });
    });

    group('create factory', () {
      test('creates valid module', () {
        final module = RuntimeModule.create(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        expect(module.id, testId);
        expect(module.name, 'Test Module');
      });

      test('throws on empty platform artifacts', () {
        expect(
          () => RuntimeModule.create(
            id: testId,
            name: 'Test Module',
            description: 'A test module',
            type: ModuleType.runtime,
            version: testVersion,
            platformArtifacts: {},
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on empty name', () {
        expect(
          () => RuntimeModule.create(
            id: testId,
            name: '',
            description: 'A test module',
            type: ModuleType.runtime,
            version: testVersion,
            platformArtifacts: testArtifacts,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on whitespace-only name', () {
        expect(
          () => RuntimeModule.create(
            id: testId,
            name: '   ',
            description: 'A test module',
            type: ModuleType.runtime,
            version: testVersion,
            platformArtifacts: testArtifacts,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on invalid artifact', () {
        final invalidArtifact = PlatformArtifact(
          url: DownloadUrl('https://example.com/file.tar.gz'),
          hash: SHA256Hash('a' * 64),
          size: ByteSize(0), // Invalid - zero size
        );

        expect(
          () => RuntimeModule.create(
            id: testId,
            name: 'Test Module',
            description: 'A test module',
            type: ModuleType.runtime,
            version: testVersion,
            platformArtifacts: {
              PlatformIdentifier.linuxX64: invalidArtifact,
            },
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('artifactFor', () {
      late RuntimeModule module;

      setUp(() {
        module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );
      });

      test('returns Some for existing platform', () {
        final result = module.artifactFor(PlatformIdentifier.linuxX64);
        expect(result.isSome(), isTrue);
        expect(result.getOrElse(() => throw Exception()), testArtifacts[PlatformIdentifier.linuxX64]);
      });

      test('returns None for non-existing platform', () {
        final result = module.artifactFor(PlatformIdentifier.macosArm64);
        expect(result.isNone(), isTrue);
      });
    });

    group('isAvailableForPlatform', () {
      late RuntimeModule module;

      setUp(() {
        module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );
      });

      test('returns true for available platform', () {
        expect(module.isAvailableForPlatform(PlatformIdentifier.linuxX64), isTrue);
        expect(module.isAvailableForPlatform(PlatformIdentifier.windowsX64), isTrue);
      });

      test('returns false for unavailable platform', () {
        expect(module.isAvailableForPlatform(PlatformIdentifier.macosArm64), isFalse);
        expect(module.isAvailableForPlatform(PlatformIdentifier.macosX64), isFalse);
      });
    });

    group('hasDependencies', () {
      test('returns false when no dependencies', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        expect(module.hasDependencies, isFalse);
      });

      test('returns true when has dependencies', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          dependencies: [ModuleId('dep1')],
        );

        expect(module.hasDependencies, isTrue);
      });
    });

    group('isCritical', () {
      test('returns true for non-optional module', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          isOptional: false,
        );

        expect(module.isCritical, isTrue);
      });

      test('returns false for optional module', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          isOptional: true,
        );

        expect(module.isCritical, isFalse);
      });
    });

    group('sizeForPlatform', () {
      late RuntimeModule module;

      setUp(() {
        module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );
      });

      test('returns Some with size for available platform', () {
        final result = module.sizeForPlatform(PlatformIdentifier.linuxX64);
        expect(result.isSome(), isTrue);
        expect(
          result.getOrElse(() => throw Exception()),
          testArtifacts[PlatformIdentifier.linuxX64]!.size,
        );
      });

      test('returns None for unavailable platform', () {
        final result = module.sizeForPlatform(PlatformIdentifier.macosArm64);
        expect(result.isNone(), isTrue);
      });
    });

    group('dependsOn', () {
      test('returns true when depends on module', () {
        final depId = ModuleId('dep1');
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          dependencies: [depId, ModuleId('dep2')],
        );

        expect(module.dependsOn(depId), isTrue);
      });

      test('returns false when does not depend on module', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
          dependencies: [ModuleId('dep1')],
        );

        expect(module.dependsOn(ModuleId('dep2')), isFalse);
      });
    });

    group('validateArtifacts', () {
      test('returns true when all artifacts are valid', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        expect(module.validateArtifacts(), isTrue);
      });

      test('returns false when any artifact is invalid', () {
        final invalidArtifact = PlatformArtifact(
          url: DownloadUrl('https://example.com/file.tar.gz'),
          hash: SHA256Hash('a' * 64),
          size: ByteSize(0),
        );

        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: {
            PlatformIdentifier.linuxX64: testArtifacts[PlatformIdentifier.linuxX64]!,
            PlatformIdentifier.windowsX64: invalidArtifact,
          },
        );

        expect(module.validateArtifacts(), isFalse);
      });
    });

    group('supportedPlatforms', () {
      test('returns list of supported platforms', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final platforms = module.supportedPlatforms;
        expect(platforms.length, 2);
        expect(platforms, contains(PlatformIdentifier.linuxX64));
        expect(platforms, contains(PlatformIdentifier.windowsX64));
      });

      test('returns empty list when no artifacts', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: {},
        );

        expect(module.supportedPlatforms, isEmpty);
      });
    });

    group('displayNameWithVersion', () {
      test('formats name with version', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Node.js',
          description: 'JavaScript runtime',
          type: ModuleType.runtime,
          version: RuntimeVersion(major: 20, minor: 10, patch: 0),
          platformArtifacts: testArtifacts,
        );

        expect(module.displayNameWithVersion, 'Node.js v20.10.0');
      });
    });

    group('hasCircularDependency', () {
      test('returns true when module ID is in visited set', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final visited = {testId};
        expect(module.hasCircularDependency(visited), isTrue);
      });

      test('returns false when module ID is not in visited set', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final visited = <ModuleId>{};
        expect(module.hasCircularDependency(visited), isFalse);
      });

      test('adds module ID to visited set', () {
        final module = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final visited = <ModuleId>{};
        module.hasCircularDependency(visited);
        expect(visited, contains(testId));
      });
    });

    group('equality', () {
      test('modules with same ID are equal', () {
        final module1 = RuntimeModule(
          id: testId,
          name: 'Test Module 1',
          description: 'Description 1',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final module2 = RuntimeModule(
          id: testId,
          name: 'Test Module 2',
          description: 'Description 2',
          type: ModuleType.server,
          version: RuntimeVersion(major: 2, minor: 0, patch: 0),
          platformArtifacts: testArtifacts,
        );

        expect(module1, equals(module2));
        expect(module1.hashCode, equals(module2.hashCode));
      });

      test('modules with different IDs are not equal', () {
        final module1 = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final module2 = RuntimeModule(
          id: ModuleId('other-module'),
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        expect(module1, isNot(equals(module2)));
      });
    });

    group('copyWith', () {
      test('creates copy with new name', () {
        final module1 = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final module2 = module1.copyWith(name: 'New Name');

        expect(module2.id, testId);
        expect(module2.name, 'New Name');
        expect(module1.name, 'Test Module');
      });

      test('creates copy with new version', () {
        final module1 = RuntimeModule(
          id: testId,
          name: 'Test Module',
          description: 'A test module',
          type: ModuleType.runtime,
          version: testVersion,
          platformArtifacts: testArtifacts,
        );

        final newVersion = RuntimeVersion(major: 2, minor: 0, patch: 0);
        final module2 = module1.copyWith(version: newVersion);

        expect(module2.version, newVersion);
        expect(module1.version, testVersion);
      });
    });

    group('real-world scenarios', () {
      test('creates Node.js module', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl('https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.gz'),
          hash: SHA256Hash('a' * 64),
          size: ByteSize.fromMB(50),
        );

        final module = RuntimeModule.create(
          id: ModuleId.nodejs,
          name: 'Node.js',
          description: 'JavaScript runtime built on Chrome\'s V8 engine',
          type: ModuleType.runtime,
          version: RuntimeVersion(major: 20, minor: 10, patch: 0),
          platformArtifacts: {
            PlatformIdentifier.linuxX64: artifact,
          },
        );

        expect(module.displayNameWithVersion, 'Node.js v20.10.0');
        expect(module.isCritical, isTrue);
        expect(module.hasDependencies, isFalse);
      });

      test('creates OpenVSCode Server module with Node.js dependency', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl('https://github.com/gitpod-io/openvscode-server/releases/download/v1.85.0/openvscode-server-v1.85.0-linux-x64.tar.gz'),
          hash: SHA256Hash('b' * 64),
          size: ByteSize.fromMB(120),
        );

        final module = RuntimeModule.create(
          id: ModuleId.openVSCodeServer,
          name: 'OpenVSCode Server',
          description: 'Headless VS Code server',
          type: ModuleType.server,
          version: RuntimeVersion(major: 1, minor: 85, patch: 0),
          platformArtifacts: {
            PlatformIdentifier.linuxX64: artifact,
          },
          dependencies: [ModuleId.nodejs],
        );

        expect(module.hasDependencies, isTrue);
        expect(module.dependsOn(ModuleId.nodejs), isTrue);
        expect(module.dependencies.length, 1);
      });

      test('creates base extensions module', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl('https://cdn.example.com/base-extensions-v1.0.0.zip'),
          hash: SHA256Hash('c' * 64),
          size: ByteSize.fromMB(5),
        );

        final module = RuntimeModule.create(
          id: ModuleId.baseExtensions,
          name: 'Base Extensions',
          description: 'Essential VS Code extensions',
          type: ModuleType.extensions,
          version: RuntimeVersion(major: 1, minor: 0, patch: 0),
          platformArtifacts: {
            PlatformIdentifier.linuxX64: artifact,
            PlatformIdentifier.windowsX64: artifact,
            PlatformIdentifier.macosX64: artifact,
            PlatformIdentifier.macosArm64: artifact,
          },
          dependencies: [ModuleId.openVSCodeServer],
          isOptional: true,
        );

        expect(module.isOptional, isTrue);
        expect(module.supportedPlatforms.length, 4);
        expect(module.dependsOn(ModuleId.openVSCodeServer), isTrue);
      });
    });
  });
}
