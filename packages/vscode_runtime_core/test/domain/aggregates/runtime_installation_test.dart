import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/src/domain/aggregates/runtime_installation.dart';
import 'package:vscode_runtime_core/src/domain/entities/runtime_module.dart';
import 'package:vscode_runtime_core/src/domain/entities/platform_artifact.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/installation_id.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/module_id.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/runtime_version.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/platform_identifier.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/download_url.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/sha256_hash.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/byte_size.dart';
import 'package:vscode_runtime_core/src/domain/enums/module_type.dart';
import 'package:vscode_runtime_core/src/domain/enums/installation_status.dart';
import 'package:vscode_runtime_core/src/domain/enums/installation_trigger.dart';
import 'package:vscode_runtime_core/src/domain/events/domain_event.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('RuntimeInstallation', () {
    late RuntimeModule module1;
    late RuntimeModule module2;
    late PlatformIdentifier platform;

    setUp(() {
      platform = PlatformIdentifier.linuxX64;

      final artifact = PlatformArtifact(
        url: DownloadUrl(value: 'https://example.com/file.tar.gz'),
        hash: SHA256Hash(value: 'a' * 64),
        size: ByteSize.fromMB(10),
      );

      module1 = RuntimeModule.create(
        id: ModuleId(value: 'module1'),
        name: 'Module 1',
        description: 'First module',
        type: ModuleType.runtime,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {platform: artifact},
      );

      module2 = RuntimeModule.create(
        id: ModuleId(value: 'module2'),
        name: 'Module 2',
        description: 'Second module',
        type: ModuleType.server,
        version: RuntimeVersion(major: 1, minor: 0, patch: 0),
        platformArtifacts: {platform: artifact},
        dependencies: [module1.id],
      );
    });

    group('create factory', () {
      test('creates valid installation', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        expect(installation.id, isNotNull);
        expect(installation.modules, [module1]);
        expect(installation.targetPlatform, platform);
        expect(installation.status, InstallationStatus.pending);
        expect(installation.trigger, InstallationTrigger.settings);
        expect(installation.installedModules, isEmpty);
        expect(installation.progress, 0.0);
        expect(installation.currentModule, isNull);
        expect(installation.errorMessage, isNull);
      });

      test('creates installation with custom trigger', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
          trigger: InstallationTrigger.fileOpen,
        );

        expect(installation.trigger, InstallationTrigger.fileOpen);
      });

      test('emits InstallationStarted event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        expect(installation.uncommittedEvents.length, 1);
        final event = installation.uncommittedEvents.first;
        expect(event, isA<InstallationStarted>());

        final startedEvent = event as InstallationStarted;
        expect(startedEvent.installationId, installation.id);
        expect(startedEvent.moduleCount, 1);
      });

      test('throws on incompatible modules', () {
        final incompatibleModule = RuntimeModule.create(
          id: ModuleId(value: 'incompatible'),
          name: 'Incompatible',
          description: 'Not for this platform',
          type: ModuleType.runtime,
          version: RuntimeVersion(major: 1, minor: 0, patch: 0),
          platformArtifacts: {
            PlatformIdentifier.windowsX64: PlatformArtifact(
              url: DownloadUrl(value: 'https://example.com/file.zip'),
              hash: SHA256Hash(value: 'a' * 64),
              size: ByteSize.fromMB(10),
            ),
          },
        );

        expect(
          () => RuntimeInstallation.create(
            modules: [incompatibleModule],
            platform: platform,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on circular dependencies', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl(value: 'https://example.com/file.tar.gz'),
          hash: SHA256Hash(value: 'a' * 64),
          size: ByteSize.fromMB(10),
        );

        final moduleA = RuntimeModule(
          id: ModuleId(value: 'module-a'),
          name: 'Module A',
          description: 'Module A',
          type: ModuleType.runtime,
          version: RuntimeVersion(major: 1, minor: 0, patch: 0),
          platformArtifacts: {platform: artifact},
          dependencies: [ModuleId(value: 'module-b')],
        );

        final moduleB = RuntimeModule(
          id: ModuleId(value: 'module-b'),
          name: 'Module B',
          description: 'Module B',
          type: ModuleType.runtime,
          version: RuntimeVersion(major: 1, minor: 0, patch: 0),
          platformArtifacts: {platform: artifact},
          dependencies: [ModuleId(value: 'module-a')],
        );

        expect(
          () => RuntimeInstallation.create(
            modules: [moduleA, moduleB],
            platform: platform,
          ),
          throwsA(isA<DependencyException>()),
        );
      });
    });

    group('start command', () {
      test('transitions from pending to in progress', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        final started = installation.start();

        expect(started.status, InstallationStatus.inProgress);
      });

      test('emits InstallationProgressChanged event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        final started = installation.start();

        // Should have 2 events: InstallationStarted + InstallationProgressChanged
        expect(started.uncommittedEvents.length, 2);
        final event = started.uncommittedEvents.last;
        expect(event, isA<InstallationProgressChanged>());

        final progressEvent = event as InstallationProgressChanged;
        expect(progressEvent.status, InstallationStatus.inProgress);
        expect(progressEvent.progress, 0.0);
      });

      test('throws when already started', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        expect(
          () => installation.start(),
          throwsA(isA<InvalidStateException>()),
        );
      });

      test('throws when completed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(
          () => installation.start(),
          throwsA(isA<InvalidStateException>()),
        );
      });
    });

    group('markModuleDownloadStarted command', () {
      test('marks module download as started', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleDownloadStarted(module1.id);

        expect(updated.currentModule, module1.id);
      });

      test('emits ModuleDownloadStarted event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleDownloadStarted(module1.id);

        final event = updated.uncommittedEvents.last;
        expect(event, isA<ModuleDownloadStarted>());

        final downloadEvent = event as ModuleDownloadStarted;
        expect(downloadEvent.moduleId, module1.id);
      });

      test('throws when module does not exist', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        expect(
          () => installation.markModuleDownloadStarted(ModuleId(value: 'nonexistent')),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws when module already installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(
          () => installation.markModuleDownloadStarted(module1.id),
          throwsA(isA<InvalidStateException>()),
        );
      });

      test('throws when not in progress', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        expect(
          () => installation.markModuleDownloadStarted(module1.id),
          throwsA(isA<InvalidStateException>()),
        );
      });
    });

    group('markModuleDownloaded command', () {
      test('marks module as downloaded', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleDownloaded(module1.id);

        expect(updated.currentModule, module1.id);
      });

      test('emits ModuleDownloaded event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleDownloaded(module1.id);

        final event = updated.uncommittedEvents.last;
        expect(event, isA<ModuleDownloaded>());

        final downloadEvent = event as ModuleDownloaded;
        expect(downloadEvent.moduleId, module1.id);
      });
    });

    group('markModuleVerified command', () {
      test('marks module as verified', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleVerified(module1.id);

        // Should emit event but not change status
        expect(updated.status, InstallationStatus.inProgress);
      });

      test('emits ModuleVerified event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleVerified(module1.id);

        final event = updated.uncommittedEvents.last;
        expect(event, isA<ModuleVerified>());

        final verifiedEvent = event as ModuleVerified;
        expect(verifiedEvent.moduleId, module1.id);
      });
    });

    group('markModuleExtractionStarted command', () {
      test('marks extraction as started', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleExtractionStarted(module1.id);

        expect(updated.status, InstallationStatus.inProgress);
      });

      test('emits ModuleExtractionStarted event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleExtractionStarted(module1.id);

        final event = updated.uncommittedEvents.last;
        expect(event, isA<ModuleExtractionStarted>());

        final extractionEvent = event as ModuleExtractionStarted;
        expect(extractionEvent.moduleId, module1.id);
      });
    });

    group('markModuleInstalled command', () {
      test('marks module as installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start();

        final updated = installation.markModuleInstalled(module1.id);

        expect(updated.installedModules, contains(module1.id));
        expect(updated.currentModule, isNull);
      });

      test('updates progress', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start();

        final updated = installation.markModuleInstalled(module1.id);

        expect(updated.progress, 0.5); // 1 of 2 modules installed
      });

      test('completes installation when all modules installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleInstalled(module1.id);

        expect(updated.status, InstallationStatus.completed);
        expect(updated.progress, 1.0);
        expect(updated.completedAt, isNotNull);
      });

      test('emits ModuleExtracted event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleInstalled(module1.id);

        // Find ModuleExtracted event
        final extractedEvent = updated.uncommittedEvents
            .whereType<ModuleExtracted>()
            .first;
        expect(extractedEvent.moduleId, module1.id);
      });

      test('emits InstallationCompleted event when done', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.markModuleInstalled(module1.id);

        // Find InstallationCompleted event
        final completedEvent = updated.uncommittedEvents
            .whereType<InstallationCompleted>()
            .firstOrNull;
        expect(completedEvent, isNotNull);
      });

      test('does not emit InstallationCompleted when more modules remain', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start();

        final updated = installation.markModuleInstalled(module1.id);

        final completedEvent = updated.uncommittedEvents
            .whereType<InstallationCompleted>()
            .firstOrNull;
        expect(completedEvent, isNull);
        expect(updated.status, InstallationStatus.inProgress);
      });

      test('throws when module already installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(
          () => installation.markModuleInstalled(module1.id),
          throwsA(isA<InvalidStateException>()),
        );
      });
    });

    group('updateProgress command', () {
      test('updates progress value', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.updateProgress(0.5);

        expect(updated.progress, 0.5);
      });

      test('emits InstallationProgressChanged event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final updated = installation.updateProgress(0.75);

        final event = updated.uncommittedEvents.last;
        expect(event, isA<InstallationProgressChanged>());

        final progressEvent = event as InstallationProgressChanged;
        expect(progressEvent.progress, 0.75);
      });

      test('throws on invalid progress (negative)', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        expect(
          () => installation.updateProgress(-0.1),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on invalid progress (> 1)', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        expect(
          () => installation.updateProgress(1.1),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws when not in progress', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        expect(
          () => installation.updateProgress(0.5),
          throwsA(isA<InvalidStateException>()),
        );
      });
    });

    group('fail command', () {
      test('marks installation as failed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final failed = installation.fail('Test error');

        expect(failed.status, InstallationStatus.failed);
        expect(failed.errorMessage, 'Test error');
        expect(failed.failedAt, isNotNull);
      });

      test('emits InstallationFailed event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final failed = installation.fail('Test error');

        final event = failed.uncommittedEvents.last;
        expect(event, isA<InstallationFailed>());

        final failedEvent = event as InstallationFailed;
        expect(failedEvent.error, 'Test error');
        expect(failedEvent.failedModuleId, isNull);
      });

      test('includes failed module in event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final failed = installation.fail('Test error', failedModule: module1.id);

        final event = failed.uncommittedEvents.last as InstallationFailed;
        expect(event.failedModuleId, module1.id.value);
      });

      test('throws when already in terminal state', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(
          () => installation.fail('Test error'),
          throwsA(isA<InvalidStateException>()),
        );
      });
    });

    group('cancel command', () {
      test('marks installation as cancelled', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final cancelled = installation.cancel();

        expect(cancelled.status, InstallationStatus.cancelled);
      });

      test('emits InstallationCancelled event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final cancelled = installation.cancel();

        final event = cancelled.uncommittedEvents.last;
        expect(event, isA<InstallationCancelled>());
      });

      test('includes reason in event', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final cancelled = installation.cancel(reason: 'User requested');

        final event = cancelled.uncommittedEvents.last as InstallationCancelled;
        expect(event.reason, 'User requested');
      });

      test('can cancel from pending state', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        final cancelled = installation.cancel();

        expect(cancelled.status, InstallationStatus.cancelled);
      });

      test('throws when already completed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(
          () => installation.cancel(),
          throwsA(isA<InvalidStateException>()),
        );
      });
    });

    group('getNextModuleToInstall query', () {
      test('returns first module with no dependencies', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start();

        final next = installation.getNextModuleToInstall();

        expect(next.isSome(), isTrue);
        expect(next.getOrElse(() => throw Exception()), module1);
      });

      test('returns module whose dependencies are installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        final next = installation.getNextModuleToInstall();

        expect(next.isSome(), isTrue);
        expect(next.getOrElse(() => throw Exception()), module2);
      });

      test('returns None when all modules installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        final next = installation.getNextModuleToInstall();

        expect(next.isNone(), isTrue);
      });

      test('returns None when not in progress', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        final next = installation.getNextModuleToInstall();

        expect(next.isNone(), isTrue);
      });

      test('throws on unresolvable dependencies', () {
        final artifact = PlatformArtifact(
          url: DownloadUrl(value: 'https://example.com/file.tar.gz'),
          hash: SHA256Hash(value: 'a' * 64),
          size: ByteSize.fromMB(10),
        );

        final moduleWithMissingDep = RuntimeModule(
          id: ModuleId(value: 'module-missing'),
          name: 'Module with missing dep',
          description: 'Module with missing dependency',
          type: ModuleType.runtime,
          version: RuntimeVersion(major: 1, minor: 0, patch: 0),
          platformArtifacts: {platform: artifact},
          dependencies: [ModuleId(value: 'nonexistent')],
        );

        final installation = RuntimeInstallation.create(
          modules: [moduleWithMissingDep],
          platform: platform,
        ).start();

        expect(
          () => installation.getNextModuleToInstall(),
          throwsA(isA<DependencyException>()),
        );
      });
    });

    group('calculateProgress query', () {
      test('returns 0 when no modules installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start();

        expect(installation.calculateProgress(), 0.0);
      });

      test('returns 0.5 when half modules installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(installation.calculateProgress(), 0.5);
      });

      test('returns 1.0 when all modules installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(installation.calculateProgress(), 1.0);
      });

      test('returns 1.0 for empty module list', () {
        final installation = RuntimeInstallation(
          id: InstallationId.generate(),
          modules: [],
          targetPlatform: platform,
          status: InstallationStatus.pending,
          createdAt: DateTime.now(),
          trigger: InstallationTrigger.settings,
        );

        expect(installation.calculateProgress(), 1.0);
      });
    });

    group('getRemainingModules query', () {
      test('returns all modules when none installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start();

        final remaining = installation.getRemainingModules();

        expect(remaining.length, 2);
        expect(remaining, containsAll([module1, module2]));
      });

      test('returns only uninstalled modules', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        final remaining = installation.getRemainingModules();

        expect(remaining.length, 1);
        expect(remaining.first, module2);
      });

      test('returns empty list when all installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        final remaining = installation.getRemainingModules();

        expect(remaining, isEmpty);
      });
    });

    group('getInstalledModuleObjects query', () {
      test('returns empty list when nothing installed', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        final installed = installation.getInstalledModuleObjects();

        expect(installed, isEmpty);
      });

      test('returns installed modules', () {
        final installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        final installed = installation.getInstalledModuleObjects();

        expect(installed.length, 1);
        expect(installed.first, module1);
      });
    });

    group('isModuleInstalled query', () {
      test('returns false for uninstalled module', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        expect(installation.isModuleInstalled(module1.id), isFalse);
      });

      test('returns true for installed module', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start().markModuleInstalled(module1.id);

        expect(installation.isModuleInstalled(module1.id), isTrue);
      });
    });

    group('getDuration query', () {
      test('returns duration for completed installation', () async {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        await Future.delayed(Duration(milliseconds: 10));

        final completed = installation.markModuleInstalled(module1.id);
        final duration = completed.getDuration();

        expect(duration, isNotNull);
        expect(duration!.inMilliseconds, greaterThan(0));
      });

      test('returns duration for failed installation', () async {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        await Future.delayed(Duration(milliseconds: 10));

        final failed = installation.fail('Test error');
        final duration = failed.getDuration();

        expect(duration, isNotNull);
        expect(duration!.inMilliseconds, greaterThan(0));
      });

      test('returns duration for in-progress installation', () async {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        ).start();

        await Future.delayed(Duration(milliseconds: 10));

        final duration = installation.getDuration();

        expect(duration, isNotNull);
        expect(duration!.inMilliseconds, greaterThan(0));
      });
    });

    group('clearEvents', () {
      test('clears uncommitted events', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        expect(installation.uncommittedEvents, isNotEmpty);

        final cleared = installation.clearEvents();

        expect(cleared.uncommittedEvents, isEmpty);
      });

      test('preserves all other state', () {
        final installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        final cleared = installation.clearEvents();

        expect(cleared.id, installation.id);
        expect(cleared.status, installation.status);
        expect(cleared.modules, installation.modules);
      });
    });

    group('complex workflows', () {
      test('full successful installation workflow', () {
        var installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        );

        // Start
        installation = installation.start();
        expect(installation.status, InstallationStatus.inProgress);

        // Install module1
        installation = installation.markModuleDownloadStarted(module1.id);
        installation = installation.markModuleDownloaded(module1.id);
        installation = installation.markModuleVerified(module1.id);
        installation = installation.markModuleExtractionStarted(module1.id);
        installation = installation.markModuleInstalled(module1.id);

        expect(installation.isModuleInstalled(module1.id), isTrue);
        expect(installation.status, InstallationStatus.inProgress);
        expect(installation.progress, 0.5);

        // Install module2
        installation = installation.markModuleDownloadStarted(module2.id);
        installation = installation.markModuleDownloaded(module2.id);
        installation = installation.markModuleVerified(module2.id);
        installation = installation.markModuleExtractionStarted(module2.id);
        installation = installation.markModuleInstalled(module2.id);

        expect(installation.isModuleInstalled(module2.id), isTrue);
        expect(installation.status, InstallationStatus.completed);
        expect(installation.progress, 1.0);
        expect(installation.completedAt, isNotNull);
      });

      test('installation failure during download', () {
        var installation = RuntimeInstallation.create(
          modules: [module1],
          platform: platform,
        );

        installation = installation.start();
        installation = installation.markModuleDownloadStarted(module1.id);
        installation = installation.fail(
          'Download failed',
          failedModule: module1.id,
        );

        expect(installation.status, InstallationStatus.failed);
        expect(installation.errorMessage, 'Download failed');
        expect(installation.failedAt, isNotNull);

        final failedEvent = installation.uncommittedEvents
            .whereType<InstallationFailed>()
            .first;
        expect(failedEvent.failedModuleId, module1.id.value);
      });

      test('user cancellation during installation', () {
        var installation = RuntimeInstallation.create(
          modules: [module1, module2],
          platform: platform,
        );

        installation = installation.start();
        installation = installation.markModuleInstalled(module1.id);
        installation = installation.cancel(reason: 'User cancelled');

        expect(installation.status, InstallationStatus.cancelled);

        final cancelledEvent = installation.uncommittedEvents
            .whereType<InstallationCancelled>()
            .first;
        expect(cancelledEvent.reason, 'User cancelled');
      });
    });
  });
}
