/// Core domain layer for MultiEditor - a multi-file code editor.
///
/// This package provides the foundational entities, value objects, and interfaces
/// for building multi-file code editing experiences following Clean Architecture
/// and Domain-Driven Design principles.
///
/// ## Features
///
/// * **Domain Entities**: FileDocument, Folder, Project, FileTreeNode
/// * **Value Objects**: Type-safe wrappers for file paths, names, content
/// * **Repository Interfaces**: Abstraction for data access
/// * **Domain Events**: File and folder lifecycle events
/// * **Validation Services**: Input validation and language detection
///
/// ## Example
///
/// ```dart
/// import 'package:multi_editor_core/multi_editor_core.dart';
///
/// // Create a file document
/// final file = FileDocument(
///   id: 'file_1',
///   name: 'main.dart',
///   content: 'void main() {}',
///   language: 'dart',
/// );
/// ```
library;

export 'src/domain/entities/file_document.dart';
export 'src/domain/entities/folder.dart';
export 'src/domain/entities/project.dart';
export 'src/domain/entities/file_tree_node.dart';

export 'src/domain/value_objects/file_name.dart';
export 'src/domain/value_objects/file_path.dart';
export 'src/domain/value_objects/file_content.dart';
export 'src/domain/value_objects/language_id.dart';

export 'src/domain/failures/domain_failure.dart';

export 'src/ports/repositories/file_repository.dart';
export 'src/ports/repositories/folder_repository.dart';
export 'src/ports/repositories/project_repository.dart';

export 'src/ports/services/validation_service.dart';
export 'src/ports/services/language_detector.dart';

export 'src/ports/events/editor_event.dart';
export 'src/ports/events/event_bus.dart';
