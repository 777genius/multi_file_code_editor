/// LSP domain layer - platform-agnostic LSP abstractions.
///
/// This package provides domain entities and interfaces for Language Server Protocol
/// operations without depending on any specific implementation.
library lsp_domain;

// Entities
export 'src/entities/completion_list.dart';
export 'src/entities/diagnostic.dart';
export 'src/entities/hover_info.dart';
export 'src/entities/lsp_session.dart';

// Value Objects
export 'src/value_objects/session_id.dart';

// Repositories (Ports)
export 'src/repositories/i_lsp_client_repository.dart';

// Failures
export 'src/failures/lsp_failure.dart';
