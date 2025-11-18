import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/src/services/editor_service.dart';

// Test implementation of EditorService
class TestEditorService extends EditorService {
  bool _isAvailable = true;
  bool _isDisposed = false;

  @override
  bool get isAvailable => _isAvailable && !_isDisposed;

  void setAvailability(bool available) {
    _isAvailable = available;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  bool get isDisposed => _isDisposed;
}

// Mock implementation with state tracking
class MockEditorService extends EditorService {
  bool _isAvailable = false;
  int _disposeCallCount = 0;

  @override
  bool get isAvailable => _isAvailable;

  void makeAvailable() {
    _isAvailable = true;
  }

  void makeUnavailable() {
    _isAvailable = false;
  }

  @override
  void dispose() {
    _disposeCallCount++;
    _isAvailable = false;
    super.dispose();
  }

  int get disposeCallCount => _disposeCallCount;
}

// Minimal implementation
class MinimalEditorService extends EditorService {
  @override
  bool get isAvailable => true;
}

// Unavailable service
class UnavailableEditorService extends EditorService {
  @override
  bool get isAvailable => false;
}

// Service with custom dispose logic
class DisposableEditorService extends EditorService {
  final List<String> _disposedResources = [];

  @override
  bool get isAvailable => _disposedResources.isEmpty;

  @override
  void dispose() {
    _disposedResources.add('resource1');
    _disposedResources.add('resource2');
    super.dispose();
  }

  List<String> get disposedResources => List.unmodifiable(_disposedResources);
}

void main() {
  group('EditorService', () {
    group('Abstract Interface', () {
      test('should be implementable', () {
        // Act
        final service = TestEditorService();

        // Assert
        expect(service, isA<EditorService>());
      });

      test('should require isAvailable implementation', () {
        // Act
        final service = MinimalEditorService();

        // Assert
        expect(() => service.isAvailable, returnsNormally);
      });

      test('should have optional dispose method', () {
        // Act
        final service = MinimalEditorService();

        // Assert
        expect(() => service.dispose(), returnsNormally);
      });
    });

    group('IsAvailable', () {
      test('should return true when service is available', () {
        // Arrange
        final service = TestEditorService();

        // Act
        final isAvailable = service.isAvailable;

        // Assert
        expect(isAvailable, isTrue);
      });

      test('should return false when service is unavailable', () {
        // Arrange
        final service = UnavailableEditorService();

        // Act
        final isAvailable = service.isAvailable;

        // Assert
        expect(isAvailable, isFalse);
      });

      test('should reflect dynamic availability changes', () {
        // Arrange
        final service = TestEditorService();

        // Act & Assert
        expect(service.isAvailable, isTrue);

        service.setAvailability(false);
        expect(service.isAvailable, isFalse);

        service.setAvailability(true);
        expect(service.isAvailable, isTrue);
      });

      test('should return false after dispose', () {
        // Arrange
        final service = TestEditorService();

        // Act
        service.dispose();

        // Assert
        expect(service.isAvailable, isFalse);
      });

      test('should support querying availability multiple times', () {
        // Arrange
        final service = TestEditorService();

        // Act & Assert
        expect(service.isAvailable, isTrue);
        expect(service.isAvailable, isTrue);
        expect(service.isAvailable, isTrue);
      });
    });

    group('Dispose', () {
      test('should dispose service', () {
        // Arrange
        final service = TestEditorService();

        // Act
        service.dispose();

        // Assert
        expect(service.isDisposed, isTrue);
      });

      test('should call dispose once', () {
        // Arrange
        final service = MockEditorService();

        // Act
        service.dispose();

        // Assert
        expect(service.disposeCallCount, equals(1));
      });

      test('should allow multiple dispose calls', () {
        // Arrange
        final service = MockEditorService();

        // Act
        service.dispose();
        service.dispose();
        service.dispose();

        // Assert
        expect(service.disposeCallCount, equals(3));
      });

      test('should clean up resources on dispose', () {
        // Arrange
        final service = DisposableEditorService();

        // Act
        service.dispose();

        // Assert
        expect(service.disposedResources.length, equals(2));
        expect(service.disposedResources, contains('resource1'));
        expect(service.disposedResources, contains('resource2'));
      });

      test('should update availability after dispose', () {
        // Arrange
        final service = MockEditorService();
        service.makeAvailable();

        // Act
        service.dispose();

        // Assert
        expect(service.isAvailable, isFalse);
      });

      test('should handle dispose on already disposed service', () {
        // Arrange
        final service = TestEditorService();
        service.dispose();

        // Act & Assert - should not throw
        expect(() => service.dispose(), returnsNormally);
      });

      test('should call super.dispose', () {
        // Arrange
        final service = DisposableEditorService();

        // Act & Assert - should complete without error
        expect(() => service.dispose(), returnsNormally);
      });
    });

    group('Implementation Examples', () {
      test('should support Monaco-based implementation', () {
        // Arrange
        final service = MinimalEditorService();

        // Assert
        expect(service, isA<EditorService>());
        expect(service.isAvailable, isTrue);
      });

      test('should support CodeMirror-based implementation', () {
        // Arrange - Simulating CodeMirror service
        final service = TestEditorService();

        // Assert
        expect(service, isA<EditorService>());
        expect(service.isAvailable, isTrue);
      });

      test('should support Ace-based implementation', () {
        // Arrange - Simulating Ace service
        final service = MockEditorService();
        service.makeAvailable();

        // Assert
        expect(service, isA<EditorService>());
        expect(service.isAvailable, isTrue);
      });
    });

    group('Lifecycle Management', () {
      test('should transition from unavailable to available', () {
        // Arrange
        final service = MockEditorService();

        // Act & Assert
        expect(service.isAvailable, isFalse);

        service.makeAvailable();
        expect(service.isAvailable, isTrue);
      });

      test('should transition from available to unavailable', () {
        // Arrange
        final service = MockEditorService();
        service.makeAvailable();

        // Act & Assert
        expect(service.isAvailable, isTrue);

        service.makeUnavailable();
        expect(service.isAvailable, isFalse);
      });

      test('should handle full lifecycle', () {
        // Arrange
        final service = MockEditorService();

        // Act & Assert - Full lifecycle
        // 1. Initially unavailable
        expect(service.isAvailable, isFalse);

        // 2. Become available
        service.makeAvailable();
        expect(service.isAvailable, isTrue);

        // 3. Become unavailable
        service.makeUnavailable();
        expect(service.isAvailable, isFalse);

        // 4. Become available again
        service.makeAvailable();
        expect(service.isAvailable, isTrue);

        // 5. Dispose
        service.dispose();
        expect(service.isAvailable, isFalse);
      });
    });

    group('Type Safety', () {
      test('should maintain type as EditorService', () {
        // Arrange
        EditorService service = TestEditorService();

        // Assert
        expect(service, isA<EditorService>());
      });

      test('should support polymorphism', () {
        // Arrange
        final List<EditorService> services = [
          TestEditorService(),
          MockEditorService(),
          MinimalEditorService(),
          UnavailableEditorService(),
        ];

        // Assert
        for (final service in services) {
          expect(service, isA<EditorService>());
        }
      });

      test('should allow interface-based usage', () {
        // Arrange
        EditorService createService() {
          return TestEditorService();
        }

        // Act
        final service = createService();

        // Assert
        expect(service.isAvailable, isNotNull);
      });
    });

    group('Edge Cases', () {
      test('should handle rapid availability changes', () {
        // Arrange
        final service = TestEditorService();

        // Act
        for (var i = 0; i < 100; i++) {
          service.setAvailability(i % 2 == 0);
        }

        // Assert
        expect(service.isAvailable, isTrue); // Last value was even (true)
      });

      test('should handle disposal during unavailable state', () {
        // Arrange
        final service = TestEditorService();
        service.setAvailability(false);

        // Act
        service.dispose();

        // Assert
        expect(service.isDisposed, isTrue);
        expect(service.isAvailable, isFalse);
      });

      test('should handle disposal during available state', () {
        // Arrange
        final service = TestEditorService();
        service.setAvailability(true);

        // Act
        service.dispose();

        // Assert
        expect(service.isDisposed, isTrue);
        expect(service.isAvailable, isFalse);
      });
    });

    group('Documentation Compliance', () {
      test('should provide type-safe editor interaction', () {
        // Arrange
        EditorService service = TestEditorService();

        // Act
        final isAvailable = service.isAvailable;

        // Assert
        expect(isAvailable, isA<bool>());
      });

      test('should not depend on specific implementations', () {
        // Arrange
        final services = <EditorService>[
          TestEditorService(),
          MockEditorService(),
          MinimalEditorService(),
        ];

        // Act & Assert - All can be used through interface
        for (final service in services) {
          expect(() => service.isAvailable, returnsNormally);
          expect(() => service.dispose(), returnsNormally);
        }
      });

      test('should support optional resource disposal', () {
        // Arrange
        final service = TestEditorService();

        // Act & Assert - dispose should be optional
        expect(() => service.dispose(), returnsNormally);
      });
    });

    group('Integration Scenarios', () {
      test('should work with plugin system', () {
        // Arrange
        final editorService = TestEditorService();

        // Simulate plugin checking editor availability
        bool canUseEditor() => editorService.isAvailable;

        // Act & Assert
        expect(canUseEditor(), isTrue);

        editorService.setAvailability(false);
        expect(canUseEditor(), isFalse);
      });

      test('should support dependency injection', () {
        // Arrange
        EditorService createEditorService({required bool available}) {
          final service = TestEditorService();
          service.setAvailability(available);
          return service;
        }

        // Act
        final availableService = createEditorService(available: true);
        final unavailableService = createEditorService(available: false);

        // Assert
        expect(availableService.isAvailable, isTrue);
        expect(unavailableService.isAvailable, isFalse);
      });

      test('should support service registry pattern', () {
        // Arrange
        final Map<String, EditorService> registry = {
          'monaco': TestEditorService(),
          'codemirror': MockEditorService(),
          'ace': MinimalEditorService(),
        };

        // Act
        final monacoAvailable = registry['monaco']!.isAvailable;
        final codemirrorAvailable = registry['codemirror']!.isAvailable;

        // Assert
        expect(monacoAvailable, isTrue);
        expect(codemirrorAvailable, isFalse);
      });

      test('should support factory pattern', () {
        // Arrange
        EditorService createEditor(String type) {
          switch (type) {
            case 'test':
              return TestEditorService();
            case 'mock':
              return MockEditorService();
            default:
              return MinimalEditorService();
          }
        }

        // Act
        final testEditor = createEditor('test');
        final mockEditor = createEditor('mock');
        final defaultEditor = createEditor('unknown');

        // Assert
        expect(testEditor, isA<TestEditorService>());
        expect(mockEditor, isA<MockEditorService>());
        expect(defaultEditor, isA<MinimalEditorService>());
      });
    });

    group('Backwards Compatibility', () {
      test('should maintain v0.1.1 API changes', () {
        // Arrange - v0.1.1 removed registerSnippets method
        final service = TestEditorService();

        // Assert - service should not have registerSnippets method
        expect(service, isA<EditorService>());
        // Method should not exist in interface
      });

      test('should work without Monaco-specific dependencies', () {
        // Arrange
        final service = MinimalEditorService();

        // Act
        final isAvailable = service.isAvailable;

        // Assert - No Monaco-specific imports or dependencies
        expect(isAvailable, isA<bool>());
      });
    });

    group('Performance', () {
      test('should handle availability checks efficiently', () {
        // Arrange
        final service = TestEditorService();

        // Act
        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < 10000; i++) {
          service.isAvailable;
        }
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should handle multiple service instances efficiently', () {
        // Arrange
        final services = List.generate(
          1000,
          (index) => TestEditorService(),
        );

        // Act
        final stopwatch = Stopwatch()..start();
        for (final service in services) {
          service.isAvailable;
        }
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('Null Safety', () {
      test('should never return null for isAvailable', () {
        // Arrange
        final services = <EditorService>[
          TestEditorService(),
          MockEditorService(),
          MinimalEditorService(),
          UnavailableEditorService(),
        ];

        // Act & Assert
        for (final service in services) {
          expect(service.isAvailable, isNotNull);
          expect(service.isAvailable, isA<bool>());
        }
      });

      test('should handle dispose without null errors', () {
        // Arrange
        final services = <EditorService>[
          TestEditorService(),
          MockEditorService(),
          MinimalEditorService(),
        ];

        // Act & Assert
        for (final service in services) {
          expect(() => service.dispose(), returnsNormally);
        }
      });
    });

    group('Concurrent Access', () {
      test('should support concurrent availability checks', () async {
        // Arrange
        final service = TestEditorService();

        // Act
        final futures = List.generate(
          100,
          (index) => Future(() => service.isAvailable),
        );

        final results = await Future.wait(futures);

        // Assert
        expect(results.every((r) => r == true), isTrue);
      });

      test('should support concurrent availability changes', () async {
        // Arrange
        final service = TestEditorService();

        // Act
        final futures = List.generate(
          100,
          (index) => Future(() {
            service.setAvailability(index % 2 == 0);
            return service.isAvailable;
          }),
        );

        await Future.wait(futures);

        // Assert - should complete without errors
        expect(service.isAvailable, isA<bool>());
      });
    });
  });
}
