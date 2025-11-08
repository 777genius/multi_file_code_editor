//! FFI tests for editor_native
//!
//! These tests verify that the C FFI interface works correctly
//! and that all unsafe operations are sound.

use super::*;
use std::ffi::CString;

// ============================================================
// Helper Functions
// ============================================================

unsafe fn create_c_string(s: &str) -> *const c_char {
    CString::new(s).unwrap().into_raw()
}

unsafe fn free_c_string(ptr: *const c_char) {
    if !ptr.is_null() {
        drop(CString::from_raw(ptr as *mut c_char));
    }
}

unsafe fn c_string_to_rust(ptr: *const c_char) -> String {
    CStr::from_ptr(ptr).to_str().unwrap().to_string()
}

// ============================================================
// Lifecycle Tests
// ============================================================

#[test]
fn test_ffi_editor_new() {
    unsafe {
        let handle = editor_new();
        assert!(!handle.is_null());
        editor_free(handle);
    }
}

#[test]
fn test_ffi_editor_with_content() {
    unsafe {
        let content = create_c_string("Hello World");
        let language = create_c_string("rust");

        let handle = editor_with_content(content, language);
        assert!(!handle.is_null());

        editor_free(handle);
        free_c_string(content);
        free_c_string(language);
    }
}

#[test]
fn test_ffi_editor_with_content_null_content() {
    unsafe {
        let language = create_c_string("rust");
        let handle = editor_with_content(ptr::null(), language);
        assert!(handle.is_null());
        free_c_string(language);
    }
}

#[test]
fn test_ffi_editor_with_content_null_language() {
    unsafe {
        let content = create_c_string("Hello");
        let handle = editor_with_content(content, ptr::null());
        assert!(handle.is_null());
        free_c_string(content);
    }
}

#[test]
fn test_ffi_editor_free_null() {
    unsafe {
        // Should not crash
        editor_free(ptr::null_mut());
    }
}

// ============================================================
// Content Operations Tests
// ============================================================

#[test]
fn test_ffi_get_content() {
    unsafe {
        let handle = editor_new();
        let content_ptr = editor_get_content(handle);
        assert!(!content_ptr.is_null());

        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "");

        editor_free_string(content_ptr);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_get_content_null_handle() {
    unsafe {
        let content_ptr = editor_get_content(ptr::null_mut());
        assert!(content_ptr.is_null());
    }
}

#[test]
fn test_ffi_set_content() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Hello World");

        let result = editor_set_content(handle, content);
        assert_eq!(result as i32, ResultCode::Success as i32);

        let content_ptr = editor_get_content(handle);
        let retrieved = c_string_to_rust(content_ptr);
        assert_eq!(retrieved, "Hello World");

        editor_free_string(content_ptr);
        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_set_content_null_handle() {
    unsafe {
        let content = create_c_string("Hello");
        let result = editor_set_content(ptr::null_mut(), content);
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
        free_c_string(content);
    }
}

#[test]
fn test_ffi_set_content_null_content() {
    unsafe {
        let handle = editor_new();
        let result = editor_set_content(handle, ptr::null());
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_insert_text() {
    unsafe {
        let handle = editor_new();
        let text1 = create_c_string("Hello, ");
        let text2 = create_c_string("World!");

        assert_eq!(editor_insert_text(handle, text1) as i32, ResultCode::Success as i32);
        assert_eq!(editor_insert_text(handle, text2) as i32, ResultCode::Success as i32);

        let content_ptr = editor_get_content(handle);
        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "Hello, World!");

        editor_free_string(content_ptr);
        free_c_string(text1);
        free_c_string(text2);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_insert_text_null_handle() {
    unsafe {
        let text = create_c_string("Hello");
        let result = editor_insert_text(ptr::null_mut(), text);
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
        free_c_string(text);
    }
}

#[test]
fn test_ffi_delete() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Hello World");
        editor_set_content(handle, content);

        editor_move_cursor(handle, 0, 5);
        let result = editor_delete(handle);
        assert_eq!(result as i32, ResultCode::Success as i32);

        let content_ptr = editor_get_content(handle);
        let new_content = c_string_to_rust(content_ptr);
        assert_eq!(new_content, "HelloWorld");

        editor_free_string(content_ptr);
        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_delete_null_handle() {
    unsafe {
        let result = editor_delete(ptr::null_mut());
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
    }
}

// ============================================================
// Cursor & Selection Tests
// ============================================================

#[test]
fn test_ffi_get_cursor() {
    unsafe {
        let handle = editor_new();
        let mut line: usize = 999;
        let mut column: usize = 999;

        let result = editor_get_cursor(handle, &mut line, &mut column);
        assert_eq!(result as i32, ResultCode::Success as i32);
        assert_eq!(line, 0);
        assert_eq!(column, 0);

        editor_free(handle);
    }
}

#[test]
fn test_ffi_get_cursor_null_handle() {
    unsafe {
        let mut line: usize = 0;
        let mut column: usize = 0;
        let result = editor_get_cursor(ptr::null_mut(), &mut line, &mut column);
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
    }
}

#[test]
fn test_ffi_get_cursor_null_outputs() {
    unsafe {
        let handle = editor_new();
        let result = editor_get_cursor(handle, ptr::null_mut(), ptr::null_mut());
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_move_cursor() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Hello World");
        editor_set_content(handle, content);

        let result = editor_move_cursor(handle, 0, 5);
        assert_eq!(result as i32, ResultCode::Success as i32);

        let mut line: usize = 0;
        let mut column: usize = 0;
        editor_get_cursor(handle, &mut line, &mut column);
        assert_eq!(line, 0);
        assert_eq!(column, 5);

        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_move_cursor_null_handle() {
    unsafe {
        let result = editor_move_cursor(ptr::null_mut(), 0, 5);
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
    }
}

#[test]
fn test_ffi_set_selection() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Hello World");
        editor_set_content(handle, content);

        let result = editor_set_selection(handle, 0, 0, 0, 5);
        assert_eq!(result as i32, ResultCode::Success as i32);

        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_set_selection_null_handle() {
    unsafe {
        let result = editor_set_selection(ptr::null_mut(), 0, 0, 0, 5);
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
    }
}

#[test]
fn test_ffi_clear_selection() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Hello World");
        editor_set_content(handle, content);

        editor_set_selection(handle, 0, 0, 0, 5);
        let result = editor_clear_selection(handle);
        assert_eq!(result as i32, ResultCode::Success as i32);

        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_clear_selection_null_handle() {
    unsafe {
        let result = editor_clear_selection(ptr::null_mut());
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
    }
}

// ============================================================
// Undo/Redo Tests
// ============================================================

#[test]
fn test_ffi_undo_redo() {
    unsafe {
        let handle = editor_new();
        let text1 = create_c_string("Hello");
        let text2 = create_c_string(" World");

        editor_insert_text(handle, text1);
        editor_insert_text(handle, text2);

        // Undo
        let result = editor_undo(handle);
        assert_eq!(result, 1); // Success

        let content_ptr = editor_get_content(handle);
        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "Hello");
        editor_free_string(content_ptr);

        // Redo
        let result = editor_redo(handle);
        assert_eq!(result, 1); // Success

        let content_ptr = editor_get_content(handle);
        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "Hello World");
        editor_free_string(content_ptr);

        free_c_string(text1);
        free_c_string(text2);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_undo_empty_stack() {
    unsafe {
        let handle = editor_new();
        let result = editor_undo(handle);
        assert_eq!(result, 0); // Nothing to undo
        editor_free(handle);
    }
}

#[test]
fn test_ffi_redo_empty_stack() {
    unsafe {
        let handle = editor_new();
        let result = editor_redo(handle);
        assert_eq!(result, 0); // Nothing to redo
        editor_free(handle);
    }
}

#[test]
fn test_ffi_undo_null_handle() {
    unsafe {
        let result = editor_undo(ptr::null_mut());
        assert_eq!(result, -1); // Error
    }
}

#[test]
fn test_ffi_redo_null_handle() {
    unsafe {
        let result = editor_redo(ptr::null_mut());
        assert_eq!(result, -1); // Error
    }
}

// ============================================================
// Language Tests
// ============================================================

#[test]
fn test_ffi_set_language() {
    unsafe {
        let handle = editor_new();
        let language = create_c_string("rust");

        let result = editor_set_language(handle, language);
        assert_eq!(result as i32, ResultCode::Success as i32);

        free_c_string(language);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_set_language_null_handle() {
    unsafe {
        let language = create_c_string("rust");
        let result = editor_set_language(ptr::null_mut(), language);
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
        free_c_string(language);
    }
}

#[test]
fn test_ffi_set_language_null_language() {
    unsafe {
        let handle = editor_new();
        let result = editor_set_language(handle, ptr::null());
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
        editor_free(handle);
    }
}

// ============================================================
// Metadata Tests
// ============================================================

#[test]
fn test_ffi_line_count() {
    unsafe {
        let handle = editor_new();
        let count = editor_line_count(handle);
        assert_eq!(count, 1); // Empty editor has 1 line

        let content = create_c_string("Line 1\nLine 2\nLine 3");
        editor_set_content(handle, content);

        let count = editor_line_count(handle);
        assert_eq!(count, 3);

        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_line_count_null_handle() {
    unsafe {
        let count = editor_line_count(ptr::null_mut());
        assert_eq!(count, 0);
    }
}

#[test]
fn test_ffi_get_line() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Line 1\nLine 2\nLine 3");
        editor_set_content(handle, content);

        let line_ptr = editor_get_line(handle, 1);
        assert!(!line_ptr.is_null());

        let line = c_string_to_rust(line_ptr);
        assert_eq!(line, "Line 2\n");

        editor_free_string(line_ptr);
        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_get_line_null_handle() {
    unsafe {
        let line_ptr = editor_get_line(ptr::null_mut(), 0);
        assert!(line_ptr.is_null());
    }
}

#[test]
fn test_ffi_get_line_out_of_bounds() {
    unsafe {
        let handle = editor_new();
        let content = create_c_string("Hello");
        editor_set_content(handle, content);

        let line_ptr = editor_get_line(handle, 100);
        assert!(line_ptr.is_null());

        free_c_string(content);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_is_dirty() {
    unsafe {
        let handle = editor_new();

        // Initially not dirty
        assert_eq!(editor_is_dirty(handle), 0);

        // Insert text makes it dirty
        let text = create_c_string("Hello");
        editor_insert_text(handle, text);
        assert_eq!(editor_is_dirty(handle), 1);

        // Mark saved makes it clean
        editor_mark_saved(handle);
        assert_eq!(editor_is_dirty(handle), 0);

        free_c_string(text);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_is_dirty_null_handle() {
    unsafe {
        let result = editor_is_dirty(ptr::null_mut());
        assert_eq!(result, 0);
    }
}

#[test]
fn test_ffi_mark_saved() {
    unsafe {
        let handle = editor_new();
        let text = create_c_string("Hello");
        editor_insert_text(handle, text);

        assert_eq!(editor_is_dirty(handle), 1);

        let result = editor_mark_saved(handle);
        assert_eq!(result as i32, ResultCode::Success as i32);
        assert_eq!(editor_is_dirty(handle), 0);

        free_c_string(text);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_mark_saved_null_handle() {
    unsafe {
        let result = editor_mark_saved(ptr::null_mut());
        assert_eq!(result as i32, ResultCode::ErrorNull as i32);
    }
}

// ============================================================
// Memory Management Tests
// ============================================================

#[test]
fn test_ffi_free_string_null() {
    unsafe {
        // Should not crash
        editor_free_string(ptr::null_mut());
    }
}

// ============================================================
// Complex Integration Tests
// ============================================================

#[test]
fn test_ffi_full_editing_workflow() {
    unsafe {
        // Create editor
        let handle = editor_new();
        assert!(!handle.is_null());

        // Set language
        let language = create_c_string("rust");
        assert_eq!(editor_set_language(handle, language) as i32, ResultCode::Success as i32);

        // Insert text
        let text1 = create_c_string("fn main() {\n");
        let text2 = create_c_string("    println!(\"Hello\");\n");
        let text3 = create_c_string("}");

        editor_insert_text(handle, text1);
        editor_insert_text(handle, text2);
        editor_insert_text(handle, text3);

        // Verify content
        let content_ptr = editor_get_content(handle);
        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "fn main() {\n    println!(\"Hello\");\n}");
        editor_free_string(content_ptr);

        // Verify line count
        assert_eq!(editor_line_count(handle), 3);

        // Verify dirty flag
        assert_eq!(editor_is_dirty(handle), 1);

        // Mark saved
        editor_mark_saved(handle);
        assert_eq!(editor_is_dirty(handle), 0);

        // Test undo
        assert_eq!(editor_undo(handle), 1);
        let content_ptr = editor_get_content(handle);
        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "fn main() {\n    println!(\"Hello\");\n");
        editor_free_string(content_ptr);

        // Test redo
        assert_eq!(editor_redo(handle), 1);
        let content_ptr = editor_get_content(handle);
        let content = c_string_to_rust(content_ptr);
        assert_eq!(content, "fn main() {\n    println!(\"Hello\");\n}");
        editor_free_string(content_ptr);

        // Cleanup
        free_c_string(language);
        free_c_string(text1);
        free_c_string(text2);
        free_c_string(text3);
        editor_free(handle);
    }
}

#[test]
fn test_ffi_multiple_editors() {
    unsafe {
        // Create multiple editors
        let handle1 = editor_new();
        let handle2 = editor_new();
        let handle3 = editor_new();

        assert!(!handle1.is_null());
        assert!(!handle2.is_null());
        assert!(!handle3.is_null());

        // Set different content in each
        let content1 = create_c_string("Editor 1");
        let content2 = create_c_string("Editor 2");
        let content3 = create_c_string("Editor 3");

        editor_set_content(handle1, content1);
        editor_set_content(handle2, content2);
        editor_set_content(handle3, content3);

        // Verify each editor has correct content
        let ptr1 = editor_get_content(handle1);
        let ptr2 = editor_get_content(handle2);
        let ptr3 = editor_get_content(handle3);

        assert_eq!(c_string_to_rust(ptr1), "Editor 1");
        assert_eq!(c_string_to_rust(ptr2), "Editor 2");
        assert_eq!(c_string_to_rust(ptr3), "Editor 3");

        // Cleanup
        editor_free_string(ptr1);
        editor_free_string(ptr2);
        editor_free_string(ptr3);
        free_c_string(content1);
        free_c_string(content2);
        free_c_string(content3);
        editor_free(handle1);
        editor_free(handle2);
        editor_free(handle3);
    }
}
