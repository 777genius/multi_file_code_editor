// High-performance Myers diff algorithm for WebAssembly
// Optimized for speed and small binary size

use wasm_bindgen::prelude::*;
use serde::{Deserialize, Serialize};

// When the `console_error_panic_hook` feature is enabled, we can call the
// `set_panic_hook` function at least once during initialization, and then
// we will get better error messages if our code ever panics.
#[cfg(feature = "console_error_panic_hook")]
pub use console_error_panic_hook::set_once as set_panic_hook;

/// Initialize the WASM module
#[wasm_bindgen(start)]
pub fn init() {
    #[cfg(feature = "console_error_panic_hook")]
    set_panic_hook();
}

/// Diff line type
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum DiffLineType {
    Added,
    Removed,
    Context,
}

/// A line in a diff
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DiffLine {
    #[serde(rename = "type")]
    pub line_type: DiffLineType,
    pub content: String,
    pub old_line_number: Option<usize>,
    pub new_line_number: Option<usize>,
}

/// A hunk of diff (continuous block of changes)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DiffHunk {
    pub old_start: usize,
    pub old_count: usize,
    pub new_start: usize,
    pub new_count: usize,
    pub header: String,
    pub lines: Vec<DiffLine>,
}

/// Edit operation from Myers algorithm
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Edit {
    Insert(usize),  // Insert from new at position
    Delete(usize),  // Delete from old at position
    Keep(usize, usize), // Keep (old_pos, new_pos)
}

/// Myers diff algorithm implementation
///
/// Time complexity: O((N+M)D) where N and M are lengths of sequences and D is edit distance
/// Space complexity: O((N+M)D)
///
/// This is the standard diff algorithm used by git and most diff tools.
/// It finds the shortest edit script (minimum number of insertions/deletions).
struct MyersDiff<'a> {
    old: &'a [&'a str],
    new: &'a [&'a str],
}

impl<'a> MyersDiff<'a> {
    fn new(old: &'a [&'a str], new: &'a [&'a str]) -> Self {
        Self { old, new }
    }

    /// Find the shortest edit script using Myers algorithm
    fn compute(&self) -> Vec<Edit> {
        let n = self.old.len();
        let m = self.new.len();
        let max_d = n + m;

        // V array stores the furthest reaching path for each k-diagonal
        // k-diagonal = x - y where (x, y) is position in edit graph
        let mut v: Vec<isize> = vec![0; 2 * max_d + 1];
        let offset = max_d as isize;

        // Trace stores the V arrays for each d (edit distance)
        let mut trace: Vec<Vec<isize>> = Vec::new();

        // Find the shortest path (minimum edit distance)
        for d in 0..=max_d {
            // For each k-diagonal in range [-d, d] with step 2
            for k in (-(d as isize)..=(d as isize)).step_by(2) {
                let k_idx = (k + offset) as usize;

                // Decide whether to go down or right
                let mut x = if k == -(d as isize) || (k != d as isize && v[(k_idx - 1)] < v[(k_idx + 1)]) {
                    // Go down (insert)
                    v[(k_idx + 1)]
                } else {
                    // Go right (delete)
                    v[(k_idx - 1)] + 1
                };

                let mut y = x - k;

                // Follow diagonal (keep matching lines)
                while x < n as isize && y < m as isize
                    && self.old[x as usize] == self.new[y as usize] {
                    x += 1;
                    y += 1;
                }

                v[k_idx] = x;

                // Check if we reached the end
                if x >= n as isize && y >= m as isize {
                    trace.push(v.clone());
                    return self.backtrack(&trace, offset);
                }
            }

            trace.push(v.clone());
        }

        // No path found (shouldn't happen)
        Vec::new()
    }

    /// Backtrack through the trace to construct the edit script
    fn backtrack(&self, trace: &[Vec<isize>], offset: isize) -> Vec<Edit> {
        let mut edits = Vec::new();
        let mut x = self.old.len() as isize;
        let mut y = self.new.len() as isize;

        // Backtrack from end to start
        for d in (0..trace.len()).rev() {
            let v = &trace[d];
            let k = x - y;
            let k_idx = (k + offset) as usize;

            // Determine previous k
            let prev_k = if k == -(d as isize) || (k != d as isize && v[(k_idx - 1)] < v[(k_idx + 1)]) {
                k + 1
            } else {
                k - 1
            };

            let prev_k_idx = (prev_k + offset) as usize;
            let prev_x = if d > 0 { v[prev_k_idx] } else { 0 };
            let prev_y = prev_x - prev_k;

            // Follow diagonal backwards (keep operations)
            while x > prev_x && y > prev_y {
                x -= 1;
                y -= 1;
                edits.push(Edit::Keep(x as usize, y as usize));
            }

            if d > 0 {
                // Insert or delete operation
                if x == prev_x {
                    // Insert
                    y -= 1;
                    edits.push(Edit::Insert(y as usize));
                } else {
                    // Delete
                    x -= 1;
                    edits.push(Edit::Delete(x as usize));
                }
            }
        }

        edits.reverse();
        edits
    }
}

/// Convert edit script to diff hunks with context
fn edits_to_hunks(
    old_lines: &[&str],
    new_lines: &[&str],
    edits: &[Edit],
    context_lines: usize,
) -> Vec<DiffHunk> {
    if edits.is_empty() {
        return Vec::new();
    }

    // Convert edits to diff lines
    let mut diff_lines: Vec<(usize, usize, DiffLine)> = Vec::new();

    for edit in edits {
        match edit {
            Edit::Keep(old_idx, new_idx) => {
                diff_lines.push((
                    *old_idx,
                    *new_idx,
                    DiffLine {
                        line_type: DiffLineType::Context,
                        content: old_lines[*old_idx].to_string(),
                        old_line_number: Some(old_idx + 1),
                        new_line_number: Some(new_idx + 1),
                    },
                ));
            }
            Edit::Delete(old_idx) => {
                diff_lines.push((
                    *old_idx,
                    usize::MAX,
                    DiffLine {
                        line_type: DiffLineType::Removed,
                        content: old_lines[*old_idx].to_string(),
                        old_line_number: Some(old_idx + 1),
                        new_line_number: None,
                    },
                ));
            }
            Edit::Insert(new_idx) => {
                diff_lines.push((
                    usize::MAX,
                    *new_idx,
                    DiffLine {
                        line_type: DiffLineType::Added,
                        content: new_lines[*new_idx].to_string(),
                        old_line_number: None,
                        new_line_number: Some(new_idx + 1),
                    },
                ));
            }
        }
    }

    // Group into hunks based on context
    let mut hunks: Vec<DiffHunk> = Vec::new();
    let mut current_hunk_lines: Vec<DiffLine> = Vec::new();
    let mut hunk_old_start = 0;
    let mut hunk_new_start = 0;
    let mut last_change_idx = 0;
    let mut context_after_change = 0;

    for (i, (old_idx, new_idx, line)) in diff_lines.iter().enumerate() {
        let is_change = line.line_type != DiffLineType::Context;

        if is_change {
            // Start new hunk if needed
            if current_hunk_lines.is_empty() {
                // Include context before change
                let context_start = if i >= context_lines {
                    i - context_lines
                } else {
                    0
                };

                for j in context_start..i {
                    current_hunk_lines.push(diff_lines[j].2.clone());
                }

                hunk_old_start = if context_start < diff_lines.len() {
                    diff_lines[context_start].0.min(old_lines.len().saturating_sub(1))
                } else {
                    0
                };

                hunk_new_start = if context_start < diff_lines.len() {
                    diff_lines[context_start].1.min(new_lines.len().saturating_sub(1))
                } else {
                    0
                };
            }

            current_hunk_lines.push(line.clone());
            last_change_idx = i;
            context_after_change = 0;
        } else if !current_hunk_lines.is_empty() {
            // Add context after change
            current_hunk_lines.push(line.clone());
            context_after_change += 1;

            // Close hunk if we have enough context
            if context_after_change >= context_lines {
                let old_count = current_hunk_lines.iter()
                    .filter(|l| l.line_type != DiffLineType::Added)
                    .count();
                let new_count = current_hunk_lines.iter()
                    .filter(|l| l.line_type != DiffLineType::Removed)
                    .count();

                hunks.push(DiffHunk {
                    old_start: hunk_old_start + 1,
                    old_count,
                    new_start: hunk_new_start + 1,
                    new_count,
                    header: format!(
                        "@@ -{},{} +{},{} @@",
                        hunk_old_start + 1,
                        old_count,
                        hunk_new_start + 1,
                        new_count
                    ),
                    lines: current_hunk_lines.clone(),
                });

                current_hunk_lines.clear();
                context_after_change = 0;
            }
        }
    }

    // Close last hunk if any
    if !current_hunk_lines.is_empty() {
        let old_count = current_hunk_lines.iter()
            .filter(|l| l.line_type != DiffLineType::Added)
            .count();
        let new_count = current_hunk_lines.iter()
            .filter(|l| l.line_type != DiffLineType::Removed)
            .count();

        hunks.push(DiffHunk {
            old_start: hunk_old_start + 1,
            old_count,
            new_start: hunk_new_start + 1,
            new_count,
            header: format!(
                "@@ -{},{} +{},{} @@",
                hunk_old_start + 1,
                old_count,
                hunk_new_start + 1,
                new_count
            ),
            lines: current_hunk_lines,
        });
    }

    hunks
}

/// Compute diff between two texts using Myers algorithm
///
/// Returns a JSON string containing the diff hunks.
///
/// # Arguments
/// * `old_text` - Original text
/// * `new_text` - Modified text
/// * `context_lines` - Number of context lines to show around changes (default: 3)
///
/// # Returns
/// JSON string with diff hunks or error message
#[wasm_bindgen]
pub fn myers_diff(old_text: &str, new_text: &str, context_lines: usize) -> String {
    // Split into lines
    let old_lines: Vec<&str> = old_text.lines().collect();
    let new_lines: Vec<&str> = new_text.lines().collect();

    // Run Myers algorithm
    let myers = MyersDiff::new(&old_lines, &new_lines);
    let edits = myers.compute();

    // Convert to hunks
    let hunks = edits_to_hunks(&old_lines, &new_lines, &edits, context_lines);

    // Serialize to JSON
    match serde_json::to_string(&hunks) {
        Ok(json) => json,
        Err(e) => format!("{{\"error\": \"{}\"}}", e),
    }
}

/// Get diff statistics
///
/// Returns JSON with statistics: additions, deletions, total changes
#[wasm_bindgen]
pub fn diff_stats(old_text: &str, new_text: &str) -> String {
    let old_lines: Vec<&str> = old_text.lines().collect();
    let new_lines: Vec<&str> = new_text.lines().collect();

    let myers = MyersDiff::new(&old_lines, &new_lines);
    let edits = myers.compute();

    let mut additions = 0;
    let mut deletions = 0;

    for edit in edits {
        match edit {
            Edit::Insert(_) => additions += 1,
            Edit::Delete(_) => deletions += 1,
            Edit::Keep(_, _) => {}
        }
    }

    format!(
        "{{\"additions\": {}, \"deletions\": {}, \"total\": {}}}",
        additions,
        deletions,
        additions + deletions
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_myers_simple() {
        let old = "a\nb\nc\n";
        let new = "a\nx\nc\n";

        let result = myers_diff(old, new, 3);
        assert!(result.contains("\"type\":\"removed\""));
        assert!(result.contains("\"type\":\"added\""));
    }

    #[test]
    fn test_myers_additions() {
        let old = "a\nb\n";
        let new = "a\nb\nc\n";

        let result = myers_diff(old, new, 3);
        assert!(result.contains("\"type\":\"added\""));
    }

    #[test]
    fn test_myers_deletions() {
        let old = "a\nb\nc\n";
        let new = "a\nc\n";

        let result = myers_diff(old, new, 3);
        assert!(result.contains("\"type\":\"removed\""));
    }

    #[test]
    fn test_myers_no_changes() {
        let old = "a\nb\nc\n";
        let new = "a\nb\nc\n";

        let result = myers_diff(old, new, 3);
        assert_eq!(result, "[]");
    }

    #[test]
    fn test_diff_stats() {
        let old = "a\nb\nc\n";
        let new = "a\nx\nc\nd\n";

        let result = diff_stats(old, new);
        assert!(result.contains("\"additions\": 2"));
        assert!(result.contains("\"deletions\": 1"));
    }
}
