import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editor_core/editor_core.dart';
import 'package:injectable/injectable.dart';

import 'editor_event.dart';
import 'editor_state.dart';

/// EditorBloc
///
/// Manages editor state and coordinates text editing operations.
///
/// Architecture (Clean Architecture + BLoC):
/// ```
/// UI Widget
///     ↓ dispatches events
/// EditorBloc
///     ↓ calls
/// Use Cases (Application Layer)
///     ↓ uses
/// Repositories (Domain Interfaces)
///     ↑ implemented by
/// Infrastructure Adapters
/// ```
///
/// Responsibilities:
/// - Manages editor content and cursor state
/// - Handles user text editing operations
/// - Coordinates undo/redo operations
/// - Tracks document changes and save state
/// - Never directly accesses Infrastructure
///
/// Example:
/// ```dart
/// // In UI widget
/// context.read<EditorBloc>().add(TextInsertedEvent(
///   text: 'Hello',
///   position: 0,
/// ));
///
/// // In BlocBuilder
/// BlocBuilder<EditorBloc, EditorState>(
///   builder: (context, state) {
///     if (state is EditorReadyState) {
///       return Text(state.content);
///     }
///     return CircularProgressIndicator();
///   },
/// );
/// ```
@injectable
class EditorBloc extends Bloc<EditorEvent, EditorState> {
  final ICodeEditorRepository _editorRepository;

  EditorBloc({
    required ICodeEditorRepository editorRepository,
  })  : _editorRepository = editorRepository,
        super(const EditorInitialState()) {
    // Register event handlers
    on<TextInsertedEvent>(_onTextInserted);
    on<TextDeletedEvent>(_onTextDeleted);
    on<CursorMovedEvent>(_onCursorMoved);
    on<TextSelectedEvent>(_onTextSelected);
    on<UndoRequestedEvent>(_onUndoRequested);
    on<RedoRequestedEvent>(_onRedoRequested);
    on<DocumentOpenedEvent>(_onDocumentOpened);
    on<DocumentClosedEvent>(_onDocumentClosed);
    on<DocumentSaveRequestedEvent>(_onDocumentSaveRequested);
    on<ContentLoadedEvent>(_onContentLoaded);
  }

  // ================================================================
  // Event Handlers
  // ================================================================

  /// Handles text insertion
  Future<void> _onTextInserted(
    TextInsertedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    // Call repository to insert text
    final result = await _editorRepository.insertText(event.text);

    result.fold(
      (failure) => emit(EditorErrorState(
        message: 'Failed to insert text: ${failure.toString()}',
        failure: failure,
      )),
      (_) async {
        // Get updated content
        final contentResult = await _editorRepository.getContent();
        final cursorResult = await _editorRepository.getCursorPosition();

        contentResult.fold(
          (failure) => emit(EditorErrorState(
            message: 'Failed to get content',
            failure: failure,
          )),
          (content) {
            cursorResult.fold(
              (failure) => emit(EditorErrorState(
                message: 'Failed to get cursor',
                failure: failure,
              )),
              (cursor) {
                emit(currentState.copyWith(
                  content: content,
                  cursorPosition: cursor,
                  hasUnsavedChanges: true,
                  canUndo: true,
                ));
              },
            );
          },
        );
      },
    );
  }

  /// Handles text deletion
  Future<void> _onTextDeleted(
    TextDeletedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    final result = await _editorRepository.deleteText(
      start: event.start,
      end: event.end,
    );

    result.fold(
      (failure) => emit(EditorErrorState(
        message: 'Failed to delete text',
        failure: failure,
      )),
      (_) async {
        final contentResult = await _editorRepository.getContent();
        final cursorResult = await _editorRepository.getCursorPosition();

        contentResult.fold(
          (failure) => emit(EditorErrorState(
            message: 'Failed to get content',
            failure: failure,
          )),
          (content) {
            cursorResult.fold(
              (failure) => emit(EditorErrorState(
                message: 'Failed to get cursor',
                failure: failure,
              )),
              (cursor) {
                emit(currentState.copyWith(
                  content: content,
                  cursorPosition: cursor,
                  hasUnsavedChanges: true,
                  canUndo: true,
                ));
              },
            );
          },
        );
      },
    );
  }

  /// Handles cursor movement
  Future<void> _onCursorMoved(
    CursorMovedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    final result = await _editorRepository.moveCursor(event.position);

    result.fold(
      (failure) => emit(EditorErrorState(
        message: 'Failed to move cursor',
        failure: failure,
      )),
      (_) {
        emit(currentState.copyWith(
          cursorPosition: event.position,
          selection: null, // Clear selection on cursor move
        ));
      },
    );
  }

  /// Handles text selection
  Future<void> _onTextSelected(
    TextSelectedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    emit(currentState.copyWith(selection: event.selection));
  }

  /// Handles undo
  Future<void> _onUndoRequested(
    UndoRequestedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    final result = await _editorRepository.undo();

    result.fold(
      (failure) => emit(EditorErrorState(
        message: 'Failed to undo',
        failure: failure,
      )),
      (_) async {
        final contentResult = await _editorRepository.getContent();
        final cursorResult = await _editorRepository.getCursorPosition();

        contentResult.fold(
          (failure) => emit(EditorErrorState(
            message: 'Failed to get content',
            failure: failure,
          )),
          (content) {
            cursorResult.fold(
              (failure) => emit(EditorErrorState(
                message: 'Failed to get cursor',
                failure: failure,
              )),
              (cursor) {
                emit(currentState.copyWith(
                  content: content,
                  cursorPosition: cursor,
                  canRedo: true,
                ));
              },
            );
          },
        );
      },
    );
  }

  /// Handles redo
  Future<void> _onRedoRequested(
    RedoRequestedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    final result = await _editorRepository.redo();

    result.fold(
      (failure) => emit(EditorErrorState(
        message: 'Failed to redo',
        failure: failure,
      )),
      (_) async {
        final contentResult = await _editorRepository.getContent();
        final cursorResult = await _editorRepository.getCursorPosition();

        contentResult.fold(
          (failure) => emit(EditorErrorState(
            message: 'Failed to get content',
            failure: failure,
          )),
          (content) {
            cursorResult.fold(
              (failure) => emit(EditorErrorState(
                message: 'Failed to get cursor',
                failure: failure,
              )),
              (cursor) {
                emit(currentState.copyWith(
                  content: content,
                  cursorPosition: cursor,
                  canUndo: true,
                ));
              },
            );
          },
        );
      },
    );
  }

  /// Handles document opening
  Future<void> _onDocumentOpened(
    DocumentOpenedEvent event,
    Emitter<EditorState> emit,
  ) async {
    emit(const EditorLoadingState(message: 'Opening document...'));

    // TODO: Load document content from file system
    // For now, start with empty content
    emit(EditorReadyState(
      content: '',
      cursorPosition: CursorPosition.create(line: 0, column: 0),
      documentUri: event.uri,
      languageId: event.languageId,
    ));
  }

  /// Handles document closing
  Future<void> _onDocumentClosed(
    DocumentClosedEvent event,
    Emitter<EditorState> emit,
  ) async {
    emit(const EditorInitialState());
  }

  /// Handles document save
  Future<void> _onDocumentSaveRequested(
    DocumentSaveRequestedEvent event,
    Emitter<EditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReadyState) return;

    emit(EditorLoadingState(message: 'Saving document...'));

    // TODO: Save document content to file system

    emit(currentState.copyWith(hasUnsavedChanges: false));
  }

  /// Handles content loading
  Future<void> _onContentLoaded(
    ContentLoadedEvent event,
    Emitter<EditorState> emit,
  ) async {
    emit(EditorReadyState(
      content: event.content,
      cursorPosition: CursorPosition.create(line: 0, column: 0),
      documentUri: event.documentUri,
    ));
  }

  @override
  Future<void> close() {
    // Cleanup if needed
    return super.close();
  }
}
