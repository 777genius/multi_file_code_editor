import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;

/// Commands for managing Dart pub packages.
///
/// Provides IDE integration for common pub commands:
/// - pub get
/// - pub upgrade
/// - pub outdated
/// - pub add/remove packages
///
/// This is a pure Dart implementation that executes pub commands
/// and parses their output.
class PubCommands {
  final String _projectRoot;

  PubCommands({required String projectRoot}) : _projectRoot = projectRoot;

  /// Gets the path to pubspec.yaml
  String get pubspecPath => path.join(_projectRoot, 'pubspec.yaml');

  /// Checks if this is a valid Dart/Flutter project
  Future<bool> isValidDartProject() async {
    final pubspecFile = File(pubspecPath);
    return await pubspecFile.exists();
  }

  /// Executes 'dart pub get' or 'flutter pub get'
  ///
  /// Returns:
  /// - Right(output) on success
  /// - Left(error) on failure
  Future<Either<String, String>> pubGet({bool useFlutter = false}) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final command = useFlutter ? 'flutter' : 'dart';
      final result = await Process.run(
        command,
        ['pub', 'get'],
        workingDirectory: _projectRoot,
      );

      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left(result.stderr.toString());
      }
    } catch (e) {
      return left('Failed to execute pub get: $e');
    }
  }

  /// Executes 'dart pub upgrade' or 'flutter pub upgrade'
  ///
  /// Returns:
  /// - Right(output) on success
  /// - Left(error) on failure
  Future<Either<String, String>> pubUpgrade({
    bool useFlutter = false,
  }) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final command = useFlutter ? 'flutter' : 'dart';
      final result = await Process.run(
        command,
        ['pub', 'upgrade'],
        workingDirectory: _projectRoot,
      );

      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left(result.stderr.toString());
      }
    } catch (e) {
      return left('Failed to execute pub upgrade: $e');
    }
  }

  /// Executes 'dart pub outdated'
  ///
  /// Returns:
  /// - Right(output) on success (list of outdated packages)
  /// - Left(error) on failure
  Future<Either<String, String>> pubOutdated({
    bool useFlutter = false,
  }) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final command = useFlutter ? 'flutter' : 'dart';
      final result = await Process.run(
        command,
        ['pub', 'outdated', '--json'],
        workingDirectory: _projectRoot,
      );

      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left(result.stderr.toString());
      }
    } catch (e) {
      return left('Failed to execute pub outdated: $e');
    }
  }

  /// Adds a package using 'dart pub add'
  ///
  /// Parameters:
  /// - [packageName]: Name of the package to add
  /// - [version]: Optional version constraint
  /// - [isDev]: Add as dev dependency
  /// - [useFlutter]: Use flutter pub instead of dart pub
  ///
  /// Returns:
  /// - Right(output) on success
  /// - Left(error) on failure
  Future<Either<String, String>> addPackage({
    required String packageName,
    String? version,
    bool isDev = false,
    bool useFlutter = false,
  }) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final command = useFlutter ? 'flutter' : 'dart';
      final args = ['pub', 'add'];

      if (isDev) {
        args.add('--dev');
      }

      final packageSpec = version != null ? '$packageName:$version' : packageName;
      args.add(packageSpec);

      final result = await Process.run(
        command,
        args,
        workingDirectory: _projectRoot,
      );

      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left(result.stderr.toString());
      }
    } catch (e) {
      return left('Failed to add package: $e');
    }
  }

  /// Removes a package using 'dart pub remove'
  ///
  /// Parameters:
  /// - [packageName]: Name of the package to remove
  /// - [useFlutter]: Use flutter pub instead of dart pub
  ///
  /// Returns:
  /// - Right(output) on success
  /// - Left(error) on failure
  Future<Either<String, String>> removePackage({
    required String packageName,
    bool useFlutter = false,
  }) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final command = useFlutter ? 'flutter' : 'dart';
      final result = await Process.run(
        command,
        ['pub', 'remove', packageName],
        workingDirectory: _projectRoot,
      );

      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left(result.stderr.toString());
      }
    } catch (e) {
      return left('Failed to remove package: $e');
    }
  }

  /// Runs 'dart analyze' or 'flutter analyze'
  ///
  /// Returns:
  /// - Right(output) on success
  /// - Left(error) on failure
  Future<Either<String, String>> analyze({bool useFlutter = false}) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final command = useFlutter ? 'flutter' : 'dart';
      final result = await Process.run(
        command,
        ['analyze'],
        workingDirectory: _projectRoot,
      );

      // Note: analyze returns 0 even with warnings
      return right(result.stdout.toString());
    } catch (e) {
      return left('Failed to run analyze: $e');
    }
  }

  /// Runs 'dart format' on the project
  ///
  /// Parameters:
  /// - [fix]: Apply fixes
  ///
  /// Returns:
  /// - Right(output) on success
  /// - Left(error) on failure
  Future<Either<String, String>> format({bool fix = false}) async {
    if (!await isValidDartProject()) {
      return left('Not a valid Dart/Flutter project');
    }

    try {
      final args = ['format'];
      if (fix) {
        args.add('--fix');
      }
      args.add('.');

      final result = await Process.run(
        'dart',
        args,
        workingDirectory: _projectRoot,
      );

      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left(result.stderr.toString());
      }
    } catch (e) {
      return left('Failed to format code: $e');
    }
  }

  /// Gets Dart SDK version
  ///
  /// Returns:
  /// - Right(version) on success
  /// - Left(error) on failure
  Future<Either<String, String>> getDartVersion() async {
    try {
      final result = await Process.run('dart', ['--version']);
      return right(result.stderr.toString()); // dart --version outputs to stderr
    } catch (e) {
      return left('Failed to get Dart version: $e');
    }
  }

  /// Gets Flutter SDK version (if available)
  ///
  /// Returns:
  /// - Right(version) on success
  /// - Left(error) on failure
  Future<Either<String, String>> getFlutterVersion() async {
    try {
      final result = await Process.run('flutter', ['--version']);
      if (result.exitCode == 0) {
        return right(result.stdout.toString());
      } else {
        return left('Flutter not available');
      }
    } catch (e) {
      return left('Flutter not available: $e');
    }
  }
}
