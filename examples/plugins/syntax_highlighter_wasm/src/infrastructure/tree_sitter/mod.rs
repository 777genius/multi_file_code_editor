// Infrastructure Layer - Tree-sitter Integration
//
// Implements domain services using Tree-sitter library.
// Adapter pattern: adapts Tree-sitter API to domain interfaces.

pub mod ts_parser;
pub mod ts_highlighter;

pub use ts_parser::TreeSitterParser;
pub use ts_highlighter::TreeSitterHighlighter;
