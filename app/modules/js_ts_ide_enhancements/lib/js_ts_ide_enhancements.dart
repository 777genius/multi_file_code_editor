/// JavaScript/TypeScript-specific IDE enhancements.
///
/// This module provides JavaScript and TypeScript-specific tools and commands
/// that integrate with the IDE:
///
/// - **Package Management**: npm, yarn, pnpm support
/// - **Commands**: install, add, remove, update, outdated
/// - **Script Runner**: Run package.json scripts
/// - **SDK Info**: Node.js and package manager versions
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
/// import 'package:js_ts_ide_enhancements/js_ts_ide_enhancements.dart';
///
/// // Use npm commands
/// final npmCommands = NpmCommands(
///   projectRoot: '/path/to/project',
///   packageManager: PackageManager.npm,
/// );
///
/// // Auto-detect package manager
/// final detected = await npmCommands.detectPackageManager();
/// npmCommands.setPackageManager(detected);
///
/// // Install packages
/// final result = await npmCommands.install();
///
/// // Run script
/// await npmCommands.runScript(scriptName: 'build');
///
/// // Use UI panel
/// NpmCommandsPanel(
///   projectRoot: '/path/to/project',
/// )
/// ```
library js_ts_ide_enhancements;

// Commands
export 'src/commands/npm_commands.dart';

// Widgets
export 'src/widgets/npm_commands_panel.dart';
