import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/src/commands/command_bus.dart';

void main() {
  group('Command', () {
    group('Construction', () {
      test('should create command with id and handler', () {
        // Arrange
        Future<String> handler(String input) async => 'result: $input';

        // Act
        final command = Command<String, String>(
          id: 'test.command',
          handler: handler,
        );

        // Assert
        expect(command.id, equals('test.command'));
        expect(command.handler, equals(handler));
      });

      test('should create command with different input/output types', () {
        // Arrange
        Future<int> handler(String input) async => input.length;

        // Act
        final command = Command<String, int>(
          id: 'length.command',
          handler: handler,
        );

        // Assert
        expect(command.id, equals('length.command'));
      });

      test('should create command with void input', () {
        // Arrange
        Future<String> handler(void _) async => 'executed';

        // Act
        final command = Command<void, String>(
          id: 'void.command',
          handler: handler,
        );

        // Assert
        expect(command.id, equals('void.command'));
      });

      test('should create command with void output', () {
        // Arrange
        Future<void> handler(String input) async {}

        // Act
        final command = Command<String, void>(
          id: 'action.command',
          handler: handler,
        );

        // Assert
        expect(command.id, equals('action.command'));
      });
    });

    group('Execute', () {
      test('should execute command and return result', () async {
        // Arrange
        final command = Command<int, int>(
          id: 'double',
          handler: (input) async => input * 2,
        );

        // Act
        final result = await command.execute(5);

        // Assert
        expect(result, equals(10));
      });

      test('should execute command with string transformation', () async {
        // Arrange
        final command = Command<String, String>(
          id: 'uppercase',
          handler: (input) async => input.toUpperCase(),
        );

        // Act
        final result = await command.execute('hello');

        // Assert
        expect(result, equals('HELLO'));
      });

      test('should execute command with complex input', () async {
        // Arrange
        final command = Command<Map<String, dynamic>, String>(
          id: 'format',
          handler: (input) async => 'Name: ${input['name']}, Age: ${input['age']}',
        );

        // Act
        final result = await command.execute({'name': 'John', 'age': 30});

        // Assert
        expect(result, equals('Name: John, Age: 30'));
      });

      test('should execute command with async operations', () async {
        // Arrange
        final command = Command<int, int>(
          id: 'delayed.double',
          handler: (input) async {
            await Future.delayed(const Duration(milliseconds: 10));
            return input * 2;
          },
        );

        // Act
        final result = await command.execute(7);

        // Assert
        expect(result, equals(14));
      });

      test('should propagate exceptions from handler', () async {
        // Arrange
        final command = Command<String, String>(
          id: 'error.command',
          handler: (input) async {
            throw Exception('Command failed');
          },
        );

        // Act & Assert
        await expectLater(
          command.execute('test'),
          throwsException,
        );
      });
    });
  });

  group('CommandBus', () {
    late CommandBus bus;

    setUp(() {
      bus = CommandBus();
    });

    group('Register', () {
      test('should register a command', () {
        // Arrange
        final command = Command<String, String>(
          id: 'test.command',
          handler: (input) async => input,
        );

        // Act
        bus.register(command);

        // Assert
        expect(bus.hasCommand('test.command'), isTrue);
      });

      test('should register multiple commands', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'command1',
          handler: (input) async => input,
        );
        final command2 = Command<int, int>(
          id: 'command2',
          handler: (input) async => input,
        );

        // Act
        bus.register(command1);
        bus.register(command2);

        // Assert
        expect(bus.hasCommand('command1'), isTrue);
        expect(bus.hasCommand('command2'), isTrue);
      });

      test('should throw error when registering duplicate command', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'duplicate',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'duplicate',
          handler: (input) async => input.toUpperCase(),
        );

        bus.register(command1);

        // Act & Assert
        expect(
          () => bus.register(command2),
          throwsA(isA<StateError>()),
        );
      });

      test('should include command ID in duplicate error message', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'test.duplicate',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'test.duplicate',
          handler: (input) async => input,
        );

        bus.register(command1);

        // Act & Assert
        expect(
          () => bus.register(command2),
          throwsA(
            predicate((e) => e.toString().contains('test.duplicate')),
          ),
        );
      });

      test('should register commands with different types', () {
        // Arrange
        final stringCommand = Command<String, String>(
          id: 'string.cmd',
          handler: (input) async => input,
        );
        final intCommand = Command<int, int>(
          id: 'int.cmd',
          handler: (input) async => input,
        );
        final boolCommand = Command<bool, bool>(
          id: 'bool.cmd',
          handler: (input) async => !input,
        );

        // Act
        bus.register(stringCommand);
        bus.register(intCommand);
        bus.register(boolCommand);

        // Assert
        expect(bus.allCommandIds.length, equals(3));
      });
    });

    group('Unregister', () {
      test('should unregister a command', () {
        // Arrange
        final command = Command<String, String>(
          id: 'test.command',
          handler: (input) async => input,
        );

        bus.register(command);

        // Act
        bus.unregister('test.command');

        // Assert
        expect(bus.hasCommand('test.command'), isFalse);
      });

      test('should handle unregister of non-existent command', () {
        // Act & Assert - should not throw
        expect(
          () => bus.unregister('non.existent'),
          returnsNormally,
        );
      });

      test('should allow re-registration after unregister', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'reusable',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'reusable',
          handler: (input) async => input.toUpperCase(),
        );

        bus.register(command1);
        bus.unregister('reusable');

        // Act & Assert
        expect(() => bus.register(command2), returnsNormally);
        expect(bus.hasCommand('reusable'), isTrue);
      });
    });

    group('Execute', () {
      test('should execute registered command', () async {
        // Arrange
        final command = Command<int, int>(
          id: 'double',
          handler: (input) async => input * 2,
        );

        bus.register(command);

        // Act
        final result = await bus.execute<int, int>('double', 5);

        // Assert
        expect(result, equals(10));
      });

      test('should execute command with string input', () async {
        // Arrange
        final command = Command<String, String>(
          id: 'uppercase',
          handler: (input) async => input.toUpperCase(),
        );

        bus.register(command);

        // Act
        final result = await bus.execute<String, String>('uppercase', 'hello');

        // Assert
        expect(result, equals('HELLO'));
      });

      test('should execute command with complex types', () async {
        // Arrange
        final command = Command<Map<String, int>, int>(
          id: 'sum.values',
          handler: (input) async => input.values.reduce((a, b) => a + b),
        );

        bus.register(command);

        // Act
        final result = await bus.execute<Map<String, int>, int>(
          'sum.values',
          {'a': 1, 'b': 2, 'c': 3},
        );

        // Assert
        expect(result, equals(6));
      });

      test('should throw error when executing non-existent command', () async {
        // Act & Assert
        await expectLater(
          bus.execute<String, String>('non.existent', 'test'),
          throwsA(isA<StateError>()),
        );
      });

      test('should include command ID in non-existent error message', () async {
        // Act & Assert
        await expectLater(
          bus.execute<String, String>('missing.command', 'test'),
          throwsA(
            predicate((e) => e.toString().contains('missing.command')),
          ),
        );
      });

      test('should wrap handler exceptions in CommandExecutionException', () async {
        // Arrange
        final command = Command<String, String>(
          id: 'failing.command',
          handler: (input) async {
            throw Exception('Handler error');
          },
        );

        bus.register(command);

        // Act & Assert
        await expectLater(
          bus.execute<String, String>('failing.command', 'test'),
          throwsA(isA<CommandExecutionException>()),
        );
      });

      test('should include command ID in execution exception', () async {
        // Arrange
        final command = Command<String, String>(
          id: 'error.command',
          handler: (input) async {
            throw Exception('Test error');
          },
        );

        bus.register(command);

        // Act & Assert
        await expectLater(
          bus.execute<String, String>('error.command', 'test'),
          throwsA(
            predicate((e) =>
                e is CommandExecutionException &&
                e.commandId == 'error.command'),
          ),
        );
      });

      test('should preserve original exception in CommandExecutionException', () async {
        // Arrange
        final originalError = Exception('Original error');
        final command = Command<String, String>(
          id: 'test.command',
          handler: (input) async {
            throw originalError;
          },
        );

        bus.register(command);

        // Act
        try {
          await bus.execute<String, String>('test.command', 'test');
          fail('Should have thrown');
        } catch (e) {
          // Assert
          expect(e, isA<CommandExecutionException>());
          final cmdException = e as CommandExecutionException;
          expect(cmdException.cause, equals(originalError));
        }
      });

      test('should execute multiple commands sequentially', () async {
        // Arrange
        final results = <int>[];

        final command1 = Command<int, int>(
          id: 'cmd1',
          handler: (input) async {
            results.add(1);
            return input + 1;
          },
        );

        final command2 = Command<int, int>(
          id: 'cmd2',
          handler: (input) async {
            results.add(2);
            return input + 2;
          },
        );

        bus.register(command1);
        bus.register(command2);

        // Act
        final result1 = await bus.execute<int, int>('cmd1', 10);
        final result2 = await bus.execute<int, int>('cmd2', result1);

        // Assert
        expect(result1, equals(11));
        expect(result2, equals(13));
        expect(results, equals([1, 2]));
      });

      test('should handle concurrent command execution', () async {
        // Arrange
        final command = Command<int, int>(
          id: 'async.command',
          handler: (input) async {
            await Future.delayed(const Duration(milliseconds: 10));
            return input * 2;
          },
        );

        bus.register(command);

        // Act
        final futures = [
          bus.execute<int, int>('async.command', 1),
          bus.execute<int, int>('async.command', 2),
          bus.execute<int, int>('async.command', 3),
        ];

        final results = await Future.wait(futures);

        // Assert
        expect(results, equals([2, 4, 6]));
      });
    });

    group('HasCommand', () {
      test('should return true for registered command', () {
        // Arrange
        final command = Command<String, String>(
          id: 'test.command',
          handler: (input) async => input,
        );

        bus.register(command);

        // Act
        final hasCommand = bus.hasCommand('test.command');

        // Assert
        expect(hasCommand, isTrue);
      });

      test('should return false for non-existent command', () {
        // Act
        final hasCommand = bus.hasCommand('non.existent');

        // Assert
        expect(hasCommand, isFalse);
      });

      test('should return false after unregister', () {
        // Arrange
        final command = Command<String, String>(
          id: 'test.command',
          handler: (input) async => input,
        );

        bus.register(command);
        bus.unregister('test.command');

        // Act
        final hasCommand = bus.hasCommand('test.command');

        // Assert
        expect(hasCommand, isFalse);
      });
    });

    group('AllCommandIds', () {
      test('should return empty list when no commands registered', () {
        // Act
        final commandIds = bus.allCommandIds;

        // Assert
        expect(commandIds, isEmpty);
      });

      test('should return list of registered command IDs', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'command1',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'command2',
          handler: (input) async => input,
        );

        bus.register(command1);
        bus.register(command2);

        // Act
        final commandIds = bus.allCommandIds;

        // Assert
        expect(commandIds.length, equals(2));
        expect(commandIds, contains('command1'));
        expect(commandIds, contains('command2'));
      });

      test('should update list after unregister', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'command1',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'command2',
          handler: (input) async => input,
        );

        bus.register(command1);
        bus.register(command2);
        bus.unregister('command1');

        // Act
        final commandIds = bus.allCommandIds;

        // Assert
        expect(commandIds.length, equals(1));
        expect(commandIds, contains('command2'));
        expect(commandIds, isNot(contains('command1')));
      });
    });

    group('Clear', () {
      test('should clear all registered commands', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'command1',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'command2',
          handler: (input) async => input,
        );

        bus.register(command1);
        bus.register(command2);

        // Act
        bus.clear();

        // Assert
        expect(bus.allCommandIds, isEmpty);
        expect(bus.hasCommand('command1'), isFalse);
        expect(bus.hasCommand('command2'), isFalse);
      });

      test('should allow registration after clear', () {
        // Arrange
        final command1 = Command<String, String>(
          id: 'test.command',
          handler: (input) async => input,
        );
        final command2 = Command<String, String>(
          id: 'test.command',
          handler: (input) async => input.toUpperCase(),
        );

        bus.register(command1);
        bus.clear();

        // Act & Assert
        expect(() => bus.register(command2), returnsNormally);
        expect(bus.hasCommand('test.command'), isTrue);
      });

      test('should handle clear on empty bus', () {
        // Act & Assert
        expect(() => bus.clear(), returnsNormally);
        expect(bus.allCommandIds, isEmpty);
      });
    });

    group('Real-World Use Cases', () {
      test('should support file operation commands', () async {
        // Arrange
        final saveCommand = Command<Map<String, dynamic>, bool>(
          id: 'file.save',
          handler: (input) async {
            final path = input['path'] as String;
            final content = input['content'] as String;
            // Simulate save operation
            return path.isNotEmpty && content.isNotEmpty;
          },
        );

        bus.register(saveCommand);

        // Act
        final result = await bus.execute<Map<String, dynamic>, bool>(
          'file.save',
          {'path': '/test/file.txt', 'content': 'Hello World'},
        );

        // Assert
        expect(result, isTrue);
      });

      test('should support code formatting commands', () async {
        // Arrange
        final formatCommand = Command<String, String>(
          id: 'code.format',
          handler: (input) async {
            // Simulate formatting
            return input.trim().replaceAll(RegExp(r'\s+'), ' ');
          },
        );

        bus.register(formatCommand);

        // Act
        final result = await bus.execute<String, String>(
          'code.format',
          '  hello    world  ',
        );

        // Assert
        expect(result, equals('hello world'));
      });

      test('should support snippet insertion commands', () async {
        // Arrange
        final insertSnippetCommand = Command<Map<String, dynamic>, String>(
          id: 'editor.insertSnippet',
          handler: (input) async {
            final snippetName = input['name'] as String;
            final variables = input['variables'] as Map<String, String>?;

            if (snippetName == 'function') {
              final name = variables?['name'] ?? 'myFunction';
              return 'function $name() {\n  // TODO\n}';
            }
            return '';
          },
        );

        bus.register(insertSnippetCommand);

        // Act
        final result = await bus.execute<Map<String, dynamic>, String>(
          'editor.insertSnippet',
          {
            'name': 'function',
            'variables': {'name': 'calculateSum'},
          },
        );

        // Assert
        expect(result, contains('function calculateSum'));
      });

      test('should support find and replace commands', () async {
        // Arrange
        final replaceCommand = Command<Map<String, dynamic>, String>(
          id: 'editor.replace',
          handler: (input) async {
            final text = input['text'] as String;
            final find = input['find'] as String;
            final replace = input['replace'] as String;
            return text.replaceAll(find, replace);
          },
        );

        bus.register(replaceCommand);

        // Act
        final result = await bus.execute<Map<String, dynamic>, String>(
          'editor.replace',
          {
            'text': 'Hello World, Hello Universe',
            'find': 'Hello',
            'replace': 'Hi',
          },
        );

        // Assert
        expect(result, equals('Hi World, Hi Universe'));
      });

      test('should support command chaining', () async {
        // Arrange
        final trimCommand = Command<String, String>(
          id: 'string.trim',
          handler: (input) async => input.trim(),
        );

        final uppercaseCommand = Command<String, String>(
          id: 'string.uppercase',
          handler: (input) async => input.toUpperCase(),
        );

        final reverseCommand = Command<String, String>(
          id: 'string.reverse',
          handler: (input) async => input.split('').reversed.join(''),
        );

        bus.register(trimCommand);
        bus.register(uppercaseCommand);
        bus.register(reverseCommand);

        // Act
        var result = await bus.execute<String, String>('string.trim', '  hello  ');
        result = await bus.execute<String, String>('string.uppercase', result);
        result = await bus.execute<String, String>('string.reverse', result);

        // Assert
        expect(result, equals('OLLEH'));
      });
    });
  });

  group('CommandExecutionException', () {
    test('should create exception with command ID and cause', () {
      // Arrange
      final cause = Exception('Test error');

      // Act
      final exception = CommandExecutionException(
        commandId: 'test.command',
        cause: cause,
      );

      // Assert
      expect(exception.commandId, equals('test.command'));
      expect(exception.cause, equals(cause));
    });

    test('should have descriptive toString', () {
      // Arrange
      final cause = Exception('Original error');
      final exception = CommandExecutionException(
        commandId: 'my.command',
        cause: cause,
      );

      // Act
      final str = exception.toString();

      // Assert
      expect(str, contains('CommandExecutionException'));
      expect(str, contains('my.command'));
      expect(str, contains('Original error'));
    });

    test('should preserve different cause types', () {
      // Arrange
      final stringCause = 'Error message';
      final exceptionCause = Exception('Exception message');
      final errorCause = ArgumentError('Invalid argument');

      // Act
      final stringException = CommandExecutionException(
        commandId: 'cmd1',
        cause: stringCause,
      );
      final exceptionException = CommandExecutionException(
        commandId: 'cmd2',
        cause: exceptionCause,
      );
      final errorException = CommandExecutionException(
        commandId: 'cmd3',
        cause: errorCause,
      );

      // Assert
      expect(stringException.cause, isA<String>());
      expect(exceptionException.cause, isA<Exception>());
      expect(errorException.cause, isA<ArgumentError>());
    });
  });
}
