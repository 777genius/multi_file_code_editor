#!/bin/bash

# Build script for Git Diff WASM module
set -e

echo "🦀 Building Git Diff WASM module..."

# Check if wasm-pack is installed
if ! command -v wasm-pack &> /dev/null; then
    echo "❌ wasm-pack not found. Installing..."
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

# Check if wasm32 target is installed
if ! rustup target list | grep -q "wasm32-unknown-unknown (installed)"; then
    echo "📦 Installing wasm32-unknown-unknown target..."
    rustup target add wasm32-unknown-unknown
fi

# Clean previous build
echo "🧹 Cleaning previous build..."
rm -rf pkg/
rm -rf target/

# Build for release
echo "🔨 Building release version..."
wasm-pack build \
    --target web \
    --release \
    --out-dir pkg

# Optimize with wasm-opt if available
if command -v wasm-opt &> /dev/null; then
    echo "⚡ Optimizing WASM binary with wasm-opt..."
    wasm-opt -Oz \
        --enable-mutable-globals \
        pkg/git_diff_wasm_bg.wasm \
        -o pkg/git_diff_wasm_bg.wasm
fi

# Show binary size
echo "📊 Binary sizes:"
ls -lh pkg/*.wasm | awk '{print $5, $9}'

# Gzip for comparison
gzip -c pkg/git_diff_wasm_bg.wasm > pkg/git_diff_wasm_bg.wasm.gz
echo "📦 Gzipped size: $(ls -lh pkg/git_diff_wasm_bg.wasm.gz | awk '{print $5}')"
rm pkg/git_diff_wasm_bg.wasm.gz

# Copy to assets directory
echo "📂 Copying to Flutter assets..."
mkdir -p ../assets/wasm/
cp pkg/git_diff_wasm_bg.wasm ../assets/wasm/
cp pkg/git_diff_wasm.js ../assets/wasm/

echo "✅ Build complete!"
echo ""
echo "Output files:"
echo "  - pkg/git_diff_wasm_bg.wasm (WASM binary)"
echo "  - pkg/git_diff_wasm.js (JS bindings)"
echo "  - ../assets/wasm/ (copied to Flutter assets)"
