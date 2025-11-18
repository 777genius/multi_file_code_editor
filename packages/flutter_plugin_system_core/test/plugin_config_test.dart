import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:test/test.dart';

void main() {
  group('PluginConfig', () {
    group('Creation', () {
      test('should create config with default values', () {
        // Act
        const config = PluginConfig();

        // Assert
        expect(config.settings, isEmpty);
        expect(config.enabled, isTrue);
        expect(config.priority, equals(100));
        expect(config.autoReload, isFalse);
        expect(config.metadata, isNull);
      });

      test('should create config with custom values', () {
        // Arrange & Act
        const config = PluginConfig(
          settings: {'theme': 'dark', 'fontSize': 14},
          enabled: false,
          priority: 50,
          autoReload: true,
          metadata: {'version': '1.0.0'},
        );

        // Assert
        expect(config.settings['theme'], equals('dark'));
        expect(config.settings['fontSize'], equals(14));
        expect(config.enabled, isFalse);
        expect(config.priority, equals(50));
        expect(config.autoReload, isTrue);
        expect(config.metadata!['version'], equals('1.0.0'));
      });

      test('should create config from manifest defaults', () {
        // Arrange
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
          configSchema: {
            'properties': {
              'theme': {'default': 'light'},
              'maxSize': {'default': 100},
              'enabled': {'default': true},
            },
          },
        );

        // Act
        final config = PluginConfig.fromManifest(manifest);

        // Assert
        expect(config.settings['theme'], equals('light'));
        expect(config.settings['maxSize'], equals(100));
        expect(config.settings['enabled'], equals(true));
      });

      test('should handle manifest without config schema', () {
        // Arrange
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        // Act
        final config = PluginConfig.fromManifest(manifest);

        // Assert
        expect(config.settings, isEmpty);
      });
    });

    group('Settings Access', () {
      test('should get setting with type safety', () {
        // Arrange
        const config = PluginConfig(
          settings: {
            'string': 'value',
            'int': 42,
            'double': 3.14,
            'bool': true,
          },
        );

        // Act & Assert
        expect(config.getSetting<String>('string'), equals('value'));
        expect(config.getSetting<int>('int'), equals(42));
        expect(config.getSetting<double>('double'), equals(3.14));
        expect(config.getSetting<bool>('bool'), isTrue);
      });

      test('should return null for missing settings', () {
        // Arrange
        const config = PluginConfig(settings: {'exists': 'value'});

        // Act & Assert
        expect(config.getSetting<String>('missing'), isNull);
      });

      test('should return null for wrong type', () {
        // Arrange
        const config = PluginConfig(settings: {'number': 42});

        // Act & Assert
        expect(config.getSetting<String>('number'), isNull);
        expect(config.getSetting<int>('number'), equals(42));
      });

      test('should get setting with default value', () {
        // Arrange
        const config = PluginConfig(settings: {'exists': 'value'});

        // Act & Assert
        expect(
          config.getSettingOr('exists', 'default'),
          equals('value'),
        );
        expect(
          config.getSettingOr('missing', 'default'),
          equals('default'),
        );
      });

      test('should handle complex types', () {
        // Arrange
        const config = PluginConfig(
          settings: {
            'list': [1, 2, 3],
            'map': {'nested': 'value'},
          },
        );

        // Act & Assert
        expect(config.getSetting<List>('list'), equals([1, 2, 3]));
        expect(config.getSetting<Map>('map'), equals({'nested': 'value'}));
      });
    });

    group('Settings Update', () {
      test('should update settings', () {
        // Arrange
        const config = PluginConfig(
          settings: {'original': 'value'},
        );

        // Act
        final updated = config.updateSettings({'new': 'setting'});

        // Assert
        expect(updated.settings['original'], equals('value'));
        expect(updated.settings['new'], equals('setting'));
      });

      test('should override existing settings', () {
        // Arrange
        const config = PluginConfig(
          settings: {'key': 'old'},
        );

        // Act
        final updated = config.updateSettings({'key': 'new'});

        // Assert
        expect(updated.settings['key'], equals('new'));
      });

      test('should preserve other config properties', () {
        // Arrange
        const config = PluginConfig(
          settings: {'key': 'value'},
          enabled: false,
          priority: 50,
          autoReload: true,
        );

        // Act
        final updated = config.updateSettings({'new': 'setting'});

        // Assert
        expect(updated.enabled, isFalse);
        expect(updated.priority, equals(50));
        expect(updated.autoReload, isTrue);
      });

      test('should not mutate original config', () {
        // Arrange
        const config = PluginConfig(
          settings: {'original': 'value'},
        );

        // Act
        final updated = config.updateSettings({'new': 'setting'});

        // Assert
        expect(config.settings, hasLength(1));
        expect(updated.settings, hasLength(2));
        expect(config.settings.containsKey('new'), isFalse);
      });
    });

    group('Serialization', () {
      test('should serialize to JSON', () {
        // Arrange
        const config = PluginConfig(
          settings: {'theme': 'dark'},
          enabled: true,
          priority: 100,
          autoReload: false,
        );

        // Act
        final json = config.toJson();

        // Assert
        expect(json['settings'], equals({'theme': 'dark'}));
        expect(json['enabled'], isTrue);
        expect(json['priority'], equals(100));
        expect(json['autoReload'], isFalse);
      });

      test('should deserialize from JSON', () {
        // Arrange
        final json = {
          'settings': {'theme': 'dark'},
          'enabled': false,
          'priority': 50,
          'autoReload': true,
          'metadata': {'version': '1.0.0'},
        };

        // Act
        final config = PluginConfig.fromJson(json);

        // Assert
        expect(config.settings['theme'], equals('dark'));
        expect(config.enabled, isFalse);
        expect(config.priority, equals(50));
        expect(config.autoReload, isTrue);
        expect(config.metadata!['version'], equals('1.0.0'));
      });

      test('should handle missing fields in JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final config = PluginConfig.fromJson(json);

        // Assert
        expect(config.settings, isEmpty);
        expect(config.enabled, isTrue);
        expect(config.priority, equals(100));
        expect(config.autoReload, isFalse);
      });

      test('should round-trip through JSON', () {
        // Arrange
        const original = PluginConfig(
          settings: {
            'string': 'value',
            'number': 42,
            'nested': {'key': 'value'},
          },
          enabled: false,
          priority: 75,
          autoReload: true,
        );

        // Act
        final json = original.toJson();
        final restored = PluginConfig.fromJson(json);

        // Assert
        expect(restored.settings, equals(original.settings));
        expect(restored.enabled, equals(original.enabled));
        expect(restored.priority, equals(original.priority));
        expect(restored.autoReload, equals(original.autoReload));
      });
    });

    group('Immutability', () {
      test('should create new instance on update', () {
        // Arrange
        const config = PluginConfig(settings: {'key': 'value'});

        // Act
        final updated = config.updateSettings({'new': 'setting'});

        // Assert
        expect(config, isNot(same(updated)));
      });

      test('should support copyWith', () {
        // Arrange
        const config = PluginConfig(
          settings: {'theme': 'dark'},
          enabled: true,
          priority: 100,
        );

        // Act
        final copied = config.copyWith(enabled: false);

        // Assert
        expect(copied.settings, equals(config.settings));
        expect(copied.enabled, isFalse);
        expect(copied.priority, equals(config.priority));
      });

      test('should preserve original on copyWith', () {
        // Arrange
        const config = PluginConfig(enabled: true);

        // Act
        final copied = config.copyWith(enabled: false);

        // Assert
        expect(config.enabled, isTrue);
        expect(copied.enabled, isFalse);
      });
    });

    group('Priority', () {
      test('should use default priority', () {
        // Arrange & Act
        const config = PluginConfig();

        // Assert
        expect(config.priority, equals(100));
      });

      test('should support custom priority', () {
        // Arrange & Act
        const lowPriority = PluginConfig(priority: 1);
        const highPriority = PluginConfig(priority: 999);

        // Assert
        expect(lowPriority.priority, lessThan(highPriority.priority));
      });

      test('should allow negative priority', () {
        // Arrange & Act
        const config = PluginConfig(priority: -10);

        // Assert
        expect(config.priority, equals(-10));
      });
    });

    group('Auto-Reload', () {
      test('should be disabled by default', () {
        // Arrange & Act
        const config = PluginConfig();

        // Assert
        expect(config.autoReload, isFalse);
      });

      test('should support enabling auto-reload', () {
        // Arrange & Act
        const config = PluginConfig(autoReload: true);

        // Assert
        expect(config.autoReload, isTrue);
      });
    });

    group('Metadata', () {
      test('should be null by default', () {
        // Arrange & Act
        const config = PluginConfig();

        // Assert
        expect(config.metadata, isNull);
      });

      test('should support custom metadata', () {
        // Arrange & Act
        const config = PluginConfig(
          metadata: {
            'version': '1.0.0',
            'author': 'Test',
            'custom': {'nested': 'value'},
          },
        );

        // Assert
        expect(config.metadata!['version'], equals('1.0.0'));
        expect(config.metadata!['author'], equals('Test'));
        expect(config.metadata!['custom'], equals({'nested': 'value'}));
      });
    });

    group('Complex Scenarios', () {
      test('should handle deeply nested settings', () {
        // Arrange
        const config = PluginConfig(
          settings: {
            'level1': {
              'level2': {
                'level3': {
                  'value': 'deep',
                },
              },
            },
          },
        );

        // Act
        final level1 = config.getSetting<Map>('level1');
        final level2 = level1!['level2'] as Map;
        final level3 = level2['level3'] as Map;

        // Assert
        expect(level3['value'], equals('deep'));
      });

      test('should handle settings with special characters', () {
        // Arrange
        const config = PluginConfig(
          settings: {
            'key.with.dots': 'value1',
            'key-with-dashes': 'value2',
            'key_with_underscores': 'value3',
          },
        );

        // Assert
        expect(config.getSetting<String>('key.with.dots'), equals('value1'));
        expect(config.getSetting<String>('key-with-dashes'), equals('value2'));
        expect(config.getSetting<String>('key_with_underscores'), equals('value3'));
      });

      test('should handle empty string keys', () {
        // Arrange
        const config = PluginConfig(
          settings: {'': 'empty_key'},
        );

        // Assert
        expect(config.getSetting<String>(''), equals('empty_key'));
      });

      test('should merge multiple setting updates', () {
        // Arrange
        const config = PluginConfig(
          settings: {'a': 1},
        );

        // Act
        final step1 = config.updateSettings({'b': 2});
        final step2 = step1.updateSettings({'c': 3});
        final step3 = step2.updateSettings({'a': 10}); // Override

        // Assert
        expect(step3.settings['a'], equals(10));
        expect(step3.settings['b'], equals(2));
        expect(step3.settings['c'], equals(3));
      });

      test('should handle config schema with complex types', () {
        // Arrange
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
          configSchema: {
            'properties': {
              'stringArray': {'default': ['a', 'b', 'c']},
              'numberMap': {'default': {'x': 1, 'y': 2}},
              'boolValue': {'default': false},
            },
          },
        );

        // Act
        final config = PluginConfig.fromManifest(manifest);

        // Assert
        expect(config.getSetting<List>('stringArray'), equals(['a', 'b', 'c']));
        expect(config.getSetting<Map>('numberMap'), equals({'x': 1, 'y': 2}));
        expect(config.getSetting<bool>('boolValue'), isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle null values in settings', () {
        // Arrange
        const config = PluginConfig(
          settings: {'nullable': null},
        );

        // Assert
        expect(config.settings.containsKey('nullable'), isTrue);
        expect(config.settings['nullable'], isNull);
      });

      test('should handle very large settings maps', () {
        // Arrange
        final largeSettings = Map.fromEntries(
          List.generate(1000, (i) => MapEntry('key$i', 'value$i')),
        );
        final config = PluginConfig(settings: largeSettings);

        // Act
        final value500 = config.getSetting<String>('key500');

        // Assert
        expect(config.settings.length, equals(1000));
        expect(value500, equals('value500'));
      });

      test('should handle config with all fields', () {
        // Arrange & Act
        final config = PluginConfig(
          settings: {'all': 'fields'},
          enabled: false,
          priority: 42,
          autoReload: true,
          metadata: {'meta': 'data'},
        );

        // Assert
        expect(config.settings, isNotEmpty);
        expect(config.enabled, isFalse);
        expect(config.priority, equals(42));
        expect(config.autoReload, isTrue);
        expect(config.metadata, isNotEmpty);
      });
    });
  });
}
