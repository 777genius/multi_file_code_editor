/// Platform-agnostic code editor domain layer.
///
/// This package provides abstractions for code editor functionality
/// without depending on any specific implementation (Monaco, native, etc.).
///
/// Key principle: The domain layer defines WHAT the editor can do,
/// not HOW it's implemented.
library editor_core;

// Entities
export 'src/entities/cursor_position.dart';
export 'src/entities/editor_document.dart';
export 'src/entities/editor_theme.dart';
export 'src/entities/text_selection.dart';

// Value Objects
export 'src/value_objects/document_uri.dart';
export 'src/value_objects/language_id.dart';

// Repositories (Ports)
export 'src/repositories/i_code_editor_repository.dart';

// Failures
export 'src/failures/editor_failure.dart';

// Events
export 'src/events/editor_event.dart';
