import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/plugins/plugin_ui_registry.dart';

void main() {
  group('PluginUIRegistry Tests', () {
    late PluginUIRegistry registry;

    setUp(() {
      registry = PluginUIRegistry();
    });

    tearDown(() {
      registry.dispose();
    });

    group('Registration', () {
      test('should register UI descriptor', () {
        // Arrange
        final descriptor = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );

        // Act
        registry.registerUI(descriptor);

        // Assert
        expect(registry.hasUI('test-plugin'), isTrue);
        expect(registry.getUI('test-plugin'), equals(descriptor));
      });

      test('should update existing UI descriptor', () {
        // Arrange
        final descriptor1 = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test 1',
          uiData: const {},
        );
        final descriptor2 = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.favorite.codePoint,
          tooltip: 'Test 2',
          uiData: const {},
        );

        // Act
        registry.registerUI(descriptor1);
        registry.registerUI(descriptor2);

        // Assert
        expect(registry.getUI('test-plugin'), equals(descriptor2));
      });

      test('should emit registration event', () {
        // Arrange
        final descriptor = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );

        PluginUIUpdateEvent? event;
        registry.updates.listen((e) => event = e);

        // Act
        registry.registerUI(descriptor);

        // Assert
        expect(event, isNotNull);
        expect(event!.type, equals(PluginUIUpdateType.registered));
        expect(event!.descriptor, equals(descriptor));
      });
    });

    group('Unregistration', () {
      test('should unregister UI descriptor', () {
        // Arrange
        final descriptor = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );
        registry.registerUI(descriptor);

        // Act
        registry.unregisterUI('test-plugin');

        // Assert
        expect(registry.hasUI('test-plugin'), isFalse);
        expect(registry.getUI('test-plugin'), isNull);
      });

      test('should emit unregistration event', () {
        // Arrange
        final descriptor = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );
        registry.registerUI(descriptor);

        PluginUIUpdateEvent? event;
        final subscription = registry.updates.listen((e) {
          if (e.type == PluginUIUpdateType.unregistered) {
            event = e;
          }
        });

        // Act
        registry.unregisterUI('test-plugin');

        // Assert
        expect(event, isNotNull);
        expect(event!.type, equals(PluginUIUpdateType.unregistered));

        subscription.cancel();
      });

      test('should handle unregistering non-existent plugin', () {
        // Act & Assert - should not throw
        expect(() => registry.unregisterUI('non-existent'), returnsNormally);
      });
    });

    group('Query', () {
      test('should return all registered UIs', () {
        // Arrange
        final descriptor1 = PluginUIDescriptor(
          pluginId: 'plugin-1',
          iconCode: Icons.star.codePoint,
          tooltip: 'Plugin 1',
          priority: 1,
          uiData: const {},
        );
        final descriptor2 = PluginUIDescriptor(
          pluginId: 'plugin-2',
          iconCode: Icons.favorite.codePoint,
          tooltip: 'Plugin 2',
          priority: 2,
          uiData: const {},
        );

        registry.registerUI(descriptor1);
        registry.registerUI(descriptor2);

        // Act
        final uis = registry.getRegisteredUIs();

        // Assert
        expect(uis.length, equals(2));
        expect(uis, contains(descriptor1));
        expect(uis, contains(descriptor2));
      });

      test('should sort UIs by priority', () {
        // Arrange
        final descriptor1 = PluginUIDescriptor(
          pluginId: 'plugin-1',
          iconCode: Icons.star.codePoint,
          tooltip: 'Plugin 1',
          priority: 2,
          uiData: const {},
        );
        final descriptor2 = PluginUIDescriptor(
          pluginId: 'plugin-2',
          iconCode: Icons.favorite.codePoint,
          tooltip: 'Plugin 2',
          priority: 1,
          uiData: const {},
        );

        registry.registerUI(descriptor1);
        registry.registerUI(descriptor2);

        // Act
        final uis = registry.getRegisteredUIs();

        // Assert
        expect(uis[0].pluginId, equals('plugin-2')); // Lower priority first
        expect(uis[1].pluginId, equals('plugin-1'));
      });

      test('should check if plugin has UI', () {
        // Arrange
        final descriptor = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );
        registry.registerUI(descriptor);

        // Act & Assert
        expect(registry.hasUI('test-plugin'), isTrue);
        expect(registry.hasUI('non-existent'), isFalse);
      });
    });

    group('Statistics', () {
      test('should return statistics', () {
        // Arrange
        final descriptor = PluginUIDescriptor(
          pluginId: 'test-plugin',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );
        registry.registerUI(descriptor);

        // Act
        final stats = registry.getStatistics();

        // Assert
        expect(stats['totalRegistered'], equals(1));
        expect(stats['plugins'], contains('test-plugin'));
      });
    });

    group('Use Cases', () {
      test('UC1: Register multiple plugin UIs', () {
        // Arrange
        final recentFiles = PluginUIDescriptor(
          pluginId: 'recent-files',
          iconCode: Icons.history.codePoint,
          tooltip: 'Recent Files',
          priority: 1,
          uiData: const {},
        );
        final search = PluginUIDescriptor(
          pluginId: 'search',
          iconCode: Icons.search.codePoint,
          tooltip: 'Search',
          priority: 2,
          uiData: const {},
        );

        // Act
        registry.registerUI(recentFiles);
        registry.registerUI(search);

        // Assert
        final uis = registry.getRegisteredUIs();
        expect(uis.length, equals(2));
        expect(uis[0].pluginId, equals('recent-files'));
        expect(uis[1].pluginId, equals('search'));
      });

      test('UC2: Update plugin UI dynamically', () {
        // Arrange
        final original = PluginUIDescriptor(
          pluginId: 'dynamic-plugin',
          iconCode: Icons.widgets.codePoint,
          tooltip: 'Original',
          uiData: const {'items': []},
        );
        registry.registerUI(original);

        final updated = PluginUIDescriptor(
          pluginId: 'dynamic-plugin',
          iconCode: Icons.widgets.codePoint,
          tooltip: 'Updated',
          uiData: const {
            'items': [
              {'id': '1', 'title': 'New Item'},
            ],
          },
        );

        // Act
        registry.registerUI(updated);

        // Assert
        final current = registry.getUI('dynamic-plugin');
        expect(current?.tooltip, equals('Updated'));
        expect(current?.uiData['items'], isNotEmpty);
      });

      test('UC3: Listen to plugin UI updates', () async {
        // Arrange
        final events = <PluginUIUpdateEvent>[];
        final subscription = registry.updates.listen(events.add);

        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.star.codePoint,
          tooltip: 'Test',
          uiData: const {},
        );

        // Act
        registry.registerUI(descriptor);
        await Future.delayed(const Duration(milliseconds: 10));
        registry.unregisterUI('test');
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(events.length, equals(2));
        expect(events[0].type, equals(PluginUIUpdateType.registered));
        expect(events[1].type, equals(PluginUIUpdateType.unregistered));

        await subscription.cancel();
      });
    });
  });
}
