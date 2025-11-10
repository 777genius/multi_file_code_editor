// Infrastructure Layer
//
// External library adapters and concrete implementations.
// Depends on Domain layer (implements interfaces).
// Provides concrete implementations of domain services.

pub mod tree_sitter;
pub mod memory;

// Re-export for convenience
pub use tree_sitter::{TreeSitterParser, TreeSitterHighlighter};
pub use memory::{alloc, dealloc};
