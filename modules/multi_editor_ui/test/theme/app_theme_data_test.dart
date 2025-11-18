import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/app_theme_data.dart';
import 'package:multi_editor_ui/src/theme/editor_theme_extension.dart';
import 'package:multi_editor_ui/src/theme/systems/app_elevation.dart';
import 'package:multi_editor_ui/src/theme/systems/app_icon_size.dart';
import 'package:multi_editor_ui/src/theme/systems/app_radius.dart';
import 'package:multi_editor_ui/src/theme/systems/app_spacing.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/font_primitives.dart';

void main() {
  group('AppThemeData', () {
    group('light theme', () {
      late ThemeData lightTheme;

      setUp(() {
        lightTheme = AppThemeData.light();
      });

      test('should create light theme with correct brightness', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(lightTheme.brightness, equals(Brightness.light));
        expect(lightTheme.colorScheme.brightness, equals(Brightness.light));
      });

      test('should use Material 3', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(lightTheme.useMaterial3, isTrue);
      });

      test('should generate color scheme from seed color', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(lightTheme.colorScheme, isNotNull);
        expect(lightTheme.colorScheme.primary, isNotNull);
        expect(lightTheme.colorScheme.surface, isNotNull);
        expect(lightTheme.colorScheme.onSurface, isNotNull);
      });

      test('should configure AppBar theme correctly', () {
        // Arrange & Act
        final appBarTheme = lightTheme.appBarTheme;

        // Assert
        expect(appBarTheme.backgroundColor,
            equals(lightTheme.colorScheme.surfaceContainerHighest));
        expect(appBarTheme.foregroundColor,
            equals(lightTheme.colorScheme.onSurface));
        expect(appBarTheme.elevation, equals(AppElevation.none));
        expect(appBarTheme.centerTitle, isFalse);
        expect(appBarTheme.titleTextStyle?.fontSize,
            equals(FontPrimitives.fontSize16));
        expect(appBarTheme.titleTextStyle?.fontWeight,
            equals(FontPrimitives.fontWeightMedium));
      });

      test('should configure icon theme correctly', () {
        // Arrange & Act
        final iconTheme = lightTheme.iconTheme;

        // Assert
        expect(iconTheme.color, equals(lightTheme.colorScheme.onSurface));
        expect(iconTheme.size, equals(AppIconSize.s));
      });

      test('should configure divider theme correctly', () {
        // Arrange & Act
        final dividerTheme = lightTheme.dividerTheme;

        // Assert
        expect(dividerTheme.color, equals(lightTheme.colorScheme.outline));
        expect(dividerTheme.thickness, equals(1));
        expect(dividerTheme.space, equals(1));
      });

      test('should configure card theme with border and radius', () {
        // Arrange & Act
        final cardTheme = lightTheme.cardTheme;

        // Assert
        expect(cardTheme.color, equals(lightTheme.colorScheme.surface));
        expect(cardTheme.elevation, equals(AppElevation.none));
        expect(cardTheme.shape, isA<RoundedRectangleBorder>());

        final shape = cardTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, equals(BorderRadius.circular(AppRadius.m)));
        expect(shape.side.color, equals(lightTheme.colorScheme.outline));
      });

      test('should configure dialog theme correctly', () {
        // Arrange & Act
        final dialogTheme = lightTheme.dialogTheme;

        // Assert
        expect(
            dialogTheme.backgroundColor, equals(lightTheme.colorScheme.surface));
        expect(dialogTheme.surfaceTintColor, equals(Colors.transparent));
        expect(dialogTheme.shape, isA<RoundedRectangleBorder>());

        final shape = dialogTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, equals(BorderRadius.circular(AppRadius.l)));
      });

      test('should configure input decoration theme correctly', () {
        // Arrange & Act
        final inputTheme = lightTheme.inputDecorationTheme;

        // Assert
        expect(inputTheme.filled, isTrue);
        expect(inputTheme.fillColor,
            equals(lightTheme.colorScheme.surfaceContainerHighest));

        // Check border configurations
        expect(inputTheme.border, isA<OutlineInputBorder>());
        expect(inputTheme.enabledBorder, isA<OutlineInputBorder>());
        expect(inputTheme.focusedBorder, isA<OutlineInputBorder>());

        final focusedBorder = inputTheme.focusedBorder as OutlineInputBorder;
        expect(focusedBorder.borderSide.color,
            equals(lightTheme.colorScheme.primary));
        expect(focusedBorder.borderSide.width, equals(2));

        // Check padding
        expect(
          inputTheme.contentPadding,
          equals(const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.m,
          )),
        );
      });

      test('should configure list tile theme correctly', () {
        // Arrange & Act
        final listTileTheme = lightTheme.listTileTheme;

        // Assert
        expect(listTileTheme.dense, isTrue);
        expect(
          listTileTheme.contentPadding,
          equals(const EdgeInsets.symmetric(
            horizontal: AppSpacing.s,
            vertical: AppSpacing.xxs,
          )),
        );
      });

      test('should configure popup menu theme correctly', () {
        // Arrange & Act
        final popupTheme = lightTheme.popupMenuTheme;

        // Assert
        expect(popupTheme.color, equals(lightTheme.colorScheme.surface));
        expect(popupTheme.elevation, equals(AppElevation.l));
        expect(popupTheme.shape, isA<RoundedRectangleBorder>());

        final shape = popupTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, equals(BorderRadius.circular(AppRadius.m)));
        expect(shape.side.color, equals(lightTheme.colorScheme.outline));
      });

      test('should configure tooltip theme correctly', () {
        // Arrange & Act
        final tooltipTheme = lightTheme.tooltipTheme;

        // Assert
        expect(tooltipTheme.decoration, isA<BoxDecoration>());
        final decoration = tooltipTheme.decoration as BoxDecoration;
        expect(decoration.borderRadius,
            equals(BorderRadius.circular(AppRadius.s)));

        expect(tooltipTheme.textStyle?.fontSize,
            equals(FontPrimitives.fontSize12));
        expect(
          tooltipTheme.padding,
          equals(const EdgeInsets.symmetric(
            horizontal: AppSpacing.s,
            vertical: AppSpacing.xs,
          )),
        );
      });

      test('should include EditorThemeExtension', () {
        // Arrange & Act
        final extension =
            lightTheme.extension<EditorThemeExtension>() as EditorThemeExtension;

        // Assert
        expect(extension, isNotNull);
        expect(extension, isA<EditorThemeExtension>());
      });

      test('should build complete text theme', () {
        // Arrange & Act
        final textTheme = lightTheme.textTheme;

        // Assert - Display styles
        expect(textTheme.displayLarge, isNotNull);
        expect(textTheme.displayLarge?.fontSize,
            equals(FontPrimitives.fontSize32));
        expect(textTheme.displayLarge?.fontWeight,
            equals(FontPrimitives.fontWeightSemiBold));
        expect(textTheme.displayLarge?.color,
            equals(lightTheme.colorScheme.onSurface));

        expect(textTheme.displayMedium, isNotNull);
        expect(textTheme.displayMedium?.fontSize,
            equals(FontPrimitives.fontSize28));

        expect(textTheme.displaySmall, isNotNull);
        expect(textTheme.displaySmall?.fontSize,
            equals(FontPrimitives.fontSize24));

        // Assert - Headline styles
        expect(textTheme.headlineLarge, isNotNull);
        expect(textTheme.headlineLarge?.fontSize,
            equals(FontPrimitives.fontSize20));
        expect(textTheme.headlineLarge?.fontWeight,
            equals(FontPrimitives.fontWeightMedium));

        expect(textTheme.headlineMedium, isNotNull);
        expect(textTheme.headlineMedium?.fontSize,
            equals(FontPrimitives.fontSize18));

        expect(textTheme.headlineSmall, isNotNull);
        expect(textTheme.headlineSmall?.fontSize,
            equals(FontPrimitives.fontSize16));

        // Assert - Title styles
        expect(textTheme.titleLarge, isNotNull);
        expect(textTheme.titleLarge?.fontSize,
            equals(FontPrimitives.fontSize16));

        expect(textTheme.titleMedium, isNotNull);
        expect(textTheme.titleMedium?.fontSize,
            equals(FontPrimitives.fontSize14));

        expect(textTheme.titleSmall, isNotNull);
        expect(textTheme.titleSmall?.fontSize,
            equals(FontPrimitives.fontSize12));

        // Assert - Body styles
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyLarge?.fontSize,
            equals(FontPrimitives.fontSize14));

        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodyMedium?.fontSize,
            equals(FontPrimitives.fontSize13));

        expect(textTheme.bodySmall, isNotNull);
        expect(textTheme.bodySmall?.fontSize,
            equals(FontPrimitives.fontSize12));
        expect(textTheme.bodySmall?.color,
            equals(lightTheme.colorScheme.onSurfaceVariant));

        // Assert - Label styles
        expect(textTheme.labelLarge, isNotNull);
        expect(textTheme.labelLarge?.fontSize,
            equals(FontPrimitives.fontSize14));

        expect(textTheme.labelMedium, isNotNull);
        expect(textTheme.labelMedium?.fontSize,
            equals(FontPrimitives.fontSize12));

        expect(textTheme.labelSmall, isNotNull);
        expect(textTheme.labelSmall?.fontSize,
            equals(FontPrimitives.fontSize11));
        expect(textTheme.labelSmall?.color,
            equals(lightTheme.colorScheme.onSurfaceVariant));
      });
    });

    group('dark theme', () {
      late ThemeData darkTheme;

      setUp(() {
        darkTheme = AppThemeData.dark();
      });

      test('should create dark theme with correct brightness', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(darkTheme.colorScheme.brightness, equals(Brightness.dark));
      });

      test('should use Material 3', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(darkTheme.useMaterial3, isTrue);
      });

      test('should generate color scheme from seed color', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(darkTheme.colorScheme, isNotNull);
        expect(darkTheme.colorScheme.primary, isNotNull);
        expect(darkTheme.colorScheme.surface, isNotNull);
        expect(darkTheme.colorScheme.onSurface, isNotNull);
      });

      test('should configure AppBar theme correctly', () {
        // Arrange & Act
        final appBarTheme = darkTheme.appBarTheme;

        // Assert
        expect(appBarTheme.backgroundColor,
            equals(darkTheme.colorScheme.surfaceContainerHighest));
        expect(appBarTheme.foregroundColor,
            equals(darkTheme.colorScheme.onSurface));
        expect(appBarTheme.elevation, equals(AppElevation.none));
        expect(appBarTheme.centerTitle, isFalse);
      });

      test('should configure icon theme correctly', () {
        // Arrange & Act
        final iconTheme = darkTheme.iconTheme;

        // Assert
        expect(iconTheme.color, equals(darkTheme.colorScheme.onSurface));
        expect(iconTheme.size, equals(AppIconSize.s));
      });

      test('should include EditorThemeExtension', () {
        // Arrange & Act
        final extension =
            darkTheme.extension<EditorThemeExtension>() as EditorThemeExtension;

        // Assert
        expect(extension, isNotNull);
        expect(extension, isA<EditorThemeExtension>());
      });

      test('should build complete text theme', () {
        // Arrange & Act
        final textTheme = darkTheme.textTheme;

        // Assert - All text styles should be defined
        expect(textTheme.displayLarge, isNotNull);
        expect(textTheme.displayMedium, isNotNull);
        expect(textTheme.displaySmall, isNotNull);
        expect(textTheme.headlineLarge, isNotNull);
        expect(textTheme.headlineMedium, isNotNull);
        expect(textTheme.headlineSmall, isNotNull);
        expect(textTheme.titleLarge, isNotNull);
        expect(textTheme.titleMedium, isNotNull);
        expect(textTheme.titleSmall, isNotNull);
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodySmall, isNotNull);
        expect(textTheme.labelLarge, isNotNull);
        expect(textTheme.labelMedium, isNotNull);
        expect(textTheme.labelSmall, isNotNull);
      });
    });

    group('light vs dark theme differences', () {
      late ThemeData lightTheme;
      late ThemeData darkTheme;

      setUp(() {
        lightTheme = AppThemeData.light();
        darkTheme = AppThemeData.dark();
      });

      test('should have different brightness', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(lightTheme.brightness, equals(Brightness.light));
        expect(darkTheme.brightness, equals(Brightness.dark));
      });

      test('should have different seed colors', () {
        // Arrange & Act - done in setUp

        // Assert
        // Primary colors should be different due to different seed colors
        expect(lightTheme.colorScheme.primary,
            isNot(equals(darkTheme.colorScheme.primary)));
      });

      test('should have different surface colors', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(lightTheme.colorScheme.surface,
            isNot(equals(darkTheme.colorScheme.surface)));
      });

      test('should have different text colors', () {
        // Arrange & Act - done in setUp

        // Assert
        expect(lightTheme.textTheme.bodyLarge?.color,
            isNot(equals(darkTheme.textTheme.bodyLarge?.color)));
      });

      test('should have different editor theme extensions', () {
        // Arrange & Act
        final lightExt = lightTheme.extension<EditorThemeExtension>()
            as EditorThemeExtension;
        final darkExt = darkTheme.extension<EditorThemeExtension>()
            as EditorThemeExtension;

        // Assert
        expect(lightExt.fileTreeHoverBackground,
            isNot(equals(darkExt.fileTreeHoverBackground)));
        expect(lightExt.fileTreeSelectionBackground,
            isNot(equals(darkExt.fileTreeSelectionBackground)));
      });
    });

    group('real-world use cases', () {
      test('should provide consistent spacing throughout theme', () {
        // Arrange
        final theme = AppThemeData.light();

        // Act & Assert - Check that spacing is used consistently
        final listTilePadding = theme.listTileTheme.contentPadding as EdgeInsets;
        final inputPadding = theme.inputDecorationTheme.contentPadding as EdgeInsets;

        expect(listTilePadding.horizontal, equals(AppSpacing.s));
        expect(inputPadding.horizontal, equals(AppSpacing.m));
      });

      test('should support theme switching without null safety issues', () {
        // Arrange
        final lightTheme = AppThemeData.light();
        final darkTheme = AppThemeData.dark();

        // Act & Assert - All required fields should be non-null
        expect(lightTheme.colorScheme, isNotNull);
        expect(darkTheme.colorScheme, isNotNull);
        expect(lightTheme.textTheme, isNotNull);
        expect(darkTheme.textTheme, isNotNull);
        expect(lightTheme.appBarTheme, isNotNull);
        expect(darkTheme.appBarTheme, isNotNull);
      });

      test('should provide accessible editor theme extension', () {
        // Arrange
        final theme = AppThemeData.light();

        // Act
        final extension =
            theme.extension<EditorThemeExtension>() as EditorThemeExtension;

        // Assert - Extension should provide all editor-specific colors
        expect(extension.fileTreeHoverBackground, isNotNull);
        expect(extension.fileTreeSelectionBackground, isNotNull);
        expect(extension.fileTreeSelectionHoverBackground, isNotNull);
        expect(extension.fileTreeBorder, isNotNull);
      });

      test('should maintain Material 3 design system consistency', () {
        // Arrange & Act
        final lightTheme = AppThemeData.light();
        final darkTheme = AppThemeData.dark();

        // Assert - Both themes should use Material 3
        expect(lightTheme.useMaterial3, isTrue);
        expect(darkTheme.useMaterial3, isTrue);

        // Both should have proper color scheme structure
        expect(lightTheme.colorScheme.surface, isNotNull);
        expect(lightTheme.colorScheme.surfaceContainerHighest, isNotNull);
        expect(darkTheme.colorScheme.surface, isNotNull);
        expect(darkTheme.colorScheme.surfaceContainerHighest, isNotNull);
      });
    });
  });
}
