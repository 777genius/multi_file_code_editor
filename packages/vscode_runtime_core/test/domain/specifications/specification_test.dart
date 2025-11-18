import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/specifications/specification.dart';
import 'package:vscode_runtime_core/src/domain/specifications/platform_compatible_spec.dart';
import 'package:vscode_runtime_core/src/domain/specifications/dependencies_met_spec.dart';
import 'package:vscode_runtime_core/src/domain/specifications/module_installable_spec.dart';
import 'package:vscode_runtime_core/src/domain/entities/runtime_module.dart';
import 'package:vscode_runtime_core/src/domain/entities/platform_artifact.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/module_id.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/runtime_version.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/platform_identifier.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/download_url.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/sha256_hash.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/byte_size.dart';
import 'package:vscode_runtime_core/src/domain/enums/module_type.dart';

// Test specification for demonstration
class IsEvenSpecification extends Specification<int> {
  @override
  bool isSatisfiedBy(int candidate) => candidate % 2 == 0;

  @override
  String get description => 'Number must be even';
}

class IsPositiveSpecification extends Specification<int> {
  @override
  bool isSatisfiedBy(int candidate) => candidate > 0;

  @override
  String get description => 'Number must be positive';
}

class GreaterThanSpecification extends Specification<int> {
  final int threshold;

  GreaterThanSpecification(this.threshold);

  @override
  bool isSatisfiedBy(int candidate) => candidate > threshold;

  @override
  String get description => 'Number must be greater than $threshold';
}

void main() {
  group('Specification Pattern', () {
    group('base specification', () {
      test('concrete specification checks condition', () {
        final spec = IsEvenSpecification();

        expect(spec.isSatisfiedBy(2), isTrue);
        expect(spec.isSatisfiedBy(3), isFalse);
        expect(spec.isSatisfiedBy(4), isTrue);
      });

      test('has description', () {
        final spec = IsEvenSpecification();
        expect(spec.description, 'Number must be even');
      });
    });

    group('AndSpecification', () {
      test('satisfied when both specs are satisfied', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.and(isPositive);

        expect(spec.isSatisfiedBy(2), isTrue); // even and positive
        expect(spec.isSatisfiedBy(4), isTrue); // even and positive
      });

      test('not satisfied when left spec fails', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.and(isPositive);

        expect(spec.isSatisfiedBy(3), isFalse); // not even
      });

      test('not satisfied when right spec fails', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.and(isPositive);

        expect(spec.isSatisfiedBy(-2), isFalse); // even but not positive
      });

      test('not satisfied when both specs fail', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.and(isPositive);

        expect(spec.isSatisfiedBy(-3), isFalse); // neither even nor positive
      });

      test('has combined description', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.and(isPositive);

        expect(
          spec.description,
          '(Number must be even AND Number must be positive)',
        );
      });
    });

    group('OrSpecification', () {
      test('satisfied when left spec is satisfied', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.or(isPositive);

        expect(spec.isSatisfiedBy(-2), isTrue); // even but not positive
      });

      test('satisfied when right spec is satisfied', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.or(isPositive);

        expect(spec.isSatisfiedBy(3), isTrue); // positive but not even
      });

      test('satisfied when both specs are satisfied', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.or(isPositive);

        expect(spec.isSatisfiedBy(2), isTrue); // both even and positive
      });

      test('not satisfied when both specs fail', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.or(isPositive);

        expect(spec.isSatisfiedBy(-3), isFalse); // neither even nor positive
      });

      test('has combined description', () {
        final isEven = IsEvenSpecification();
        final isPositive = IsPositiveSpecification();
        final spec = isEven.or(isPositive);

        expect(
          spec.description,
          '(Number must be even OR Number must be positive)',
        );
      });
    });

    group('NotSpecification', () {
      test('satisfied when inner spec is not satisfied', () {
        final isEven = IsEvenSpecification();
        final spec = isEven.not();

        expect(spec.isSatisfiedBy(3), isTrue); // not even
        expect(spec.isSatisfiedBy(5), isTrue); // not even
      });

      test('not satisfied when inner spec is satisfied', () {
        final isEven = IsEvenSpecification();
        final spec = isEven.not();

        expect(spec.isSatisfiedBy(2), isFalse); // is even
        expect(spec.isSatisfiedBy(4), isFalse); // is even
      });

      test('has negated description', () {
        final isEven = IsEvenSpecification();
        final spec = isEven.not();

        expect(spec.description, 'NOT Number must be even');
      });
    });

    group('CompositeSpecification', () {
      test('satisfied when all specs are satisfied', () {
        final spec = CompositeSpecification([
          IsEvenSpecification(),
          IsPositiveSpecification(),
          GreaterThanSpecification(5),
        ]);

        expect(spec.isSatisfiedBy(6), isTrue); // even, positive, > 5
        expect(spec.isSatisfiedBy(8), isTrue); // even, positive, > 5
      });

      test('not satisfied when any spec fails', () {
        final spec = CompositeSpecification([
          IsEvenSpecification(),
          IsPositiveSpecification(),
          GreaterThanSpecification(5),
        ]);

        expect(spec.isSatisfiedBy(3), isFalse); // not even
        expect(spec.isSatisfiedBy(-6), isFalse); // not positive
        expect(spec.isSatisfiedBy(4), isFalse); // not > 5
      });

      test('satisfied when empty list', () {
        final spec = CompositeSpecification<int>([]);

        expect(spec.isSatisfiedBy(123), isTrue); // vacuous truth
      });

      test('has combined description', () {
        final spec = CompositeSpecification([
          IsEvenSpecification(),
          IsPositiveSpecification(),
        ]);

        expect(
          spec.description,
          '(Number must be even AND Number must be positive)',
        );
      });
    });

    group('complex combinations', () {
      test('(even AND positive) OR (greater than 10)', () {
        final evenAndPositive = IsEvenSpecification().and(IsPositiveSpecification());
        final greaterThan10 = GreaterThanSpecification(10);
        final spec = evenAndPositive.or(greaterThan10);

        expect(spec.isSatisfiedBy(2), isTrue); // even and positive
        expect(spec.isSatisfiedBy(11), isTrue); // > 10
        expect(spec.isSatisfiedBy(-3), isFalse); // neither
      });

      test('NOT (even OR positive)', () {
        final evenOrPositive = IsEvenSpecification().or(IsPositiveSpecification());
        final spec = evenOrPositive.not();

        expect(spec.isSatisfiedBy(-3), isTrue); // not even and not positive
        expect(spec.isSatisfiedBy(-2), isFalse); // is even
        expect(spec.isSatisfiedBy(1), isFalse); // is positive
      });

      test('chained AND operations', () {
        final spec = IsEvenSpecification()
            .and(IsPositiveSpecification())
            .and(GreaterThanSpecification(5));

        expect(spec.isSatisfiedBy(6), isTrue); // all conditions met
        expect(spec.isSatisfiedBy(4), isFalse); // not > 5
      });

      test('chained OR operations', () {
        final spec = IsEvenSpecification()
            .or(IsPositiveSpecification())
            .or(GreaterThanSpecification(100));

        expect(spec.isSatisfiedBy(-2), isTrue); // is even
        expect(spec.isSatisfiedBy(3), isTrue); // is positive
        expect(spec.isSatisfiedBy(101), isTrue); // > 100
        expect(spec.isSatisfiedBy(-3), isFalse); // none
      });
    });
  });

  group('PlatformCompatibleSpecification', () {
    late RuntimeModule linuxModule;
    late RuntimeModule multiPlatformModule;

    setUp(() {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      linuxModule = RuntimeModule.create(
        id: ModuleId('linux-only'),
        name: 'Linux Only',
        description: 'Only for Linux',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {
          PlatformIdentifier.linuxX64: artifact,
        },
      );

      multiPlatformModule = RuntimeModule.create(
        id: ModuleId('multi-platform'),
        name: 'Multi Platform',
        description: 'For multiple platforms',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {
          PlatformIdentifier.linuxX64: artifact,
          PlatformIdentifier.windowsX64: artifact,
          PlatformIdentifier.macosX64: artifact,
        },
      );
    });

    test('satisfied when module supports platform', () {
      final spec = PlatformCompatibleSpecification(PlatformIdentifier.linuxX64);

      expect(spec.isSatisfiedBy(linuxModule), isTrue);
      expect(spec.isSatisfiedBy(multiPlatformModule), isTrue);
    });

    test('not satisfied when module does not support platform', () {
      final spec = PlatformCompatibleSpecification(PlatformIdentifier.windowsX64);

      expect(spec.isSatisfiedBy(linuxModule), isFalse);
    });

    test('has descriptive message', () {
      final spec = PlatformCompatibleSpecification(PlatformIdentifier.linuxX64);

      expect(spec.description, contains('linux-x64'));
    });
  });

  group('DependenciesMetSpecification', () {
    late RuntimeModule noDepsModule;
    late RuntimeModule withDepsModule;

    setUp(() {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      noDepsModule = RuntimeModule.create(
        id: ModuleId('no-deps'),
        name: 'No Dependencies',
        description: 'Has no dependencies',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: artifact},
      );

      withDepsModule = RuntimeModule.create(
        id: ModuleId('with-deps'),
        name: 'With Dependencies',
        description: 'Has dependencies',
        type: ModuleType.server,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: artifact},
        dependencies: [
          ModuleId('dep1'),
          ModuleId('dep2'),
        ],
      );
    });

    test('satisfied when no dependencies', () {
      final spec = DependenciesMetSpecification({});

      expect(spec.isSatisfiedBy(noDepsModule), isTrue);
    });

    test('satisfied when all dependencies installed', () {
      final spec = DependenciesMetSpecification({
        ModuleId('dep1'),
        ModuleId('dep2'),
      });

      expect(spec.isSatisfiedBy(withDepsModule), isTrue);
    });

    test('satisfied when more than required deps installed', () {
      final spec = DependenciesMetSpecification({
        ModuleId('dep1'),
        ModuleId('dep2'),
        ModuleId('dep3'),
      });

      expect(spec.isSatisfiedBy(withDepsModule), isTrue);
    });

    test('not satisfied when missing dependencies', () {
      final spec = DependenciesMetSpecification({
        ModuleId('dep1'),
        // dep2 missing
      });

      expect(spec.isSatisfiedBy(withDepsModule), isFalse);
    });

    test('not satisfied when no dependencies installed', () {
      final spec = DependenciesMetSpecification({});

      expect(spec.isSatisfiedBy(withDepsModule), isFalse);
    });

    test('has descriptive message', () {
      final spec = DependenciesMetSpecification({});

      expect(spec.description, 'All dependencies must be installed');
    });
  });

  group('CanInstallModuleSpecification', () {
    late RuntimeModule module;

    setUp(() {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      module = RuntimeModule.create(
        id: ModuleId('test-module'),
        name: 'Test Module',
        description: 'Test',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {
          PlatformIdentifier.linuxX64: artifact,
        },
        dependencies: [ModuleId('dep1')],
      );
    });

    test('satisfied when platform compatible and dependencies met', () {
      final spec = CanInstallModuleSpecification(
        platform: PlatformIdentifier.linuxX64,
        installedModules: {ModuleId('dep1')},
      );

      expect(spec.isSatisfiedBy(module), isTrue);
    });

    test('not satisfied when platform incompatible', () {
      final spec = CanInstallModuleSpecification(
        platform: PlatformIdentifier.windowsX64,
        installedModules: {ModuleId('dep1')},
      );

      expect(spec.isSatisfiedBy(module), isFalse);
    });

    test('not satisfied when dependencies not met', () {
      final spec = CanInstallModuleSpecification(
        platform: PlatformIdentifier.linuxX64,
        installedModules: {},
      );

      expect(spec.isSatisfiedBy(module), isFalse);
    });

    test('has combined description', () {
      final spec = CanInstallModuleSpecification(
        platform: PlatformIdentifier.linuxX64,
        installedModules: {},
      );

      expect(spec.description, contains('AND'));
    });
  });

  group('ModuleNotInstalledSpecification', () {
    late RuntimeModule module;

    setUp(() {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      module = RuntimeModule.create(
        id: ModuleId('test-module'),
        name: 'Test Module',
        description: 'Test',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: artifact},
      );
    });

    test('satisfied when module not installed', () {
      final spec = ModuleNotInstalledSpecification({});

      expect(spec.isSatisfiedBy(module), isTrue);
    });

    test('satisfied when other modules installed', () {
      final spec = ModuleNotInstalledSpecification({
        ModuleId('other-module'),
      });

      expect(spec.isSatisfiedBy(module), isTrue);
    });

    test('not satisfied when module already installed', () {
      final spec = ModuleNotInstalledSpecification({
        ModuleId('test-module'),
      });

      expect(spec.isSatisfiedBy(module), isFalse);
    });

    test('has descriptive message', () {
      final spec = ModuleNotInstalledSpecification({});

      expect(spec.description, 'Module must not be already installed');
    });
  });

  group('ModuleHasValidArtifactsSpecification', () {
    test('satisfied when all artifacts valid', () {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      final module = RuntimeModule.create(
        id: ModuleId('test-module'),
        name: 'Test Module',
        description: 'Test',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: artifact},
      );

      final spec = ModuleHasValidArtifactsSpecification();

      expect(spec.isSatisfiedBy(module), isTrue);
    });

    test('not satisfied when artifact invalid', () {
      final invalidArtifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize(0), // Invalid - zero size
      );

      final module = RuntimeModule(
        id: ModuleId('test-module'),
        name: 'Test Module',
        description: 'Test',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: invalidArtifact},
      );

      final spec = ModuleHasValidArtifactsSpecification();

      expect(spec.isSatisfiedBy(module), isFalse);
    });

    test('has descriptive message', () {
      final spec = ModuleHasValidArtifactsSpecification();

      expect(spec.description, 'Module must have valid artifacts');
    });
  });

  group('ModuleIsCriticalSpecification', () {
    test('satisfied for critical (non-optional) module', () {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      final module = RuntimeModule.create(
        id: ModuleId('critical-module'),
        name: 'Critical Module',
        description: 'Critical',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: artifact},
        isOptional: false,
      );

      final spec = ModuleIsCriticalSpecification();

      expect(spec.isSatisfiedBy(module), isTrue);
    });

    test('not satisfied for optional module', () {
      final artifact = PlatformArtifact(
        url: DownloadUrl('https://example.com/file.tar.gz'),
        hash: SHA256Hash('a' * 64),
        size: ByteSize.fromMB(10),
      );

      final module = RuntimeModule.create(
        id: ModuleId('optional-module'),
        name: 'Optional Module',
        description: 'Optional',
        type: ModuleType.extensions,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {PlatformIdentifier.linuxX64: artifact},
        isOptional: true,
      );

      final spec = ModuleIsCriticalSpecification();

      expect(spec.isSatisfiedBy(module), isFalse);
    });

    test('has descriptive message', () {
      final spec = ModuleIsCriticalSpecification();

      expect(spec.description, 'Module must be critical (non-optional)');
    });
  });
}
