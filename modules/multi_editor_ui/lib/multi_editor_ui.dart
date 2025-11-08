/// UI components for Multi-File Code Editor including Monaco Editor integration.
///
/// This package provides ready-to-use Flutter widgets for building code editing
/// experiences with file trees, editor scaffolds, and plugin UI integration.
///
/// ## Features
///
/// * **Monaco Editor Widget**: Cross-platform code editor with syntax highlighting
/// * **File Tree View**: Hierarchical file browser with drag-and-drop
/// * **Editor Scaffold**: Complete editor layout with header and panels
/// * **Theme Support**: Dark/light themes with dynamic switching
/// * **Plugin UI**: Integration points for plugin-contributed UI
///
/// ## Example
///
/// ```dart
/// import 'package:multi_editor_ui/multi_editor_ui.dart';
///
/// EditorScaffold(
///   fileTree: FileTreeView(controller: fileTreeController),
///   editor: MonacoCodeEditor(controller: editorController),
/// )
/// ```
library;

export 'src/state/editor_state.dart';
export 'src/state/file_tree_state.dart';

export 'src/controllers/editor_controller.dart';
export 'src/controllers/file_tree_controller.dart';

export 'src/widgets/code_editor/monaco_code_editor.dart';
export 'src/widgets/code_editor/editor_config.dart';

export 'src/widgets/file_tree/file_tree_view.dart';

export 'src/widgets/dialogs/create_file_dialog.dart';
export 'src/widgets/dialogs/create_folder_dialog.dart';
export 'src/widgets/dialogs/rename_dialog.dart';
export 'src/widgets/dialogs/confirm_delete_dialog.dart';

export 'src/widgets/scaffold/editor_scaffold.dart';

export 'src/theme/app_theme.dart';
