# 🔥 КРИТИЧЕСКИЕ БАГИ В INFRASTRUCTURE СЛОЕ

**Дата**: 2025-01-18 (Третья итерация - Infrastructure)
**Статус**: ⚠️ **Найдено 11 КРИТИЧЕСКИХ багов в infrastructure**

---

## 🚨 БЛОКЕРЫ КОМПИЛЯЦИИ

Весь **Infrastructure слой** не соответствует интерфейсам! Ни один репозиторий и сервис не компилируется!

---

## 📋 КРИТИЧЕСКИЕ БАГИ

### **БАГ #17: ManifestRepository.fetchManifest() - НЕПРАВИЛЬНЫЙ ТИП ВОЗВРАТА** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/repositories/manifest_repository.dart:14`

**Проблема**:
```dart
// Реализация (НЕПРАВИЛЬНО):
@override
Future<Either<DomainException, List<RuntimeModule>>> fetchManifest() async {
  // ...
  final modules = manifestDto.toDomain();
  return right(modules);  // ❌ Возвращает List<RuntimeModule>
}
```

**Интерфейс требует**:
```dart
Future<Either<DomainException, RuntimeManifest>> fetchManifest();
// ✅ Должен возвращать RuntimeManifest (объект с version, modules, publishedAt)
```

**Решение**: Вернуть RuntimeManifest вместо списка модулей

---

### **БАГ #18: ManifestRepository.getModules() - REQUIRED параметр вместо OPTIONAL** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/repositories/manifest_repository.dart:31`

**Проблема**:
```dart
// Реализация:
@override
Future<Either<DomainException, List<RuntimeModule>>> getModules(
  PlatformIdentifier platform,  // ❌ REQUIRED параметр
) async
```

**Интерфейс требует**:
```dart
Future<Either<DomainException, List<RuntimeModule>>> getModules([
  PlatformIdentifier? platform,  // ✅ OPTIONAL параметр
]);
```

**Решение**: Сделать параметр опциональным `[PlatformIdentifier? platform]`

---

### **БАГ #19: ManifestRepository.hasManifestUpdate() - ЛИШНИЙ ПАРАМЕТР** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/repositories/manifest_repository.dart:56`

**Проблема**:
```dart
// Реализация:
@override
Future<Either<DomainException, bool>> hasManifestUpdate(
  String currentVersion,  // ❌ Параметр не должен быть!
) async
```

**Интерфейс требует**:
```dart
Future<Either<DomainException, bool>> hasManifestUpdate();
// ✅ Без параметров
```

**Решение**: Удалить параметр

---

### **БАГ #20-22: ManifestRepository - ОТСУТСТВУЮТ 3 МЕТОДА** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/repositories/manifest_repository.dart`

**Отсутствуют методы**:

1. `getCachedManifest()`:
```dart
Future<Either<DomainException, Option<RuntimeManifest>>> getCachedManifest();
```

2. `getModule(ModuleId)`:
```dart
Future<Either<DomainException, Option<RuntimeModule>>> getModule(
  ModuleId moduleId,
);
```

3. `getManifestVersion()`:
```dart
Future<Either<DomainException, RuntimeVersion>> getManifestVersion();
```

**Решение**: Добавить все 3 метода

---

### **БАГ #23: RuntimeRepository.deleteInstallation() - ОТСУТСТВУЕТ ПАРАМЕТР** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/repositories/runtime_repository.dart:119`

**Проблема**:
```dart
// Реализация:
@override
Future<Either<DomainException, Unit>> deleteInstallation() async {
  // ❌ Без параметра
}
```

**Интерфейс требует**:
```dart
Future<Either<DomainException, Unit>> deleteInstallation([
  InstallationId? installationId,  // ✅ Опциональный параметр
]);
```

**Решение**: Добавить опциональный параметр

---

### **БАГ #24-28: RuntimeRepository - ОТСУТСТВУЮТ 5 МЕТОДОВ** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/repositories/runtime_repository.dart`

**Отсутствуют методы**:

1. `getInstallationHistory()`:
```dart
Future<Either<DomainException, List<RuntimeInstallation>>> getInstallationHistory();
```

2. `getInstallationDirectory()`:
```dart
Future<Either<DomainException, String>> getInstallationDirectory();
```

3. `getModuleDirectory(ModuleId)`:
```dart
Future<Either<DomainException, String>> getModuleDirectory(ModuleId moduleId);
```

4. `saveInstalledVersion(RuntimeVersion)`:
```dart
Future<Either<DomainException, Unit>> saveInstalledVersion(RuntimeVersion version);
```

5. `getLatestInstallation()`:
```dart
Future<Either<DomainException, Option<RuntimeInstallation>>> getLatestInstallation();
```

**Решение**: Добавить все 5 методов

---

### **БАГ #29: DownloadService.download() - НЕПРАВИЛЬНАЯ СИГНАТУРА** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/services/download_service.dart:24`

**Проблема**:
```dart
// Реализация:
@override
Future<Either<DomainException, File>> download({
  required DownloadUrl url,
  required String targetPath,  // ❌ Неправильный параметр!
  void Function(ByteSize downloaded, ByteSize total)? onProgress,
  CancelToken? cancelToken,
}) async
```

**Интерфейс требует**:
```dart
Future<Either<DomainException, File>> download({
  required DownloadUrl url,
  required ByteSize expectedSize,  // ✅ Правильный параметр
  void Function(ByteSize received, ByteSize total)? onProgress,
  CancelToken? cancelToken,
});
```

**Решение**:
- Заменить `String targetPath` на `ByteSize expectedSize`
- Сервис сам должен определять targetPath

---

### **БАГ #30: DownloadService - ОТСУТСТВУЮТ 2 МЕТОДА** 🔴

**Файл**: `packages/vscode_runtime_infrastructure/lib/src/services/download_service.dart`

**Отсутствуют методы**:

1. `cancelDownload(CancelToken)`:
```dart
Future<Either<DomainException, Unit>> cancelDownload(CancelToken token);
```

2. `getProgressStream(CancelToken)`:
```dart
Stream<DownloadProgress> getProgressStream(CancelToken token);
```

**Решение**: Добавить оба метода

---

### **БАГ #31: DownloadService & Infrastructure - использует Dio.CancelToken** 🟡

**Файл**: Multiple files

**Проблема**:
- Infrastructure импортирует `package:dio/dio.dart`
- Использует Dio.CancelToken вместо domain CancelToken
- Domain Core определяет свой CancelToken

**Решение**:
1. Использовать domain CancelToken в интерфейсах
2. Infrastructure может внутри мапить на Dio.CancelToken
3. Или полностью использовать domain CancelToken везде

---

## 📊 СТАТИСТИКА

| Репозиторий/Сервис | Баги найдены | Отсутствует методов |
|---------------------|--------------|---------------------|
| ManifestRepository | 5 | 3 метода |
| RuntimeRepository | 6 | 5 методов |
| DownloadService | 3 | 2 метода |
| **ВСЕГО** | **14 багов** | **10 методов** |

---

## 🎯 ПРИОРИТЕТ

### 🔴 КРИТИЧЕСКИЙ - Блокируют компиляцию:

Все 14 багов критические! Infrastructure НЕ компилируется без исправлений.

**Порядок исправления**:

1. ✅ ManifestRepository:
   - Исправить fetchManifest() тип возврата
   - Исправить getModules() параметр
   - Исправить hasManifestUpdate() параметр
   - Добавить 3 недостающих метода

2. ✅ RuntimeRepository:
   - Исправить deleteInstallation() параметр
   - Добавить 5 недостающих методов

3. ✅ DownloadService:
   - Исправить download() сигнатуру
   - Добавить 2 недостающих метода

4. ✅ Решить проблему CancelToken

---

## 🚨 КРИТИЧНОСТЬ

**БЕЗ ЭТИХ ИСПРАВЛЕНИЙ**:
- ❌ Infrastructure слой не компилируется
- ❌ Невозможно запустить приложение
- ❌ Все тесты фейлятся
- ❌ Build_runner не поможет

**Это блокеры ВСЕГО проекта!**

---

## 📁 ФАЙЛЫ К ИСПРАВЛЕНИЮ

```
packages/vscode_runtime_infrastructure/lib/src/
├── repositories/
│   ├── manifest_repository.dart          🔴 5 багов
│   └── runtime_repository.dart           🔴 6 багов
└── services/
    └── download_service.dart              🔴 3 бага
```

---

*Отчёт создан: 2025-01-18*
*Итерация: 3 (Infrastructure)*
*Всего багов: 16 (первые 2 итерации) + 14 (infrastructure) = **30 критических багов***
