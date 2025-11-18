import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/src/messaging/plugin_message_bus.dart';

// Test message types
class TestMessage extends PluginMessage {
  final String content;

  TestMessage({
    required super.senderId,
    super.targetId,
    super.timestamp,
    required this.content,
  });
}

class TestRequest extends PluginRequest<String> {
  final String query;

  TestRequest({
    required super.senderId,
    required super.targetId,
    required this.query,
  });
}

void main() {
  group('PluginMessage', () {
    group('Construction', () {
      test('should create with required parameters', () {
        // Act
        final message = TestMessage(
          senderId: 'plugin1',
          content: 'test',
        );

        // Assert
        expect(message.senderId, equals('plugin1'));
        expect(message.targetId, isNull);
        expect(message.timestamp, isNotNull);
      });

      test('should create with target ID for directed messages', () {
        // Act
        final message = TestMessage(
          senderId: 'plugin1',
          targetId: 'plugin2',
          content: 'direct',
        );

        // Assert
        expect(message.senderId, equals('plugin1'));
        expect(message.targetId, equals('plugin2'));
      });

      test('should create with custom timestamp', () {
        // Arrange
        final customTime = DateTime(2024, 1, 1);

        // Act
        final message = TestMessage(
          senderId: 'plugin1',
          timestamp: customTime,
          content: 'test',
        );

        // Assert
        expect(message.timestamp, equals(customTime));
      });

      test('should auto-generate timestamp if not provided', () {
        // Arrange
        final before = DateTime.now();

        // Act
        final message = TestMessage(
          senderId: 'plugin1',
          content: 'test',
        );

        // Assert
        final after = DateTime.now();
        expect(message.timestamp.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(message.timestamp.isBefore(after.add(const Duration(seconds: 1))), isTrue);
      });
    });
  });

  group('PluginResponse', () {
    group('Success Response', () {
      test('should create success response with data', () {
        // Act
        final response = PluginResponse<String>.success('result data');

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.isError, isFalse);
        expect(response.success, isTrue);
        expect(response.data, equals('result data'));
        expect(response.error, isNull);
      });

      test('should create success response with null data', () {
        // Act
        final response = PluginResponse<String>.success(null);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNull);
        expect(response.error, isNull);
      });

      test('should create success response with complex data', () {
        // Arrange
        final complexData = {'key1': 'value1', 'key2': 42};

        // Act
        final response = PluginResponse<Map<String, dynamic>>.success(complexData);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, equals(complexData));
      });
    });

    group('Error Response', () {
      test('should create error response with message', () {
        // Act
        final response = PluginResponse<String>.error('Operation failed');

        // Assert
        expect(response.isError, isTrue);
        expect(response.isSuccess, isFalse);
        expect(response.success, isFalse);
        expect(response.error, equals('Operation failed'));
        expect(response.data, isNull);
      });

      test('should create error response with null message', () {
        // Act
        final response = PluginResponse<String>.error(null);

        // Assert
        expect(response.isError, isTrue);
        expect(response.error, isNull);
      });
    });
  });

  group('PluginMessageBus', () {
    late PluginMessageBus bus;

    setUp(() {
      bus = PluginMessageBus();
    });

    tearDown(() {
      bus.dispose();
    });

    group('Subscription', () {
      test('should subscribe to messages of specific type', () async {
        // Arrange
        final receivedMessages = <TestMessage>[];

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            receivedMessages.add(message);
          },
        );

        // Act
        await bus.publish(TestMessage(
          senderId: 'plugin2',
          content: 'hello',
        ));

        // Wait for async processing
        await Future.delayed(Duration.zero);

        // Assert
        expect(receivedMessages.length, equals(1));
        expect(receivedMessages.first.content, equals('hello'));
      });

      test('should subscribe multiple handlers for same type', () async {
        // Arrange
        var handler1Called = false;
        var handler2Called = false;

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            handler1Called = true;
          },
        );

        bus.subscribe<TestMessage>(
          pluginId: 'plugin2',
          handler: (message) {
            handler2Called = true;
          },
        );

        // Act
        await bus.publish(TestMessage(
          senderId: 'plugin3',
          content: 'test',
        ));

        await Future.delayed(Duration.zero);

        // Assert
        expect(handler1Called, isTrue);
        expect(handler2Called, isTrue);
      });

      test('should filter messages with custom filter', () async {
        // Arrange
        final receivedMessages = <TestMessage>[];

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            receivedMessages.add(message);
          },
          filter: (message) => message.content.startsWith('important'),
        );

        // Act
        await bus.publish(TestMessage(senderId: 'p1', content: 'important message'));
        await bus.publish(TestMessage(senderId: 'p1', content: 'normal message'));
        await bus.publish(TestMessage(senderId: 'p1', content: 'important data'));

        await Future.delayed(Duration.zero);

        // Assert
        expect(receivedMessages.length, equals(2));
        expect(receivedMessages[0].content, equals('important message'));
        expect(receivedMessages[1].content, equals('important data'));
      });

      test('should handle filter exceptions gracefully', () async {
        // Arrange
        final receivedMessages = <TestMessage>[];

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            receivedMessages.add(message);
          },
          filter: (message) => throw Exception('Filter error'),
        );

        // Act
        await bus.publish(TestMessage(senderId: 'p1', content: 'test'));

        await Future.delayed(Duration.zero);

        // Assert - should not receive message due to filter exception
        expect(receivedMessages, isEmpty);
      });
    });

    group('Unsubscribe', () {
      test('should unsubscribe all handlers for a plugin', () async {
        // Arrange
        var handler1Called = false;
        var handler2Called = false;

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            handler1Called = true;
          },
        );

        bus.subscribe<TestMessage>(
          pluginId: 'plugin2',
          handler: (message) {
            handler2Called = true;
          },
        );

        // Act
        bus.unsubscribe('plugin1');

        await bus.publish(TestMessage(senderId: 'p3', content: 'test'));
        await Future.delayed(Duration.zero);

        // Assert
        expect(handler1Called, isFalse);
        expect(handler2Called, isTrue);
      });

      test('should close plugin stream when unsubscribing', () async {
        // Arrange
        final stream = bus.getPluginStream('plugin1');
        var streamClosed = false;

        stream.listen(
          (message) {},
          onDone: () {
            streamClosed = true;
          },
        );

        // Act
        bus.unsubscribe('plugin1');

        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(streamClosed, isTrue);
      });

      test('should handle unsubscribe for non-existent plugin', () {
        // Act & Assert - should not throw
        expect(() => bus.unsubscribe('non-existent'), returnsNormally);
      });
    });

    group('Publishing', () {
      test('should publish message to global stream', () async {
        // Arrange
        final messages = <PluginMessage>[];
        bus.messages.listen((msg) => messages.add(msg));

        // Act
        await bus.publish(TestMessage(senderId: 'p1', content: 'test'));
        await Future.delayed(Duration.zero);

        // Assert
        expect(messages.length, equals(1));
      });

      test('should publish message to plugin-specific stream', () async {
        // Arrange
        final pluginMessages = <PluginMessage>[];
        final stream = bus.getPluginStream('plugin1');
        stream.listen((msg) => pluginMessages.add(msg));

        // Act
        await bus.publish(TestMessage(senderId: 'plugin1', content: 'test'));
        await Future.delayed(Duration.zero);

        // Assert
        expect(pluginMessages.length, equals(1));
      });

      test('should publish to targeted plugin only', () async {
        // Arrange
        var plugin1Received = false;
        var plugin2Received = false;

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            plugin1Received = true;
          },
        );

        bus.subscribe<TestMessage>(
          pluginId: 'plugin2',
          handler: (message) {
            plugin2Received = true;
          },
        );

        // Act
        await bus.publish(TestMessage(
          senderId: 'p3',
          targetId: 'plugin2',
          content: 'targeted',
        ));
        await Future.delayed(Duration.zero);

        // Assert
        expect(plugin1Received, isFalse);
        expect(plugin2Received, isTrue);
      });

      test('should broadcast to all plugins when no target specified', () async {
        // Arrange
        var plugin1Received = false;
        var plugin2Received = false;

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            plugin1Received = true;
          },
        );

        bus.subscribe<TestMessage>(
          pluginId: 'plugin2',
          handler: (message) {
            plugin2Received = true;
          },
        );

        // Act
        await bus.publish(TestMessage(
          senderId: 'p3',
          content: 'broadcast',
        ));
        await Future.delayed(Duration.zero);

        // Assert
        expect(plugin1Received, isTrue);
        expect(plugin2Received, isTrue);
      });

      test('should handle handler exceptions without stopping other handlers', () async {
        // Arrange
        var handler1Called = false;
        var handler2Called = false;

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            handler1Called = true;
            throw Exception('Handler 1 error');
          },
        );

        bus.subscribe<TestMessage>(
          pluginId: 'plugin2',
          handler: (message) {
            handler2Called = true;
          },
        );

        // Act
        await bus.publish(TestMessage(senderId: 'p3', content: 'test'));
        await Future.delayed(Duration.zero);

        // Assert
        expect(handler1Called, isTrue);
        expect(handler2Called, isTrue);
      });

      test('should not dispatch to handlers of different message types', () async {
        // Arrange
        var wrongHandlerCalled = false;

        bus.subscribe<BroadcastMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            wrongHandlerCalled = true;
          },
        );

        // Act
        await bus.publish(TestMessage(senderId: 'p1', content: 'test'));
        await Future.delayed(Duration.zero);

        // Assert
        expect(wrongHandlerCalled, isFalse);
      });
    });

    group('Request-Response', () {
      test('should send request and receive response', () async {
        // Arrange
        bus.subscribe<TestRequest>(
          pluginId: 'responder',
          handler: (request) async {
            await bus.publish(PluginResponse<String>.success('response to ${request.query}'));
          },
        );

        // Act
        final response = await bus.request<TestRequest, String>(
          TestRequest(
            senderId: 'requester',
            targetId: 'responder',
            query: 'test query',
          ),
        );

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, contains('response to'));
      });

      test('should timeout request after specified duration', () async {
        // Act
        final response = await bus.request<TestRequest, String>(
          TestRequest(
            senderId: 'requester',
            targetId: 'non-existent',
            query: 'test',
          ),
          timeout: const Duration(milliseconds: 100),
        );

        // Assert
        expect(response.isError, isTrue);
        expect(response.error, contains('timeout'));
      });

      test('should handle request errors gracefully', () async {
        // Arrange
        bus.subscribe<TestRequest>(
          pluginId: 'responder',
          handler: (request) async {
            throw Exception('Handler error');
          },
        );

        // Act
        final response = await bus.request<TestRequest, String>(
          TestRequest(
            senderId: 'requester',
            targetId: 'responder',
            query: 'test',
          ),
          timeout: const Duration(milliseconds: 100),
        );

        // Assert
        expect(response.isError, isTrue);
      });
    });

    group('Plugin Streams', () {
      test('should create plugin stream on first access', () {
        // Act
        final stream = bus.getPluginStream('plugin1');

        // Assert
        expect(stream, isNotNull);
      });

      test('should return same stream on subsequent access', () {
        // Act
        final stream1 = bus.getPluginStream('plugin1');
        final stream2 = bus.getPluginStream('plugin1');

        // Assert
        expect(identical(stream1, stream2), isTrue);
      });

      test('should receive messages on plugin stream', () async {
        // Arrange
        final messages = <PluginMessage>[];
        final stream = bus.getPluginStream('plugin1');
        stream.listen((msg) => messages.add(msg));

        // Act
        await bus.publish(TestMessage(senderId: 'plugin1', content: 'test1'));
        await bus.publish(TestMessage(senderId: 'plugin1', content: 'test2'));
        await Future.delayed(Duration.zero);

        // Assert
        expect(messages.length, equals(2));
      });
    });

    group('Statistics', () {
      test('should track total handlers count', () {
        // Arrange
        bus.subscribe<TestMessage>(pluginId: 'p1', handler: (_) {});
        bus.subscribe<TestMessage>(pluginId: 'p2', handler: (_) {});
        bus.subscribe<BroadcastMessage>(pluginId: 'p3', handler: (_) {});

        // Act
        final stats = bus.statistics;

        // Assert
        expect(stats.totalHandlers, equals(3));
      });

      test('should track message types', () {
        // Arrange
        bus.subscribe<TestMessage>(pluginId: 'p1', handler: (_) {});
        bus.subscribe<BroadcastMessage>(pluginId: 'p2', handler: (_) {});

        // Act
        final stats = bus.statistics;

        // Assert
        expect(stats.messageTypes.length, equals(2));
        expect(stats.messageTypes, contains(TestMessage));
        expect(stats.messageTypes, contains(BroadcastMessage));
      });

      test('should track handlers by type', () {
        // Arrange
        bus.subscribe<TestMessage>(pluginId: 'p1', handler: (_) {});
        bus.subscribe<TestMessage>(pluginId: 'p2', handler: (_) {});
        bus.subscribe<BroadcastMessage>(pluginId: 'p3', handler: (_) {});

        // Act
        final stats = bus.statistics;

        // Assert
        expect(stats.handlersByType[TestMessage], equals(2));
        expect(stats.handlersByType[BroadcastMessage], equals(1));
      });

      test('should track active plugin streams', () {
        // Arrange
        bus.getPluginStream('plugin1');
        bus.getPluginStream('plugin2');

        // Act
        final stats = bus.statistics;

        // Assert
        expect(stats.activePluginStreams, equals(2));
      });

      test('should provide statistics toString', () {
        // Arrange
        bus.subscribe<TestMessage>(pluginId: 'p1', handler: (_) {});

        // Act
        final stats = bus.statistics;
        final str = stats.toString();

        // Assert
        expect(str, contains('Total Handlers'));
        expect(str, contains('Message Types'));
        expect(str, contains('Active Plugin Streams'));
      });
    });

    group('Common Message Types', () {
      test('should handle GetDataRequest', () async {
        // Arrange
        final receivedRequests = <GetDataRequest>[];

        bus.subscribe<GetDataRequest>(
          pluginId: 'provider',
          handler: (request) {
            receivedRequests.add(request);
          },
        );

        // Act
        await bus.publish(GetDataRequest<String>(
          senderId: 'requester',
          targetId: 'provider',
          dataKey: 'user.name',
          parameters: {'id': '123'},
        ));
        await Future.delayed(Duration.zero);

        // Assert
        expect(receivedRequests.length, equals(1));
        expect(receivedRequests.first.dataKey, equals('user.name'));
        expect(receivedRequests.first.parameters?['id'], equals('123'));
      });

      test('should handle PluginStateChangedMessage', () async {
        // Arrange
        final receivedMessages = <PluginStateChangedMessage>[];

        bus.subscribe<PluginStateChangedMessage>(
          pluginId: 'observer',
          handler: (message) {
            receivedMessages.add(message);
          },
        );

        // Act
        await bus.publish(PluginStateChangedMessage(
          senderId: 'plugin1',
          state: 'activated',
          data: {'version': '1.0.0'},
        ));
        await Future.delayed(Duration.zero);

        // Assert
        expect(receivedMessages.length, equals(1));
        expect(receivedMessages.first.state, equals('activated'));
        expect(receivedMessages.first.data?['version'], equals('1.0.0'));
      });

      test('should handle ActionRequest', () async {
        // Arrange
        final receivedRequests = <ActionRequest>[];

        bus.subscribe<ActionRequest>(
          pluginId: 'executor',
          handler: (request) {
            receivedRequests.add(request);
          },
        );

        // Act
        await bus.publish(ActionRequest<void>(
          senderId: 'caller',
          targetId: 'executor',
          action: 'refreshData',
          parameters: {'force': true},
        ));
        await Future.delayed(Duration.zero);

        // Assert
        expect(receivedRequests.length, equals(1));
        expect(receivedRequests.first.action, equals('refreshData'));
        expect(receivedRequests.first.parameters?['force'], isTrue);
      });

      test('should handle BroadcastMessage', () async {
        // Arrange
        final plugin1Messages = <BroadcastMessage>[];
        final plugin2Messages = <BroadcastMessage>[];

        bus.subscribe<BroadcastMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            plugin1Messages.add(message);
          },
        );

        bus.subscribe<BroadcastMessage>(
          pluginId: 'plugin2',
          handler: (message) {
            plugin2Messages.add(message);
          },
        );

        // Act
        await bus.publish(BroadcastMessage(
          senderId: 'broadcaster',
          topic: 'theme.changed',
          payload: {'theme': 'dark'},
        ));
        await Future.delayed(Duration.zero);

        // Assert
        expect(plugin1Messages.length, equals(1));
        expect(plugin2Messages.length, equals(1));
        expect(plugin1Messages.first.topic, equals('theme.changed'));
        expect(plugin1Messages.first.targetId, isNull);
      });
    });

    group('Dispose', () {
      test('should clear all handlers on dispose', () {
        // Arrange
        bus.subscribe<TestMessage>(pluginId: 'p1', handler: (_) {});
        bus.subscribe<TestMessage>(pluginId: 'p2', handler: (_) {});

        // Act
        bus.dispose();

        // Assert
        final stats = bus.statistics;
        expect(stats.totalHandlers, equals(0));
        expect(stats.messageTypes, isEmpty);
      });

      test('should close all plugin streams on dispose', () async {
        // Arrange
        final stream1 = bus.getPluginStream('plugin1');
        final stream2 = bus.getPluginStream('plugin2');

        var stream1Closed = false;
        var stream2Closed = false;

        stream1.listen(
          (_) {},
          onDone: () {
            stream1Closed = true;
          },
        );

        stream2.listen(
          (_) {},
          onDone: () {
            stream2Closed = true;
          },
        );

        // Act
        bus.dispose();

        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(stream1Closed, isTrue);
        expect(stream2Closed, isTrue);
      });

      test('should close message stream on dispose', () async {
        // Arrange
        var streamClosed = false;

        bus.messages.listen(
          (_) {},
          onDone: () {
            streamClosed = true;
          },
        );

        // Act
        bus.dispose();

        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(streamClosed, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle empty message publication', () async {
        // Arrange - no handlers registered

        // Act & Assert - should not throw
        await expectLater(
          bus.publish(TestMessage(senderId: 'p1', content: 'test')),
          completes,
        );
      });

      test('should handle rapid sequential publications', () async {
        // Arrange
        final receivedMessages = <TestMessage>[];

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) {
            receivedMessages.add(message);
          },
        );

        // Act
        for (var i = 0; i < 100; i++) {
          await bus.publish(TestMessage(
            senderId: 'p1',
            content: 'message$i',
          ));
        }

        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(receivedMessages.length, equals(100));
      });

      test('should handle concurrent subscriptions', () async {
        // Act
        final futures = List.generate(10, (i) async {
          bus.subscribe<TestMessage>(
            pluginId: 'plugin$i',
            handler: (_) {},
          );
        });

        await Future.wait(futures);

        // Assert
        final stats = bus.statistics;
        expect(stats.totalHandlers, equals(10));
      });

      test('should handle async handler execution', () async {
        // Arrange
        var handlerCompleted = false;

        bus.subscribe<TestMessage>(
          pluginId: 'plugin1',
          handler: (message) async {
            await Future.delayed(const Duration(milliseconds: 50));
            handlerCompleted = true;
          },
        );

        // Act
        await bus.publish(TestMessage(senderId: 'p1', content: 'test'));

        // Assert
        expect(handlerCompleted, isTrue);
      });
    });
  });
}
