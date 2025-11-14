// Infrastructure - WASM memory management

use serde::Serialize;
use std::sync::Mutex;
use std::collections::HashMap;

// Global memory registry to prevent GC collection
static MEMORY_REGISTRY: Mutex<Option<HashMap<u32, Vec<u8>>>> = Mutex::new(None);

fn get_registry() -> &'static Mutex<Option<HashMap<u32, Vec<u8>>>> {
    &MEMORY_REGISTRY
}

fn ensure_registry_initialized() {
    let mut guard = MEMORY_REGISTRY.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
}

/// Allocate memory in WASM linear memory
#[no_mangle]
pub extern "C" fn alloc(size: u32) -> u32 {
    ensure_registry_initialized();

    let buf = vec![0u8; size as usize];
    let ptr = buf.as_ptr() as u32;

    // Store in registry to prevent GC
    let mut guard = MEMORY_REGISTRY.lock().unwrap();
    if let Some(ref mut registry) = *guard {
        registry.insert(ptr, buf);
    }

    ptr
}

/// Deallocate memory
#[no_mangle]
pub extern "C" fn dealloc(ptr: u32) {
    let mut guard = MEMORY_REGISTRY.lock().unwrap();
    if let Some(ref mut registry) = *guard {
        registry.remove(&ptr);
    }
}

/// Serialize data and pack pointer + length into u64
pub fn serialize_and_pack<T: Serialize>(data: &T) -> u64 {
    // Serialize using MessagePack
    let bytes = match rmp_serde::to_vec(data) {
        Ok(b) => b,
        Err(err) => {
            eprintln!("Serialization error: {}", err);
            return 0;
        }
    };

    if bytes.is_empty() {
        return 0;
    }

    // Allocate memory
    let ptr = alloc(bytes.len() as u32);

    // Copy data to allocated memory
    unsafe {
        std::ptr::copy_nonoverlapping(
            bytes.as_ptr(),
            ptr as *mut u8,
            bytes.len(),
        );
    }

    // Store bytes in registry to prevent GC
    let mut guard = MEMORY_REGISTRY.lock().unwrap();
    if let Some(ref mut registry) = *guard {
        registry.insert(ptr, bytes);
    }

    // Pack: (ptr << 32) | length
    ((ptr as u64) << 32) | (bytes.len() as u64)
}

/// Read data from WASM memory
pub fn read_memory(ptr: u32, len: u32) -> Vec<u8> {
    unsafe {
        std::slice::from_raw_parts(ptr as *const u8, len as usize).to_vec()
    }
}
