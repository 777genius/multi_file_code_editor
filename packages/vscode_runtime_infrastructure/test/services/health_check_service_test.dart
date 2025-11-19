import 'package:test/test.dart';
import 'package:vscode_runtime_infrastructure/src/services/health_check_service.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

void main() {
  late HealthCheckService service;

  setUp(() {
    service = HealthCheckService(timeout: const Duration(milliseconds: 500));
  });

  group('HealthCheckService', () {
    group('Component Registration', () {
      test('should register health check', () {
        // Arrange & Act
        service.registerCheck('test', () async {
          return HealthCheckResult(
            componentName: 'test',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Assert
        final components = service.getRegisteredComponents();
        expect(components, contains('test'));
      });

      test('should unregister health check', () {
        // Arrange
        service.registerCheck('test', () async {
          return HealthCheckResult(
            componentName: 'test',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Act
        service.unregisterCheck('test');

        // Assert
        final components = service.getRegisteredComponents();
        expect(components, isNot(contains('test')));
      });

      test('should allow multiple registrations', () {
        // Arrange & Act
        service.registerCheck('component1', () async {
          return HealthCheckResult(
            componentName: 'component1',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        service.registerCheck('component2', () async {
          return HealthCheckResult(
            componentName: 'component2',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Assert
        final components = service.getRegisteredComponents();
        expect(components.length, equals(2));
        expect(components, containsAll(['component1', 'component2']));
      });
    });

    group('Component Health Check', () {
      test('should check individual component health', () async {
        // Arrange
        service.registerCheck('database', () async {
          return HealthCheckResult(
            componentName: 'database',
            status: HealthStatus.healthy,
            message: 'Connected',
            timestamp: DateTime.now().toUtc(),
            responseTime: const Duration(milliseconds: 50),
          );
        });

        // Act
        final result = await service.checkComponent('database');

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return health result'),
          (healthResult) {
            expect(healthResult.componentName, equals('database'));
            expect(healthResult.status, equals(HealthStatus.healthy));
            expect(healthResult.message, equals('Connected'));
            expect(healthResult.isHealthy, isTrue);
          },
        );
      });

      test('should return error for unregistered component', () async {
        // Act
        final result = await service.checkComponent('nonexistent');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error.message, contains('not registered'));
          },
          (_) => fail('Should return error'),
        );
      });

      test('should timeout slow health checks', () async {
        // Arrange - health check that takes longer than timeout
        service.registerCheck('slow_component', () async {
          await Future.delayed(const Duration(seconds: 2));
          return HealthCheckResult(
            componentName: 'slow_component',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Act
        final result = await service.checkComponent('slow_component');

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return timeout result'),
          (healthResult) {
            expect(healthResult.status, equals(HealthStatus.unhealthy));
            expect(healthResult.message, contains('timed out'));
          },
        );
      });

      test('should handle health check exceptions', () async {
        // Arrange - health check that throws
        service.registerCheck('failing_component', () async {
          throw Exception('Health check failed');
        });

        // Act
        final result = await service.checkComponent('failing_component');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error.message, contains('Health check failed')),
          (_) => fail('Should return error'),
        );
      });
    });

    group('System Health Check', () {
      test('should check all components in parallel', () async {
        // Arrange
        var comp1Checked = false;
        var comp2Checked = false;

        service.registerCheck('component1', () async {
          await Future.delayed(const Duration(milliseconds: 100));
          comp1Checked = true;
          return HealthCheckResult(
            componentName: 'component1',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        service.registerCheck('component2', () async {
          await Future.delayed(const Duration(milliseconds: 100));
          comp2Checked = true;
          return HealthCheckResult(
            componentName: 'component2',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Act
        final result = await service.checkAll();

        // Assert
        expect(result.isRight(), isTrue);
        expect(comp1Checked, isTrue);
        expect(comp2Checked, isTrue);

        result.fold(
          (_) => fail('Should return system health'),
          (systemHealth) {
            expect(systemHealth.componentResults.length, equals(2));
            expect(systemHealth.overallStatus, equals(HealthStatus.healthy));
            expect(systemHealth.isHealthy, isTrue);
            expect(systemHealth.healthyCount, equals(2));
            expect(systemHealth.degradedCount, equals(0));
            expect(systemHealth.unhealthyCount, equals(0));
          },
        );
      });

      test('should determine overall status as degraded when some components degraded', () async {
        // Arrange
        service.registerCheck('healthy_component', () async {
          return HealthCheckResult(
            componentName: 'healthy_component',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        service.registerCheck('degraded_component', () async {
          return HealthCheckResult(
            componentName: 'degraded_component',
            status: HealthStatus.degraded,
            message: 'Slow response',
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Act
        final result = await service.checkAll();

        // Assert
        result.fold(
          (_) => fail('Should return system health'),
          (systemHealth) {
            expect(systemHealth.overallStatus, equals(HealthStatus.degraded));
            expect(systemHealth.isDegraded, isTrue);
            expect(systemHealth.healthyCount, equals(1));
            expect(systemHealth.degradedCount, equals(1));
          },
        );
      });

      test('should determine overall status as unhealthy when any component unhealthy', () async {
        // Arrange
        service.registerCheck('healthy_component', () async {
          return HealthCheckResult(
            componentName: 'healthy_component',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        service.registerCheck('unhealthy_component', () async {
          return HealthCheckResult(
            componentName: 'unhealthy_component',
            status: HealthStatus.unhealthy,
            message: 'Database connection failed',
            timestamp: DateTime.now().toUtc(),
          );
        });

        // Act
        final result = await service.checkAll();

        // Assert
        result.fold(
          (_) => fail('Should return system health'),
          (systemHealth) {
            expect(systemHealth.overallStatus, equals(HealthStatus.unhealthy));
            expect(systemHealth.isUnhealthy, isTrue);
            expect(systemHealth.healthyCount, equals(1));
            expect(systemHealth.unhealthyCount, equals(1));
          },
        );
      });

      test('should return healthy when no components registered', () async {
        // Act
        final result = await service.checkAll();

        // Assert
        result.fold(
          (_) => fail('Should return system health'),
          (systemHealth) {
            expect(systemHealth.overallStatus, equals(HealthStatus.healthy));
            expect(systemHealth.componentResults, isEmpty);
          },
        );
      });

      test('should handle failures gracefully in checkAll', () async {
        // Arrange
        service.registerCheck('good', () async {
          return HealthCheckResult(
            componentName: 'good',
            status: HealthStatus.healthy,
            timestamp: DateTime.now().toUtc(),
          );
        });

        service.registerCheck('bad', () async {
          throw Exception('Check failed');
        });

        // Act
        final result = await service.checkAll();

        // Assert
        result.fold(
          (_) => fail('Should return system health even with failures'),
          (systemHealth) {
            expect(systemHealth.componentResults.length, equals(2));
            // One healthy, one unhealthy (from exception)
            expect(systemHealth.healthyCount, equals(1));
            expect(systemHealth.unhealthyCount, equals(1));
          },
        );
      });
    });

    group('HealthCheckResult', () {
      test('should create result with all fields', () {
        // Arrange & Act
        final result = HealthCheckResult(
          componentName: 'test',
          status: HealthStatus.healthy,
          message: 'All good',
          timestamp: DateTime.now().toUtc(),
          responseTime: const Duration(milliseconds: 100),
          metadata: {'version': '1.0.0'},
        );

        // Assert
        expect(result.componentName, equals('test'));
        expect(result.status, equals(HealthStatus.healthy));
        expect(result.message, equals('All good'));
        expect(result.responseTime?.inMilliseconds, equals(100));
        expect(result.metadata?['version'], equals('1.0.0'));
        expect(result.isHealthy, isTrue);
        expect(result.isDegraded, isFalse);
        expect(result.isUnhealthy, isFalse);
      });

      test('should convert to JSON', () {
        // Arrange
        final timestamp = DateTime.now().toUtc();
        final result = HealthCheckResult(
          componentName: 'database',
          status: HealthStatus.degraded,
          message: 'Slow queries',
          timestamp: timestamp,
          responseTime: const Duration(milliseconds: 500),
          metadata: {'connection_pool': '8/10'},
        );

        // Act
        final json = result.toJson();

        // Assert
        expect(json['component'], equals('database'));
        expect(json['status'], equals('degraded'));
        expect(json['message'], equals('Slow queries'));
        expect(json['timestamp'], equals(timestamp.toIso8601String()));
        expect(json['responseTime'], equals(500));
        expect(json['metadata'], equals({'connection_pool': '8/10'}));
      });
    });

    group('SystemHealth', () {
      test('should convert to JSON', () {
        // Arrange
        final timestamp = DateTime.now().toUtc();
        final systemHealth = SystemHealth(
          overallStatus: HealthStatus.healthy,
          componentResults: [
            HealthCheckResult(
              componentName: 'comp1',
              status: HealthStatus.healthy,
              timestamp: timestamp,
            ),
            HealthCheckResult(
              componentName: 'comp2',
              status: HealthStatus.healthy,
              timestamp: timestamp,
            ),
          ],
          timestamp: timestamp,
        );

        // Act
        final json = systemHealth.toJson();

        // Assert
        expect(json['overallStatus'], equals('healthy'));
        expect(json['timestamp'], equals(timestamp.toIso8601String()));
        expect(json['summary']['total'], equals(2));
        expect(json['summary']['healthy'], equals(2));
        expect(json['summary']['degraded'], equals(0));
        expect(json['summary']['unhealthy'], equals(0));
        expect(json['components'].length, equals(2));
      });
    });
  });
}
