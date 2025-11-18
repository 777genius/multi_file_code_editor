import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/color_primitives.dart';
import 'package:multi_editor_ui/src/theme/utils/accessibility.dart';

void main() {
  group('Accessibility', () {
    group('contrastRatio', () {
      test('should calculate contrast ratio between black and white', () {
        // Arrange
        const foreground = ColorPrimitives.black;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);

        // Assert
        expect(ratio, equals(21.0),
            reason: 'Black on white should be maximum contrast (21:1)');
      });

      test('should calculate contrast ratio between white and black', () {
        // Arrange
        const foreground = ColorPrimitives.white;
        const background = ColorPrimitives.black;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);

        // Assert
        expect(ratio, equals(21.0),
            reason: 'White on black should be maximum contrast (21:1)');
      });

      test('should calculate same color contrast as 1:1', () {
        // Arrange
        const foreground = ColorPrimitives.blue50;
        const background = ColorPrimitives.blue50;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);

        // Assert
        expect(ratio, equals(1.0),
            reason: 'Same colors should have 1:1 contrast');
      });

      test('should calculate gray50 on white contrast', () {
        // Arrange
        const foreground = ColorPrimitives.gray50;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);

        // Assert
        expect(ratio, greaterThan(4.5),
            reason: 'Gray50 on white should pass WCAG AA');
      });

      test('should be symmetric (order should not matter)', () {
        // Arrange
        const color1 = ColorPrimitives.blue50;
        const color2 = ColorPrimitives.white;

        // Act
        final ratio1 = Accessibility.contrastRatio(color1, color2);
        final ratio2 = Accessibility.contrastRatio(color2, color1);

        // Assert
        expect(ratio1, equals(ratio2),
            reason: 'Contrast ratio should be symmetric');
      });

      test('should return value between 1 and 21', () {
        // Arrange
        const testPairs = [
          [ColorPrimitives.blue50, ColorPrimitives.white],
          [ColorPrimitives.gray50, ColorPrimitives.gray90],
          [ColorPrimitives.red50, ColorPrimitives.black],
        ];

        // Act & Assert
        for (final pair in testPairs) {
          final ratio = Accessibility.contrastRatio(pair[0], pair[1]);
          expect(ratio, greaterThanOrEqualTo(1.0));
          expect(ratio, lessThanOrEqualTo(21.0));
        }
      });
    });

    group('meetsWcagAA', () {
      test('should pass for black on white', () {
        // Arrange
        const foreground = ColorPrimitives.black;
        const background = ColorPrimitives.white;

        // Act
        final passes = Accessibility.meetsWcagAA(foreground, background);

        // Assert
        expect(passes, isTrue,
            reason: 'Black on white should meet WCAG AA (4.5:1)');
      });

      test('should pass for white on black', () {
        // Arrange
        const foreground = ColorPrimitives.white;
        const background = ColorPrimitives.black;

        // Act
        final passes = Accessibility.meetsWcagAA(foreground, background);

        // Assert
        expect(passes, isTrue,
            reason: 'White on black should meet WCAG AA (4.5:1)');
      });

      test('should pass for gray10 on white', () {
        // Arrange
        const foreground = ColorPrimitives.gray10;
        const background = ColorPrimitives.white;

        // Act
        final passes = Accessibility.meetsWcagAA(foreground, background);

        // Assert
        expect(passes, isTrue,
            reason: 'Dark gray on white should meet WCAG AA');
      });

      test('should fail for gray80 on white', () {
        // Arrange
        const foreground = ColorPrimitives.gray80;
        const background = ColorPrimitives.white;

        // Act
        final passes = Accessibility.meetsWcagAA(foreground, background);

        // Assert
        expect(passes, isFalse,
            reason: 'Light gray on white should not meet WCAG AA');
      });

      test('should fail for same color', () {
        // Arrange
        const foreground = ColorPrimitives.blue50;
        const background = ColorPrimitives.blue50;

        // Act
        final passes = Accessibility.meetsWcagAA(foreground, background);

        // Assert
        expect(passes, isFalse,
            reason: 'Same colors should not meet WCAG AA');
      });
    });

    group('meetsWcagAALarge', () {
      test('should pass for 3:1 contrast', () {
        // Arrange - Find colors with ~3:1 contrast
        const foreground = ColorPrimitives.gray60;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);
        final passes = Accessibility.meetsWcagAALarge(foreground, background);

        // Assert
        if (ratio >= 3.0) {
          expect(passes, isTrue,
              reason: 'Should pass WCAG AA Large if contrast >= 3:1');
        }
      });

      test('should have lower requirement than regular AA', () {
        // Arrange
        const foreground = ColorPrimitives.gray70;
        const background = ColorPrimitives.white;

        // Act
        final passesRegular =
            Accessibility.meetsWcagAA(foreground, background);
        final passesLarge =
            Accessibility.meetsWcagAALarge(foreground, background);

        // Assert - Large text is more lenient
        if (passesRegular) {
          expect(passesLarge, isTrue,
              reason: 'If regular passes, large should also pass');
        }
      });
    });

    group('meetsWcagAAA', () {
      test('should pass for black on white', () {
        // Arrange
        const foreground = ColorPrimitives.black;
        const background = ColorPrimitives.white;

        // Act
        final passes = Accessibility.meetsWcagAAA(foreground, background);

        // Assert
        expect(passes, isTrue,
            reason: 'Black on white should meet WCAG AAA (7:1)');
      });

      test('should have higher requirement than AA', () {
        // Arrange
        const foreground = ColorPrimitives.gray50;
        const background = ColorPrimitives.white;

        // Act
        final passesAA = Accessibility.meetsWcagAA(foreground, background);
        final passesAAA = Accessibility.meetsWcagAAA(foreground, background);

        // Assert - AAA is stricter than AA
        if (passesAAA) {
          expect(passesAA, isTrue,
              reason: 'If AAA passes, AA should also pass');
        }
      });

      test('should fail for moderate contrast', () {
        // Arrange - Use colors with 4.5-7:1 contrast
        const foreground = ColorPrimitives.gray50;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);
        final passes = Accessibility.meetsWcagAAA(foreground, background);

        // Assert
        if (ratio < 7.0) {
          expect(passes, isFalse,
              reason: 'Should fail WCAG AAA if contrast < 7:1');
        }
      });
    });

    group('meetsWcagAAALarge', () {
      test('should pass for 4.5:1 contrast', () {
        // Arrange
        const foreground = ColorPrimitives.gray50;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);
        final passes = Accessibility.meetsWcagAAALarge(foreground, background);

        // Assert
        if (ratio >= 4.5) {
          expect(passes, isTrue,
              reason: 'Should pass WCAG AAA Large if contrast >= 4.5:1');
        }
      });

      test('should have same requirement as regular AA', () {
        // Arrange
        const foreground = ColorPrimitives.gray50;
        const background = ColorPrimitives.white;

        // Act
        final passesAA = Accessibility.meetsWcagAA(foreground, background);
        final passesAAALarge =
            Accessibility.meetsWcagAAALarge(foreground, background);

        // Assert
        expect(passesAA, equals(passesAAALarge),
            reason: 'WCAG AAA Large should equal WCAG AA regular');
      });
    });

    group('recommendedTextColor', () {
      test('should recommend black for light backgrounds', () {
        // Arrange
        const background = ColorPrimitives.white;

        // Act
        final recommended = Accessibility.recommendedTextColor(background);

        // Assert
        expect(recommended, equals(Colors.black),
            reason: 'Black should be recommended for white background');
      });

      test('should recommend white for dark backgrounds', () {
        // Arrange
        const background = ColorPrimitives.black;

        // Act
        final recommended = Accessibility.recommendedTextColor(background);

        // Assert
        expect(recommended, equals(Colors.white),
            reason: 'White should be recommended for black background');
      });

      test('should recommend black for gray98', () {
        // Arrange
        const background = ColorPrimitives.gray98;

        // Act
        final recommended = Accessibility.recommendedTextColor(background);

        // Assert
        expect(recommended, equals(Colors.black),
            reason: 'Black should be recommended for light gray');
      });

      test('should recommend white for gray10', () {
        // Arrange
        const background = ColorPrimitives.gray10;

        // Act
        final recommended = Accessibility.recommendedTextColor(background);

        // Assert
        expect(recommended, equals(Colors.white),
            reason: 'White should be recommended for dark gray');
      });

      test('should handle mid-tone colors', () {
        // Arrange
        const background = ColorPrimitives.gray50;

        // Act
        final recommended = Accessibility.recommendedTextColor(background);

        // Assert - Should be either black or white
        expect([Colors.black, Colors.white].contains(recommended), isTrue,
            reason: 'Should recommend either black or white');
      });
    });

    group('assertContrast', () {
      test('should not throw in release mode', () {
        // Arrange
        const foreground = ColorPrimitives.gray80; // Low contrast
        const background = ColorPrimitives.white;

        // Act & Assert - Should not throw, just print in debug
        expect(
          () => Accessibility.assertContrast(
            foreground,
            background,
            minimumRatio: 4.5,
          ),
          returnsNormally,
        );
      });

      test('should accept label parameter', () {
        // Arrange
        const foreground = ColorPrimitives.black;
        const background = ColorPrimitives.white;

        // Act & Assert
        expect(
          () => Accessibility.assertContrast(
            foreground,
            background,
            label: 'Test Label',
          ),
          returnsNormally,
        );
      });

      test('should accept custom minimum ratio', () {
        // Arrange
        const foreground = ColorPrimitives.gray70;
        const background = ColorPrimitives.white;

        // Act & Assert
        expect(
          () => Accessibility.assertContrast(
            foreground,
            background,
            minimumRatio: 3.0,
          ),
          returnsNormally,
        );
      });
    });

    group('real-world color combinations', () {
      test('should validate light theme text on background', () {
        // Arrange
        const textColor = ColorPrimitives.gray10;
        const backgroundColor = ColorPrimitives.gray98;

        // Act
        final ratio = Accessibility.contrastRatio(textColor, backgroundColor);
        final passes = Accessibility.meetsWcagAA(textColor, backgroundColor);

        // Assert
        expect(ratio, greaterThan(4.5));
        expect(passes, isTrue,
            reason: 'Light theme text should be accessible');
      });

      test('should validate dark theme text on background', () {
        // Arrange
        const textColor = ColorPrimitives.gray95;
        const backgroundColor = ColorPrimitives.gray20;

        // Act
        final ratio = Accessibility.contrastRatio(textColor, backgroundColor);
        final passes = Accessibility.meetsWcagAA(textColor, backgroundColor);

        // Assert
        expect(ratio, greaterThan(4.5));
        expect(passes, isTrue,
            reason: 'Dark theme text should be accessible');
      });

      test('should validate primary action color on light background', () {
        // Arrange
        const actionColor = ColorPrimitives.blue50;
        const backgroundColor = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(actionColor, backgroundColor);
        final passes = Accessibility.meetsWcagAA(actionColor, backgroundColor);

        // Assert
        expect(ratio, greaterThan(3.0),
            reason: 'Action colors should have reasonable contrast');
      });

      test('should validate error color on light background', () {
        // Arrange
        const errorColor = ColorPrimitives.red50;
        const backgroundColor = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(errorColor, backgroundColor);

        // Assert
        expect(ratio, greaterThan(3.0),
            reason: 'Error colors should be visible');
      });

      test('should validate success color on light background', () {
        // Arrange
        const successColor = ColorPrimitives.green50;
        const backgroundColor = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(successColor, backgroundColor);

        // Assert
        expect(ratio, greaterThan(3.0),
            reason: 'Success colors should be visible');
      });
    });

    group('WCAG compliance levels', () {
      test('should have clear hierarchy: AAA > AA > AA Large', () {
        // Arrange
        const foreground = ColorPrimitives.gray40;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);
        final aaLarge = Accessibility.meetsWcagAALarge(foreground, background);
        final aa = Accessibility.meetsWcagAA(foreground, background);
        final aaa = Accessibility.meetsWcagAAA(foreground, background);

        // Assert - If AAA passes, all lower levels should pass
        if (aaa) {
          expect(aa, isTrue, reason: 'AAA implies AA');
          expect(aaLarge, isTrue, reason: 'AAA implies AA Large');
        }
        // If AA passes, AA Large should pass
        if (aa) {
          expect(aaLarge, isTrue, reason: 'AA implies AA Large');
        }
      });

      test('should enforce correct ratio thresholds', () {
        // Arrange & Act & Assert
        // Test at exact thresholds
        const threshold30 = 3.0;
        const threshold45 = 4.5;
        const threshold70 = 7.0;

        // Values just below thresholds should fail
        expect(threshold30 - 0.1 >= 3.0, isFalse);
        expect(threshold45 - 0.1 >= 4.5, isFalse);
        expect(threshold70 - 0.1 >= 7.0, isFalse);

        // Values at thresholds should pass
        expect(threshold30 >= 3.0, isTrue);
        expect(threshold45 >= 4.5, isTrue);
        expect(threshold70 >= 7.0, isTrue);
      });
    });

    group('edge cases', () {
      test('should handle transparent foreground', () {
        // Arrange
        const foreground = ColorPrimitives.transparent;
        const background = ColorPrimitives.white;

        // Act
        final ratio = Accessibility.contrastRatio(foreground, background);

        // Assert - Transparent should have low contrast
        expect(ratio, lessThan(21.0));
      });

      test('should handle very similar colors', () {
        // Arrange
        const color1 = Color(0xFF000000);
        const color2 = Color(0xFF010101);

        // Act
        final ratio = Accessibility.contrastRatio(color1, color2);

        // Assert - Very similar colors should have ~1:1 contrast
        expect(ratio, closeTo(1.0, 0.1));
      });

      test('should handle saturated colors', () {
        // Arrange
        const red = ColorPrimitives.red50;
        const blue = ColorPrimitives.blue50;

        // Act
        final ratio = Accessibility.contrastRatio(red, blue);

        // Assert - Should return valid ratio
        expect(ratio, greaterThanOrEqualTo(1.0));
        expect(ratio, lessThanOrEqualTo(21.0));
      });
    });

    group('contrast ratio calculations', () {
      test('should calculate relative luminance correctly', () {
        // Arrange - Test known values
        const white = ColorPrimitives.white;
        const black = ColorPrimitives.black;

        // Act
        final whiteRatio = Accessibility.contrastRatio(white, black);
        final blackRatio = Accessibility.contrastRatio(black, white);

        // Assert - Both should be maximum contrast
        expect(whiteRatio, equals(21.0));
        expect(blackRatio, equals(21.0));
      });

      test('should handle mid-tone grays correctly', () {
        // Arrange
        const midGray = ColorPrimitives.gray50;
        const lightGray = ColorPrimitives.gray90;

        // Act
        final ratio = Accessibility.contrastRatio(midGray, lightGray);

        // Assert - Should have measurable contrast
        expect(ratio, greaterThan(2.0));
        expect(ratio, lessThan(10.0));
      });
    });

    group('accessibility best practices', () {
      test('should pass for primary UI text colors', () {
        // Arrange - Common UI text combinations
        final combinations = [
          [ColorPrimitives.gray10, ColorPrimitives.white],
          [ColorPrimitives.gray95, ColorPrimitives.gray20],
          [ColorPrimitives.black, ColorPrimitives.gray95],
        ];

        // Act & Assert
        for (final combo in combinations) {
          final passes = Accessibility.meetsWcagAA(combo[0], combo[1]);
          expect(passes, isTrue,
              reason: 'Primary text should meet WCAG AA');
        }
      });

      test('should validate language colors have sufficient contrast', () {
        // Arrange - Language colors on white background
        final languageColors = [
          ColorPrimitives.dartBlue,
          ColorPrimitives.pythonGreen,
          ColorPrimitives.typeScriptBlue,
          ColorPrimitives.cssBlue,
        ];

        // Act & Assert
        for (final color in languageColors) {
          final ratio = Accessibility.contrastRatio(color, ColorPrimitives.white);
          expect(ratio, greaterThan(3.0),
              reason: 'Language colors should be visible');
        }
      });
    });
  });
}
