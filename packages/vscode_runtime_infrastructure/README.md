# VS Code Runtime Infrastructure

Infrastructure layer package for VS Code Runtime Management system.

## Overview

This package implements the port interfaces defined in `vscode_runtime_core`, providing concrete implementations for:

- **Services**: File system, platform detection, downloads, extraction, verification
- **Repositories**: Manifest fetching, installation state persistence
- **Event Bus**: Domain event publishing and subscription
- **Data Sources**: Remote manifest fetching, local storage

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

Run build_runner to generate JSON serialization code for DTOs:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run Tests

```bash
flutter test
```

## Components

### Services

#### FileSystemService
- Installation directory management
- Module directory creation
- Download directory handling
- File operations (copy, move, permissions)

#### PlatformService
- OS and architecture detection
- Platform information (version, processors)
- Disk space checking
- Permission verification

#### DownloadService
- HTTP/HTTPS downloads with progress tracking
- Cancellation support
- Remote file size detection
- URL accessibility checking

#### ExtractionService
- Archive extraction (ZIP, TAR.GZ, TAR.XZ, TAR.BZ2)
- Progress tracking
- Selective file extraction
- Permission preservation

#### VerificationService
- SHA256 hash computation and verification
- File size verification
- Combined integrity checks

### Repositories

#### ManifestRepository
- Fetches runtime module manifests from CDN
- Filters modules by platform compatibility
- Checks for manifest updates

#### RuntimeRepository
- Persists installation state
- Tracks installed modules
- Manages installation history

### Event Bus

- Publishes domain events
- Type-safe event subscriptions
- Uses RxDart for stream management

### Data Sources

#### ManifestDataSource
- HTTP client for manifest fetching
- JSON parsing to DTOs

#### RuntimeStorageDataSource
- Local file-based persistence
- Installation state serialization
- Module installation markers

## DTOs

Data Transfer Objects for serialization:

- `ManifestDto`: Runtime manifest with modules
- `RuntimeModuleDto`: Module metadata
- `PlatformArtifactDto`: Platform-specific artifacts
- `RuntimeInstallationDto`: Installation state

## Dependencies

- `dio`: HTTP client
- `archive`: Archive extraction
- `crypto`: SHA256 hashing
- `path_provider`: Directory paths
- `platform`: Platform detection
- `rxdart`: Reactive streams

## Usage Example

```dart
import 'package:vscode_runtime_infrastructure/vscode_runtime_infrastructure.dart';

// Initialize services
final fileSystemService = FileSystemService();
final platformService = PlatformService();
final downloadService = DownloadService();
final extractionService = ExtractionService();
final verificationService = VerificationService();
final eventBus = EventBus();

// Initialize data sources
final manifestDataSource = ManifestDataSource(
  manifestUrl: 'https://cdn.example.com/manifest.json',
);

final storageDir = await fileSystemService.getInstallationDirectory();
final storageDataSource = RuntimeStorageDataSource(storageDir.getOrElse(() => throw Exception()));

// Initialize repositories
final manifestRepo = ManifestRepository(manifestDataSource);
final runtimeRepo = RuntimeRepository(storageDataSource);
```
