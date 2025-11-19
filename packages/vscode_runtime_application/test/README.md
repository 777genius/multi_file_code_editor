# Application Layer Tests

Comprehensive test suite for the application layer (handlers and DTOs) of the VS Code Runtime Management system.

## Test Structure

```
test/
├── handlers/                           # Handler tests (CQRS)
│   └── get_platform_info_query_handler_test.dart
└── dtos/                              # DTO tests
    └── platform_info_dto_test.dart

## Coverage

Target: 70%+ code coverage

### Current Coverage by Component

- **GetPlatformInfoQueryHandler**: ~90% (all paths tested)
- **PlatformInfoDto**: ~100% (all computed properties tested)

## Running Tests

### Run all application tests
```bash
cd packages/vscode_runtime_application
dart test
```

### Run specific test file
```bash
dart test test/handlers/get_platform_info_query_handler_test.dart
```

### Run with coverage
```bash
dart test --coverage=coverage
```

## Test Patterns

### Testing Query Handlers

Query handlers are tested with mocked dependencies:

```dart
class MockPlatformService extends Mock implements IPlatformService {}

void main() {
  late GetPlatformInfoQueryHandler handler;
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockPlatformService = MockPlatformService();
    handler = GetPlatformInfoQueryHandler(mockPlatformService);
  });

  test('should return platform info DTO with all data', () async {
    // Arrange - mock all dependencies
    when(() => mockPlatformService.getPlatformInfo()).thenAnswer(...);

    // Act - execute handler
    final result = await handler.handle(query);

    // Assert - verify result and interactions
    expect(result.isRight(), isTrue);
    verify(() => mockPlatformService.getPlatformInfo()).called(1);
  });
}
```

### Testing DTOs

DTOs are tested for:
- Construction
- Computed properties
- Business logic
- Serialization

```dart
test('should compute canInstallRuntime correctly', () {
  final dto = PlatformInfoDto(
    identifier: PlatformIdentifier.linux,
    availableDiskSpace: ByteSize.fromGB(10),
    hasRequiredPermissions: true,
    isSupported: true,
    // ... other fields
  );

  expect(dto.canInstallRuntime, isTrue);
});
```

## Key Test Cases

### GetPlatformInfoQueryHandler

#### Success Paths
- ✅ Returns complete platform info DTO
- ✅ All services called correctly
- ✅ Data properly transformed to DTO

#### Fallback Scenarios
- ✅ Uses 100GB fallback when disk space unavailable
- ✅ Sets hasRequiredPermissions to false when check fails
- ✅ Sets isSupported to false when support check fails

#### Error Handling
- ✅ Returns error when platform info fetch fails
- ✅ Handles domain exceptions
- ✅ Handles generic exceptions with inner exception preserved

### PlatformInfoDto

#### Computed Properties
- ✅ `hasSufficientSpace` (>= 1GB requirement)
- ✅ `canInstallRuntime` (all conditions met)
- ✅ `installationWarning` (appropriate warnings)
- ✅ `displayString` (platform display name)

#### Business Logic
- ✅ Disk space threshold (1GB minimum)
- ✅ Combined permissions and support checks
- ✅ Priority of warning messages
- ✅ Edge cases (exactly 1GB, etc.)

## Test Coverage Examples

### Testing All Branches

```dart
group('canInstallRuntime', () {
  test('should return true when all conditions met', () { ... });
  test('should return false when platform not supported', () { ... });
  test('should return false when insufficient permissions', () { ... });
  test('should return false when insufficient disk space', () { ... });
});
```

### Testing Error Paths

```dart
test('should return error when platform info fetch fails', () async {
  // Mock failure
  when(() => mockPlatformService.getPlatformInfo()).thenAnswer(
    (_) async => left(const DomainException('Failed')),
  );

  final result = await handler.handle(query);

  expect(result.isLeft(), isTrue);
  result.fold(
    (error) => expect(error.message, contains('Failed')),
    (_) => fail('Should return error'),
  );
});
```

## CQRS Pattern Testing

Handlers follow CQRS (Command Query Responsibility Segregation):

- **Query Handlers**: Read operations, return DTOs
  - GetPlatformInfoQueryHandler ✅
  - GetRuntimeStatusQueryHandler (TODO)
  - GetInstallationProgressQueryHandler (TODO)

- **Command Handlers**: Write operations, return Unit or errors
  - InstallRuntimeCommandHandler (TODO)
  - CancelInstallationCommandHandler (TODO)
  - CheckRuntimeUpdatesCommandHandler (TODO)

## Best Practices

1. **Comprehensive Mocking**: All dependencies are mocked
2. **Verify Interactions**: All service calls are verified
3. **Test Fallbacks**: Graceful degradation is tested
4. **Edge Cases**: Boundary conditions are tested
5. **Error Paths**: Both domain and generic exceptions tested
6. **Business Logic**: DTO computed properties thoroughly tested

## Future Improvements

- [ ] Add tests for remaining query handlers
- [ ] Add tests for command handlers
- [ ] Add tests for remaining DTOs
- [ ] Add integration tests for handler orchestration
- [ ] Increase coverage to 90%+
- [ ] Add end-to-end handler flow tests
