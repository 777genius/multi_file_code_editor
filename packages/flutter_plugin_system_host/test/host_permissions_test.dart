import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_host/flutter_plugin_system_host.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Host Permissions', () {
    group('PermissionSystem', () {
      late PermissionSystem permissionSystem;

      setUp(() {
        permissionSystem = PermissionSystem();
      });

      group('Registration', () {
        test('should register plugin permissions', () {
          // Arrange
          const permissions = PluginPermissions(
            allowedHostFunctions: ['func1', 'func2'],
            maxExecutionTime: Duration(seconds: 10),
          );

          // Act
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Assert
          expect(permissionSystem.isRegistered('test.plugin'), isTrue);
          final retrieved = permissionSystem.getPermissions('test.plugin');
          expect(retrieved.allowedHostFunctions, hasLength(2));
        });

        test('should prevent duplicate registration', () {
          // Arrange
          const permissions = PluginPermissions();
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            () => permissionSystem.registerPlugin('test.plugin', permissions),
            throwsArgumentError,
          );
        });

        test('should register multiple plugins', () {
          // Act
          permissionSystem.registerPlugin('plugin1', const PluginPermissions());
          permissionSystem.registerPlugin('plugin2', const PluginPermissions());
          permissionSystem.registerPlugin('plugin3', const PluginPermissions());

          // Assert
          final registered = permissionSystem.getRegisteredPlugins();
          expect(registered, hasLength(3));
        });
      });

      group('Permission Queries', () {
        test('should check host function permissions', () {
          // Arrange
          const permissions = PluginPermissions(
            allowedHostFunctions: ['allowed_func'],
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            permissionSystem.canCallHostFunction('test.plugin', 'allowed_func'),
            isTrue,
          );
          expect(
            permissionSystem.canCallHostFunction('test.plugin', 'blocked_func'),
            isFalse,
          );
        });

        test('should return default permissions for unregistered plugin', () {
          // Act
          final permissions = permissionSystem.getPermissions('unregistered');

          // Assert
          expect(permissions.allowedHostFunctions, isEmpty);
          expect(permissions.maxExecutionTime, equals(const Duration(seconds: 5)));
        });

        test('should check filesystem access', () {
          // Arrange
          const permissions = PluginPermissions(
            filesystemAccess: FilesystemAccessLevel.readOnly,
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final retrieved = permissionSystem.getPermissions('test.plugin');

          // Assert
          expect(retrieved.filesystemAccess, equals(FilesystemAccessLevel.readOnly));
        });

        test('should check network access', () {
          // Arrange
          const permissions = PluginPermissions(canAccessNetwork: true);
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final retrieved = permissionSystem.getPermissions('test.plugin');

          // Assert
          expect(retrieved.canAccessNetwork, isTrue);
        });
      });

      group('Permission Updates', () {
        test('should update plugin permissions', () {
          // Arrange
          const initialPermissions = PluginPermissions(
            allowedHostFunctions: ['func1'],
          );
          permissionSystem.registerPlugin('test.plugin', initialPermissions);

          // Act
          const updatedPermissions = PluginPermissions(
            allowedHostFunctions: ['func1', 'func2'],
          );
          permissionSystem.updatePermissions('test.plugin', updatedPermissions);

          // Assert
          final retrieved = permissionSystem.getPermissions('test.plugin');
          expect(retrieved.allowedHostFunctions, hasLength(2));
        });

        test('should throw when updating unregistered plugin', () {
          // Act & Assert
          expect(
            () => permissionSystem.updatePermissions('unregistered', const PluginPermissions()),
            throwsArgumentError,
          );
        });
      });

      group('Unregistration', () {
        test('should unregister plugin permissions', () {
          // Arrange
          permissionSystem.registerPlugin('test.plugin', const PluginPermissions());

          // Act
          permissionSystem.unregisterPlugin('test.plugin');

          // Assert
          expect(permissionSystem.isRegistered('test.plugin'), isFalse);
        });

        test('should handle unregistering non-existent plugin', () {
          // Act & Assert - should not throw
          permissionSystem.unregisterPlugin('non.existent');
        });
      });

      group('Statistics', () {
        test('should provide permission statistics', () {
          // Arrange
          permissionSystem.registerPlugin(
            'plugin1',
            const PluginPermissions(allowedHostFunctions: ['f1', 'f2']),
          );
          permissionSystem.registerPlugin(
            'plugin2',
            const PluginPermissions(allowedHostFunctions: ['f3']),
          );

          // Act
          final stats = permissionSystem.getStatistics();

          // Assert
          expect(stats['total_plugins'], equals(2));
          expect(stats['avg_host_functions'], equals(1.5));
        });

        test('should track network access statistics', () {
          // Arrange
          permissionSystem.registerPlugin(
            'plugin1',
            const PluginPermissions(canAccessNetwork: true),
          );
          permissionSystem.registerPlugin(
            'plugin2',
            const PluginPermissions(canAccessNetwork: false),
          );

          // Act
          final stats = permissionSystem.getStatistics();

          // Assert
          expect(stats['plugins_with_network'], equals(1));
        });

        test('should track filesystem access statistics', () {
          // Arrange
          permissionSystem.registerPlugin(
            'plugin1',
            const PluginPermissions(filesystemAccess: FilesystemAccessLevel.readOnly),
          );
          permissionSystem.registerPlugin(
            'plugin2',
            const PluginPermissions(filesystemAccess: FilesystemAccessLevel.none),
          );

          // Act
          final stats = permissionSystem.getStatistics();

          // Assert
          expect(stats['plugins_with_filesystem'], equals(1));
        });

        test('should handle empty permission system statistics', () {
          // Act
          final stats = permissionSystem.getStatistics();

          // Assert
          expect(stats['total_plugins'], equals(0));
          expect(stats['avg_host_functions'], equals(0.0));
        });
      });

      group('Clear', () {
        test('should clear all permissions', () {
          // Arrange
          permissionSystem.registerPlugin('plugin1', const PluginPermissions());
          permissionSystem.registerPlugin('plugin2', const PluginPermissions());

          // Act
          permissionSystem.clear();

          // Assert
          expect(permissionSystem.getRegisteredPlugins(), isEmpty);
        });
      });
    });

    group('SecurityGuard', () {
      late PermissionSystem permissionSystem;
      late SecurityGuard securityGuard;

      setUp(() {
        permissionSystem = PermissionSystem();
        securityGuard = SecurityGuard(permissionSystem);
      });

      group('Host Function Permission Enforcement', () {
        test('should allow calling permitted functions', () {
          // Arrange
          const permissions = PluginPermissions(
            allowedHostFunctions: ['allowed_func'],
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert - should not throw
          securityGuard.enforceHostFunctionPermission('test.plugin', 'allowed_func');
        });

        test('should deny calling non-permitted functions', () {
          // Arrange
          const permissions = PluginPermissions(
            allowedHostFunctions: ['allowed_func'],
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            () => securityGuard.enforceHostFunctionPermission('test.plugin', 'blocked_func'),
            throwsA(isA<PermissionDeniedException>()),
          );
        });

        test('should check permission without throwing', () {
          // Arrange
          const permissions = PluginPermissions(
            allowedHostFunctions: ['func'],
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(securityGuard.canCallHostFunction('test.plugin', 'func'), isTrue);
          expect(securityGuard.canCallHostFunction('test.plugin', 'other'), isFalse);
        });
      });

      group('Timeout Enforcement', () {
        test('should execute function within timeout', () async {
          // Arrange
          const permissions = PluginPermissions(
            maxExecutionTime: Duration(seconds: 1),
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final result = await securityGuard.executeWithTimeout(
            'test.plugin',
            () async {
              await Future.delayed(const Duration(milliseconds: 10));
              return 'result';
            },
          );

          // Assert
          expect(result, equals('result'));
        });

        test('should timeout on slow function', () async {
          // Arrange
          const permissions = PluginPermissions(
            maxExecutionTime: Duration(milliseconds: 50),
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            () => securityGuard.executeWithTimeout(
              'test.plugin',
              () async {
                await Future.delayed(const Duration(milliseconds: 200));
                return 'result';
              },
            ),
            throwsA(isA<PluginTimeoutException>()),
          );
        });

        test('should use correct timeout from permissions', () {
          // Arrange
          const permissions = PluginPermissions(
            maxExecutionTime: Duration(seconds: 10),
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final timeout = securityGuard.getMaxExecutionTime('test.plugin');

          // Assert
          expect(timeout, equals(const Duration(seconds: 10)));
        });
      });

      group('Memory Limit Enforcement', () {
        test('should allow memory usage within limit', () {
          // Arrange
          const permissions = PluginPermissions(
            maxMemoryBytes: 1024 * 1024, // 1MB
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert - should not throw
          securityGuard.checkMemoryLimit('test.plugin', 512 * 1024); // 512KB
        });

        test('should deny memory usage exceeding limit', () {
          // Arrange
          const permissions = PluginPermissions(
            maxMemoryBytes: 1024 * 1024, // 1MB
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            () => securityGuard.checkMemoryLimit('test.plugin', 2 * 1024 * 1024), // 2MB
            throwsA(isA<PluginMemoryLimitException>()),
          );
        });

        test('should get memory limit from permissions', () {
          // Arrange
          const permissions = PluginPermissions(
            maxMemoryBytes: 50 * 1024 * 1024, // 50MB
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final limit = securityGuard.getMaxMemoryBytes('test.plugin');

          // Assert
          expect(limit, equals(50 * 1024 * 1024));
        });
      });

      group('Network Permission Enforcement', () {
        test('should allow network access when permitted', () {
          // Arrange
          const permissions = PluginPermissions(canAccessNetwork: true);
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert - should not throw
          securityGuard.enforceNetworkPermission('test.plugin');
        });

        test('should deny network access when not permitted', () {
          // Arrange
          const permissions = PluginPermissions(canAccessNetwork: false);
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            () => securityGuard.enforceNetworkPermission('test.plugin'),
            throwsA(isA<PermissionDeniedException>()),
          );
        });

        test('should check network permission without throwing', () {
          // Arrange
          permissionSystem.registerPlugin(
            'plugin1',
            const PluginPermissions(canAccessNetwork: true),
          );
          permissionSystem.registerPlugin(
            'plugin2',
            const PluginPermissions(canAccessNetwork: false),
          );

          // Act & Assert
          expect(securityGuard.canAccessNetwork('plugin1'), isTrue);
          expect(securityGuard.canAccessNetwork('plugin2'), isFalse);
        });
      });

      group('Filesystem Permission Enforcement', () {
        test('should allow filesystem access when permitted', () {
          // Arrange
          const permissions = PluginPermissions(
            filesystemAccess: FilesystemAccessLevel.readWrite,
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert - should not throw
          securityGuard.enforceFilesystemPermission(
            'test.plugin',
            FilesystemAccessLevel.readOnly,
          );
        });

        test('should deny filesystem access when not permitted', () {
          // Arrange
          const permissions = PluginPermissions(
            filesystemAccess: FilesystemAccessLevel.readOnly,
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            () => securityGuard.enforceFilesystemPermission(
              'test.plugin',
              FilesystemAccessLevel.readWrite,
            ),
            throwsA(isA<PermissionDeniedException>()),
          );
        });

        test('should check filesystem permission hierarchy', () {
          // Arrange
          const permissions = PluginPermissions(
            filesystemAccess: FilesystemAccessLevel.readWrite,
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act & Assert
          expect(
            securityGuard.canAccessFilesystem('test.plugin', FilesystemAccessLevel.none),
            isTrue,
          );
          expect(
            securityGuard.canAccessFilesystem('test.plugin', FilesystemAccessLevel.readOnly),
            isTrue,
          );
          expect(
            securityGuard.canAccessFilesystem('test.plugin', FilesystemAccessLevel.readWrite),
            isTrue,
          );
          expect(
            securityGuard.canAccessFilesystem('test.plugin', FilesystemAccessLevel.full),
            isFalse,
          );
        });

        test('should get filesystem access level', () {
          // Arrange
          const permissions = PluginPermissions(
            filesystemAccess: FilesystemAccessLevel.readOnly,
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final level = securityGuard.getFilesystemAccess('test.plugin');

          // Assert
          expect(level, equals(FilesystemAccessLevel.readOnly));
        });
      });

      group('Security Summary', () {
        test('should provide comprehensive security summary', () {
          // Arrange
          const permissions = PluginPermissions(
            allowedHostFunctions: ['func1', 'func2'],
            maxExecutionTime: Duration(seconds: 5),
            maxMemoryBytes: 50 * 1024 * 1024,
            maxCallDepth: 100,
            canAccessNetwork: true,
            filesystemAccess: FilesystemAccessLevel.readOnly,
          );
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final summary = securityGuard.getSecuritySummary('test.plugin');

          // Assert
          expect(summary['plugin_id'], equals('test.plugin'));
          expect(summary['allowed_host_functions'], hasLength(2));
          expect(summary['max_execution_time_ms'], equals(5000));
          expect(summary['max_memory_bytes'], equals(50 * 1024 * 1024));
          expect(summary['max_call_depth'], equals(100));
          expect(summary['can_access_network'], isTrue);
          expect(summary['filesystem_access'], equals('readOnly'));
        });
      });

      group('Call Depth', () {
        test('should get max call depth from permissions', () {
          // Arrange
          const permissions = PluginPermissions(maxCallDepth: 50);
          permissionSystem.registerPlugin('test.plugin', permissions);

          // Act
          final depth = securityGuard.getMaxCallDepth('test.plugin');

          // Assert
          expect(depth, equals(50));
        });
      });
    });

    group('Permission Boundaries', () {
      test('should enforce strict permission boundaries between plugins', () {
        // Arrange
        final permissionSystem = PermissionSystem();
        permissionSystem.registerPlugin(
          'plugin1',
          const PluginPermissions(allowedHostFunctions: ['func1']),
        );
        permissionSystem.registerPlugin(
          'plugin2',
          const PluginPermissions(allowedHostFunctions: ['func2']),
        );

        // Act & Assert
        expect(
          permissionSystem.canCallHostFunction('plugin1', 'func1'),
          isTrue,
        );
        expect(
          permissionSystem.canCallHostFunction('plugin1', 'func2'),
          isFalse,
        );
        expect(
          permissionSystem.canCallHostFunction('plugin2', 'func2'),
          isTrue,
        );
        expect(
          permissionSystem.canCallHostFunction('plugin2', 'func1'),
          isFalse,
        );
      });

      test('should isolate permission updates', () {
        // Arrange
        final permissionSystem = PermissionSystem();
        const permissions1 = PluginPermissions(allowedHostFunctions: ['func1']);
        const permissions2 = PluginPermissions(allowedHostFunctions: ['func2']);

        permissionSystem.registerPlugin('plugin1', permissions1);
        permissionSystem.registerPlugin('plugin2', permissions2);

        // Act - update plugin1 permissions
        const updatedPermissions1 = PluginPermissions(
          allowedHostFunctions: ['func1', 'func3'],
        );
        permissionSystem.updatePermissions('plugin1', updatedPermissions1);

        // Assert - plugin2 permissions unchanged
        final plugin2Perms = permissionSystem.getPermissions('plugin2');
        expect(plugin2Perms.allowedHostFunctions, equals(['func2']));
        expect(plugin2Perms.allowedHostFunctions, isNot(contains('func3')));
      });
    });
  });
}
