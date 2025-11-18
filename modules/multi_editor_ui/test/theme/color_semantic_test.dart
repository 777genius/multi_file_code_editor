import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/color_primitives.dart';
import 'package:multi_editor_ui/src/theme/tokens/semantic/color_semantic.dart';

void main() {
  group('ColorSemantic', () {
    group('light theme', () {
      late ColorSemantic lightColors;

      setUp(() {
        lightColors = ColorSemantic.light;
      });

      test('should define action primary color', () {
        // Arrange & Act
        final color = lightColors.actionPrimary;

        // Assert
        expect(color, equals(ColorPrimitives.blue50));
        expect(color, isNotNull);
      });

      test('should define action primary hover color', () {
        // Arrange & Act
        final color = lightColors.actionPrimaryHover;

        // Assert
        expect(color, equals(ColorPrimitives.blue60));
        expect(color.computeLuminance(),
            greaterThan(lightColors.actionPrimary.computeLuminance()),
            reason: 'Hover should be lighter in light theme');
      });

      test('should define action secondary color', () {
        // Arrange & Act
        final color = lightColors.actionSecondary;

        // Assert
        expect(color, equals(ColorPrimitives.purple50));
      });

      test('should define action secondary hover color', () {
        // Arrange & Act
        final color = lightColors.actionSecondaryHover;

        // Assert
        expect(color, equals(ColorPrimitives.purple60));
      });

      test('should define surface base color', () {
        // Arrange & Act
        final color = lightColors.surfaceBase;

        // Assert
        expect(color, equals(ColorPrimitives.gray98));
        expect(color.computeLuminance(), greaterThan(0.9),
            reason: 'Light theme surface should be very light');
      });

      test('should define surface elevated color', () {
        // Arrange & Act
        final color = lightColors.surfaceElevated;

        // Assert
        expect(color, equals(ColorPrimitives.white));
      });

      test('should define surface overlay color', () {
        // Arrange & Act
        final color = lightColors.surfaceOverlay;

        // Assert
        expect(color, equals(ColorPrimitives.gray95));
      });

      test('should define surface high color', () {
        // Arrange & Act
        final color = lightColors.surfaceHigh;

        // Assert
        expect(color, equals(ColorPrimitives.gray90));
      });

      test('should define content primary color', () {
        // Arrange & Act
        final color = lightColors.contentPrimary;

        // Assert
        expect(color, equals(ColorPrimitives.gray10));
        expect(color.computeLuminance(), lessThan(0.1),
            reason: 'Light theme text should be very dark');
      });

      test('should define content secondary color', () {
        // Arrange & Act
        final color = lightColors.contentSecondary;

        // Assert
        expect(color, equals(ColorPrimitives.gray40));
      });

      test('should define content tertiary color', () {
        // Arrange & Act
        final color = lightColors.contentTertiary;

        // Assert
        expect(color, equals(ColorPrimitives.gray60));
      });

      test('should define content inverse color', () {
        // Arrange & Act
        final color = lightColors.contentInverse;

        // Assert
        expect(color, equals(ColorPrimitives.white));
      });

      test('should define border default color', () {
        // Arrange & Act
        final color = lightColors.borderDefault;

        // Assert
        expect(color, equals(ColorPrimitives.gray90));
      });

      test('should define border subtle color', () {
        // Arrange & Act
        final color = lightColors.borderSubtle;

        // Assert
        expect(color, equals(ColorPrimitives.gray95));
      });

      test('should define border strong color', () {
        // Arrange & Act
        final color = lightColors.borderStrong;

        // Assert
        expect(color, equals(ColorPrimitives.gray70));
      });

      test('should define feedback success color', () {
        // Arrange & Act
        final color = lightColors.feedbackSuccess;

        // Assert
        expect(color, equals(ColorPrimitives.green50));
      });

      test('should define feedback error color', () {
        // Arrange & Act
        final color = lightColors.feedbackError;

        // Assert
        expect(color, equals(ColorPrimitives.red50));
      });

      test('should define feedback warning color', () {
        // Arrange & Act
        final color = lightColors.feedbackWarning;

        // Assert
        expect(color, equals(ColorPrimitives.orange50));
      });

      test('should define feedback info color', () {
        // Arrange & Act
        final color = lightColors.feedbackInfo;

        // Assert
        expect(color, equals(ColorPrimitives.blue50));
      });
    });

    group('dark theme', () {
      late ColorSemantic darkColors;

      setUp(() {
        darkColors = ColorSemantic.dark;
      });

      test('should define action primary color', () {
        // Arrange & Act
        final color = darkColors.actionPrimary;

        // Assert
        expect(color, equals(ColorPrimitives.blue60));
      });

      test('should define action primary hover color', () {
        // Arrange & Act
        final color = darkColors.actionPrimaryHover;

        // Assert
        expect(color, equals(ColorPrimitives.blue70));
        expect(color.computeLuminance(),
            greaterThan(darkColors.actionPrimary.computeLuminance()),
            reason: 'Hover should be lighter in dark theme too');
      });

      test('should define action secondary color', () {
        // Arrange & Act
        final color = darkColors.actionSecondary;

        // Assert
        expect(color, equals(ColorPrimitives.purple60));
      });

      test('should define action secondary hover color', () {
        // Arrange & Act
        final color = darkColors.actionSecondaryHover;

        // Assert
        expect(color, equals(ColorPrimitives.purple70));
      });

      test('should define surface base color', () {
        // Arrange & Act
        final color = darkColors.surfaceBase;

        // Assert
        expect(color, equals(ColorPrimitives.gray20));
        expect(color.computeLuminance(), lessThan(0.1),
            reason: 'Dark theme surface should be very dark');
      });

      test('should define surface elevated color', () {
        // Arrange & Act
        final color = darkColors.surfaceElevated;

        // Assert
        expect(color, equals(ColorPrimitives.gray30));
      });

      test('should define surface overlay color', () {
        // Arrange & Act
        final color = darkColors.surfaceOverlay;

        // Assert
        expect(color, equals(ColorPrimitives.gray40));
      });

      test('should define surface high color', () {
        // Arrange & Act
        final color = darkColors.surfaceHigh;

        // Assert
        expect(color, equals(ColorPrimitives.gray50));
      });

      test('should define content primary color', () {
        // Arrange & Act
        final color = darkColors.contentPrimary;

        // Assert
        expect(color, equals(ColorPrimitives.gray95));
        expect(color.computeLuminance(), greaterThan(0.8),
            reason: 'Dark theme text should be very light');
      });

      test('should define content secondary color', () {
        // Arrange & Act
        final color = darkColors.contentSecondary;

        // Assert
        expect(color, equals(ColorPrimitives.gray80));
      });

      test('should define content tertiary color', () {
        // Arrange & Act
        final color = darkColors.contentTertiary;

        // Assert
        expect(color, equals(ColorPrimitives.gray60));
      });

      test('should define content inverse color', () {
        // Arrange & Act
        final color = darkColors.contentInverse;

        // Assert
        expect(color, equals(ColorPrimitives.gray10));
      });

      test('should define border default color', () {
        // Arrange & Act
        final color = darkColors.borderDefault;

        // Assert
        expect(color, equals(ColorPrimitives.gray40));
      });

      test('should define border subtle color', () {
        // Arrange & Act
        final color = darkColors.borderSubtle;

        // Assert
        expect(color, equals(ColorPrimitives.gray30));
      });

      test('should define border strong color', () {
        // Arrange & Act
        final color = darkColors.borderStrong;

        // Assert
        expect(color, equals(ColorPrimitives.gray60));
      });

      test('should define feedback success color', () {
        // Arrange & Act
        final color = darkColors.feedbackSuccess;

        // Assert
        expect(color, equals(ColorPrimitives.green60));
      });

      test('should define feedback error color', () {
        // Arrange & Act
        final color = darkColors.feedbackError;

        // Assert
        expect(color, equals(ColorPrimitives.red60));
      });

      test('should define feedback warning color', () {
        // Arrange & Act
        final color = darkColors.feedbackWarning;

        // Assert
        expect(color, equals(ColorPrimitives.orange60));
      });

      test('should define feedback info color', () {
        // Arrange & Act
        final color = darkColors.feedbackInfo;

        // Assert
        expect(color, equals(ColorPrimitives.blue60));
      });
    });

    group('light vs dark differences', () {
      test('should have inverted surface colors', () {
        // Arrange
        final light = ColorSemantic.light;
        final dark = ColorSemantic.dark;

        // Act & Assert
        expect(light.surfaceBase.computeLuminance(),
            greaterThan(dark.surfaceBase.computeLuminance()),
            reason: 'Light theme surfaces should be lighter');
        expect(light.contentPrimary.computeLuminance(),
            lessThan(dark.contentPrimary.computeLuminance()),
            reason: 'Light theme text should be darker');
      });

      test('should have different action colors', () {
        // Arrange
        final light = ColorSemantic.light;
        final dark = ColorSemantic.dark;

        // Act & Assert
        expect(light.actionPrimary, isNot(equals(dark.actionPrimary)),
            reason: 'Action colors should differ between themes');
      });

      test('should have adjusted feedback colors', () {
        // Arrange
        final light = ColorSemantic.light;
        final dark = ColorSemantic.dark;

        // Act & Assert
        expect(light.feedbackSuccess, isNot(equals(dark.feedbackSuccess)));
        expect(light.feedbackError, isNot(equals(dark.feedbackError)));
      });
    });

    group('copyWith', () {
      test('should copy with new action primary color', () {
        // Arrange
        final original = ColorSemantic.light;
        const newColor = Color(0xFF123456);

        // Act
        final copied = original.copyWith(actionPrimary: newColor);

        // Assert
        expect(copied.actionPrimary, equals(newColor));
        expect(copied.actionSecondary, equals(original.actionSecondary));
      });

      test('should preserve other values when copying', () {
        // Arrange
        final original = ColorSemantic.light;

        // Act
        final copied = original.copyWith(surfaceBase: Colors.red);

        // Assert
        expect(copied.surfaceBase, equals(Colors.red));
        expect(copied.contentPrimary, equals(original.contentPrimary));
        expect(copied.borderDefault, equals(original.borderDefault));
      });

      test('should return new instance', () {
        // Arrange
        final original = ColorSemantic.light;

        // Act
        final copied = original.copyWith(actionPrimary: Colors.blue);

        // Assert
        expect(copied, isNot(same(original)));
      });

      test('should handle multiple property changes', () {
        // Arrange
        final original = ColorSemantic.light;

        // Act
        final copied = original.copyWith(
          actionPrimary: Colors.red,
          surfaceBase: Colors.white,
          contentPrimary: Colors.black,
        );

        // Assert
        expect(copied.actionPrimary, equals(Colors.red));
        expect(copied.surfaceBase, equals(Colors.white));
        expect(copied.contentPrimary, equals(Colors.black));
      });
    });

    group('semantic meaning', () {
      test('should map primitives to meaningful contexts', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act & Assert - Each semantic color should have clear purpose
        expect(colors.actionPrimary, isNotNull,
            reason: 'Primary actions need a color');
        expect(colors.surfaceBase, isNotNull,
            reason: 'Surfaces need a color');
        expect(colors.contentPrimary, isNotNull,
            reason: 'Content needs a color');
        expect(colors.feedbackSuccess, isNotNull,
            reason: 'Success states need a color');
      });

      test('should differentiate between action types', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act & Assert
        expect(colors.actionPrimary, isNot(equals(colors.actionSecondary)),
            reason: 'Primary and secondary actions should be distinct');
      });

      test('should provide hover states', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act & Assert
        expect(colors.actionPrimaryHover,
            isNot(equals(colors.actionPrimary)),
            reason: 'Hover state should differ from normal');
      });
    });

    group('real-world use cases', () {
      test('should provide colors for button primary', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final buttonColor = colors.actionPrimary;
        final hoverColor = colors.actionPrimaryHover;

        // Assert
        expect(buttonColor, isNotNull);
        expect(hoverColor, isNotNull);
        expect(hoverColor, isNot(equals(buttonColor)));
      });

      test('should provide colors for card backgrounds', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final cardBackground = colors.surfaceElevated;
        final cardBorder = colors.borderDefault;

        // Assert
        expect(cardBackground, isNotNull);
        expect(cardBorder, isNotNull);
      });

      test('should provide colors for text hierarchy', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final primary = colors.contentPrimary;
        final secondary = colors.contentSecondary;
        final tertiary = colors.contentTertiary;

        // Assert - Each should be progressively lighter
        expect(primary.computeLuminance(),
            lessThan(secondary.computeLuminance()));
        expect(secondary.computeLuminance(),
            lessThan(tertiary.computeLuminance()));
      });

      test('should provide colors for feedback messages', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final success = colors.feedbackSuccess;
        final error = colors.feedbackError;
        final warning = colors.feedbackWarning;
        final info = colors.feedbackInfo;

        // Assert
        expect(success, isNotNull);
        expect(error, isNotNull);
        expect(warning, isNotNull);
        expect(info, isNotNull);
        expect(success, isNot(equals(error)));
      });

      test('should provide colors for code editor surfaces', () {
        // Arrange
        final lightColors = ColorSemantic.light;
        final darkColors = ColorSemantic.dark;

        // Act
        final lightEditor = lightColors.surfaceBase;
        final darkEditor = darkColors.surfaceBase;

        // Assert
        expect(lightEditor.computeLuminance(), greaterThan(0.9));
        expect(darkEditor.computeLuminance(), lessThan(0.1));
      });
    });

    group('border hierarchy', () {
      test('should have progressive border visibility', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final subtle = colors.borderSubtle;
        final defaultBorder = colors.borderDefault;
        final strong = colors.borderStrong;

        // Assert - Subtle should be lightest, strong should be darkest
        expect(subtle.computeLuminance(),
            greaterThan(defaultBorder.computeLuminance()));
        expect(defaultBorder.computeLuminance(),
            greaterThan(strong.computeLuminance()));
      });

      test('should work in dark theme too', () {
        // Arrange
        final colors = ColorSemantic.dark;

        // Act
        final subtle = colors.borderSubtle;
        final defaultBorder = colors.borderDefault;
        final strong = colors.borderStrong;

        // Assert - In dark theme, subtle is darker, strong is lighter
        expect(subtle.computeLuminance(),
            lessThan(defaultBorder.computeLuminance()));
        expect(defaultBorder.computeLuminance(),
            lessThan(strong.computeLuminance()));
      });
    });

    group('surface hierarchy', () {
      test('should have progressive surface elevation in light theme', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final base = colors.surfaceBase;
        final elevated = colors.surfaceElevated;

        // Assert
        expect(elevated.computeLuminance(),
            greaterThan(base.computeLuminance()),
            reason: 'Elevated surfaces should be lighter in light theme');
      });

      test('should have progressive surface elevation in dark theme', () {
        // Arrange
        final colors = ColorSemantic.dark;

        // Act
        final base = colors.surfaceBase;
        final elevated = colors.surfaceElevated;
        final overlay = colors.surfaceOverlay;

        // Assert - In dark theme, elevated surfaces are lighter
        expect(elevated.computeLuminance(),
            greaterThan(base.computeLuminance()));
        expect(overlay.computeLuminance(),
            greaterThan(elevated.computeLuminance()));
      });
    });

    group('content hierarchy', () {
      test('should have clear text priority in light theme', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final primary = colors.contentPrimary;
        final secondary = colors.contentSecondary;
        final tertiary = colors.contentTertiary;

        // Assert - Primary should be darkest
        expect(primary.computeLuminance(),
            lessThan(secondary.computeLuminance()));
        expect(secondary.computeLuminance(),
            lessThan(tertiary.computeLuminance()));
      });

      test('should have clear text priority in dark theme', () {
        // Arrange
        final colors = ColorSemantic.dark;

        // Act
        final primary = colors.contentPrimary;
        final secondary = colors.contentSecondary;
        final tertiary = colors.contentTertiary;

        // Assert - Primary should be lightest
        expect(primary.computeLuminance(),
            greaterThan(secondary.computeLuminance()));
        expect(secondary.computeLuminance(),
            greaterThan(tertiary.computeLuminance()));
      });
    });

    group('inverse content', () {
      test('should provide inverse content color for light theme', () {
        // Arrange
        final colors = ColorSemantic.light;

        // Act
        final inverse = colors.contentInverse;
        final primary = colors.contentPrimary;

        // Assert - Inverse should be opposite
        expect(inverse.computeLuminance(),
            greaterThan(primary.computeLuminance() * 10));
      });

      test('should provide inverse content color for dark theme', () {
        // Arrange
        final colors = ColorSemantic.dark;

        // Act
        final inverse = colors.contentInverse;
        final primary = colors.contentPrimary;

        // Assert - Inverse should be opposite
        expect(inverse.computeLuminance(),
            lessThan(primary.computeLuminance() / 10));
      });
    });
  });
}
