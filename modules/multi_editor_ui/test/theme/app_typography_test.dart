import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/systems/app_typography.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/font_primitives.dart';

void main() {
  group('AppTypography', () {
    group('font families', () {
      test('should define sans-serif font family', () {
        // Arrange & Act
        final fontFamily = AppTypography.fontFamilySans;

        // Assert
        expect(fontFamily, isNotNull);
        expect(fontFamily, equals(FontPrimitives.fontFamilySans));
        expect(fontFamily, contains('SF Pro Text'));
      });

      test('should define monospace font family', () {
        // Arrange & Act
        final fontFamily = AppTypography.fontFamilyMono;

        // Assert
        expect(fontFamily, isNotNull);
        expect(fontFamily, equals(FontPrimitives.fontFamilyMono));
        expect(fontFamily, contains('SF Mono'));
        expect(fontFamily, contains('Monaco'));
        expect(fontFamily, contains('Consolas'));
      });

      test('should use system fonts as fallback', () {
        // Arrange & Act
        final sans = AppTypography.fontFamilySans;
        final mono = AppTypography.fontFamilyMono;

        // Assert - Check for system font fallbacks
        expect(sans, contains('Roboto'));
        expect(sans, contains('sans-serif'));
        expect(mono, contains('monospace'));
      });
    });

    group('font sizes', () {
      test('should define extra small font size', () {
        // Arrange & Act
        final fontSize = AppTypography.fontSizeXs;

        // Assert
        expect(fontSize, equals(11.0));
        expect(fontSize, equals(FontPrimitives.fontSize11));
      });

      test('should define small font size', () {
        // Arrange & Act
        final fontSize = AppTypography.fontSizeS;

        // Assert
        expect(fontSize, equals(12.0));
        expect(fontSize, equals(FontPrimitives.fontSize12));
      });

      test('should define medium font size', () {
        // Arrange & Act
        final fontSize = AppTypography.fontSizeM;

        // Assert
        expect(fontSize, equals(14.0));
        expect(fontSize, equals(FontPrimitives.fontSize14));
      });

      test('should define large font size', () {
        // Arrange & Act
        final fontSize = AppTypography.fontSizeL;

        // Assert
        expect(fontSize, equals(16.0));
        expect(fontSize, equals(FontPrimitives.fontSize16));
      });

      test('should define extra large font size', () {
        // Arrange & Act
        final fontSize = AppTypography.fontSizeXl;

        // Assert
        expect(fontSize, equals(18.0));
        expect(fontSize, equals(FontPrimitives.fontSize18));
      });

      test('should define extra extra large font size', () {
        // Arrange & Act
        final fontSize = AppTypography.fontSizeXxl;

        // Assert
        expect(fontSize, equals(20.0));
        expect(fontSize, equals(FontPrimitives.fontSize20));
      });

      test('should have progressive font size scale', () {
        // Arrange & Act
        final sizes = [
          AppTypography.fontSizeXs,
          AppTypography.fontSizeS,
          AppTypography.fontSizeM,
          AppTypography.fontSizeL,
          AppTypography.fontSizeXl,
          AppTypography.fontSizeXxl,
        ];

        // Assert - Each size should be larger than the previous
        for (int i = 1; i < sizes.length; i++) {
          expect(sizes[i], greaterThan(sizes[i - 1]),
              reason: 'Font size at index $i should be larger than ${i - 1}');
        }
      });

      test('should use positive values', () {
        // Arrange & Act
        final sizes = [
          AppTypography.fontSizeXs,
          AppTypography.fontSizeS,
          AppTypography.fontSizeM,
          AppTypography.fontSizeL,
          AppTypography.fontSizeXl,
          AppTypography.fontSizeXxl,
        ];

        // Assert
        for (final size in sizes) {
          expect(size, greaterThan(0), reason: 'Font size should be positive');
        }
      });
    });

    group('font weights', () {
      test('should define regular font weight', () {
        // Arrange & Act
        final fontWeight = AppTypography.fontWeightRegular;

        // Assert
        expect(fontWeight, equals(FontWeight.w400));
        expect(fontWeight, equals(FontPrimitives.fontWeightRegular));
      });

      test('should define medium font weight', () {
        // Arrange & Act
        final fontWeight = AppTypography.fontWeightMedium;

        // Assert
        expect(fontWeight, equals(FontWeight.w500));
        expect(fontWeight, equals(FontPrimitives.fontWeightMedium));
      });

      test('should define semi-bold font weight', () {
        // Arrange & Act
        final fontWeight = AppTypography.fontWeightSemiBold;

        // Assert
        expect(fontWeight, equals(FontWeight.w600));
        expect(fontWeight, equals(FontPrimitives.fontWeightSemiBold));
      });

      test('should define bold font weight', () {
        // Arrange & Act
        final fontWeight = AppTypography.fontWeightBold;

        // Assert
        expect(fontWeight, equals(FontWeight.w700));
        expect(fontWeight, equals(FontPrimitives.fontWeightBold));
      });

      test('should have progressive font weight scale', () {
        // Arrange & Act
        final weights = [
          AppTypography.fontWeightRegular,
          AppTypography.fontWeightMedium,
          AppTypography.fontWeightSemiBold,
          AppTypography.fontWeightBold,
        ];

        // Assert - Each weight should be heavier than the previous
        for (int i = 1; i < weights.length; i++) {
          expect(weights[i].index, greaterThan(weights[i - 1].index),
              reason: 'Font weight at index $i should be heavier than ${i - 1}');
        }
      });
    });

    group('line heights', () {
      test('should define tight line height', () {
        // Arrange & Act
        final lineHeight = AppTypography.lineHeightTight;

        // Assert
        expect(lineHeight, equals(1.2));
        expect(lineHeight, equals(FontPrimitives.lineHeight120));
      });

      test('should define normal line height', () {
        // Arrange & Act
        final lineHeight = AppTypography.lineHeightNormal;

        // Assert
        expect(lineHeight, equals(1.4));
        expect(lineHeight, equals(FontPrimitives.lineHeight140));
      });

      test('should define relaxed line height', () {
        // Arrange & Act
        final lineHeight = AppTypography.lineHeightRelaxed;

        // Assert
        expect(lineHeight, equals(1.5));
        expect(lineHeight, equals(FontPrimitives.lineHeight150));
      });

      test('should have progressive line height scale', () {
        // Arrange & Act
        final lineHeights = [
          AppTypography.lineHeightTight,
          AppTypography.lineHeightNormal,
          AppTypography.lineHeightRelaxed,
        ];

        // Assert - Each line height should be larger than the previous
        for (int i = 1; i < lineHeights.length; i++) {
          expect(lineHeights[i], greaterThan(lineHeights[i - 1]),
              reason:
                  'Line height at index $i should be larger than ${i - 1}');
        }
      });

      test('should use reasonable line height values', () {
        // Arrange & Act
        final lineHeights = [
          AppTypography.lineHeightTight,
          AppTypography.lineHeightNormal,
          AppTypography.lineHeightRelaxed,
        ];

        // Assert - Line heights should be between 1.0 and 2.0 for readability
        for (final lineHeight in lineHeights) {
          expect(lineHeight, greaterThanOrEqualTo(1.0),
              reason: 'Line height should be at least 1.0');
          expect(lineHeight, lessThanOrEqualTo(2.0),
              reason: 'Line height should not exceed 2.0');
        }
      });
    });

    group('primitive references', () {
      test('should reference font primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppTypography.fontFamilySans,
            equals(FontPrimitives.fontFamilySans));
        expect(AppTypography.fontFamilyMono,
            equals(FontPrimitives.fontFamilyMono));
      });

      test('should reference font size primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppTypography.fontSizeXs, equals(FontPrimitives.fontSize11));
        expect(AppTypography.fontSizeS, equals(FontPrimitives.fontSize12));
        expect(AppTypography.fontSizeM, equals(FontPrimitives.fontSize14));
        expect(AppTypography.fontSizeL, equals(FontPrimitives.fontSize16));
        expect(AppTypography.fontSizeXl, equals(FontPrimitives.fontSize18));
        expect(AppTypography.fontSizeXxl, equals(FontPrimitives.fontSize20));
      });

      test('should reference font weight primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppTypography.fontWeightRegular,
            equals(FontPrimitives.fontWeightRegular));
        expect(AppTypography.fontWeightMedium,
            equals(FontPrimitives.fontWeightMedium));
        expect(AppTypography.fontWeightSemiBold,
            equals(FontPrimitives.fontWeightSemiBold));
        expect(AppTypography.fontWeightBold,
            equals(FontPrimitives.fontWeightBold));
      });

      test('should reference line height primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppTypography.lineHeightTight,
            equals(FontPrimitives.lineHeight120));
        expect(AppTypography.lineHeightNormal,
            equals(FontPrimitives.lineHeight140));
        expect(AppTypography.lineHeightRelaxed,
            equals(FontPrimitives.lineHeight150));
      });
    });

    group('real-world use cases', () {
      test('should provide suitable sizes for code editor', () {
        // Arrange & Act
        final codeEditorSize = AppTypography.fontSizeM; // 14px
        final lineNumberSize = AppTypography.fontSizeS; // 12px
        final tooltipSize = AppTypography.fontSizeXs; // 11px

        // Assert
        expect(codeEditorSize, equals(14.0),
            reason: 'Code editor should use readable 14px font');
        expect(lineNumberSize, equals(12.0),
            reason: 'Line numbers should be slightly smaller');
        expect(tooltipSize, equals(11.0),
            reason: 'Tooltips should use smallest readable size');
      });

      test('should provide suitable sizes for UI elements', () {
        // Arrange & Act
        final buttonTextSize = AppTypography.fontSizeM;
        final headingSize = AppTypography.fontSizeXl;
        final titleSize = AppTypography.fontSizeL;

        // Assert
        expect(buttonTextSize, equals(14.0));
        expect(headingSize, equals(18.0));
        expect(titleSize, equals(16.0));
      });

      test('should create TextStyle with typography values', () {
        // Arrange & Act
        final textStyle = TextStyle(
          fontFamily: AppTypography.fontFamilyMono,
          fontSize: AppTypography.fontSizeM,
          fontWeight: AppTypography.fontWeightRegular,
          height: AppTypography.lineHeightNormal,
        );

        // Assert
        expect(textStyle.fontFamily, equals(AppTypography.fontFamilyMono));
        expect(textStyle.fontSize, equals(14.0));
        expect(textStyle.fontWeight, equals(FontWeight.w400));
        expect(textStyle.height, equals(1.4));
      });

      test('should support heading hierarchy', () {
        // Arrange & Act
        final h1 = TextStyle(
          fontSize: AppTypography.fontSizeXxl,
          fontWeight: AppTypography.fontWeightBold,
        );
        final h2 = TextStyle(
          fontSize: AppTypography.fontSizeXl,
          fontWeight: AppTypography.fontWeightSemiBold,
        );
        final h3 = TextStyle(
          fontSize: AppTypography.fontSizeL,
          fontWeight: AppTypography.fontWeightMedium,
        );

        // Assert - Headings should follow size hierarchy
        expect(h1.fontSize, greaterThan(h2.fontSize!));
        expect(h2.fontSize, greaterThan(h3.fontSize!));
      });

      test('should support code editor monospace rendering', () {
        // Arrange & Act
        final codeStyle = TextStyle(
          fontFamily: AppTypography.fontFamilyMono,
          fontSize: AppTypography.fontSizeM,
          height: AppTypography.lineHeightTight,
        );

        // Assert
        expect(codeStyle.fontFamily, contains('SF Mono'));
        expect(codeStyle.fontSize, equals(14.0));
        expect(codeStyle.height, equals(1.2),
            reason: 'Code should use tight line height');
      });

      test('should support accessible text sizes', () {
        // Arrange & Act
        final minReadableSize = AppTypography.fontSizeXs;

        // Assert - Minimum size should be at least 11px for accessibility
        expect(minReadableSize, greaterThanOrEqualTo(11.0),
            reason: 'Minimum text size should meet accessibility standards');
      });

      test('should maintain consistency across font systems', () {
        // Arrange & Act
        final sizes = [
          AppTypography.fontSizeXs,
          AppTypography.fontSizeS,
          AppTypography.fontSizeM,
        ];

        // Assert - Adjacent sizes should have reasonable steps
        final step1 = sizes[1] - sizes[0];
        final step2 = sizes[2] - sizes[1];

        expect(step1, equals(1.0), reason: '11px to 12px is 1px step');
        expect(step2, equals(2.0), reason: '12px to 14px is 2px step');
      });
    });

    group('integration with Flutter TextStyle', () {
      test('should work with Flutter TextStyle constructor', () {
        // Arrange & Act
        final textStyle = TextStyle(
          fontFamily: AppTypography.fontFamilySans,
          fontSize: AppTypography.fontSizeM,
          fontWeight: AppTypography.fontWeightMedium,
          height: AppTypography.lineHeightNormal,
        );

        // Assert
        expect(textStyle, isA<TextStyle>());
        expect(textStyle.fontFamily, isNotNull);
        expect(textStyle.fontSize, isNotNull);
        expect(textStyle.fontWeight, isNotNull);
        expect(textStyle.height, isNotNull);
      });

      test('should create body text style', () {
        // Arrange & Act
        final bodyStyle = TextStyle(
          fontFamily: AppTypography.fontFamilySans,
          fontSize: AppTypography.fontSizeM,
          fontWeight: AppTypography.fontWeightRegular,
          height: AppTypography.lineHeightNormal,
        );

        // Assert
        expect(bodyStyle.fontSize, equals(14.0));
        expect(bodyStyle.fontWeight, equals(FontWeight.w400));
        expect(bodyStyle.height, equals(1.4));
      });

      test('should create heading text style', () {
        // Arrange & Act
        final headingStyle = TextStyle(
          fontFamily: AppTypography.fontFamilySans,
          fontSize: AppTypography.fontSizeXxl,
          fontWeight: AppTypography.fontWeightBold,
          height: AppTypography.lineHeightTight,
        );

        // Assert
        expect(headingStyle.fontSize, equals(20.0));
        expect(headingStyle.fontWeight, equals(FontWeight.w700));
        expect(headingStyle.height, equals(1.2));
      });
    });
  });
}
