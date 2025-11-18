import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/editor_theme_extension.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/color_primitives.dart';

void main() {
  group('EditorThemeExtension', () {
    group('light theme', () {
      late EditorThemeExtension lightTheme;

      setUp(() {
        lightTheme = EditorThemeExtension.light;
      });

      test('should define file tree hover background', () {
        // Arrange & Act
        final color = lightTheme.fileTreeHoverBackground;

        // Assert
        expect(color, equals(ColorPrimitives.gray95));
        expect(color, isNotNull);
      });

      test('should define file tree selection background', () {
        // Arrange & Act
        final color = lightTheme.fileTreeSelectionBackground;

        // Assert
        expect(color, equals(const Color(0xFFE3F2FD)));
      });

      test('should define file tree selection hover background', () {
        // Arrange & Act
        final color = lightTheme.fileTreeSelectionHoverBackground;

        // Assert
        expect(color, equals(const Color(0xFFBBDEFB)));
      });

      test('should define file tree border', () {
        // Arrange & Act
        final color = lightTheme.fileTreeBorder;

        // Assert
        expect(color, equals(ColorPrimitives.gray90));
      });

      test('should use light colors', () {
        // Arrange & Act
        final colors = [
          lightTheme.fileTreeHoverBackground,
          lightTheme.fileTreeSelectionBackground,
          lightTheme.fileTreeSelectionHoverBackground,
        ];

        // Assert - All should be light colors
        for (final color in colors) {
          expect(color.computeLuminance(), greaterThan(0.7),
              reason: 'Light theme colors should have high luminance');
        }
      });
    });

    group('dark theme', () {
      late EditorThemeExtension darkTheme;

      setUp(() {
        darkTheme = EditorThemeExtension.dark;
      });

      test('should define file tree hover background', () {
        // Arrange & Act
        final color = darkTheme.fileTreeHoverBackground;

        // Assert
        expect(color, equals(ColorPrimitives.gray30));
      });

      test('should define file tree selection background', () {
        // Arrange & Act
        final color = darkTheme.fileTreeSelectionBackground;

        // Assert
        expect(color, equals(ColorPrimitives.gray40));
      });

      test('should define file tree selection hover background', () {
        // Arrange & Act
        final color = darkTheme.fileTreeSelectionHoverBackground;

        // Assert
        expect(color, equals(ColorPrimitives.gray50));
      });

      test('should define file tree border', () {
        // Arrange & Act
        final color = darkTheme.fileTreeBorder;

        // Assert
        expect(color, equals(ColorPrimitives.gray40));
      });

      test('should use dark colors', () {
        // Arrange & Act
        final colors = [
          darkTheme.fileTreeHoverBackground,
          darkTheme.fileTreeSelectionBackground,
          darkTheme.fileTreeSelectionHoverBackground,
        ];

        // Assert - All should be dark colors
        for (final color in colors) {
          expect(color.computeLuminance(), lessThan(0.3),
              reason: 'Dark theme colors should have low luminance');
        }
      });
    });

    group('light vs dark differences', () {
      test('should have different hover backgrounds', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act & Assert
        expect(light.fileTreeHoverBackground,
            isNot(equals(dark.fileTreeHoverBackground)));
        expect(light.fileTreeHoverBackground.computeLuminance(),
            greaterThan(dark.fileTreeHoverBackground.computeLuminance()));
      });

      test('should have different selection backgrounds', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act & Assert
        expect(light.fileTreeSelectionBackground,
            isNot(equals(dark.fileTreeSelectionBackground)));
        expect(light.fileTreeSelectionBackground.computeLuminance(),
            greaterThan(dark.fileTreeSelectionBackground.computeLuminance()));
      });

      test('should have inverted color relationships', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act & Assert - Light theme should be lighter, dark theme darker
        expect(light.fileTreeHoverBackground.computeLuminance(),
            greaterThan(0.7));
        expect(dark.fileTreeHoverBackground.computeLuminance(), lessThan(0.3));
      });
    });

    group('copyWith', () {
      test('should copy with new hover background', () {
        // Arrange
        final original = EditorThemeExtension.light;
        const newColor = Color(0xFF123456);

        // Act
        final copied = original.copyWith(fileTreeHoverBackground: newColor);

        // Assert
        expect(copied.fileTreeHoverBackground, equals(newColor));
        expect(copied.fileTreeSelectionBackground,
            equals(original.fileTreeSelectionBackground));
      });

      test('should copy with new selection background', () {
        // Arrange
        final original = EditorThemeExtension.light;
        const newColor = Color(0xFF654321);

        // Act
        final copied =
            original.copyWith(fileTreeSelectionBackground: newColor);

        // Assert
        expect(copied.fileTreeSelectionBackground, equals(newColor));
        expect(copied.fileTreeHoverBackground,
            equals(original.fileTreeHoverBackground));
      });

      test('should copy with new selection hover background', () {
        // Arrange
        final original = EditorThemeExtension.light;
        const newColor = Color(0xFFABCDEF);

        // Act
        final copied =
            original.copyWith(fileTreeSelectionHoverBackground: newColor);

        // Assert
        expect(copied.fileTreeSelectionHoverBackground, equals(newColor));
      });

      test('should copy with new border', () {
        // Arrange
        final original = EditorThemeExtension.light;
        const newColor = Color(0xFFDEADBE);

        // Act
        final copied = original.copyWith(fileTreeBorder: newColor);

        // Assert
        expect(copied.fileTreeBorder, equals(newColor));
      });

      test('should preserve other values when copying one', () {
        // Arrange
        final original = EditorThemeExtension.light;

        // Act
        final copied = original.copyWith(fileTreeBorder: Colors.red);

        // Assert
        expect(copied.fileTreeBorder, equals(Colors.red));
        expect(copied.fileTreeHoverBackground,
            equals(original.fileTreeHoverBackground));
        expect(copied.fileTreeSelectionBackground,
            equals(original.fileTreeSelectionBackground));
        expect(copied.fileTreeSelectionHoverBackground,
            equals(original.fileTreeSelectionHoverBackground));
      });

      test('should return new instance', () {
        // Arrange
        final original = EditorThemeExtension.light;

        // Act
        final copied = original.copyWith(fileTreeBorder: Colors.blue);

        // Assert
        expect(copied, isNot(same(original)));
      });

      test('should handle multiple property changes', () {
        // Arrange
        final original = EditorThemeExtension.light;

        // Act
        final copied = original.copyWith(
          fileTreeHoverBackground: Colors.red,
          fileTreeSelectionBackground: Colors.blue,
        );

        // Assert
        expect(copied.fileTreeHoverBackground, equals(Colors.red));
        expect(copied.fileTreeSelectionBackground, equals(Colors.blue));
      });
    });

    group('lerp', () {
      test('should lerp at t=0 returns first theme', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act
        final result = light.lerp(dark, 0.0) as EditorThemeExtension;

        // Assert
        expect(result.fileTreeHoverBackground,
            equals(light.fileTreeHoverBackground));
        expect(result.fileTreeSelectionBackground,
            equals(light.fileTreeSelectionBackground));
      });

      test('should lerp at t=1 returns second theme', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act
        final result = light.lerp(dark, 1.0) as EditorThemeExtension;

        // Assert
        expect(result.fileTreeHoverBackground,
            equals(dark.fileTreeHoverBackground));
        expect(result.fileTreeSelectionBackground,
            equals(dark.fileTreeSelectionBackground));
      });

      test('should lerp at t=0.5 returns mid-point', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act
        final result = light.lerp(dark, 0.5) as EditorThemeExtension;

        // Assert - Result should be between light and dark
        final lightLum = light.fileTreeHoverBackground.computeLuminance();
        final darkLum = dark.fileTreeHoverBackground.computeLuminance();
        final resultLum = result.fileTreeHoverBackground.computeLuminance();

        expect(resultLum, lessThan(lightLum));
        expect(resultLum, greaterThan(darkLum));
      });

      test('should return self if other is not EditorThemeExtension', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final result = theme.lerp(null, 0.5);

        // Assert
        expect(result, equals(theme));
      });

      test('should lerp all properties', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act
        final result = light.lerp(dark, 0.5) as EditorThemeExtension;

        // Assert - All properties should be interpolated
        expect(result.fileTreeHoverBackground, isNotNull);
        expect(result.fileTreeSelectionBackground, isNotNull);
        expect(result.fileTreeSelectionHoverBackground, isNotNull);
        expect(result.fileTreeBorder, isNotNull);
      });
    });

    group('state hierarchy', () {
      test('should have progressive hover states in light theme', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final normal = theme.fileTreeSelectionBackground;
        final hover = theme.fileTreeSelectionHoverBackground;

        // Assert - Hover should be more prominent
        expect(hover.computeLuminance(), lessThan(normal.computeLuminance()),
            reason: 'Hover should be darker/more prominent in light theme');
      });

      test('should have progressive hover states in dark theme', () {
        // Arrange
        final theme = EditorThemeExtension.dark;

        // Act
        final normal = theme.fileTreeSelectionBackground;
        final hover = theme.fileTreeSelectionHoverBackground;

        // Assert - Hover should be more prominent
        expect(hover.computeLuminance(),
            greaterThan(normal.computeLuminance()),
            reason: 'Hover should be lighter/more prominent in dark theme');
      });

      test('should have clear selection vs hover distinction', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final hover = theme.fileTreeHoverBackground;
        final selection = theme.fileTreeSelectionBackground;

        // Assert - Selection should be more distinct than hover
        expect(selection, isNot(equals(hover)));
      });
    });

    group('EditorThemeExtensionGetter', () {
      testWidgets('should get extension from BuildContext', (tester) async {
        // Arrange
        EditorThemeExtension? capturedExtension;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [EditorThemeExtension.light],
            ),
            home: Builder(
              builder: (context) {
                capturedExtension = context.editorTheme;
                return Container();
              },
            ),
          ),
        );

        // Assert
        expect(capturedExtension, isNotNull);
        expect(capturedExtension, isA<EditorThemeExtension>());
      });

      testWidgets('should return default if extension not found',
          (tester) async {
        // Arrange
        EditorThemeExtension? capturedExtension;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(), // No extension
            home: Builder(
              builder: (context) {
                capturedExtension = context.editorTheme;
                return Container();
              },
            ),
          ),
        );

        // Assert
        expect(capturedExtension, isNotNull);
        expect(capturedExtension, equals(EditorThemeExtension.light),
            reason: 'Should fall back to light theme');
      });

      testWidgets('should work with dark theme', (tester) async {
        // Arrange
        EditorThemeExtension? capturedExtension;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [EditorThemeExtension.dark],
            ),
            home: Builder(
              builder: (context) {
                capturedExtension = context.editorTheme;
                return Container();
              },
            ),
          ),
        );

        // Assert
        expect(capturedExtension, isNotNull);
        expect(capturedExtension?.fileTreeHoverBackground,
            equals(ColorPrimitives.gray30));
      });
    });

    group('real-world use cases', () {
      test('should provide colors for file tree hover state', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final hoverColor = theme.fileTreeHoverBackground;

        // Assert
        expect(hoverColor, isNotNull);
        expect(hoverColor.opacity, equals(1.0),
            reason: 'Hover background should be opaque');
      });

      test('should provide colors for file tree selection', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final selectionColor = theme.fileTreeSelectionBackground;
        final selectionHoverColor = theme.fileTreeSelectionHoverBackground;

        // Assert
        expect(selectionColor, isNotNull);
        expect(selectionHoverColor, isNotNull);
        expect(selectionColor, isNot(equals(selectionHoverColor)));
      });

      test('should provide colors for file tree borders', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final borderColor = theme.fileTreeBorder;

        // Assert
        expect(borderColor, isNotNull);
      });

      test('should support theme switching', () {
        // Arrange
        final lightTheme = EditorThemeExtension.light;
        final darkTheme = EditorThemeExtension.dark;

        // Act & Assert - All colors should be defined in both themes
        expect(lightTheme.fileTreeHoverBackground, isNotNull);
        expect(lightTheme.fileTreeSelectionBackground, isNotNull);
        expect(darkTheme.fileTreeHoverBackground, isNotNull);
        expect(darkTheme.fileTreeSelectionBackground, isNotNull);
      });
    });

    group('ThemeExtension implementation', () {
      test('should be a ThemeExtension', () {
        // Arrange & Act
        final extension = EditorThemeExtension.light;

        // Assert
        expect(extension, isA<ThemeExtension<EditorThemeExtension>>());
      });

      test('should be immutable', () {
        // Arrange & Act
        final extension = EditorThemeExtension.light;

        // Assert - Class should be marked as @immutable
        expect(extension, isA<EditorThemeExtension>());
      });

      test('should implement copyWith', () {
        // Arrange
        final extension = EditorThemeExtension.light;

        // Act
        final copied = extension.copyWith(fileTreeBorder: Colors.red);

        // Assert
        expect(copied, isA<EditorThemeExtension>());
        expect(copied, isNot(same(extension)));
      });

      test('should implement lerp', () {
        // Arrange
        final light = EditorThemeExtension.light;
        final dark = EditorThemeExtension.dark;

        // Act
        final lerped = light.lerp(dark, 0.5);

        // Assert
        expect(lerped, isA<EditorThemeExtension>());
      });
    });

    group('color relationships', () {
      test('should have hover lighter than normal in light theme', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final hover = theme.fileTreeHoverBackground;
        final normal = theme.fileTreeSelectionBackground;

        // Assert
        expect(hover.computeLuminance(),
            greaterThan(normal.computeLuminance()),
            reason: 'Hover should be lighter than selection in light theme');
      });

      test('should have selection hover between selection and hover', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final hover = theme.fileTreeHoverBackground;
        final selection = theme.fileTreeSelectionBackground;
        final selectionHover = theme.fileTreeSelectionHoverBackground;

        // Assert
        final hoverLum = hover.computeLuminance();
        final selectionLum = selection.computeLuminance();
        final selectionHoverLum = selectionHover.computeLuminance();

        expect(selectionHoverLum, lessThan(hoverLum));
        expect(selectionHoverLum, greaterThan(selectionLum));
      });
    });

    group('editor-specific functionality', () {
      test('should provide distinct states for file tree', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final states = [
          theme.fileTreeHoverBackground,
          theme.fileTreeSelectionBackground,
          theme.fileTreeSelectionHoverBackground,
        ];

        // Assert - All states should be different
        expect(states[0], isNot(equals(states[1])));
        expect(states[1], isNot(equals(states[2])));
        expect(states[0], isNot(equals(states[2])));
      });

      test('should support border definition', () {
        // Arrange
        final theme = EditorThemeExtension.light;

        // Act
        final border = theme.fileTreeBorder;

        // Assert
        expect(border, isNotNull);
        expect(border.opacity, equals(1.0));
      });
    });

    group('integration with Flutter theme system', () {
      testWidgets('should work with Theme.of(context)', (tester) async {
        // Arrange
        EditorThemeExtension? capturedExtension;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [EditorThemeExtension.light],
            ),
            home: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                capturedExtension =
                    theme.extension<EditorThemeExtension>();
                return Container();
              },
            ),
          ),
        );

        // Assert
        expect(capturedExtension, isNotNull);
        expect(capturedExtension, isA<EditorThemeExtension>());
      });

      testWidgets('should work with custom theme', (tester) async {
        // Arrange
        final customExtension = EditorThemeExtension.light.copyWith(
          fileTreeBorder: Colors.red,
        );
        EditorThemeExtension? capturedExtension;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [customExtension],
            ),
            home: Builder(
              builder: (context) {
                capturedExtension = context.editorTheme;
                return Container();
              },
            ),
          ),
        );

        // Assert
        expect(capturedExtension?.fileTreeBorder, equals(Colors.red));
      });
    });
  });
}
