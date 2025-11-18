import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_host/flutter_plugin_system_host.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test host function
class TestHostFunction implements HostFunction<String> {
  final List<List<dynamic>> callLog = [];
  String returnValue = 'result';
  bool shouldThrow = false;

  @override
  HostFunctionSignature get signature => const HostFunctionSignature(
    name: 'test_function',
    returnType: 'String',
    parameters: [
      HostFunctionParameter(name: 'arg1', type: 'String'),
    ],
  );

  @override
  bool validateArgs(List args) {
    return args.length == 1 && args[0] is String;
  }

  @override
  Future<String> call(List args) async {
    callLog.add(args);
    if (shouldThrow) {
      throw Exception('Test error');
    }
    return returnValue;
  }
}

void main() {
  group('Host API', () {
    group('Host Function Registry', () {
      late HostFunctionRegistry registry;

      setUp(() {
        registry = HostFunctionRegistry();
      });

      group('Registration', () {
        test('should register host function', () {
          // Arrange
          final function = TestHostFunction();

          // Act
          registry.register('test_func', function);

          // Assert
          expect(registry.has('test_func'), isTrue);
          expect(registry.count, equals(1));
        });

        test('should prevent duplicate registration', () {
          // Arrange
          registry.register('test_func', TestHostFunction());

          // Act & Assert
          expect(
            () => registry.register('test_func', TestHostFunction()),
            throwsStateError,
          );
        });

        test('should register multiple functions', () {
          // Act
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());
          registry.register('func3', TestHostFunction());

          // Assert
          expect(registry.count, equals(3));
          expect(registry.getAllFunctionNames(), hasLength(3));
        });
      });

      group('Function Calls', () {
        test('should call registered function', () async {
          // Arrange
          final function = TestHostFunction();
          function.returnValue = 'test_result';
          registry.register('test_func', function);

          // Act
          final result = await registry.call<String>('test_func', ['arg']);

          // Assert
          expect(result, equals('test_result'));
          expect(function.callLog, hasLength(1));
          expect(function.callLog.first, equals(['arg']));
        });

        test('should throw HostFunctionNotFoundException for missing function', () {
          // Act & Assert
          expect(
            () => registry.call('missing', []),
            throwsA(isA<HostFunctionNotFoundException>()),
          );
        });

        test('should validate arguments before calling', () {
          // Arrange
          registry.register('test_func', TestHostFunction());

          // Act & Assert - wrong number of args
          expect(
            () => registry.call('test_func', []),
            throwsArgumentError,
          );
        });

        test('should track call counts', () async {
          // Arrange
          registry.register('test_func', TestHostFunction());

          // Act
          await registry.call('test_func', ['arg1']);
          await registry.call('test_func', ['arg2']);
          await registry.call('test_func', ['arg3']);

          // Assert
          expect(registry.getCallCount('test_func'), equals(3));
        });

        test('should handle function errors gracefully', () async {
          // Arrange
          final function = TestHostFunction();
          function.shouldThrow = true;
          registry.register('failing_func', function);

          // Act & Assert
          expect(
            () => registry.call('failing_func', ['arg']),
            throwsA(isA<HostFunctionException>()),
          );
        });
      });

      group('Unregistration', () {
        test('should unregister function', () {
          // Arrange
          registry.register('test_func', TestHostFunction());

          // Act
          final result = registry.unregister('test_func');

          // Assert
          expect(result, isTrue);
          expect(registry.has('test_func'), isFalse);
          expect(registry.count, equals(0));
        });

        test('should return false when unregistering non-existent function', () {
          // Act
          final result = registry.unregister('non_existent');

          // Assert
          expect(result, isFalse);
        });

        test('should clear call counts on unregister', () async {
          // Arrange
          registry.register('test_func', TestHostFunction());
          await registry.call('test_func', ['arg']);

          // Act
          registry.unregister('test_func');

          // Assert
          expect(registry.getCallCount('test_func'), equals(0));
        });
      });

      group('Metadata', () {
        test('should get function signature', () {
          // Arrange
          registry.register('test_func', TestHostFunction());

          // Act
          final signature = registry.getSignature('test_func');

          // Assert
          expect(signature, isNotNull);
          expect(signature!.name, equals('test_function'));
          expect(signature.returnType, equals('String'));
        });

        test('should get all signatures', () {
          // Arrange
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());

          // Act
          final signatures = registry.getAllSignatures();

          // Assert
          expect(signatures, hasLength(2));
          expect(signatures.containsKey('func1'), isTrue);
          expect(signatures.containsKey('func2'), isTrue);
        });

        test('should get all function names', () {
          // Arrange
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());
          registry.register('func3', TestHostFunction());

          // Act
          final names = registry.getAllFunctionNames();

          // Assert
          expect(names, hasLength(3));
          expect(names, containsAll(['func1', 'func2', 'func3']));
        });
      });

      group('Statistics', () {
        test('should track call statistics', () async {
          // Arrange
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());

          // Act
          await registry.call('func1', ['arg']);
          await registry.call('func1', ['arg']);
          await registry.call('func2', ['arg']);

          // Assert
          final stats = registry.getStatistics();
          expect(stats['total_functions'], equals(2));
          expect(stats['total_calls'], equals(3));
          expect(stats['most_called'], equals('func1'));
          expect(stats['most_called_count'], equals(2));
        });

        test('should get all call counts', () async {
          // Arrange
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());

          // Act
          await registry.call('func1', ['arg']);
          await registry.call('func2', ['arg']);
          await registry.call('func2', ['arg']);

          // Assert
          final counts = registry.getAllCallCounts();
          expect(counts['func1'], equals(1));
          expect(counts['func2'], equals(2));
        });

        test('should reset call counts', () async {
          // Arrange
          registry.register('test_func', TestHostFunction());
          await registry.call('test_func', ['arg']);
          await registry.call('test_func', ['arg']);

          // Act
          registry.resetCallCount('test_func');

          // Assert
          expect(registry.getCallCount('test_func'), equals(0));
        });

        test('should reset all call counts', () async {
          // Arrange
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());
          await registry.call('func1', ['arg']);
          await registry.call('func2', ['arg']);

          // Act
          registry.resetAllCallCounts();

          // Assert
          expect(registry.getCallCount('func1'), equals(0));
          expect(registry.getCallCount('func2'), equals(0));
        });
      });

      group('Clear Operations', () {
        test('should clear all functions', () {
          // Arrange
          registry.register('func1', TestHostFunction());
          registry.register('func2', TestHostFunction());

          // Act
          registry.clear();

          // Assert
          expect(registry.isEmpty, isTrue);
          expect(registry.count, equals(0));
        });
      });
    });

    group('Event Dispatcher', () {
      late EventDispatcher dispatcher;

      setUp(() {
        dispatcher = EventDispatcher();
      });

      tearDown(() async {
        await dispatcher.dispose();
      });

      group('Event Dispatching', () {
        test('should dispatch events to subscribers', () async {
          // Arrange
          final events = <PluginEvent>[];
          final subscription = dispatcher.stream.listen(events.add);

          // Act
          dispatcher.dispatch(PluginEvent.now(type: 'test.event'));
          await Future.delayed(const Duration(milliseconds: 10));

          // Assert
          expect(events, hasLength(1));
          expect(events.first.type, equals('test.event'));
          await subscription.cancel();
        });

        test('should dispatch to multiple subscribers', () async {
          // Arrange
          final events1 = <PluginEvent>[];
          final events2 = <PluginEvent>[];
          final sub1 = dispatcher.stream.listen(events1.add);
          final sub2 = dispatcher.stream.listen(events2.add);

          // Act
          dispatcher.dispatch(PluginEvent.now(type: 'test.event'));
          await Future.delayed(const Duration(milliseconds: 10));

          // Assert
          expect(events1, hasLength(1));
          expect(events2, hasLength(1));
          await sub1.cancel();
          await sub2.cancel();
        });

        test('should dispatch multiple events', () async {
          // Arrange
          final events = <PluginEvent>[];
          final subscription = dispatcher.stream.listen(events.add);

          // Act
          dispatcher.dispatchAll([
            PluginEvent.now(type: 'event1'),
            PluginEvent.now(type: 'event2'),
            PluginEvent.now(type: 'event3'),
          ]);
          await Future.delayed(const Duration(milliseconds: 10));

          // Assert
          expect(events, hasLength(3));
          await subscription.cancel();
        });
      });

      group('Event Filtering', () {
        test('should filter events by type', () async {
          // Arrange
          final fileEvents = <PluginEvent>[];
          final subscription = dispatcher.streamFor('file.opened').listen(fileEvents.add);

          // Act
          dispatcher.dispatch(PluginEvent.now(type: 'file.opened'));
          dispatcher.dispatch(PluginEvent.now(type: 'file.closed'));
          dispatcher.dispatch(PluginEvent.now(type: 'editor.changed'));
          await Future.delayed(const Duration(milliseconds: 10));

          // Assert
          expect(fileEvents, hasLength(1));
          expect(fileEvents.first.type, equals('file.opened'));
          await subscription.cancel();
        });

        test('should filter events by multiple types', () async {
          // Arrange
          final events = <PluginEvent>[];
          final subscription = dispatcher.streamForAny(['type1', 'type2']).listen(events.add);

          // Act
          dispatcher.dispatch(PluginEvent.now(type: 'type1'));
          dispatcher.dispatch(PluginEvent.now(type: 'type2'));
          dispatcher.dispatch(PluginEvent.now(type: 'type3'));
          await Future.delayed(const Duration(milliseconds: 10));

          // Assert
          expect(events, hasLength(2));
          await subscription.cancel();
        });

        test('should filter events by pattern', () async {
          // Arrange
          final fileEvents = <PluginEvent>[];
          final subscription = dispatcher.streamForPattern('file.*').listen(fileEvents.add);

          // Act
          dispatcher.dispatch(PluginEvent.now(type: 'file.opened'));
          dispatcher.dispatch(PluginEvent.now(type: 'file.closed'));
          dispatcher.dispatch(PluginEvent.now(type: 'editor.changed'));
          await Future.delayed(const Duration(milliseconds: 10));

          // Assert
          expect(fileEvents, hasLength(2));
          await subscription.cancel();
        });
      });

      group('Statistics', () {
        test('should track event counts', () {
          // Act
          dispatcher.dispatch(PluginEvent.now(type: 'event1'));
          dispatcher.dispatch(PluginEvent.now(type: 'event1'));
          dispatcher.dispatch(PluginEvent.now(type: 'event2'));

          // Assert
          expect(dispatcher.getEventCount('event1'), equals(2));
          expect(dispatcher.getEventCount('event2'), equals(1));
          expect(dispatcher.totalDispatched, equals(3));
        });

        test('should provide comprehensive statistics', () {
          // Arrange
          dispatcher.dispatch(PluginEvent.now(type: 'type1'));
          dispatcher.dispatch(PluginEvent.now(type: 'type1'));
          dispatcher.dispatch(PluginEvent.now(type: 'type2'));

          // Act
          final stats = dispatcher.getStatistics();

          // Assert
          expect(stats['total_dispatched'], equals(3));
          expect(stats['unique_types'], equals(2));
          expect(stats['most_common'], equals('type1'));
          expect(stats['most_common_count'], equals(2));
        });

        test('should reset event counts', () {
          // Arrange
          dispatcher.dispatch(PluginEvent.now(type: 'test'));

          // Act
          dispatcher.resetEventCount('test');

          // Assert
          expect(dispatcher.getEventCount('test'), equals(0));
        });

        test('should reset all event counts', () {
          // Arrange
          dispatcher.dispatch(PluginEvent.now(type: 'type1'));
          dispatcher.dispatch(PluginEvent.now(type: 'type2'));

          // Act
          dispatcher.resetAllEventCounts();

          // Assert
          expect(dispatcher.totalDispatched, equals(0));
          expect(dispatcher.getEventCount('type1'), equals(0));
          expect(dispatcher.getEventCount('type2'), equals(0));
        });
      });

      group('Lifecycle', () {
        test('should track listeners', () async {
          // Arrange
          final subscription = dispatcher.stream.listen((_) {});

          // Assert
          expect(dispatcher.hasListeners, isTrue);

          // Cleanup
          await subscription.cancel();
        });

        test('should handle disposal', () async {
          // Act
          await dispatcher.dispose();

          // Assert - should throw when dispatching after disposal
          expect(
            () => dispatcher.dispatch(PluginEvent.now(type: 'test')),
            throwsStateError,
          );
        });
      });
    });

    group('Integration', () {
      test('should integrate host functions with event dispatcher', () async {
        // Arrange
        final registry = HostFunctionRegistry();
        final dispatcher = EventDispatcher();
        final function = TestHostFunction();
        registry.register('test_func', function);

        final events = <PluginEvent>[];
        final subscription = dispatcher.stream.listen(events.add);

        // Act
        await registry.call('test_func', ['arg']);
        dispatcher.dispatch(PluginEvent.now(
          type: 'function.called',
          data: {'function': 'test_func'},
        ));
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(registry.getCallCount('test_func'), equals(1));
        expect(events, hasLength(1));
        expect(events.first.type, equals('function.called'));

        // Cleanup
        await subscription.cancel();
        await dispatcher.dispose();
      });
    });
  });
}
