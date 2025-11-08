/// IDE Presentation Layer
///
/// This package provides UI widgets, BLoCs, and screens for the IDE.
/// It is the outermost layer in Clean Architecture and coordinates user interactions.
///
/// Architecture Layer: Presentation
/// - Depends on: lsp_application (Application), editor_core (Domain), lsp_domain (Domain)
/// - Used by: Main app
/// - Independent of: Infrastructure details
///
/// Key Components:
///
/// **BLoCs** (Business Logic Components - State Management):
/// - EditorBloc: Manages editor state and text editing operations
/// - LspBloc: Coordinates LSP interactions (completions, hover, diagnostics)
///
/// **Widgets** (UI Components):
/// - EditorView: Main code editor widget
/// - CompletionPopup: Code completion suggestions popup
/// - DiagnosticPanel: Errors and warnings panel
///
/// **Screens** (Full Page Layouts):
/// - IdeScreen: Main IDE screen with editor, sidebar, panels
///
/// **Dependency Injection**:
/// - Uses Injectable + GetIt for dependency injection
/// - Configured in injection_container.dart
///
/// Architecture Pattern: Clean Architecture + BLoC
/// ```
/// User Interaction
///     ↓ triggers
/// Widget (UI)
///     ↓ dispatches events
/// BLoC (Presentation Logic)
///     ↓ calls
/// Use Cases (Application Logic)
///     ↓ uses
/// Repositories (Domain Interfaces)
///     ↑ implemented by
/// Infrastructure Adapters
/// ```
///
/// Example:
/// ```dart
/// // Setup dependency injection
/// await configureDependencies();
///
/// // Use BlocProvider to provide BLoCs to widgets
/// BlocProvider(
///   create: (context) => getIt<EditorBloc>(),
///   child: EditorView(),
/// );
///
/// // In widget, dispatch events
/// context.read<EditorBloc>().add(TextInsertedEvent(
///   text: 'Hello',
///   position: 0,
/// ));
///
/// // In widget, listen to state changes
/// BlocBuilder<EditorBloc, EditorState>(
///   builder: (context, state) {
///     if (state is EditorReadyState) {
///       return Text(state.content);
///     }
///     return CircularProgressIndicator();
///   },
/// );
/// ```
library ide_presentation;

// BLoCs
export 'src/bloc/editor/editor_bloc.dart';
export 'src/bloc/editor/editor_event.dart';
export 'src/bloc/editor/editor_state.dart';

export 'src/bloc/lsp/lsp_bloc.dart';
export 'src/bloc/lsp/lsp_event.dart';
export 'src/bloc/lsp/lsp_state.dart';

// Widgets
export 'src/widgets/editor_view.dart';

// Screens
export 'src/screens/ide_screen.dart';

// Dependency Injection
export 'src/di/injection_container.dart';
