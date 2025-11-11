module github.com/777genius/multi_editor_flutter/symbol_navigator_wasm

go 1.21

require (
	github.com/malivvan/tree-sitter v0.0.0-20240101000000-000000000000
	github.com/vmihailenco/msgpack/v5 v5.4.1
)

require (
	github.com/vmihailenco/tagparser/v2 v2.0.0 // indirect
)

// Use latest tree-sitter when available
// replace github.com/malivvan/tree-sitter => github.com/malivvan/tree-sitter latest
