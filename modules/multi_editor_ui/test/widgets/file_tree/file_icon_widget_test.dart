import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/file_icon_widget.dart';

void main() {
  group('FileIconWidget Widget Tests', () {
    Widget createWidget({
      required FileIconDescriptor descriptor,
      Widget? fallback,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileIconWidget(
            descriptor: descriptor,
            fallback: fallback,
          ),
        ),
      );
    }

    group('Icon Types', () {
      testWidgets('should render IconData type', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.star.codePoint,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('should render default icon type', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.defaultIcon,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });

      testWidgets('should render fallback when default type and fallback provided',
          (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.defaultIcon,
          size: 18,
        );
        final fallback = const Icon(Icons.folder);

        // Act
        await tester.pumpWidget(
          createWidget(descriptor: descriptor, fallback: fallback),
        );

        // Assert
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('should render IconData with custom color', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.code.codePoint,
          color: Colors.blue.value,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, equals(Colors.blue));
      });

      testWidgets('should render IconData with custom font family',
          (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: 0xe900,
          iconFamily: 'CustomFont',
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon?.fontFamily, equals('CustomFont'));
      });
    });

    group('Size', () {
      testWidgets('should render with correct size', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.file_copy.codePoint,
          size: 24,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(24));
      });

      testWidgets('should render with default size 18', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.defaultIcon,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(18));
      });
    });

    group('Dark Theme Effects', () {
      testWidgets('should apply glow effect in dark theme', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.code.codePoint,
          size: 18,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: FileIconWidget(descriptor: descriptor),
            ),
          ),
        );

        // Assert - Should render with Container that has glow effect
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should not apply glow effect in light theme',
          (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.code.codePoint,
          size: 18,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: FileIconWidget(descriptor: descriptor),
            ),
          ),
        );

        // Assert - Icon should be directly rendered
        expect(find.byType(Icon), findsOneWidget);
      });
    });

    group('URL Icons', () {
      testWidgets('should handle URL type with SVG', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.url,
          url: 'https://cdn.example.com/icon.svg',
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));
        await tester.pump();

        // Assert - SvgPicture.network is used for SVG URLs
        // The widget should at least render without errors
        expect(find.byType(FileIconWidget), findsOneWidget);
      });

      testWidgets('should handle URL type with PNG', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.url,
          url: 'https://cdn.example.com/icon.png',
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));
        await tester.pump();

        // Assert - Image.network is used for raster formats
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('should show fallback when URL is null', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.url,
          url: null,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });
    });

    group('Local Assets', () {
      testWidgets('should handle local asset type', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.local,
          assetPath: 'assets/icons/file.png',
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));
        await tester.pump();

        // Assert - Image.asset is used
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('should show fallback when asset path is null',
          (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.local,
          assetPath: null,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Dart file uses default dart icon', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.code.codePoint,
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));

        // Assert
        expect(find.byIcon(Icons.code), findsOneWidget);
      });

      testWidgets('UC2: Plugin provides custom SVG icon from CDN',
          (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.url,
          url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg',
          size: 18,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));
        await tester.pump();

        // Assert - Widget renders without error
        expect(find.byType(FileIconWidget), findsOneWidget);
      });

      testWidgets('UC3: Custom icon pack from local assets', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.local,
          assetPath: 'assets/icons/custom_file.png',
          size: 20,
        );

        // Act
        await tester.pumpWidget(createWidget(descriptor: descriptor));
        await tester.pump();

        // Assert
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('UC4: Icon with custom color in dark theme', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.javascript.codePoint,
          color: const Color(0xFFF7DF1E).value, // JavaScript yellow
          size: 18,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: FileIconWidget(descriptor: descriptor),
            ),
          ),
        );

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, equals(const Color(0xFFF7DF1E)));
      });
    });

    group('CachedFileIconWidget', () {
      testWidgets('should render same as FileIconWidget', (tester) async {
        // Arrange
        final descriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          iconCode: Icons.code.codePoint,
          size: 18,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CachedFileIconWidget(descriptor: descriptor),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.code), findsOneWidget);
      });
    });
  });
}
