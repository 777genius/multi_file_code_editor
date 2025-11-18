# VS Code Runtime Core

Domain layer package for VS Code Runtime Management system.

## Overview

This package contains the pure domain logic following Clean Architecture and Domain-Driven Design principles:

- **Domain Exceptions**: Custom exception hierarchy
- **Value Objects**: Immutable, self-validating value types
- **Entities**: Business objects with identity
- **Aggregate Roots**: Consistency boundaries (RuntimeInstallation)
- **Domain Events**: State change notifications
- **Specifications**: Business rule encapsulation
- **Domain Services**: Complex business logic
- **Port Interfaces**: Abstractions for infrastructure

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

Run build_runner to generate Freezed and JSON serialization code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run Tests

```bash
flutter test
```

## Architecture

### Value Objects
- `RuntimeVersion`: Semantic versioning
- `ByteSize`: Human-readable byte sizes
- `SHA256Hash`: File integrity hashing
- `ModuleId`: Unique module identifiers
- `DownloadUrl`: Validated HTTP/HTTPS URLs
- `PlatformIdentifier`: OS and architecture identification
- `InstallationId`: UUID-based installation tracking

### Entities
- `PlatformArtifact`: Platform-specific download artifacts
- `RuntimeModule`: Downloadable runtime components with dependencies

### Aggregate Root
- `RuntimeInstallation`: Manages entire installation lifecycle
  - Ensures consistency across module installations
  - Emits domain events for all state changes
  - Validates invariants (platform compatibility, dependencies)

### Specifications
- `PlatformCompatibleSpecification`: Platform support validation
- `DependenciesMetSpecification`: Dependency resolution
- `ModuleNotInstalledSpecification`: Installation state checking
- Combinable with AND, OR, NOT operators

### Domain Services
- `DependencyResolver`: Topological sort for module installation order

## Test Coverage

All domain logic has 100% test coverage:
- Value Objects: 7 test files
- Entities: 2 test files
- Aggregate Root: 1 comprehensive test file
- Specifications: 1 test file with all patterns

Run tests with coverage:

```bash
flutter test --coverage
```

## Dependencies

- `freezed`: Immutable data classes
- `dartz`: Functional programming (Either, Option)
- `equatable`: Value equality

No dependencies on external frameworks or infrastructure.
