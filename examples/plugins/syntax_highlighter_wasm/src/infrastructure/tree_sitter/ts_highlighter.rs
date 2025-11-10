use crate::domain::{
    Highlighter, SyntaxTree, HighlightCollection, HighlightRange,
    Theme, Language, Range, Position,
};
use tree_sitter::{Parser, Query, QueryCursor};
use std::collections::HashMap;

/// Tree-sitter Highlighter Adapter
///
/// Implements Highlighter trait using Tree-sitter queries.
/// Uses Tree-sitter query language for pattern matching.
pub struct TreeSitterHighlighter {
    /// Query patterns for each language
    queries: HashMap<Language, String>,
}

impl TreeSitterHighlighter {
    /// Create new highlighter with default queries
    pub fn new() -> Self {
        let mut queries = HashMap::new();

        // Rust query patterns
        queries.insert(Language::Rust, Self::rust_query());
        queries.insert(Language::JavaScript, Self::javascript_query());
        queries.insert(Language::Json, Self::json_query());

        Self { queries }
    }

    /// Rust syntax highlighting query
    ///
    /// Tree-sitter query language: https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries
    fn rust_query() -> String {
        r#"
        ; Keywords
        [
          "fn"
          "let"
          "mut"
          "const"
          "static"
          "type"
          "impl"
          "trait"
          "struct"
          "enum"
          "mod"
          "use"
          "pub"
          "return"
          "if"
          "else"
          "match"
          "while"
          "for"
          "loop"
          "break"
          "continue"
        ] @keyword

        ; Functions
        (function_item name: (identifier) @function)
        (call_expression function: (identifier) @function)

        ; Types
        (type_identifier) @type
        (primitive_type) @type

        ; Strings
        (string_literal) @string
        (char_literal) @string

        ; Numbers
        (integer_literal) @number
        (float_literal) @number

        ; Comments
        (line_comment) @comment
        (block_comment) @comment

        ; Operators
        [
          "="
          "=="
          "!="
          "<"
          ">"
          "<="
          ">="
          "+"
          "-"
          "*"
          "/"
          "%"
        ] @operator
        "#.to_string()
    }

    /// JavaScript query
    fn javascript_query() -> String {
        r#"
        ; Keywords
        [
          "function"
          "const"
          "let"
          "var"
          "return"
          "if"
          "else"
          "for"
          "while"
          "break"
          "continue"
          "class"
          "extends"
          "new"
        ] @keyword

        ; Functions
        (function_declaration name: (identifier) @function)
        (call_expression function: (identifier) @function)

        ; Strings
        (string) @string
        (template_string) @string

        ; Numbers
        (number) @number

        ; Comments
        (comment) @comment
        "#.to_string()
    }

    /// JSON query
    fn json_query() -> String {
        r#"
        (string) @string
        (number) @number
        (true) @keyword
        (false) @keyword
        (null) @keyword
        "#.to_string()
    }

    /// Re-parse source and apply query
    ///
    /// Note: In production, we'd cache parsed trees and reuse them.
    /// Here we re-parse for simplicity.
    fn highlight_with_query(
        &self,
        tree: &SyntaxTree,
        query_str: &str,
    ) -> Result<HighlightCollection, String> {
        // Re-parse source code
        let mut parser = Parser::new();

        let language_fn = match tree.language() {
            Language::Rust => tree_sitter_rust::language,
            Language::JavaScript => tree_sitter_javascript::language,
            Language::Json => tree_sitter_json::language,
            _ => return Err("Language not supported".to_string()),
        };

        parser
            .set_language(language_fn())
            .map_err(|e| format!("Failed to set language: {}", e))?;

        let ts_tree = parser
            .parse(tree.source_code(), None)
            .ok_or("Failed to parse")?;

        // Create query
        let query = Query::new(language_fn(), query_str)
            .map_err(|e| format!("Invalid query: {}", e))?;

        // Execute query
        let mut cursor = QueryCursor::new();
        let matches = cursor.matches(&query, ts_tree.root_node(), tree.source_code().as_bytes());

        // Collect highlights
        let mut collection = HighlightCollection::new();
        let mut highlight_id = 0;

        for match_ in matches {
            for capture in match_.captures {
                let node = capture.node;
                let capture_name = &query.capture_names()[capture.index as usize];

                // Convert byte offsets to positions
                let start_byte = node.start_byte();
                let end_byte = node.end_byte();

                let range = Range::from_byte_offsets(
                    tree.source_code(),
                    start_byte,
                    end_byte,
                ).map_err(|e| format!("Range error: {}", e))?;

                // Extract text
                let text = tree.source_code()
                    .get(start_byte..end_byte)
                    .map(|s| s.to_string());

                // Create highlight range
                let highlight = HighlightRange::new(
                    format!("h{}", highlight_id),
                    range,
                    capture_name.clone(),
                ).with_text(text.unwrap_or_default());

                collection.add(highlight);
                highlight_id += 1;
            }
        }

        Ok(collection)
    }
}

impl Default for TreeSitterHighlighter {
    fn default() -> Self {
        Self::new()
    }
}

impl Highlighter for TreeSitterHighlighter {
    fn highlight(
        &self,
        tree: &SyntaxTree,
        _theme: &Theme,
    ) -> Result<HighlightCollection, String> {
        // Get query for language
        let query_str = self.queries
            .get(&tree.language())
            .ok_or_else(|| format!("No query for language: {:?}", tree.language()))?;

        // Apply query to syntax tree
        self.highlight_with_query(tree, query_str)
    }

    fn supported_token_types(&self) -> Vec<String> {
        vec![
            "keyword".to_string(),
            "function".to_string(),
            "type".to_string(),
            "string".to_string(),
            "number".to_string(),
            "comment".to_string(),
            "operator".to_string(),
            "variable".to_string(),
        ]
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::infrastructure::tree_sitter::TreeSitterParser;
    use crate::domain::Parser;

    #[test]
    fn test_rust_highlighting() {
        let parser = TreeSitterParser::new();
        let highlighter = TreeSitterHighlighter::new();

        let source = "fn main() { let x = 42; }";
        let tree = parser.parse(Language::Rust, source).unwrap();

        let theme = Theme::dark_default();
        let result = highlighter.highlight(&tree, &theme);

        assert!(result.is_ok());
        let highlights = result.unwrap();
        assert!(highlights.ranges().len() > 0);
    }
}
