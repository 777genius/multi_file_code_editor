import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock interface for SearchService
/// This service provides advanced search capabilities across files and content
abstract class SearchService {
  /// Search for files by name pattern
  Future<List<SearchResult>> searchFilesByName(String pattern, {
    String? folderId,
    bool caseSensitive = false,
    bool useRegex = false,
  });

  /// Search for content in files
  Future<List<SearchResult>> searchInContent(String query, {
    String? folderId,
    String? language,
    bool caseSensitive = false,
    bool wholeWord = false,
    bool useRegex = false,
  });

  /// Search and replace in files
  Future<int> searchAndReplace(String query, String replacement, {
    String? folderId,
    String? language,
    bool caseSensitive = false,
    bool wholeWord = false,
  });

  /// Find references to a symbol
  Future<List<SearchResult>> findReferences(String symbol, {
    String? language,
  });

  /// Find usages of a file
  Future<List<SearchResult>> findFileUsages(String fileId);

  /// Search by file extension
  Future<List<SearchResult>> searchByExtension(String extension, {
    String? folderId,
  });

  /// Advanced search with multiple criteria
  Future<List<SearchResult>> advancedSearch(SearchCriteria criteria);
}

/// Search result model
class SearchResult {
  final String fileId;
  final String fileName;
  final String filePath;
  final int? lineNumber;
  final int? columnNumber;
  final String? matchedText;
  final String? contextBefore;
  final String? contextAfter;

  const SearchResult({
    required this.fileId,
    required this.fileName,
    required this.filePath,
    this.lineNumber,
    this.columnNumber,
    this.matchedText,
    this.contextBefore,
    this.contextAfter,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          fileId == other.fileId &&
          fileName == other.fileName &&
          filePath == other.filePath &&
          lineNumber == other.lineNumber &&
          columnNumber == other.columnNumber &&
          matchedText == other.matchedText;

  @override
  int get hashCode => Object.hash(
        fileId,
        fileName,
        filePath,
        lineNumber,
        columnNumber,
        matchedText,
      );
}

/// Search criteria for advanced search
class SearchCriteria {
  final String? namePattern;
  final String? contentQuery;
  final String? folderId;
  final String? language;
  final String? extension;
  final bool caseSensitive;
  final bool wholeWord;
  final bool useRegex;
  final DateTime? modifiedAfter;
  final DateTime? modifiedBefore;
  final int? minSize;
  final int? maxSize;

  const SearchCriteria({
    this.namePattern,
    this.contentQuery,
    this.folderId,
    this.language,
    this.extension,
    this.caseSensitive = false,
    this.wholeWord = false,
    this.useRegex = false,
    this.modifiedAfter,
    this.modifiedBefore,
    this.minSize,
    this.maxSize,
  });
}

class MockSearchService extends Mock implements SearchService {}

void main() {
  group('SearchService', () {
    late MockSearchService service;

    setUp(() {
      service = MockSearchService();
    });

    group('searchFilesByName', () {
      test('should search files by exact name', () async {
        // Arrange
        const pattern = 'main.dart';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
          ),
        ];

        when(() => service.searchFilesByName(pattern))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchFilesByName(pattern);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, equals('main.dart'));
        verify(() => service.searchFilesByName(pattern)).called(1);
      });

      test('should search files with wildcard pattern', () async {
        // Arrange
        const pattern = '*.dart';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
          ),
          SearchResult(
            fileId: 'file-2',
            fileName: 'app.dart',
            filePath: '/src/app.dart',
          ),
        ];

        when(() => service.searchFilesByName(pattern))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchFilesByName(pattern);

        // Assert
        expect(results.length, equals(2));
        expect(results.every((r) => r.fileName.endsWith('.dart')), isTrue);
      });

      test('should search files with regex pattern', () async {
        // Arrange
        const pattern = r'test_.*\.dart$';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'test_main.dart',
            filePath: '/test/test_main.dart',
          ),
          SearchResult(
            fileId: 'file-2',
            fileName: 'test_app.dart',
            filePath: '/test/test_app.dart',
          ),
        ];

        when(() => service.searchFilesByName(pattern, useRegex: true))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchFilesByName(pattern, useRegex: true);

        // Assert
        expect(results.length, equals(2));
        expect(results[0].fileName, startsWith('test_'));
      });

      test('should search files in specific folder', () async {
        // Arrange
        const pattern = '*.json';
        const folderId = 'config-folder';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'config.json',
            filePath: '/config/config.json',
          ),
        ];

        when(() => service.searchFilesByName(pattern, folderId: folderId))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchFilesByName(pattern, folderId: folderId);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, equals('config.json'));
      });

      test('should perform case-sensitive search', () async {
        // Arrange
        const pattern = 'Main.dart';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'Main.dart',
            filePath: '/src/Main.dart',
          ),
        ];

        when(() => service.searchFilesByName(pattern, caseSensitive: true))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchFilesByName(pattern, caseSensitive: true);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, equals('Main.dart'));
      });

      test('should return empty list when no matches found', () async {
        // Arrange
        const pattern = 'nonexistent.file';

        when(() => service.searchFilesByName(pattern))
            .thenAnswer((_) async => []);

        // Act
        final results = await service.searchFilesByName(pattern);

        // Assert
        expect(results, isEmpty);
      });
    });

    group('searchInContent', () {
      test('should search for text in file content', () async {
        // Arrange
        const query = 'TODO';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
            lineNumber: 10,
            columnNumber: 5,
            matchedText: 'TODO: Implement feature',
            contextBefore: '  // ',
            contextAfter: '\n  void feature() {',
          ),
        ];

        when(() => service.searchInContent(query))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].matchedText, contains('TODO'));
        expect(results[0].lineNumber, equals(10));
        verify(() => service.searchInContent(query)).called(1);
      });

      test('should search with case sensitivity', () async {
        // Arrange
        const query = 'Error';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'app.dart',
            filePath: '/src/app.dart',
            lineNumber: 5,
            matchedText: 'Error',
          ),
        ];

        when(() => service.searchInContent(query, caseSensitive: true))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query, caseSensitive: true);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].matchedText, equals('Error'));
      });

      test('should search for whole word only', () async {
        // Arrange
        const query = 'test';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'test.dart',
            filePath: '/test/test.dart',
            lineNumber: 1,
            matchedText: 'test',
          ),
        ];

        when(() => service.searchInContent(query, wholeWord: true))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query, wholeWord: true);

        // Assert
        expect(results.length, equals(1));
      });

      test('should search with regex pattern', () async {
        // Arrange
        const query = r'function\s+\w+\(';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'utils.js',
            filePath: '/src/utils.js',
            lineNumber: 3,
            matchedText: 'function hello(',
          ),
        ];

        when(() => service.searchInContent(query, useRegex: true))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query, useRegex: true);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].matchedText, contains('function'));
      });

      test('should search in specific language files only', () async {
        // Arrange
        const query = 'import';
        const language = 'dart';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
            lineNumber: 1,
            matchedText: "import 'package:flutter/material.dart';",
          ),
        ];

        when(() => service.searchInContent(query, language: language))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query, language: language);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, endsWith('.dart'));
      });

      test('should return multiple matches from same file', () async {
        // Arrange
        const query = 'print';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'debug.dart',
            filePath: '/src/debug.dart',
            lineNumber: 5,
            matchedText: "print('Debug 1');",
          ),
          SearchResult(
            fileId: 'file-1',
            fileName: 'debug.dart',
            filePath: '/src/debug.dart',
            lineNumber: 10,
            matchedText: "print('Debug 2');",
          ),
        ];

        when(() => service.searchInContent(query))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query);

        // Assert
        expect(results.length, equals(2));
        expect(results[0].fileId, equals(results[1].fileId));
      });
    });

    group('searchAndReplace', () {
      test('should replace all occurrences', () async {
        // Arrange
        const query = 'oldName';
        const replacement = 'newName';

        when(() => service.searchAndReplace(query, replacement))
            .thenAnswer((_) async => 5);

        // Act
        final count = await service.searchAndReplace(query, replacement);

        // Assert
        expect(count, equals(5));
        verify(() => service.searchAndReplace(query, replacement)).called(1);
      });

      test('should replace with case sensitivity', () async {
        // Arrange
        const query = 'Error';
        const replacement = 'Exception';

        when(() => service.searchAndReplace(
              query,
              replacement,
              caseSensitive: true,
            )).thenAnswer((_) async => 3);

        // Act
        final count = await service.searchAndReplace(
          query,
          replacement,
          caseSensitive: true,
        );

        // Assert
        expect(count, equals(3));
      });

      test('should replace whole words only', () async {
        // Arrange
        const query = 'test';
        const replacement = 'spec';

        when(() => service.searchAndReplace(
              query,
              replacement,
              wholeWord: true,
            )).thenAnswer((_) async => 2);

        // Act
        final count = await service.searchAndReplace(
          query,
          replacement,
          wholeWord: true,
        );

        // Assert
        expect(count, equals(2));
      });

      test('should replace in specific folder only', () async {
        // Arrange
        const query = 'deprecated';
        const replacement = 'updated';
        const folderId = 'src-folder';

        when(() => service.searchAndReplace(
              query,
              replacement,
              folderId: folderId,
            )).thenAnswer((_) async => 7);

        // Act
        final count = await service.searchAndReplace(
          query,
          replacement,
          folderId: folderId,
        );

        // Assert
        expect(count, equals(7));
      });

      test('should return 0 when no matches found', () async {
        // Arrange
        const query = 'nonexistent';
        const replacement = 'something';

        when(() => service.searchAndReplace(query, replacement))
            .thenAnswer((_) async => 0);

        // Act
        final count = await service.searchAndReplace(query, replacement);

        // Assert
        expect(count, equals(0));
      });
    });

    group('findReferences', () {
      test('should find references to a symbol', () async {
        // Arrange
        const symbol = 'MyClass';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
            lineNumber: 10,
            matchedText: 'MyClass instance = MyClass();',
          ),
          SearchResult(
            fileId: 'file-2',
            fileName: 'test.dart',
            filePath: '/test/test.dart',
            lineNumber: 5,
            matchedText: 'expect(myClass, isA<MyClass>());',
          ),
        ];

        when(() => service.findReferences(symbol))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.findReferences(symbol);

        // Assert
        expect(results.length, equals(2));
        expect(results.every((r) => r.matchedText!.contains(symbol)), isTrue);
        verify(() => service.findReferences(symbol)).called(1);
      });

      test('should find references in specific language', () async {
        // Arrange
        const symbol = 'useState';
        const language = 'javascript';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'App.js',
            filePath: '/src/App.js',
            lineNumber: 5,
            matchedText: 'const [state, setState] = useState(0);',
          ),
        ];

        when(() => service.findReferences(symbol, language: language))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.findReferences(symbol, language: language);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, endsWith('.js'));
      });

      test('should return empty list when no references found', () async {
        // Arrange
        const symbol = 'UnusedClass';

        when(() => service.findReferences(symbol))
            .thenAnswer((_) async => []);

        // Act
        final results = await service.findReferences(symbol);

        // Assert
        expect(results, isEmpty);
      });
    });

    group('findFileUsages', () {
      test('should find usages of a file', () async {
        // Arrange
        const fileId = 'utils-file';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
            lineNumber: 1,
            matchedText: "import 'utils.dart';",
          ),
          SearchResult(
            fileId: 'file-2',
            fileName: 'app.dart',
            filePath: '/src/app.dart',
            lineNumber: 2,
            matchedText: "import 'utils.dart';",
          ),
        ];

        when(() => service.findFileUsages(fileId))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.findFileUsages(fileId);

        // Assert
        expect(results.length, equals(2));
        expect(results.every((r) => r.matchedText!.contains('utils')), isTrue);
        verify(() => service.findFileUsages(fileId)).called(1);
      });

      test('should return empty list when file not used', () async {
        // Arrange
        const fileId = 'unused-file';

        when(() => service.findFileUsages(fileId))
            .thenAnswer((_) async => []);

        // Act
        final results = await service.findFileUsages(fileId);

        // Assert
        expect(results, isEmpty);
      });
    });

    group('searchByExtension', () {
      test('should search files by extension', () async {
        // Arrange
        const extension = 'dart';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
          ),
          SearchResult(
            fileId: 'file-2',
            fileName: 'app.dart',
            filePath: '/src/app.dart',
          ),
        ];

        when(() => service.searchByExtension(extension))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchByExtension(extension);

        // Assert
        expect(results.length, equals(2));
        expect(results.every((r) => r.fileName.endsWith('.dart')), isTrue);
        verify(() => service.searchByExtension(extension)).called(1);
      });

      test('should search by extension in specific folder', () async {
        // Arrange
        const extension = 'json';
        const folderId = 'config-folder';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'config.json',
            filePath: '/config/config.json',
          ),
        ];

        when(() => service.searchByExtension(extension, folderId: folderId))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchByExtension(extension, folderId: folderId);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, endsWith('.json'));
      });
    });

    group('advancedSearch', () {
      test('should search with multiple criteria', () async {
        // Arrange
        final criteria = SearchCriteria(
          namePattern: '*.dart',
          contentQuery: 'TODO',
          language: 'dart',
          caseSensitive: false,
        );

        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
            lineNumber: 5,
            matchedText: '// TODO: Implement',
          ),
        ];

        when(() => service.advancedSearch(criteria))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.advancedSearch(criteria);

        // Assert
        expect(results.length, equals(1));
        expect(results[0].fileName, endsWith('.dart'));
        expect(results[0].matchedText, contains('TODO'));
      });

      test('should search with date filters', () async {
        // Arrange
        final now = DateTime.now();
        final criteria = SearchCriteria(
          modifiedAfter: now.subtract(const Duration(days: 7)),
          modifiedBefore: now,
        );

        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'recent.dart',
            filePath: '/src/recent.dart',
          ),
        ];

        when(() => service.advancedSearch(criteria))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.advancedSearch(criteria);

        // Assert
        expect(results.length, equals(1));
      });

      test('should search with size filters', () async {
        // Arrange
        final criteria = SearchCriteria(
          minSize: 1024, // 1KB
          maxSize: 10240, // 10KB
        );

        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'medium.dart',
            filePath: '/src/medium.dart',
          ),
        ];

        when(() => service.advancedSearch(criteria))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.advancedSearch(criteria);

        // Assert
        expect(results.length, equals(1));
      });

      test('should return empty list when criteria not met', () async {
        // Arrange
        final criteria = SearchCriteria(
          namePattern: 'nonexistent*',
          contentQuery: 'impossible_match_123456',
        );

        when(() => service.advancedSearch(criteria))
            .thenAnswer((_) async => []);

        // Act
        final results = await service.advancedSearch(criteria);

        // Assert
        expect(results, isEmpty);
      });
    });

    group('use cases', () {
      test('should perform refactoring search', () async {
        // Arrange
        const oldName = 'oldClassName';
        const newName = 'newClassName';

        when(() => service.findReferences(oldName))
            .thenAnswer((_) async => [
                  SearchResult(
                    fileId: 'file-1',
                    fileName: 'main.dart',
                    filePath: '/src/main.dart',
                    lineNumber: 10,
                    matchedText: 'oldClassName instance;',
                  ),
                ]);

        when(() => service.searchAndReplace(oldName, newName))
            .thenAnswer((_) async => 1);

        // Act - Find all references
        final references = await service.findReferences(oldName);

        // Assert - References found
        expect(references.length, equals(1));

        // Act - Replace all
        final count = await service.searchAndReplace(oldName, newName);

        // Assert - All replaced
        expect(count, equals(1));
      });

      test('should find TODO comments across project', () async {
        // Arrange
        const query = 'TODO';
        final expectedResults = [
          SearchResult(
            fileId: 'file-1',
            fileName: 'main.dart',
            filePath: '/src/main.dart',
            lineNumber: 5,
            matchedText: '// TODO: Feature A',
          ),
          SearchResult(
            fileId: 'file-2',
            fileName: 'app.dart',
            filePath: '/src/app.dart',
            lineNumber: 15,
            matchedText: '// TODO: Feature B',
          ),
        ];

        when(() => service.searchInContent(query))
            .thenAnswer((_) async => expectedResults);

        // Act
        final results = await service.searchInContent(query);

        // Assert
        expect(results.length, equals(2));
        expect(results.every((r) => r.matchedText!.contains('TODO')), isTrue);
      });

      test('should analyze project structure', () async {
        // Arrange
        const dartExtension = 'dart';
        const jsExtension = 'js';

        when(() => service.searchByExtension(dartExtension))
            .thenAnswer((_) async => List.filled(10, SearchResult(
                  fileId: 'file',
                  fileName: 'file.dart',
                  filePath: '/src/file.dart',
                )));

        when(() => service.searchByExtension(jsExtension))
            .thenAnswer((_) async => List.filled(5, SearchResult(
                  fileId: 'file',
                  fileName: 'file.js',
                  filePath: '/src/file.js',
                )));

        // Act
        final dartFiles = await service.searchByExtension(dartExtension);
        final jsFiles = await service.searchByExtension(jsExtension);

        // Assert - Project composition
        expect(dartFiles.length, equals(10));
        expect(jsFiles.length, equals(5));
      });
    });
  });
}
