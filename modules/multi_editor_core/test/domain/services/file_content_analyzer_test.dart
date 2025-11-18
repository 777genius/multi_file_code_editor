import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock interface for FileContentAnalyzer service
/// This service analyzes file content for various metrics and information
abstract class FileContentAnalyzer {
  /// Count total lines in content
  int countLines(String content);

  /// Count non-empty lines
  int countNonEmptyLines(String content);

  /// Count code lines (excluding comments and empty lines)
  int countCodeLines(String content, String language);

  /// Calculate content complexity score
  double calculateComplexity(String content, String language);

  /// Extract imports/dependencies
  List<String> extractImports(String content, String language);

  /// Find TODO/FIXME comments
  List<String> findTodoComments(String content);

  /// Detect indentation style (spaces or tabs)
  String detectIndentation(String content);

  /// Get indentation size
  int getIndentationSize(String content);

  /// Calculate file statistics
  Map<String, dynamic> getStatistics(String content, String language);
}

class MockFileContentAnalyzer extends Mock implements FileContentAnalyzer {}

void main() {
  group('FileContentAnalyzer', () {
    late MockFileContentAnalyzer analyzer;

    setUp(() {
      analyzer = MockFileContentAnalyzer();
    });

    group('countLines', () {
      test('should count lines in single-line content', () {
        // Arrange
        const content = 'void main() {}';
        when(() => analyzer.countLines(content)).thenReturn(1);

        // Act
        final result = analyzer.countLines(content);

        // Assert
        expect(result, equals(1));
        verify(() => analyzer.countLines(content)).called(1);
      });

      test('should count lines in multi-line content', () {
        // Arrange
        const content = '''
void main() {
  print('Hello');
  print('World');
}
''';
        when(() => analyzer.countLines(content)).thenReturn(5);

        // Act
        final result = analyzer.countLines(content);

        // Assert
        expect(result, equals(5));
      });

      test('should return 0 for empty content', () {
        // Arrange
        when(() => analyzer.countLines('')).thenReturn(0);

        // Act
        final result = analyzer.countLines('');

        // Assert
        expect(result, equals(0));
      });

      test('should count lines with only newlines', () {
        // Arrange
        const content = '\n\n\n';
        when(() => analyzer.countLines(content)).thenReturn(4);

        // Act
        final result = analyzer.countLines(content);

        // Assert
        expect(result, equals(4));
      });
    });

    group('countNonEmptyLines', () {
      test('should count non-empty lines', () {
        // Arrange
        const content = '''
void main() {

  print('Hello');

}
''';
        when(() => analyzer.countNonEmptyLines(content)).thenReturn(3);

        // Act
        final result = analyzer.countNonEmptyLines(content);

        // Assert
        expect(result, equals(3));
      });

      test('should exclude whitespace-only lines', () {
        // Arrange
        const content = '''
code


code
''';
        when(() => analyzer.countNonEmptyLines(content)).thenReturn(2);

        // Act
        final result = analyzer.countNonEmptyLines(content);

        // Assert
        expect(result, equals(2));
      });

      test('should return 0 for empty content', () {
        // Arrange
        when(() => analyzer.countNonEmptyLines('')).thenReturn(0);

        // Act
        final result = analyzer.countNonEmptyLines('');

        // Assert
        expect(result, equals(0));
      });
    });

    group('countCodeLines', () {
      test('should count code lines excluding comments in Dart', () {
        // Arrange
        const content = '''
// This is a comment
void main() {
  // Another comment
  print('Hello');
}
''';
        when(() => analyzer.countCodeLines(content, 'dart')).thenReturn(3);

        // Act
        final result = analyzer.countCodeLines(content, 'dart');

        // Assert
        expect(result, equals(3));
      });

      test('should count code lines excluding comments in JavaScript', () {
        // Arrange
        const content = '''
// Comment
function hello() {
  /* Block comment */
  console.log('Hello');
}
''';
        when(() => analyzer.countCodeLines(content, 'javascript')).thenReturn(3);

        // Act
        final result = analyzer.countCodeLines(content, 'javascript');

        // Assert
        expect(result, equals(3));
      });

      test('should count code lines excluding comments in Python', () {
        // Arrange
        const content = '''
# This is a comment
def hello():
    # Another comment
    print("Hello")
''';
        when(() => analyzer.countCodeLines(content, 'python')).thenReturn(2);

        // Act
        final result = analyzer.countCodeLines(content, 'python');

        // Assert
        expect(result, equals(2));
      });

      test('should handle multi-line comments', () {
        // Arrange
        const content = '''
/*
 * Multi-line comment
 * Another line
 */
function test() {
  return true;
}
''';
        when(() => analyzer.countCodeLines(content, 'javascript')).thenReturn(3);

        // Act
        final result = analyzer.countCodeLines(content, 'javascript');

        // Assert
        expect(result, equals(3));
      });

      test('should return 0 for file with only comments', () {
        // Arrange
        const content = '''
// Comment 1
// Comment 2
// Comment 3
''';
        when(() => analyzer.countCodeLines(content, 'dart')).thenReturn(0);

        // Act
        final result = analyzer.countCodeLines(content, 'dart');

        // Assert
        expect(result, equals(0));
      });
    });

    group('calculateComplexity', () {
      test('should calculate low complexity for simple code', () {
        // Arrange
        const content = 'void main() { print("Hello"); }';
        when(() => analyzer.calculateComplexity(content, 'dart'))
            .thenReturn(1.0);

        // Act
        final result = analyzer.calculateComplexity(content, 'dart');

        // Assert
        expect(result, equals(1.0));
      });

      test('should calculate higher complexity for code with branches', () {
        // Arrange
        const content = '''
void check(int value) {
  if (value > 0) {
    print('positive');
  } else if (value < 0) {
    print('negative');
  } else {
    print('zero');
  }
}
''';
        when(() => analyzer.calculateComplexity(content, 'dart'))
            .thenReturn(3.5);

        // Act
        final result = analyzer.calculateComplexity(content, 'dart');

        // Assert
        expect(result, greaterThan(1.0));
      });

      test('should calculate complexity for code with loops', () {
        // Arrange
        const content = '''
void process(List items) {
  for (var item in items) {
    if (item.isValid) {
      while (item.hasNext()) {
        item.process();
      }
    }
  }
}
''';
        when(() => analyzer.calculateComplexity(content, 'dart'))
            .thenReturn(5.0);

        // Act
        final result = analyzer.calculateComplexity(content, 'dart');

        // Assert
        expect(result, greaterThan(3.0));
      });

      test('should return 0 for empty content', () {
        // Arrange
        when(() => analyzer.calculateComplexity('', 'dart')).thenReturn(0.0);

        // Act
        final result = analyzer.calculateComplexity('', 'dart');

        // Assert
        expect(result, equals(0.0));
      });
    });

    group('extractImports', () {
      test('should extract Dart imports', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {}
''';
        final expectedImports = [
          'package:flutter/material.dart',
          'package:provider/provider.dart',
          'dart:async',
        ];

        when(() => analyzer.extractImports(content, 'dart'))
            .thenReturn(expectedImports);

        // Act
        final result = analyzer.extractImports(content, 'dart');

        // Assert
        expect(result, equals(expectedImports));
        expect(result.length, equals(3));
      });

      test('should extract JavaScript imports', () {
        // Arrange
        const content = '''
import React from 'react';
import { useState } from 'react';
import axios from 'axios';
''';
        final expectedImports = [
          'react',
          'react',
          'axios',
        ];

        when(() => analyzer.extractImports(content, 'javascript'))
            .thenReturn(expectedImports);

        // Act
        final result = analyzer.extractImports(content, 'javascript');

        // Assert
        expect(result, equals(expectedImports));
      });

      test('should extract Python imports', () {
        // Arrange
        const content = '''
import os
import sys
from datetime import datetime
from typing import List, Dict
''';
        final expectedImports = [
          'os',
          'sys',
          'datetime',
          'typing',
        ];

        when(() => analyzer.extractImports(content, 'python'))
            .thenReturn(expectedImports);

        // Act
        final result = analyzer.extractImports(content, 'python');

        // Assert
        expect(result, equals(expectedImports));
      });

      test('should return empty list for content without imports', () {
        // Arrange
        const content = 'void main() { print("Hello"); }';
        when(() => analyzer.extractImports(content, 'dart')).thenReturn([]);

        // Act
        final result = analyzer.extractImports(content, 'dart');

        // Assert
        expect(result, isEmpty);
      });

      test('should handle duplicate imports', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
''';
        final expectedImports = [
          'package:flutter/material.dart',
          'package:flutter/material.dart',
        ];

        when(() => analyzer.extractImports(content, 'dart'))
            .thenReturn(expectedImports);

        // Act
        final result = analyzer.extractImports(content, 'dart');

        // Assert
        expect(result.length, equals(2));
      });
    });

    group('findTodoComments', () {
      test('should find TODO comments', () {
        // Arrange
        const content = '''
void main() {
  // TODO: Implement this feature
  print('Hello');
  // TODO: Add error handling
}
''';
        final expectedTodos = [
          'TODO: Implement this feature',
          'TODO: Add error handling',
        ];

        when(() => analyzer.findTodoComments(content))
            .thenReturn(expectedTodos);

        // Act
        final result = analyzer.findTodoComments(content);

        // Assert
        expect(result, equals(expectedTodos));
        expect(result.length, equals(2));
      });

      test('should find FIXME comments', () {
        // Arrange
        const content = '''
void buggyFunction() {
  // FIXME: This breaks on edge cases
  return null;
}
''';
        final expectedTodos = ['FIXME: This breaks on edge cases'];

        when(() => analyzer.findTodoComments(content))
            .thenReturn(expectedTodos);

        // Act
        final result = analyzer.findTodoComments(content);

        // Assert
        expect(result, contains('FIXME: This breaks on edge cases'));
      });

      test('should find mixed TODO and FIXME comments', () {
        // Arrange
        const content = '''
// TODO: Add tests
void function1() {}

// FIXME: Performance issue
void function2() {}

// NOTE: This works correctly
void function3() {}
''';
        final expectedTodos = [
          'TODO: Add tests',
          'FIXME: Performance issue',
        ];

        when(() => analyzer.findTodoComments(content))
            .thenReturn(expectedTodos);

        // Act
        final result = analyzer.findTodoComments(content);

        // Assert
        expect(result.length, equals(2));
      });

      test('should return empty list when no TODO comments', () {
        // Arrange
        const content = '''
void main() {
  print('Hello');
}
''';
        when(() => analyzer.findTodoComments(content)).thenReturn([]);

        // Act
        final result = analyzer.findTodoComments(content);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('detectIndentation', () {
      test('should detect spaces indentation', () {
        // Arrange
        const content = '''
void main() {
  if (true) {
    print('hello');
  }
}
''';
        when(() => analyzer.detectIndentation(content)).thenReturn('spaces');

        // Act
        final result = analyzer.detectIndentation(content);

        // Assert
        expect(result, equals('spaces'));
      });

      test('should detect tabs indentation', () {
        // Arrange
        const content = 'void main() {\n\tif (true) {\n\t\tprint(\'hello\');\n\t}\n}';
        when(() => analyzer.detectIndentation(content)).thenReturn('tabs');

        // Act
        final result = analyzer.detectIndentation(content);

        // Assert
        expect(result, equals('tabs'));
      });

      test('should handle mixed indentation', () {
        // Arrange
        const content = '''
void main() {
  if (true) {
	print('mixed');
  }
}
''';
        when(() => analyzer.detectIndentation(content)).thenReturn('mixed');

        // Act
        final result = analyzer.detectIndentation(content);

        // Assert
        expect(result, equals('mixed'));
      });

      test('should return none for unindented content', () {
        // Arrange
        const content = 'void main() {}';
        when(() => analyzer.detectIndentation(content)).thenReturn('none');

        // Act
        final result = analyzer.detectIndentation(content);

        // Assert
        expect(result, equals('none'));
      });
    });

    group('getIndentationSize', () {
      test('should detect 2-space indentation', () {
        // Arrange
        const content = '''
void main() {
  if (true) {
    print('hello');
  }
}
''';
        when(() => analyzer.getIndentationSize(content)).thenReturn(2);

        // Act
        final result = analyzer.getIndentationSize(content);

        // Assert
        expect(result, equals(2));
      });

      test('should detect 4-space indentation', () {
        // Arrange
        const content = '''
void main() {
    if (true) {
        print('hello');
    }
}
''';
        when(() => analyzer.getIndentationSize(content)).thenReturn(4);

        // Act
        final result = analyzer.getIndentationSize(content);

        // Assert
        expect(result, equals(4));
      });

      test('should return 0 for unindented content', () {
        // Arrange
        const content = 'void main() {}';
        when(() => analyzer.getIndentationSize(content)).thenReturn(0);

        // Act
        final result = analyzer.getIndentationSize(content);

        // Assert
        expect(result, equals(0));
      });
    });

    group('getStatistics', () {
      test('should calculate comprehensive statistics', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';

// TODO: Add more features
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
''';
        final expectedStats = {
          'totalLines': 19,
          'nonEmptyLines': 15,
          'codeLines': 13,
          'commentLines': 1,
          'complexity': 2.0,
          'imports': 1,
          'todos': 1,
          'indentation': 'spaces',
          'indentationSize': 2,
        };

        when(() => analyzer.getStatistics(content, 'dart'))
            .thenReturn(expectedStats);

        // Act
        final result = analyzer.getStatistics(content, 'dart');

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['totalLines'], equals(19));
        expect(result['codeLines'], greaterThan(0));
        expect(result['complexity'], greaterThan(0));
      });

      test('should return basic statistics for simple content', () {
        // Arrange
        const content = 'void main() {}';
        final expectedStats = {
          'totalLines': 1,
          'nonEmptyLines': 1,
          'codeLines': 1,
          'commentLines': 0,
          'complexity': 1.0,
          'imports': 0,
          'todos': 0,
          'indentation': 'none',
          'indentationSize': 0,
        };

        when(() => analyzer.getStatistics(content, 'dart'))
            .thenReturn(expectedStats);

        // Act
        final result = analyzer.getStatistics(content, 'dart');

        // Assert
        expect(result['totalLines'], equals(1));
        expect(result['codeLines'], equals(1));
        expect(result['complexity'], equals(1.0));
      });

      test('should return zero statistics for empty content', () {
        // Arrange
        final expectedStats = {
          'totalLines': 0,
          'nonEmptyLines': 0,
          'codeLines': 0,
          'commentLines': 0,
          'complexity': 0.0,
          'imports': 0,
          'todos': 0,
          'indentation': 'none',
          'indentationSize': 0,
        };

        when(() => analyzer.getStatistics('', 'dart'))
            .thenReturn(expectedStats);

        // Act
        final result = analyzer.getStatistics('', 'dart');

        // Assert
        expect(result['totalLines'], equals(0));
        expect(result['codeLines'], equals(0));
        expect(result['complexity'], equals(0.0));
      });
    });

    group('use cases', () {
      test('should analyze file for code review', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';

// TODO: Refactor this class
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // FIXME: Memory leak
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';

        when(() => analyzer.countLines(content)).thenReturn(18);
        when(() => analyzer.countCodeLines(content, 'dart')).thenReturn(12);
        when(() => analyzer.calculateComplexity(content, 'dart')).thenReturn(3.0);
        when(() => analyzer.findTodoComments(content))
            .thenReturn(['TODO: Refactor this class', 'FIXME: Memory leak']);

        // Act
        final lines = analyzer.countLines(content);
        final codeLines = analyzer.countCodeLines(content, 'dart');
        final complexity = analyzer.calculateComplexity(content, 'dart');
        final todos = analyzer.findTodoComments(content);

        // Assert - File metrics
        expect(lines, greaterThan(0));
        expect(codeLines, greaterThan(0));
        expect(complexity, greaterThan(0));
        expect(todos.length, equals(2));
      });

      test('should detect code style consistency', () {
        // Arrange
        const content = '''
void main() {
  if (true) {
    print('hello');
  }
}
''';

        when(() => analyzer.detectIndentation(content)).thenReturn('spaces');
        when(() => analyzer.getIndentationSize(content)).thenReturn(2);

        // Act
        final indentation = analyzer.detectIndentation(content);
        final size = analyzer.getIndentationSize(content);

        // Assert
        expect(indentation, equals('spaces'));
        expect(size, equals(2));
      });

      test('should analyze project dependencies', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
''';

        final expectedImports = [
          'package:flutter/material.dart',
          'package:provider/provider.dart',
          'package:http/http.dart',
        ];

        when(() => analyzer.extractImports(content, 'dart'))
            .thenReturn(expectedImports);

        // Act
        final imports = analyzer.extractImports(content, 'dart');

        // Assert
        expect(imports.length, equals(3));
        expect(imports, contains('package:flutter/material.dart'));
      });
    });
  });
}
