use crate::domain::{Parser, ParserStatistics, SyntaxTree, Language};
use tree_sitter::{Parser as TSParser, Tree, Node};
use std::collections::HashMap;

/// Tree-sitter Parser Adapter
///
/// Implements Parser trait using Tree-sitter library.
/// Follow Adapter pattern: adapts external library to domain interface.
pub struct TreeSitterParser {
    /// Cached parsers for each language (performance optimization)
    parsers: HashMap<Language, TSParser>,

    /// Statistics for monitoring
    stats: ParserStatistics,
}

impl TreeSitterParser {
    /// Create new Tree-sitter parser
    pub fn new() -> Self {
        let mut parsers = HashMap::new();

        // Initialize parsers for supported languages
        if let Ok(mut parser) = TSParser::new() {
            parser.set_language(tree_sitter_rust::language()).ok();
            parsers.insert(Language::Rust, parser);
        }

        if let Ok(mut parser) = TSParser::new() {
            parser.set_language(tree_sitter_javascript::language()).ok();
            parsers.insert(Language::JavaScript, parser);
        }

        if let Ok(mut parser) = TSParser::new() {
            parser.set_language(tree_sitter_json::language()).ok();
            parsers.insert(Language::Json, parser);
        }

        Self {
            parsers,
            stats: ParserStatistics::default(),
        }
    }

    /// Parse with Tree-sitter and create domain SyntaxTree
    fn parse_with_ts(&self, language: Language, source_code: &str) -> Result<Tree, String> {
        let parser = self.parsers
            .get(&language)
            .ok_or_else(|| format!("No parser for language: {:?}", language))?;

        // Parse source code
        parser
            .parse(source_code, None)
            .ok_or_else(|| "Tree-sitter parse failed".to_string())
    }

    /// Count nodes in tree (for statistics)
    fn count_nodes(node: &Node) -> usize {
        let mut count = 1; // Current node

        // Recursively count children
        for i in 0..node.child_count() {
            if let Some(child) = node.child(i) {
                count += Self::count_nodes(&child);
            }
        }

        count
    }

    /// Check if tree has errors
    fn has_errors(node: &Node) -> bool {
        if node.is_error() || node.is_missing() {
            return true;
        }

        // Check children recursively
        for i in 0..node.child_count() {
            if let Some(child) = node.child(i) {
                if Self::has_errors(&child) {
                    return true;
                }
            }
        }

        false
    }

    /// Generate unique ID for syntax tree
    fn generate_tree_id(source_code: &str) -> String {
        // Simple hash based on length and first/last chars
        // In production, use proper hash function (e.g., SHA256)
        let len = source_code.len();
        let first = source_code.chars().next().unwrap_or('_');
        let last = source_code.chars().last().unwrap_or('_');

        format!("tree_{}_{}_{}", len, first as u32, last as u32)
    }
}

impl Default for TreeSitterParser {
    fn default() -> Self {
        Self::new()
    }
}

impl Parser for TreeSitterParser {
    fn parse(&self, language: Language, source_code: &str) -> Result<SyntaxTree, String> {
        // Parse with Tree-sitter
        let tree = self.parse_with_ts(language, source_code)?;
        let root_node = tree.root_node();

        // Extract tree information
        let node_count = Self::count_nodes(&root_node);
        let has_errors = Self::has_errors(&root_node);
        let tree_id = Self::generate_tree_id(source_code);

        // Create domain SyntaxTree entity
        Ok(SyntaxTree::new(
            tree_id,
            language,
            source_code.to_string(),
            root_node.kind().to_string(),
            node_count,
            has_errors,
        ))
    }

    fn supports_language(&self, language: Language) -> bool {
        self.parsers.contains_key(&language)
    }

    fn get_statistics(&self) -> ParserStatistics {
        self.stats.clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_rust_parsing() {
        let parser = TreeSitterParser::new();

        let result = parser.parse(Language::Rust, "fn main() {}");

        assert!(result.is_ok());
        let tree = result.unwrap();
        assert_eq!(tree.language(), Language::Rust);
        assert!(!tree.has_errors());
    }

    #[test]
    fn test_parse_with_errors() {
        let parser = TreeSitterParser::new();

        // Invalid Rust code
        let result = parser.parse(Language::Rust, "fn main( {");

        assert!(result.is_ok()); // Parsing succeeds even with syntax errors
        let tree = result.unwrap();
        assert!(tree.has_errors()); // But tree contains error nodes
    }

    #[test]
    fn test_language_support() {
        let parser = TreeSitterParser::new();

        assert!(parser.supports_language(Language::Rust));
        assert!(parser.supports_language(Language::JavaScript));
        assert!(!parser.supports_language(Language::Dart)); // Not implemented yet
    }
}
