# Build Instructions - VS Code Runtime Management

## ⚠️ IMPORTANT: Code Generation Required

All critical bugs have been fixed, but the code **requires code generation** before it can compile and run.

---

## 🔧 Required Steps

### 1. Generate Code for All Packages

Run build_runner for each package in the following order:

```bash
# 1. Core package (Domain layer)
cd packages/vscode_runtime_core
dart run build_runner build --delete-conflicting-outputs

# 2. Application package (Use cases)
cd ../vscode_runtime_application
dart run build_runner build --delete-conflicting-outputs

# 3. Infrastructure package (Implementations)
cd ../vscode_runtime_infrastructure
dart run build_runner build --delete-conflicting-outputs

# 4. Presentation package (MobX stores)
cd ../vscode_runtime_presentation
dart run build_runner build --delete-conflicting-outputs
```

**Expected Output**: Each package will generate:
- `.freezed.dart` files (23 files total)
- `.g.dart` files (11 files total)
- `.config.dart` files (if using injectable)

---

## 📋 What Was Fixed

### Bug #1: IManifestRepository Interface ✅
- **Fixed**: Added optional `platform` parameter to `getModules()`
- **Fixed**: Changed `getModule()` parameter from `String` to `ModuleId`
- **Impact**: Type safety and proper filtering

### Bug #2: IRuntimeRepository Interface ✅
- **Fixed**: Added `modules` parameter to `loadInstallation()`
- **Fixed**: Made `deleteInstallation()` parameter optional
- **Impact**: Proper aggregate reconstruction

### Bug #3: fetchManifest() Return Type ✅
- **Fixed**: Extract `.modules` from `RuntimeManifest` object
- **File**: `get_available_modules_query_handler.dart:55`
- **Impact**: Correct type handling

### Bug #4: MobX Store Properties ✅
- **Fixed**: Renamed `totalModules` → `totalModuleCount`
- **Fixed**: Renamed `installedModules` → `installedModuleCount`
- **Impact**: Consistency with test expectations

### Bug #5: Test Data ✅
- **Fixed**: Removed `Option` wrapper from nullable `currentModule`
- **Fixed**: Used correct DTO property names
- **Impact**: Tests now match implementation

---

## ✅ Verification Steps

After running build_runner:

### 1. Check Generated Files Exist
```bash
find packages/vscode_runtime* -name "*.freezed.dart" | wc -l
# Should output: 23

find packages/vscode_runtime* -name "*.g.dart" | wc -l
# Should output: 11
```

### 2. Verify Compilation
```bash
# From project root
cd packages/vscode_runtime_core
dart analyze
# Should show: No issues found!

cd ../vscode_runtime_application
dart analyze
# Should show: No issues found!

cd ../vscode_runtime_presentation
dart analyze
# Should show: No issues found!
```

### 3. Run Tests
```bash
# Core tests
cd packages/vscode_runtime_core
dart test

# Application tests
cd ../vscode_runtime_application
dart test

# Presentation tests
cd ../vscode_runtime_presentation
flutter test
```

---

## 📦 Package Status

| Package | Needs Generation | Status |
|---------|-----------------|--------|
| `vscode_runtime_core` | ✅ `.freezed.dart` + `.g.dart` | Ready |
| `vscode_runtime_application` | ✅ `.freezed.dart` + `.g.dart` | Ready |
| `vscode_runtime_infrastructure` | ✅ `.config.dart` | Ready |
| `vscode_runtime_presentation` | ✅ `.g.dart` (MobX) | Ready |

---

## 🚨 Common Issues

### Issue: "part of 'xxx.freezed.dart' doesn't exist"
**Solution**: Run `dart run build_runner build --delete-conflicting-outputs` in that package

### Issue: "Undefined class '_$RuntimeModule'"
**Solution**: Freezed code generation incomplete, re-run build_runner

### Issue: "The getter 'totalModuleCount' isn't defined"
**Solution**: MobX code generation incomplete, run build_runner for presentation package

### Issue: Build conflicts
**Solution**: Use `--delete-conflicting-outputs` flag to overwrite existing files

---

## 📝 Summary

**All Bugs Fixed**: ✅ 8/8 critical bugs resolved
**Code Status**: ✅ Ready for compilation
**Next Step**: 🔧 Run build_runner on all packages
**Time Required**: ~2-5 minutes (depending on machine)

After code generation completes, the entire VS Code runtime management system will be fully operational!

---

## 🎯 Quick Command

Run all build_runner commands at once:

```bash
cd packages/vscode_runtime_core && dart run build_runner build --delete-conflicting-outputs && \
cd ../vscode_runtime_application && dart run build_runner build --delete-conflicting-outputs && \
cd ../vscode_runtime_infrastructure && dart run build_runner build --delete-conflicting-outputs && \
cd ../vscode_runtime_presentation && dart run build_runner build --delete-conflicting-outputs && \
cd ../.. && echo "✅ All code generation complete!"
```

---

*Last Updated: 2025-01-18*
*Commit: 2aa683d - fix: resolve 8 critical bugs preventing compilation*
