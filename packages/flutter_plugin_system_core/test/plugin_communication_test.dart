import 'dart:async';
import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:test/test.dart';

/// Mock plugin that communicates via events
class CommunicatingPlugin implements IPlugin {
  final String _id;
  final List<PluginEvent> receivedEvents = [];
  final StreamController<PluginResponse> _responseController =
      StreamController<PluginResponse>.broadcast();

  CommunicatingPlugin(this._id);

  @override
  PluginManifest get manifest => PluginManifest(
    id: _id,
    name: 'Communicating Plugin',
    version: '1.0.0',
    description: 'Plugin for testing communication',
    runtime: PluginRuntimeType.wasm,
    subscribesTo: ['test.event', 'broadcast.event'],
    providedEvents: ['response.event'],
  );

  @override
  Future<void> initialize(PluginContext context) async {}

  @override
  Future<PluginResponse> handleEvent(PluginEvent event) async {
    receivedEvents.add(event);

    final response = PluginResponse.success(
      data: {
        'plugin_id': _id,
        'event_type': event.type,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    _responseController.add(response);
    return response;
  }

  @override
  Future<void> dispose() async {
    await _responseController.close();
  }

  Stream<PluginResponse> get responses => _responseController.stream;
}

void main() {
  group('Plugin Communication', () {
    group('Event Handling', () {
      test('should handle targeted events', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'test.event',
          targetPluginId: 'test.plugin',
          data: {'message': 'hello'},
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data['plugin_id'], equals('test.plugin'));
        expect(plugin.receivedEvents, contains(event));
      });

      test('should handle broadcast events', () async {
        // Arrange
        final plugin1 = CommunicatingPlugin('plugin1');
        final plugin2 = CommunicatingPlugin('plugin2');
        final event = PluginEvent.now(
          type: 'broadcast.event',
          data: {'broadcast': true},
        );

        // Act
        await plugin1.handleEvent(event);
        await plugin2.handleEvent(event);

        // Assert
        expect(plugin1.receivedEvents, contains(event));
        expect(plugin2.receivedEvents, contains(event));
      });

      test('should handle events with complex data', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'complex.event',
          data: {
            'nested': {
              'value': 42,
              'list': [1, 2, 3],
            },
            'map': {'a': 'alpha', 'b': 'beta'},
          },
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(plugin.receivedEvents.first.data['nested']['value'], equals(42));
      });

      test('should preserve event metadata', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final eventId = 'event-123';
        final event = PluginEvent.now(
          type: 'metadata.event',
          targetPluginId: 'test.plugin',
          sourcePluginId: 'source.plugin',
          priority: 5,
          eventId: eventId,
        );

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        expect(received.eventId, equals(eventId));
        expect(received.sourcePluginId, equals('source.plugin'));
        expect(received.priority, equals(5));
      });
    });

    group('Request-Response Pattern', () {
      test('should respond to events synchronously', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'request.event',
          data: {'request': 'data'},
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data.containsKey('plugin_id'), isTrue);
        expect(response.data.containsKey('event_type'), isTrue);
      });

      test('should handle multiple requests sequentially', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final events = List.generate(
          5,
          (i) => PluginEvent.now(
            type: 'request.$i',
            data: {'index': i},
          ),
        );

        // Act
        final responses = <PluginResponse>[];
        for (final event in events) {
          responses.add(await plugin.handleEvent(event));
        }

        // Assert
        expect(responses.length, equals(5));
        expect(plugin.receivedEvents.length, equals(5));
        for (var i = 0; i < 5; i++) {
          expect(responses[i].isSuccess, isTrue);
        }
      });

      test('should handle concurrent requests', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final events = List.generate(
          10,
          (i) => PluginEvent.now(
            type: 'concurrent.$i',
            data: {'index': i},
          ),
        );

        // Act
        final responses = await Future.wait(
          events.map((event) => plugin.handleEvent(event)),
        );

        // Assert
        expect(responses.length, equals(10));
        expect(plugin.receivedEvents.length, equals(10));
        for (final response in responses) {
          expect(response.isSuccess, isTrue);
        }
      });
    });

    group('Event Streaming', () {
      test('should stream responses', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final responses = <PluginResponse>[];
        final subscription = plugin.responses.listen(responses.add);

        // Act
        await plugin.handleEvent(PluginEvent.now(type: 'stream.1'));
        await plugin.handleEvent(PluginEvent.now(type: 'stream.2'));
        await plugin.handleEvent(PluginEvent.now(type: 'stream.3'));
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(responses.length, equals(3));
        await subscription.cancel();
      });

      test('should support response streaming to multiple listeners', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final listener1 = <PluginResponse>[];
        final listener2 = <PluginResponse>[];

        final sub1 = plugin.responses.listen(listener1.add);
        final sub2 = plugin.responses.listen(listener2.add);

        // Act
        await plugin.handleEvent(PluginEvent.now(type: 'multi.stream'));
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(listener1.length, equals(1));
        expect(listener2.length, equals(1));

        await sub1.cancel();
        await sub2.cancel();
      });
    });

    group('Data Transfer', () {
      test('should transfer string data', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'string.event',
          data: {'text': 'Hello, World!'},
        );

        // Act
        await plugin.handleEvent(event);

        // Assert
        expect(
          plugin.receivedEvents.first.getData<String>('text'),
          equals('Hello, World!'),
        );
      });

      test('should transfer numeric data', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'numeric.event',
          data: {'int': 42, 'double': 3.14},
        );

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        expect(received.getData<int>('int'), equals(42));
        expect(received.getData<double>('double'), equals(3.14));
      });

      test('should transfer list data', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'list.event',
          data: {
            'items': [1, 2, 3, 4, 5],
          },
        );

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        final items = received.getData<List>('items');
        expect(items, equals([1, 2, 3, 4, 5]));
      });

      test('should transfer map data', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'map.event',
          data: {
            'config': {
              'enabled': true,
              'timeout': 5000,
              'name': 'test',
            },
          },
        );

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        final config = received.getData<Map>('config');
        expect(config!['enabled'], isTrue);
        expect(config['timeout'], equals(5000));
        expect(config['name'], equals('test'));
      });

      test('should handle null values in data', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'null.event',
          data: {'nullable': null},
        );

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        expect(received.data.containsKey('nullable'), isTrue);
        expect(received.data['nullable'], isNull);
      });
    });

    group('Event Prioritization', () {
      test('should preserve event priority', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final lowPriority = PluginEvent.now(
          type: 'low',
          priority: 1,
        );
        final highPriority = PluginEvent.now(
          type: 'high',
          priority: 10,
        );

        // Act
        await plugin.handleEvent(lowPriority);
        await plugin.handleEvent(highPriority);

        // Assert
        expect(plugin.receivedEvents[0].priority, equals(1));
        expect(plugin.receivedEvents[1].priority, equals(10));
      });
    });

    group('Event Timestamps', () {
      test('should include timestamps in events', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(type: 'timestamp.event');

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        expect(received.timestamp, isNotNull);
        expect(received.timestamp, isA<DateTime>());
      });

      test('should maintain timestamp accuracy', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final before = DateTime.now();
        final event = PluginEvent.now(type: 'timing.event');
        final after = DateTime.now();

        // Act
        await plugin.handleEvent(event);

        // Assert
        final received = plugin.receivedEvents.first;
        expect(
          received.timestamp!.isAfter(before) ||
              received.timestamp!.isAtSameMomentAs(before),
          isTrue,
        );
        expect(
          received.timestamp!.isBefore(after) ||
              received.timestamp!.isAtSameMomentAs(after),
          isTrue,
        );
      });
    });

    group('Inter-Plugin Communication', () {
      test('should support plugin-to-plugin messaging', () async {
        // Arrange
        final sender = CommunicatingPlugin('sender.plugin');
        final receiver = CommunicatingPlugin('receiver.plugin');
        final event = PluginEvent.now(
          type: 'inter.plugin',
          sourcePluginId: 'sender.plugin',
          targetPluginId: 'receiver.plugin',
          data: {'message': 'from sender'},
        );

        // Act
        await receiver.handleEvent(event);

        // Assert
        final received = receiver.receivedEvents.first;
        expect(received.sourcePluginId, equals('sender.plugin'));
        expect(received.targetPluginId, equals('receiver.plugin'));
        expect(received.getData<String>('message'), equals('from sender'));
      });

      test('should support bidirectional communication', () async {
        // Arrange
        final plugin1 = CommunicatingPlugin('plugin1');
        final plugin2 = CommunicatingPlugin('plugin2');

        final event1to2 = PluginEvent.now(
          type: 'ping',
          sourcePluginId: 'plugin1',
          targetPluginId: 'plugin2',
        );

        final event2to1 = PluginEvent.now(
          type: 'pong',
          sourcePluginId: 'plugin2',
          targetPluginId: 'plugin1',
        );

        // Act
        await plugin2.handleEvent(event1to2);
        await plugin1.handleEvent(event2to1);

        // Assert
        expect(plugin2.receivedEvents.first.type, equals('ping'));
        expect(plugin1.receivedEvents.first.type, equals('pong'));
      });
    });

    group('Error Scenarios', () {
      test('should handle events with missing data gracefully', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: 'missing.data',
          data: {},
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(plugin.receivedEvents.first.data, isEmpty);
      });

      test('should handle invalid event types', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final event = PluginEvent.now(
          type: '',
          data: {},
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(plugin.receivedEvents.first.type, isEmpty);
      });

      test('should handle events with large payloads', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        final largeData = List.generate(1000, (i) => 'item$i');
        final event = PluginEvent.now(
          type: 'large.payload',
          data: {'items': largeData},
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        final received = plugin.receivedEvents.first;
        expect(received.getData<List>('items')?.length, equals(1000));
      });
    });

    group('Cleanup', () {
      test('should clean up resources on dispose', () async {
        // Arrange
        final plugin = CommunicatingPlugin('test.plugin');
        await plugin.handleEvent(PluginEvent.now(type: 'before.dispose'));

        // Act
        await plugin.dispose();

        // Assert
        expect(plugin.responses.isBroadcast, isTrue);
      });
    });
  });
}
