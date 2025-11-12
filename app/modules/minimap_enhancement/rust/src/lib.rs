use wasm_bindgen::prelude::*;
use serde::{Deserialize, Serialize};
use unicode_segmentation::UnicodeSegmentation;

/// Represents a single line in the minimap visualization
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MinimapLine {
    /// Indentation level (number of leading spaces/tabs)
    pub indent: u32,
    /// Visual length of the line (excluding indent)
    pub length: u32,
    /// Whether this line is a comment
    pub is_comment: bool,
    /// Whether this line is empty
    pub is_empty: bool,
    /// Character density (0-100) - how "dense" the line is
    pub density: u8,
}

/// Complete minimap data for a file
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MinimapData {
    /// All lines in the file
    pub lines: Vec<MinimapLine>,
    /// Total number of lines
    pub total_lines: usize,
    /// Maximum line length (for scaling)
    pub max_length: u32,
    /// File size in bytes
    pub file_size: usize,
}

/// Configuration for minimap generation
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MinimapConfig {
    /// Maximum lines to process (for performance)
    pub max_lines: usize,
    /// Sample rate: process every Nth line (1 = all lines)
    pub sample_rate: usize,
    /// Whether to detect comments
    pub detect_comments: bool,
}

impl Default for MinimapConfig {
    fn default() -> Self {
        Self {
            max_lines: 50_000,
            sample_rate: 1,
            detect_comments: true,
        }
    }
}

/// Main WASM entry point: Generate minimap data from source code
#[wasm_bindgen]
pub fn generate_minimap(source_code: &str, config_json: Option<String>) -> Result<JsValue, JsValue> {
    // Parse config
    let config: MinimapConfig = match config_json {
        Some(json) => serde_json::from_str(&json).unwrap_or_default(),
        None => MinimapConfig::default(),
    };

    // Generate minimap data
    let minimap_data = generate_minimap_internal(source_code, &config);

    // Serialize to JsValue
    serde_wasm_bindgen::to_value(&minimap_data)
        .map_err(|e| JsValue::from_str(&format!("Serialization error: {}", e)))
}

/// Internal implementation (testable without WASM)
fn generate_minimap_internal(source_code: &str, config: &MinimapConfig) -> MinimapData {
    let lines: Vec<&str> = source_code.lines().collect();
    let total_lines = lines.len();

    // Limit processing for performance
    let lines_to_process = total_lines.min(config.max_lines);

    let mut minimap_lines = Vec::with_capacity(lines_to_process / config.sample_rate);
    let mut max_length = 0u32;

    for (idx, line) in lines.iter().take(lines_to_process).enumerate() {
        // Sample rate: skip lines if needed
        if idx % config.sample_rate != 0 {
            continue;
        }

        let minimap_line = analyze_line(line, config);
        max_length = max_length.max(minimap_line.length + minimap_line.indent);
        minimap_lines.push(minimap_line);
    }

    MinimapData {
        lines: minimap_lines,
        total_lines,
        max_length,
        file_size: source_code.len(),
    }
}

/// Analyze a single line and extract minimap information
fn analyze_line(line: &str, config: &MinimapConfig) -> MinimapLine {
    // Check if empty
    let trimmed = line.trim();
    if trimmed.is_empty() {
        return MinimapLine {
            indent: 0,
            length: 0,
            is_comment: false,
            is_empty: true,
            density: 0,
        };
    }

    // Calculate indentation
    let indent = calculate_indent(line);

    // Check if comment (simple heuristic)
    let is_comment = if config.detect_comments {
        is_comment_line(trimmed)
    } else {
        false
    };

    // Calculate visual length (grapheme clusters for Unicode)
    let graphemes: Vec<&str> = trimmed.graphemes(true).collect();
    let length = graphemes.len() as u32;

    // Calculate character density (alphanumeric vs whitespace)
    let density = calculate_density(trimmed);

    MinimapLine {
        indent,
        length,
        is_comment,
        is_empty: false,
        density,
    }
}

/// Calculate indentation level (spaces + tabs*4)
fn calculate_indent(line: &str) -> u32 {
    let mut indent = 0u32;
    for ch in line.chars() {
        match ch {
            ' ' => indent += 1,
            '\t' => indent += 4,
            _ => break,
        }
    }
    indent
}

/// Simple comment detection (common patterns)
fn is_comment_line(trimmed: &str) -> bool {
    trimmed.starts_with("//")      // C-style
        || trimmed.starts_with("#")    // Python/Shell
        || trimmed.starts_with("/*")   // Block comment start
        || trimmed.starts_with("*")    // Block comment continuation
        || trimmed.starts_with("<!--") // HTML
        || trimmed.starts_with("--")   // SQL/Lua
}

/// Calculate character density (0-100)
/// Higher density = more alphanumeric characters
fn calculate_density(line: &str) -> u8 {
    if line.is_empty() {
        return 0;
    }

    let total = line.len() as f32;
    let alphanumeric = line.chars().filter(|c| c.is_alphanumeric()).count() as f32;

    ((alphanumeric / total) * 100.0).min(100.0) as u8
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_analyze_empty_line() {
        let config = MinimapConfig::default();
        let line = analyze_line("", &config);
        assert!(line.is_empty);
        assert_eq!(line.length, 0);
    }

    #[test]
    fn test_analyze_indented_line() {
        let config = MinimapConfig::default();
        let line = analyze_line("    fn main() {", &config);
        assert_eq!(line.indent, 4);
        assert!(!line.is_empty);
        assert!(!line.is_comment);
    }

    #[test]
    fn test_analyze_comment_line() {
        let config = MinimapConfig::default();
        let line = analyze_line("// This is a comment", &config);
        assert!(line.is_comment);
        assert!(!line.is_empty);
    }

    #[test]
    fn test_calculate_density() {
        let density = calculate_density("abc123");
        assert_eq!(density, 100);

        let density = calculate_density("abc   ");
        assert!(density < 100);
    }

    #[test]
    fn test_generate_minimap_small_file() {
        let source = "fn main() {\n    println!(\"Hello\");\n}\n";
        let config = MinimapConfig::default();
        let data = generate_minimap_internal(source, &config);

        assert_eq!(data.total_lines, 3);
        assert_eq!(data.lines.len(), 3);
    }

    #[test]
    fn test_sampling() {
        let source = "line1\nline2\nline3\nline4\nline5\n";
        let config = MinimapConfig {
            sample_rate: 2,
            ..Default::default()
        };
        let data = generate_minimap_internal(source, &config);

        // Should process lines 0, 2, 4 (3 lines)
        assert_eq!(data.lines.len(), 3);
    }
}
