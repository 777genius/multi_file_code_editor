# Build Runner Guide

## Проблема
Flutter и Dart SDK не доступны в текущем окружении, поэтому build_runner нельзя запустить напрямую.

## Решение: Запуск build_runner локально

### Модули, требующие генерацию кода:

1. **ide_presentation** - MobX stores
   - `editor_store.dart` → `editor_store.g.dart`
   - `lsp_store.dart` → `lsp_store.g.dart`

2. **lsp_infrastructure** - JSON-RPC protocol
   - `json_rpc_protocol.dart` → `json_rpc_protocol.g.dart`

3. **editor_core** - Freezed entities
   - Различные entity и value object файлы

4. **lsp_domain** - Freezed entities
   - Различные entity файлы

### Команды для генерации:

```bash
# Вариант 1: Генерация для всего приложения (из /app)
cd /home/user/multi_editor_flutter/app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Вариант 2: Через make (если доступен)
cd /home/user/multi_editor_flutter/app
make codegen

# Вариант 3: Для конкретного модуля
cd /home/user/multi_editor_flutter/app/modules/ide_presentation
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Вариант 4: Watch mode (автоматическая регенерация)
cd /home/user/multi_editor_flutter/app
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Что делает build_runner:

1. **MobX код генерация** (`*.g.dart`):
   - Генерирует reactive code для @observable, @action, @computed
   - Необходим для EditorStore и LspStore

2. **Freezed код генерация** (`*.freezed.dart`):
   - Генерирует immutable classes с copyWith, toString, equals
   - Необходим для domain entities (EditorDocument, LspSession, etc.)

3. **Injectable код генерация**:
   - Генерирует dependency injection код

### Проверка успешности:

После генерации должны появиться файлы:
```bash
# MobX stores
app/modules/ide_presentation/lib/src/stores/editor/editor_store.g.dart
app/modules/ide_presentation/lib/src/stores/lsp/lsp_store.g.dart

# JSON-RPC
app/modules/lsp_infrastructure/lib/src/protocol/json_rpc_protocol.g.dart

# Freezed entities (много файлов)
app/modules/editor_core/lib/src/entities/*.freezed.dart
app/modules/lsp_domain/lib/src/entities/*.freezed.dart
```

### Типичные ошибки и решения:

**Ошибка: "Conflicting outputs"**
```bash
# Решение: используйте --delete-conflicting-outputs
flutter pub run build_runner build --delete-conflicting-outputs
```

**Ошибка: "Could not find package"**
```bash
# Решение: запустите pub get сначала
flutter pub get
```

**Ошибка: "Version solving failed"**
```bash
# Решение: очистите кэш
flutter clean
flutter pub cache repair
flutter pub get
```

### Автоматизация через Makefile:

В `/home/user/multi_editor_flutter/app/Makefile` уже есть команды:
```bash
make codegen          # Одноразовая генерация
make codegen-watch    # Watch mode
make clean-generated  # Очистка сгенерированных файлов
```

## Важно:

- ❌ build_runner **НЕ МОЖЕТ** быть запущен в текущем окружении (нет Flutter/Dart SDK)
- ✅ build_runner должен быть запущен **локально** на машине разработчика
- ✅ Сгенерированные файлы **НЕ ДОЛЖНЫ** коммититься в git (в .gitignore)
- ✅ Каждый разработчик генерирует их локально после `git clone`

## Workflow:

```bash
# 1. Клонировать репозиторий
git clone <repo>
cd multi_editor_flutter/app

# 2. Установить зависимости
flutter pub get

# 3. Сгенерировать код
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Запустить приложение
flutter run
```
