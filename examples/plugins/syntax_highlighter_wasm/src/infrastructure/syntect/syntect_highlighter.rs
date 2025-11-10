use crate::domain::{
    Highlighter, SyntaxTree, HighlightCollection, HighlightRange,
    Theme, Language, Range, Position,
};
use syntect::parsing::{SyntaxSet, ParseState};
use syntect::highlighting::{ThemeSet, Highlighter as SyntectHighlighterTrait, HighlightState};
use syntect::util::LinesWithEndings;

/// Syntect Highlighter Adapter
///
/// Implements Highlighter trait using Syntect library.
/// Uses TextMate grammars for syntax highlighting.
pub struct SyntectHighlighter {
    /// Syntax set with all supported languages
    syntax_set: SyntaxSet,

    /// Theme set with default themes
    theme_set: ThemeSet,
}

impl SyntectHighlighter {
    /// Create new highlighter with default syntax and theme sets
    pub fn new() -> Self {
        Self {
            syntax_set: SyntaxSet::load_defaults_newlines(),
            theme_set: ThemeSet::load_defaults(),
        }
    }

    /// Get syntax by language
    fn get_syntax_for_language(&self, language: Language) -> Option<&syntect::parsing::SyntaxReference> {
        let extension = language.extension();
        self.syntax_set.find_syntax_by_extension(extension)
    }

    /// Map Syntect scope to our token type
    fn scope_to_token_type(scope_str: &str) -> String {
        // Map TextMate scopes to simpler token types
        if scope_str.contains("keyword") {
            "keyword".to_string()
        } else if scope_str.contains("function") || scope_str.contains("entity.name.function") {
            "function".to_string()
        } else if scope_str.contains("string") {
            "string".to_string()
        } else if scope_str.contains("comment") {
            "comment".to_string()
        } else if scope_str.contains("constant.numeric") {
            "number".to_string()
        } else if scope_str.contains("storage.type") || scope_str.contains("entity.name.type") {
            "type".to_string()
        } else if scope_str.contains("variable") {
            "variable".to_string()
        } else if scope_str.contains("keyword.operator") {
            "operator".to_string()
        } else {
            "text".to_string()
        }
    }

    /// Highlight with Syntect
    fn highlight_with_syntect(
        &self,
        tree: &SyntaxTree,
    ) -> Result<HighlightCollection, String> {
        // Get syntax for language
        let syntax = self.get_syntax_for_language(tree.language())
            .ok_or_else(|| format!("No syntax for language: {:?}", tree.language()))?;

        // Get default theme
        let theme = &self.theme_set.themes["base16-ocean.dark"];

        // Create highlighter
        let highlighter = SyntectHighlighterTrait::new(theme);
        let mut parse_state = ParseState::new(syntax);
        let mut highlight_state = HighlightState::new(&highlighter, syntect::parsing::ScopeStack::new());

        let mut collection = HighlightCollection::new();
        let mut highlight_id = 0;
        let mut current_line = 0;

        // Process each line
        for line in LinesWithEndings::from(tree.source_code()) {
            let ops = parse_state
                .parse_line(line, &self.syntax_set)
                .map_err(|e| format!("Parse error: {:?}", e))?;

            let mut current_col = 0;

            for (style, token_str) in highlight_state.highlight_line(&ops, &self.syntax_set) {
                if token_str.trim().is_empty() {
                    current_col += token_str.len() as u32;
                    continue;
                }

                // Get token type from scope
                let scope_str = format!("{:?}", style.foreground);
                let token_type = Self::scope_to_token_type(&scope_str);

                // Create range
                let start = Position::new(current_line, current_col);
                let end = Position::new(current_line, current_col + token_str.len() as u32);

                if let Ok(range) = Range::new(start, end) {
                    let highlight = HighlightRange::new(
                        format!("h{}", highlight_id),
                        range,
                        token_type,
                    ).with_text(token_str.to_string());

                    collection.add(highlight);
                    highlight_id += 1;
                }

                current_col += token_str.len() as u32;
            }

            current_line += 1;
        }

        Ok(collection)
    }
}

impl Default for SyntectHighlighter {
    fn default() -> Self {
        Self::new()
    }
}

impl Highlighter for SyntectHighlighter {
    fn highlight(
        &self,
        tree: &SyntaxTree,
        _theme: &Theme,
    ) -> Result<HighlightCollection, String> {
        // Note: We use Syntect's built-in theme for now
        // In future, could map our Theme to Syntect theme
        self.highlight_with_syntect(tree)
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
    use crate::infrastructure::syntect::SyntectParser;
    use crate::domain::Parser;

    #[test]
    fn test_rust_highlighting() {
        let parser = SyntectParser::new();
        let highlighter = SyntectHighlighter::new();

        let source = "fn main() { let x = 42; }";
        let tree = parser.parse(Language::Rust, source).unwrap();

        let theme = crate::domain::Theme::dark_default();
        let result = highlighter.highlight(&tree, &theme);

        assert!(result.is_ok());
        let highlights = result.unwrap();
        assert!(highlights.ranges().len() > 0);
    }

    #[test]
    fn test_scope_mapping() {
        assert_eq!(
            SyntectHighlighter::scope_to_token_type("keyword.control"),
            "keyword"
        );
        assert_eq!(
            SyntectHighlighter::scope_to_token_type("entity.name.function"),
            "function"
        );
        assert_eq!(
            SyntectHighlighter::scope_to_token_type("string.quoted"),
            "string"
        );
    }
}
