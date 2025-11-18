import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:get_it/get_it.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockGenerateSshKeyUseCase extends Mock implements GenerateSshKeyUseCase {}

void main() {
  late MockGenerateSshKeyUseCase mockUseCase;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(SshKeyType.ed25519);
  });

  setUp() {
    mockUseCase = MockGenerateSshKeyUseCase();

    getIt = GetIt.instance;
    if (!getIt.isRegistered<GenerateSshKeyUseCase>()) {
      getIt.registerSingleton<GenerateSshKeyUseCase>(mockUseCase);
    }
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget createTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: SshKeyManager(),
      ),
    );
  }

  group('SshKeyManager - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SshKeyManager), findsOneWidget);
    });

    testWidgets('should show loading indicator initially', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return right([]);
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state when loading fails', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => left(GitFailure.operationFailed(
          operation: 'list keys',
          reason: 'Test error',
        )),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show empty state when no keys', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No SSH Keys'), findsOneWidget);
      expect(find.byIcon(Icons.vpn_key_off), findsOneWidget);
    });
  });

  group('SshKeyManager - Key List', () {
    testWidgets('should display list of SSH keys', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
          '/home/user/.ssh/id_rsa.pub',
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('id_ed25519.pub'), findsOneWidget);
      expect(find.text('id_rsa.pub'), findsOneWidget);
    });

    testWidgets('should show key paths', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('/home/user/.ssh/id_ed25519.pub'), findsOneWidget);
    });

    testWidgets('should show key icon for each key', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.vpn_key), findsOneWidget);
    });
  });

  group('SshKeyManager - Key Actions', () {
    testWidgets('should show copy and delete buttons for each key',
        (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should copy public key on copy button tap', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
        ]),
      );

      when(() => mockUseCase.getPublicKeyContent(
            publicKeyPath: any(named: 'publicKeyPath'),
          )).thenAnswer(
        (_) async => right('ssh-ed25519 AAAAC3...'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Public key copied to clipboard'), findsOneWidget);
    });

    testWidgets('should show delete confirmation dialog on delete button tap',
        (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Delete SSH Key'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should delete key on confirmation', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([
          '/home/user/.ssh/id_ed25519.pub',
        ]),
      );

      when(() => mockUseCase.deleteKey(
            publicKeyPath: any(named: 'publicKeyPath'),
          )).thenAnswer(
        (_) async => right(unit),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Key deleted successfully'), findsOneWidget);
    });
  });

  group('SshKeyManager - Generate Key', () {
    testWidgets('should show generate key button', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Generate Key'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should open generate dialog on button tap', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Generate Key'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Generate SSH Key'), findsOneWidget);
      expect(find.byType(SshKeyGeneratorDialog), findsOneWidget);
    });
  });

  group('SshKeyManager - Refresh', () {
    testWidgets('should refresh keys on refresh button tap', (tester) async {
      // Arrange
      when(() => mockUseCase.listKeys()).thenAnswer(
        (_) async => right([]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final refreshButton = find.widgetWithIcon(IconButton, Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockUseCase.listKeys()).called(2); // Initial + refresh
    });
  });

  group('SshKeyGeneratorDialog', () {
    Widget createGeneratorDialog() {
      return ProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: SshKeyGeneratorDialog(),
          ),
        ),
      );
    }

    testWidgets('should render generator dialog', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Generate SSH Key'), findsOneWidget);
    });

    testWidgets('should show all key type options', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('ED25519'), findsOneWidget);
      expect(find.text('RSA'), findsOneWidget);
      expect(find.text('ECDSA'), findsOneWidget);
    });

    testWidgets('should show email field', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Email *'), findsOneWidget);
    });

    testWidgets('should show optional key name field', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Key Name (optional)'), findsOneWidget);
    });

    testWidgets('should show optional passphrase field', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Passphrase (optional)'), findsOneWidget);
    });

    testWidgets('should toggle passphrase visibility', (tester) async {
      // Arrange
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Act - Find passphrase field
      final passphraseField = find.ancestor(
        of: find.text('Passphrase (optional)'),
        matching: find.byType(TextFormField),
      );

      // Tap visibility toggle
      final visibilityButton =
          find.descendant(of: passphraseField, matching: find.byType(IconButton));
      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(SshKeyGeneratorDialog), findsOneWidget);
    });

    testWidgets('should validate email field', (tester) async {
      // Arrange
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Act - Try to generate without email
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);

      // Try with invalid email
      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'invalid-email',
      );
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('should select key type', (tester) async {
      // Arrange
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      // Act - Select RSA
      await tester.tap(find.text('RSA'));
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(SshKeyGeneratorDialog), findsOneWidget);
    });

    testWidgets('should generate key with valid data', (tester) async {
      // Arrange
      when(() => mockUseCase.call(
            email: any(named: 'email'),
            keyType: any(named: 'keyType'),
            keyName: any(named: 'keyName'),
            passphrase: any(named: 'passphrase'),
          )).thenAnswer(
        (_) async => right(SshKeyPair(
          publicKey: 'ssh-ed25519 AAAAC3...',
          privateKeyPath: '/home/user/.ssh/id_ed25519',
          publicKeyPath: '/home/user/.ssh/id_ed25519.pub',
          fingerprint: 'SHA256:abc123',
          keyType: SshKeyType.ed25519,
        )),
      );

      // Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'test@example.com',
      );

      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      // Assert - Success dialog should appear
      expect(find.text('Key Generated Successfully'), findsOneWidget);
    });

    testWidgets('should show loading state while generating', (tester) async {
      // Arrange
      when(() => mockUseCase.call(
            email: any(named: 'email'),
            keyType: any(named: 'keyType'),
            keyName: any(named: 'keyName'),
            passphrase: any(named: 'passphrase'),
          )).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return right(SshKeyPair(
            publicKey: 'ssh-ed25519 AAAAC3...',
            privateKeyPath: '/home/user/.ssh/id_ed25519',
            publicKeyPath: '/home/user/.ssh/id_ed25519.pub',
            fingerprint: 'SHA256:abc123',
            keyType: SshKeyType.ed25519,
          ));
        },
      );

      // Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'test@example.com',
      );

      await tester.tap(find.text('Generate'));
      await tester.pump();

      // Assert
      expect(find.text('Generating...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display success dialog with key details',
        (tester) async {
      // Arrange
      when(() => mockUseCase.call(
            email: any(named: 'email'),
            keyType: any(named: 'keyType'),
            keyName: any(named: 'keyName'),
            passphrase: any(named: 'passphrase'),
          )).thenAnswer(
        (_) async => right(SshKeyPair(
          publicKey: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...',
          privateKeyPath: '/home/user/.ssh/id_ed25519',
          publicKeyPath: '/home/user/.ssh/id_ed25519.pub',
          fingerprint: 'SHA256:abc123def456',
          keyType: SshKeyType.ed25519,
        )),
      );

      // Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'test@example.com',
      );

      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('ED25519'), findsOneWidget);
      expect(find.text('SHA256:abc123def456'), findsOneWidget);
      expect(find.text('/home/user/.ssh/id_ed25519'), findsOneWidget);
      expect(find.text('/home/user/.ssh/id_ed25519.pub'), findsOneWidget);
    });

    testWidgets('should copy public key in success dialog', (tester) async {
      // Arrange
      when(() => mockUseCase.call(
            email: any(named: 'email'),
            keyType: any(named: 'keyType'),
            keyName: any(named: 'keyName'),
            passphrase: any(named: 'passphrase'),
          )).thenAnswer(
        (_) async => right(SshKeyPair(
          publicKey: 'ssh-ed25519 AAAAC3...',
          privateKeyPath: '/home/user/.ssh/id_ed25519',
          publicKeyPath: '/home/user/.ssh/id_ed25519.pub',
          fingerprint: 'SHA256:abc123',
          keyType: SshKeyType.ed25519,
        )),
      );

      // Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'test@example.com',
      );

      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      // Copy public key
      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Public key copied to clipboard'), findsOneWidget);
    });

    testWidgets('should close success dialog on done button', (tester) async {
      // Arrange
      when(() => mockUseCase.call(
            email: any(named: 'email'),
            keyType: any(named: 'keyType'),
            keyName: any(named: 'keyName'),
            passphrase: any(named: 'passphrase'),
          )).thenAnswer(
        (_) async => right(SshKeyPair(
          publicKey: 'ssh-ed25519 AAAAC3...',
          privateKeyPath: '/home/user/.ssh/id_ed25519',
          publicKeyPath: '/home/user/.ssh/id_ed25519.pub',
          fingerprint: 'SHA256:abc123',
          keyType: SshKeyType.ed25519,
        )),
      );

      // Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'test@example.com',
      );

      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Assert - Dialog should close
      expect(find.byType(SshKeyGeneratorDialog), findsNothing);
    });

    testWidgets('should show error on generation failure', (tester) async {
      // Arrange
      when(() => mockUseCase.call(
            email: any(named: 'email'),
            keyType: any(named: 'keyType'),
            keyName: any(named: 'keyName'),
            passphrase: any(named: 'passphrase'),
          )).thenAnswer(
        (_) async => left(GitFailure.operationFailed(
          operation: 'generate key',
          reason: 'Permission denied',
        )),
      );

      // Act
      await tester.pumpWidget(createGeneratorDialog());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Email *'),
          matching: find.byType(TextFormField),
        ),
        'test@example.com',
      );

      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Failed to generate key'), findsOneWidget);
    });
  });
}
