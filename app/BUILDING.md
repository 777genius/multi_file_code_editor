# 🔨 Building Flutter IDE

Comprehensive guide for building the entire project from source.

---

## 📋 Prerequisites

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| **Flutter SDK** | ≥3.8.0 | Dart/Flutter app compilation |
| **Rust** | ≥1.70.0 | Native editor & LSP bridge |
| **Dart SDK** | ≥3.8.0 | Included with Flutter |
| **Git** | Any | Version control |

### Platform-Specific Requirements

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
  curl \
  git \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

#### macOS
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install curl git

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

#### Windows
```powershell
# Install Rust
# Download from: https://www.rust-lang.org/tools/install
# Run: rustup-init.exe

# Install Flutter
# Download from: https://docs.flutter.dev/get-started/install/windows
# Extract and add to PATH

# Install Visual Studio Build Tools
# Download from: https://visualstudio.microsoft.com/downloads/
# Select: "Desktop development with C++"
```

---

## 🚀 Quick Build (One Command)

```bash
cd app
make build-all
```

This will:
1. Build Rust components (editor_native, lsp_bridge)
2. Install Flutter dependencies
3. Generate MobX code
4. Build Flutter app for current platform

---

## 📦 Step-by-Step Build

### Step 1: Clone Repository

```bash
git clone https://github.com/yourusername/multi_editor_flutter.git
cd multi_editor_flutter
```

### Step 2: Build Rust Components

#### 2a. Build Native Editor (Rust)

```bash
cd app/modules/editor_native
cargo build --release
```

**Output:**
- Linux: `target/release/libeditor_native.so`
- macOS: `target/release/libeditor_native.dylib`
- Windows: `target\release\editor_native.dll`

**Verify:**
```bash
# Linux/macOS
ls -lh target/release/libeditor_native.*

# Windows
dir target\release\editor_native.dll
```

#### 2b. Build LSP Bridge (Rust)

```bash
cd ../lsp_bridge
cargo build --release
```

**Output:**
- Linux/macOS: `target/release/lsp_bridge`
- Windows: `target\release\lsp_bridge.exe`

**Verify:**
```bash
# Linux/macOS
./target/release/lsp_bridge --version

# Windows
.\target\release\lsp_bridge.exe --version
```

### Step 3: Install Flutter Dependencies

```bash
cd ../../..  # Back to app directory
flutter pub get
```

Or using melos (if installed):
```bash
cd ..  # Back to project root
melos bootstrap
```

### Step 4: Generate MobX Code

```bash
cd app/modules/ide_presentation
dart run build_runner build --delete-conflicting-outputs
```

**This generates:**
- `editor_store.g.dart`
- `lsp_store.g.dart`

**Verify:**
```bash
ls -l lib/src/stores/editor/editor_store.g.dart
ls -l lib/src/stores/lsp/lsp_store.g.dart
```

### Step 5: Build Flutter App

#### Linux
```bash
cd ../..  # Back to app directory
flutter build linux --release
```

**Output:** `build/linux/x64/release/bundle/`

#### macOS
```bash
flutter build macos --release
```

**Output:** `build/macos/Build/Products/Release/flutter_ide_app.app`

#### Windows
```bash
flutter build windows --release
```

**Output:** `build\windows\x64\runner\Release\`

#### Web
```bash
flutter build web --release
```

**Output:** `build/web/`

---

## 🔧 Makefile Commands

The app includes a comprehensive Makefile with 40+ commands:

### Setup & Install
```bash
make setup          # Full setup (dependencies + code generation)
make deps           # Install all dependencies
make codegen        # Generate MobX code
```

### Build Commands
```bash
make build-rust         # Build all Rust components
make build-editor       # Build editor_native only
make build-lsp-bridge   # Build lsp_bridge only

make build-linux        # Build Flutter app for Linux
make build-macos        # Build Flutter app for macOS
make build-windows      # Build Flutter app for Windows
make build-web          # Build Flutter app for Web
make build-all          # Build everything
```

### Run Commands
```bash
make run-dev            # Run Flutter app in development mode
make run-release        # Run Flutter app in release mode
make run-lsp-bridge     # Run LSP Bridge server
make quickstart         # One-command dev start (LSP Bridge + Flutter)
```

### Clean Commands
```bash
make clean              # Clean Flutter build artifacts
make clean-rust         # Clean Rust build artifacts
make clean-all          # Clean everything
make reset              # Nuclear option - full reset
```

### Quality Commands
```bash
make test               # Run all tests
make test-coverage      # Run tests with coverage
make lint               # Run linter
make format             # Format code
make analyze            # Analyze code
```

### Help
```bash
make help               # Show all available commands
```

---

## 🐛 Troubleshooting

### Issue: "cargo: command not found"

**Solution:**
```bash
# Add Rust to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.cargo/bin:$PATH"
source ~/.bashrc  # or source ~/.zshrc
```

### Issue: "flutter: command not found"

**Solution:**
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Verify
flutter doctor
```

### Issue: "libeditor_native.so: cannot open shared object file"

**Solution:**
```bash
# Linux: Add library to path
export LD_LIBRARY_PATH="$PWD/app/modules/editor_native/target/release:$LD_LIBRARY_PATH"

# Or copy to system library directory
sudo cp app/modules/editor_native/target/release/libeditor_native.so /usr/local/lib/
sudo ldconfig
```

### Issue: MobX code generation fails

**Solution:**
```bash
cd app/modules/ide_presentation

# Clean and rebuild
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Rust build fails with linker errors

**Linux Solution:**
```bash
# Install required development packages
sudo apt-get install build-essential pkg-config libssl-dev
```

**macOS Solution:**
```bash
# Install Xcode Command Line Tools
xcode-select --install
```

**Windows Solution:**
```powershell
# Install Visual Studio Build Tools
# Select "Desktop development with C++"
```

### Issue: LSP Bridge won't start

**Solution:**
```bash
# Check if port 9999 is already in use
lsof -i :9999  # Linux/macOS
netstat -ano | findstr :9999  # Windows

# Kill process if needed
kill -9 <PID>  # Linux/macOS
taskkill /PID <PID> /F  # Windows

# Start with different port
./target/release/lsp_bridge --port 9998
```

---

## 📊 Build Verification

After building, verify all components:

### 1. Verify Rust Libraries

```bash
# Linux
ldd app/modules/editor_native/target/release/libeditor_native.so

# macOS
otool -L app/modules/editor_native/target/release/libeditor_native.dylib

# Windows
dumpbin /dependents app\modules\editor_native\target\release\editor_native.dll
```

### 2. Verify Flutter Build

```bash
flutter doctor -v
flutter analyze
flutter test
```

### 3. Verify LSP Bridge

```bash
cd app/modules/lsp_bridge
cargo test
./target/release/lsp_bridge --help
```

---

## 🎯 Build Targets

### Development Build
```bash
# Fast builds, debug symbols, hot reload
make quickstart
```

**Features:**
- Debug symbols included
- Assertions enabled
- Hot reload supported
- Slower performance

### Release Build
```bash
# Optimized builds, no debug symbols
make build-all
```

**Features:**
- Fully optimized
- No debug symbols
- Smaller binary size
- Maximum performance

### Profile Build
```bash
flutter build <platform> --profile
```

**Features:**
- Some optimizations
- Performance tracing enabled
- Useful for profiling

---

## 🔄 Continuous Integration

### GitHub Actions Example

```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'
          channel: 'stable'

      - name: Setup Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable

      - name: Build
        run: |
          cd app
          make build-all

      - name: Test
        run: |
          cd app
          make test
```

---

## 📝 Build Times (Approximate)

| Component | Cold Build | Warm Build |
|-----------|-----------|-----------|
| editor_native (Rust) | 3-5 min | 30-60 sec |
| lsp_bridge (Rust) | 2-3 min | 20-40 sec |
| MobX Generation | 30-60 sec | 10-20 sec |
| Flutter App | 2-4 min | 30-60 sec |
| **Total** | **8-13 min** | **2-3 min** |

---

## ✅ Success Checklist

After building, you should have:

- [x] Rust libraries compiled
  - [ ] `libeditor_native.so/.dylib/.dll`
  - [ ] `lsp_bridge` executable
- [x] MobX code generated
  - [ ] `editor_store.g.dart`
  - [ ] `lsp_store.g.dart`
- [x] Flutter app built
  - [ ] Platform-specific bundle
- [x] No compilation errors
- [x] All tests passing

---

## 🎓 Architecture Overview

Understanding the build process:

```
Rust Components (FFI)          Flutter App
┌─────────────────────┐       ┌──────────────────┐
│  editor_native      │←──────│  editor_ffi      │
│  (ropey, tree-sit.) │  FFI  │  (Dart bindings) │
└─────────────────────┘       └──────────────────┘
                                       ↓
┌─────────────────────┐       ┌──────────────────┐
│  lsp_bridge         │←──────│ lsp_infrastructure│
│  (WebSocket proxy)  │  WS   │ (WebSocket client)│
└─────────────────────┘       └──────────────────┘
```

---

## 💡 Tips & Best Practices

1. **Always build Rust in release mode** for production
   ```bash
   cargo build --release  # NOT cargo build
   ```

2. **Use make commands** for consistency
   ```bash
   make build-all  # Recommended
   # vs manual steps
   ```

3. **Clean between major changes**
   ```bash
   make clean-all
   make build-all
   ```

4. **Watch mode for development**
   ```bash
   # Terminal 1: Watch Rust
   cargo watch -x 'build --release'

   # Terminal 2: Watch Flutter
   flutter run
   ```

5. **Parallel builds** for faster compilation
   ```bash
   # Use all CPU cores
   cargo build --release -j$(nproc)  # Linux
   cargo build --release -j$(sysctl -n hw.ncpu)  # macOS
   ```

---

**Happy Building!** 🚀

All commands tested on Ubuntu 22.04, macOS 13, Windows 11.
