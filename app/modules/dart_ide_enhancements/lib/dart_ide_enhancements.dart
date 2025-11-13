/// Dart-specific IDE enhancements.
///
/// This module provides Dart and Flutter-specific tools and commands
/// that integrate with the IDE:
///
/// - **Pub Commands**: pub get, upgrade, outdated, add, remove
/// - **Code Tools**: analyze, format
/// - **SDK Info**: Dart/Flutter version information
///
/// ## Architecture
///
/// This is an **Application Layer** module that:
/// - Works WITH existing editor_core and lsp_domain
/// - Provides language-specific workflows
/// - No native code (pure Dart)
/// - Follows Clean Architecture principles
///
/// ## Usage
///
/// ```dart
/// import 'package:dart_ide_enhancements/dart_ide_enhancements.dart';
///
/// // Use pub commands
/// final pubCommands = PubCommands(projectRoot: '/path/to/project');
/// final result = await pubCommands.pubGet();
///
/// // Use UI panel
/// PubCommandsPanel(
///   projectRoot: '/path/to/project',
///   isFlutterProject: true,
/// )
/// ```
library dart_ide_enhancements;

// Commands
export 'src/commands/pub_commands.dart';

// Widgets
export 'src/widgets/pub_commands_panel.dart';
