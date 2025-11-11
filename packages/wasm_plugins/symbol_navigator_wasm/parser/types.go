package parser

// Symbol represents a code symbol (class, function, method, field, etc.)
type Symbol struct {
	Name     string   `msgpack:"name"`
	Kind     string   `msgpack:"kind"`
	Location Location `msgpack:"location"`
	Parent   string   `msgpack:"parent,omitempty"`
	Children []Symbol `msgpack:"children,omitempty"`
	Metadata map[string]interface{} `msgpack:"metadata,omitempty"`
}

// Location represents the position of a symbol in source code
type Location struct {
	StartLine   int `msgpack:"start_line"`
	StartColumn int `msgpack:"start_column"`
	EndLine     int `msgpack:"end_line"`
	EndColumn   int `msgpack:"end_column"`
	StartOffset int `msgpack:"start_offset"`
	EndOffset   int `msgpack:"end_offset"`
}

// SymbolKind constants matching Dart enum
const (
	// Classes and types
	KindClass         = "class_declaration"
	KindAbstractClass = "abstract_class"
	KindMixin         = "mixin"
	KindExtension     = "extension"
	KindEnum          = "enum_declaration"
	KindTypedef       = "typedef"

	// Functions and methods
	KindFunction    = "function"
	KindMethod      = "method"
	KindConstructor = "constructor"
	KindGetter      = "getter"
	KindSetter      = "setter"

	// Fields and variables
	KindField    = "field"
	KindProperty = "property"
	KindConstant = "constant"
	KindVariable = "variable"

	// Other
	KindEnumValue = "enum_value"
	KindParameter = "parameter"
)

// Language identifiers
const (
	LangDart       = "dart"
	LangJavaScript = "javascript"
	LangTypeScript = "typescript"
	LangPython     = "python"
	LangGo         = "go"
	LangRust       = "rust"
)
