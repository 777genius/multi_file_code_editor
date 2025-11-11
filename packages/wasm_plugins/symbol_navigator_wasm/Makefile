# ============================================================================
# Symbol Navigator WASM Plugin - Makefile
# ============================================================================

PLUGIN_NAME := symbol_navigator
WASM_OUT := $(PLUGIN_NAME).wasm
BUILD_DIR := build

# Go compiler flags for WASM
GOOS := wasip1
GOARCH := wasm
GO_BUILD_FLAGS := -ldflags="-s -w" -trimpath

# Optimization flags
WASM_OPT_FLAGS := -O3 --enable-bulk-memory

.PHONY: all build clean test deps help

# Default target
all: build

# Build WASM plugin
build: deps
	@echo "Building $(PLUGIN_NAME) WASM plugin..."
	@mkdir -p $(BUILD_DIR)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build $(GO_BUILD_FLAGS) -o $(BUILD_DIR)/$(WASM_OUT) .
	@echo "✓ Built $(BUILD_DIR)/$(WASM_OUT)"
	@ls -lh $(BUILD_DIR)/$(WASM_OUT)

# Build with optimization (requires wasm-opt from binaryen)
build-opt: build
	@echo "Optimizing WASM..."
	@if command -v wasm-opt >/dev/null 2>&1; then \
		wasm-opt $(WASM_OPT_FLAGS) $(BUILD_DIR)/$(WASM_OUT) -o $(BUILD_DIR)/$(WASM_OUT).opt; \
		mv $(BUILD_DIR)/$(WASM_OUT).opt $(BUILD_DIR)/$(WASM_OUT); \
		echo "✓ Optimized $(BUILD_DIR)/$(WASM_OUT)"; \
		ls -lh $(BUILD_DIR)/$(WASM_OUT); \
	else \
		echo "⚠ wasm-opt not found, skipping optimization"; \
		echo "  Install binaryen: brew install binaryen (macOS) or apt install binaryen (Linux)"; \
	fi

# Download dependencies
deps:
	@echo "Downloading Go dependencies..."
	@go mod download
	@go mod tidy
	@echo "✓ Dependencies ready"

# Run tests
test:
	@echo "Running tests..."
	@go test ./... -v

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Clean complete"

# Verify WASM module
verify: build
	@echo "Verifying WASM module..."
	@if command -v wasm-validate >/dev/null 2>&1; then \
		wasm-validate $(BUILD_DIR)/$(WASM_OUT) && echo "✓ WASM module is valid"; \
	else \
		echo "⚠ wasm-validate not found (install wabt toolkit)"; \
	fi

# Show exported functions
inspect: build
	@echo "Inspecting WASM exports..."
	@if command -v wasm-objdump >/dev/null 2>&1; then \
		wasm-objdump -x $(BUILD_DIR)/$(WASM_OUT) | grep -A 20 "Export\["; \
	else \
		echo "⚠ wasm-objdump not found (install wabt toolkit)"; \
	fi

# Development build (with debug symbols)
dev:
	@echo "Building dev version..."
	@mkdir -p $(BUILD_DIR)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(BUILD_DIR)/$(WASM_OUT) .
	@echo "✓ Dev build complete"
	@ls -lh $(BUILD_DIR)/$(WASM_OUT)

# Install to Flutter project
install: build
	@echo "Installing WASM plugin to Flutter project..."
	@DEST_DIR="../../../modules/plugins/multi_editor_plugin_symbol_navigator/wasm"; \
	mkdir -p $$DEST_DIR; \
	cp $(BUILD_DIR)/$(WASM_OUT) $$DEST_DIR/; \
	echo "✓ Installed to $$DEST_DIR/$(WASM_OUT)"

# Show help
help:
	@echo "Symbol Navigator WASM Plugin - Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make build      - Build WASM plugin"
	@echo "  make build-opt  - Build with optimization (requires wasm-opt)"
	@echo "  make dev        - Build development version with debug symbols"
	@echo "  make test       - Run tests"
	@echo "  make clean      - Remove build artifacts"
	@echo "  make verify     - Validate WASM module"
	@echo "  make inspect    - Show exported functions"
	@echo "  make install    - Install to Flutter project"
	@echo "  make deps       - Download dependencies"
	@echo "  make help       - Show this help"
	@echo ""
	@echo "Requirements:"
	@echo "  - Go 1.21+"
	@echo "  - Optional: binaryen (wasm-opt)"
	@echo "  - Optional: wabt (wasm-validate, wasm-objdump)"
