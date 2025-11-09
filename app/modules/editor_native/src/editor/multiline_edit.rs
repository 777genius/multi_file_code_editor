use ropey::Rope;
use crate::editor::{Position, Edit};

/// Multi-cursor position for simultaneous editing.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MultiCursor {
    /// Primary cursor (always present)
    pub primary: Position,
    /// Additional cursors
    pub secondary: Vec<Position>,
}

impl MultiCursor {
    pub fn new(primary: Position) -> Self {
        Self {
            primary,
            secondary: Vec::new(),
        }
    }

    pub fn add_cursor(&mut self, position: Position) {
        if position != self.primary && !self.secondary.contains(&position) {
            self.secondary.push(position);
        }
    }

    pub fn all_cursors(&self) -> impl Iterator<Item = &Position> {
        std::iter::once(&self.primary).chain(self.secondary.iter())
    }

    pub fn cursor_count(&self) -> usize {
        1 + self.secondary.len()
    }
}

/// Multiple simultaneous text edits.
///
/// This is useful for batch operations like:
/// - Multi-cursor editing
/// - Formatting (LSP returns multiple TextEdits)
/// - Refactoring operations
#[derive(Debug, Clone)]
pub struct MultiEdit {
    pub edits: Vec<Edit>,
}

impl MultiEdit {
    pub fn new() -> Self {
        Self { edits: Vec::new() }
    }

    pub fn add_edit(&mut self, edit: Edit) {
        self.edits.push(edit);
    }

    /// Applies all edits to the rope.
    ///
    /// Edits are sorted by position (reverse order) to avoid
    /// offset invalidation issues.
    ///
    /// # Performance
    /// O(n log n + n * m) where:
    /// - n = number of edits
    /// - m = average edit size
    ///
    /// Sorting ensures later edits don't affect earlier positions.
    pub fn apply(&self, rope: &mut Rope) {
        let mut sorted_edits = self.edits.clone();

        // Sort by position (descending) to apply from bottom to top
        sorted_edits.sort_by(|a, b| b.position.cmp(&a.position));

        for edit in sorted_edits {
            // Apply deletion first
            if !edit.deleted_text.is_empty() {
                let end = edit.position + edit.deleted_text.len();
                if end <= rope.len_bytes() {
                    rope.remove(edit.position..end);
                }
            }

            // Then insertion
            if !edit.inserted_text.is_empty() {
                rope.insert(edit.position, &edit.inserted_text);
            }
        }
    }

    pub fn is_empty(&self) -> bool {
        self.edits.is_empty()
    }

    pub fn len(&self) -> usize {
        self.edits.len()
    }
}

impl Default for MultiEdit {
    fn default() -> Self {
        Self::new()
    }
}

/// Column mode (block) selection.
///
/// Allows selecting a rectangular block of text.
/// Useful for editing aligned data (CSV, tables, etc.).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ColumnSelection {
    /// Start position (top-left corner)
    pub start: Position,
    /// End position (bottom-right corner)
    pub end: Position,
}

impl ColumnSelection {
    pub fn new(start: Position, end: Position) -> Self {
        // Normalize to ensure start is top-left
        let normalized_start = Position::new(
            start.line.min(end.line),
            start.column.min(end.column),
        );
        let normalized_end = Position::new(
            start.line.max(end.line),
            start.column.max(end.column),
        );

        Self {
            start: normalized_start,
            end: normalized_end,
        }
    }

    /// Gets all cursor positions for this column selection.
    ///
    /// Returns one cursor per line in the selected range.
    pub fn to_multi_cursor(&self) -> MultiCursor {
        let mut multi_cursor = MultiCursor::new(Position::new(
            self.start.line,
            self.start.column,
        ));

        for line in (self.start.line + 1)..=self.end.line {
            multi_cursor.add_cursor(Position::new(line, self.start.column));
        }

        multi_cursor
    }

    /// Inserts text at all cursor positions in the column selection.
    pub fn insert_text(&self, rope: &mut Rope, text: &str) -> MultiEdit {
        let mut multi_edit = MultiEdit::new();

        for line in self.start.line..=self.end.line {
            let position = Position::new(line, self.start.column);
            let byte_offset = position.to_byte_offset(rope);

            multi_edit.add_edit(Edit {
                position: byte_offset,
                deleted_text: String::new(),
                inserted_text: text.to_string(),
            });
        }

        multi_edit
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_multi_cursor_creation() {
        let mut mc = MultiCursor::new(Position::new(0, 0));
        mc.add_cursor(Position::new(1, 5));
        mc.add_cursor(Position::new(2, 10));

        assert_eq!(mc.cursor_count(), 3);
    }

    #[test]
    fn test_multi_cursor_no_duplicates() {
        let mut mc = MultiCursor::new(Position::new(0, 0));
        mc.add_cursor(Position::new(1, 5));
        mc.add_cursor(Position::new(1, 5)); // Duplicate

        assert_eq!(mc.cursor_count(), 2); // Should not add duplicate
    }

    #[test]
    fn test_multi_edit_application() {
        let mut rope = Rope::from_str("Line 1\nLine 2\nLine 3");
        let mut multi_edit = MultiEdit::new();

        // Insert "Hello " at start of each line
        multi_edit.add_edit(Edit {
            position: 0,
            deleted_text: String::new(),
            inserted_text: "Hello ".to_string(),
        });

        multi_edit.add_edit(Edit {
            position: 7, // Start of "Line 2"
            deleted_text: String::new(),
            inserted_text: "Hello ".to_string(),
        });

        multi_edit.apply(&mut rope);

        let result = rope.to_string();
        assert!(result.starts_with("Hello Line 1"));
        assert!(result.contains("Hello Line 2"));
    }

    #[test]
    fn test_column_selection_normalization() {
        let col_sel = ColumnSelection::new(
            Position::new(2, 5),
            Position::new(0, 2),
        );

        // Should normalize to top-left, bottom-right
        assert_eq!(col_sel.start.line, 0);
        assert_eq!(col_sel.start.column, 2);
        assert_eq!(col_sel.end.line, 2);
        assert_eq!(col_sel.end.column, 5);
    }

    #[test]
    fn test_column_selection_to_multi_cursor() {
        let col_sel = ColumnSelection::new(
            Position::new(0, 5),
            Position::new(2, 5),
        );

        let mc = col_sel.to_multi_cursor();
        assert_eq!(mc.cursor_count(), 3); // Lines 0, 1, 2
    }

    #[test]
    fn test_column_selection_insert() {
        let mut rope = Rope::from_str("abc\ndef\nghi");
        let col_sel = ColumnSelection::new(
            Position::new(0, 1),
            Position::new(2, 1),
        );

        let mut multi_edit = col_sel.insert_text(&mut rope, "X");
        multi_edit.apply(&mut rope);

        let result = rope.to_string();
        assert_eq!(result, "aXbc\ndXef\ngXhi");
    }
}
