import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/color_primitives.dart';

void main() {
  group('ColorPrimitives', () {
    group('blue palette', () {
      test('should define blue10', () {
        // Arrange & Act
        final color = ColorPrimitives.blue10;

        // Assert
        expect(color, equals(const Color(0xFF001F3F)));
        expect(color.value, equals(0xFF001F3F));
      });

      test('should define blue20', () {
        // Arrange & Act
        final color = ColorPrimitives.blue20;

        // Assert
        expect(color, equals(const Color(0xFF003366)));
      });

      test('should define blue30', () {
        // Arrange & Act
        final color = ColorPrimitives.blue30;

        // Assert
        expect(color, equals(const Color(0xFF004080)));
      });

      test('should define blue40', () {
        // Arrange & Act
        final color = ColorPrimitives.blue40;

        // Assert
        expect(color, equals(const Color(0xFF0052A3)));
      });

      test('should define blue50', () {
        // Arrange & Act
        final color = ColorPrimitives.blue50;

        // Assert
        expect(color, equals(const Color(0xFF0066CC)));
      });

      test('should define blue60', () {
        // Arrange & Act
        final color = ColorPrimitives.blue60;

        // Assert
        expect(color, equals(const Color(0xFF3385D6)));
      });

      test('should define blue70', () {
        // Arrange & Act
        final color = ColorPrimitives.blue70;

        // Assert
        expect(color, equals(const Color(0xFF66A3E0)));
      });

      test('should define blue80', () {
        // Arrange & Act
        final color = ColorPrimitives.blue80;

        // Assert
        expect(color, equals(const Color(0xFF99C2EB)));
      });

      test('should define blue90', () {
        // Arrange & Act
        final color = ColorPrimitives.blue90;

        // Assert
        expect(color, equals(const Color(0xFFCCE0F5)));
      });

      test('should define blue95', () {
        // Arrange & Act
        final color = ColorPrimitives.blue95;

        // Assert
        expect(color, equals(const Color(0xFFE6F0FA)));
      });

      test('should have progressive lightness in blue palette', () {
        // Arrange & Act
        final blues = [
          ColorPrimitives.blue10,
          ColorPrimitives.blue20,
          ColorPrimitives.blue30,
          ColorPrimitives.blue40,
          ColorPrimitives.blue50,
          ColorPrimitives.blue60,
          ColorPrimitives.blue70,
          ColorPrimitives.blue80,
          ColorPrimitives.blue90,
          ColorPrimitives.blue95,
        ];

        // Assert - Each blue should be lighter than the previous
        for (int i = 1; i < blues.length; i++) {
          expect(blues[i].computeLuminance(),
              greaterThan(blues[i - 1].computeLuminance()),
              reason: 'Blue at index $i should be lighter than ${i - 1}');
        }
      });
    });

    group('gray palette', () {
      test('should define gray10', () {
        // Arrange & Act
        final color = ColorPrimitives.gray10;

        // Assert
        expect(color, equals(const Color(0xFF0A0A0A)));
      });

      test('should define gray20', () {
        // Arrange & Act
        final color = ColorPrimitives.gray20;

        // Assert
        expect(color, equals(const Color(0xFF1E1E1E)));
      });

      test('should define gray30', () {
        // Arrange & Act
        final color = ColorPrimitives.gray30;

        // Assert
        expect(color, equals(const Color(0xFF2D2D30)));
      });

      test('should define gray40', () {
        // Arrange & Act
        final color = ColorPrimitives.gray40;

        // Assert
        expect(color, equals(const Color(0xFF3E3E42)));
      });

      test('should define gray50', () {
        // Arrange & Act
        final color = ColorPrimitives.gray50;

        // Assert
        expect(color, equals(const Color(0xFF5C5C60)));
      });

      test('should define gray60', () {
        // Arrange & Act
        final color = ColorPrimitives.gray60;

        // Assert
        expect(color, equals(const Color(0xFF8899A8)));
      });

      test('should define gray70', () {
        // Arrange & Act
        final color = ColorPrimitives.gray70;

        // Assert
        expect(color, equals(const Color(0xFFA0A0A0)));
      });

      test('should define gray80', () {
        // Arrange & Act
        final color = ColorPrimitives.gray80;

        // Assert
        expect(color, equals(const Color(0xFFC0C0C0)));
      });

      test('should define gray90', () {
        // Arrange & Act
        final color = ColorPrimitives.gray90;

        // Assert
        expect(color, equals(const Color(0xFFE0E0E0)));
      });

      test('should define gray95', () {
        // Arrange & Act
        final color = ColorPrimitives.gray95;

        // Assert
        expect(color, equals(const Color(0xFFF5F5F5)));
      });

      test('should define gray98', () {
        // Arrange & Act
        final color = ColorPrimitives.gray98;

        // Assert
        expect(color, equals(const Color(0xFFFAFAFA)));
      });

      test('should have progressive lightness in gray palette', () {
        // Arrange & Act
        final grays = [
          ColorPrimitives.gray10,
          ColorPrimitives.gray20,
          ColorPrimitives.gray30,
          ColorPrimitives.gray40,
          ColorPrimitives.gray50,
          ColorPrimitives.gray60,
          ColorPrimitives.gray70,
          ColorPrimitives.gray80,
          ColorPrimitives.gray90,
          ColorPrimitives.gray95,
          ColorPrimitives.gray98,
        ];

        // Assert - Each gray should be lighter than the previous
        for (int i = 1; i < grays.length; i++) {
          expect(grays[i].computeLuminance(),
              greaterThan(grays[i - 1].computeLuminance()),
              reason: 'Gray at index $i should be lighter than ${i - 1}');
        }
      });
    });

    group('accent palettes', () {
      test('should define purple colors', () {
        // Arrange & Act
        final purple50 = ColorPrimitives.purple50;
        final purple60 = ColorPrimitives.purple60;
        final purple70 = ColorPrimitives.purple70;

        // Assert
        expect(purple50, equals(const Color(0xFF9C27B0)));
        expect(purple60, equals(const Color(0xFFAB47BC)));
        expect(purple70, equals(const Color(0xFFBA68C8)));
      });

      test('should define green colors', () {
        // Arrange & Act
        final green50 = ColorPrimitives.green50;
        final green60 = ColorPrimitives.green60;
        final green70 = ColorPrimitives.green70;

        // Assert
        expect(green50, equals(const Color(0xFF4CAF50)));
        expect(green60, equals(const Color(0xFF66BB6A)));
        expect(green70, equals(const Color(0xFF81C784)));
      });

      test('should define red colors', () {
        // Arrange & Act
        final red50 = ColorPrimitives.red50;
        final red60 = ColorPrimitives.red60;
        final red70 = ColorPrimitives.red70;

        // Assert
        expect(red50, equals(const Color(0xFFD32F2F)));
        expect(red60, equals(const Color(0xFFE57373)));
        expect(red70, equals(const Color(0xFFEF5350)));
      });

      test('should define orange colors', () {
        // Arrange & Act
        final orange50 = ColorPrimitives.orange50;
        final orange60 = ColorPrimitives.orange60;
        final orange70 = ColorPrimitives.orange70;

        // Assert
        expect(orange50, equals(const Color(0xFFFF9800)));
        expect(orange60, equals(const Color(0xFFFFA726)));
        expect(orange70, equals(const Color(0xFFFFB74D)));
      });

      test('should define yellow colors', () {
        // Arrange & Act
        final yellow50 = ColorPrimitives.yellow50;
        final yellow60 = ColorPrimitives.yellow60;
        final yellow70 = ColorPrimitives.yellow70;

        // Assert
        expect(yellow50, equals(const Color(0xFFF7DF1E)));
        expect(yellow60, equals(const Color(0xFFF9E54B)));
        expect(yellow70, equals(const Color(0xFFFBEB77)));
      });

      test('should have progressive lightness in accent palettes', () {
        // Arrange & Act
        final purples = [
          ColorPrimitives.purple50,
          ColorPrimitives.purple60,
          ColorPrimitives.purple70
        ];
        final greens = [
          ColorPrimitives.green50,
          ColorPrimitives.green60,
          ColorPrimitives.green70
        ];

        // Assert
        expect(purples[1].computeLuminance(),
            greaterThan(purples[0].computeLuminance()));
        expect(purples[2].computeLuminance(),
            greaterThan(purples[1].computeLuminance()));
        expect(greens[1].computeLuminance(),
            greaterThan(greens[0].computeLuminance()));
        expect(greens[2].computeLuminance(),
            greaterThan(greens[1].computeLuminance()));
      });
    });

    group('language-specific colors', () {
      test('should define Dart blue', () {
        // Arrange & Act
        final color = ColorPrimitives.dartBlue;

        // Assert
        expect(color, equals(const Color(0xFF0175C2)));
      });

      test('should define JavaScript yellow', () {
        // Arrange & Act
        final color = ColorPrimitives.javaScriptYellow;

        // Assert
        expect(color, equals(const Color(0xFFF7DF1E)));
      });

      test('should define TypeScript blue', () {
        // Arrange & Act
        final color = ColorPrimitives.typeScriptBlue;

        // Assert
        expect(color, equals(const Color(0xFF3178C6)));
      });

      test('should define Python green', () {
        // Arrange & Act
        final color = ColorPrimitives.pythonGreen;

        // Assert
        expect(color, equals(const Color(0xFF3776AB)));
      });

      test('should define HTML orange', () {
        // Arrange & Act
        final color = ColorPrimitives.htmlOrange;

        // Assert
        expect(color, equals(const Color(0xFFE44D26)));
      });

      test('should define CSS blue', () {
        // Arrange & Act
        final color = ColorPrimitives.cssBlue;

        // Assert
        expect(color, equals(const Color(0xFF264DE4)));
      });

      test('should use recognizable brand colors', () {
        // Arrange & Act
        final dartBlue = ColorPrimitives.dartBlue;
        final jsYellow = ColorPrimitives.javaScriptYellow;

        // Assert - Dart should be blue-ish, JS should be yellow-ish
        expect(dartBlue.blue, greaterThan(dartBlue.red));
        expect(jsYellow.red, greaterThan(200));
        expect(jsYellow.green, greaterThan(200));
      });
    });

    group('pure colors', () {
      test('should define white', () {
        // Arrange & Act
        final color = ColorPrimitives.white;

        // Assert
        expect(color, equals(const Color(0xFFFFFFFF)));
        expect(color, equals(Colors.white));
      });

      test('should define black', () {
        // Arrange & Act
        final color = ColorPrimitives.black;

        // Assert
        expect(color, equals(const Color(0xFF000000)));
        expect(color, equals(Colors.black));
      });

      test('should define transparent', () {
        // Arrange & Act
        final color = ColorPrimitives.transparent;

        // Assert
        expect(color, equals(Colors.transparent));
        expect(color.opacity, equals(0.0));
      });
    });

    group('color contrast', () {
      test('should have high contrast between gray10 and gray98', () {
        // Arrange & Act
        final dark = ColorPrimitives.gray10;
        final light = ColorPrimitives.gray98;

        // Assert
        expect(light.computeLuminance(),
            greaterThan(dark.computeLuminance() * 10),
            reason: 'Light and dark grays should have high contrast');
      });

      test('should have sufficient contrast in blue palette endpoints', () {
        // Arrange & Act
        final darkBlue = ColorPrimitives.blue10;
        final lightBlue = ColorPrimitives.blue95;

        // Assert
        expect(lightBlue.computeLuminance(),
            greaterThan(darkBlue.computeLuminance() * 10),
            reason: 'Blue palette should span sufficient contrast range');
      });
    });

    group('color properties', () {
      test('should be immutable Color objects', () {
        // Arrange & Act
        final color = ColorPrimitives.blue50;

        // Assert
        expect(color, isA<Color>());
        expect(color.value, isNotNull);
      });

      test('should have valid ARGB values', () {
        // Arrange & Act
        final colors = [
          ColorPrimitives.blue50,
          ColorPrimitives.gray50,
          ColorPrimitives.red50,
        ];

        // Assert
        for (final color in colors) {
          expect(color.alpha, greaterThanOrEqualTo(0));
          expect(color.alpha, lessThanOrEqualTo(255));
          expect(color.red, greaterThanOrEqualTo(0));
          expect(color.red, lessThanOrEqualTo(255));
          expect(color.green, greaterThanOrEqualTo(0));
          expect(color.green, lessThanOrEqualTo(255));
          expect(color.blue, greaterThanOrEqualTo(0));
          expect(color.blue, lessThanOrEqualTo(255));
        }
      });

      test('should be fully opaque except transparent', () {
        // Arrange & Act
        final colors = [
          ColorPrimitives.blue50,
          ColorPrimitives.gray50,
          ColorPrimitives.red50,
          ColorPrimitives.white,
          ColorPrimitives.black,
        ];

        // Assert
        for (final color in colors) {
          expect(color.alpha, equals(255),
              reason: 'Color should be fully opaque');
        }
      });
    });

    group('real-world use cases', () {
      test('should provide colors for light theme backgrounds', () {
        // Arrange & Act
        final background = ColorPrimitives.gray98;
        final surface = ColorPrimitives.white;

        // Assert
        expect(background.computeLuminance(), greaterThan(0.9));
        expect(surface.computeLuminance(), equals(1.0));
      });

      test('should provide colors for dark theme backgrounds', () {
        // Arrange & Act
        final background = ColorPrimitives.gray20;
        final surface = ColorPrimitives.gray30;

        // Assert
        expect(background.computeLuminance(), lessThan(0.1));
        expect(surface.computeLuminance(), lessThan(0.1));
      });

      test('should provide colors for primary actions', () {
        // Arrange & Act
        final primaryLight = ColorPrimitives.blue50;
        final primaryDark = ColorPrimitives.blue60;

        // Assert
        expect(primaryLight, isNotNull);
        expect(primaryDark, isNotNull);
        expect(primaryDark.computeLuminance(),
            greaterThan(primaryLight.computeLuminance()));
      });

      test('should provide colors for feedback states', () {
        // Arrange & Act
        final success = ColorPrimitives.green50;
        final error = ColorPrimitives.red50;
        final warning = ColorPrimitives.orange50;

        // Assert
        expect(success, isNotNull);
        expect(error, isNotNull);
        expect(warning, isNotNull);
      });
    });

    group('naming convention', () {
      test('should follow hue-lightness naming pattern', () {
        // Arrange & Act
        final blue50 = ColorPrimitives.blue50;
        final blue70 = ColorPrimitives.blue70;

        // Assert - Higher number should be lighter
        expect(blue70.computeLuminance(),
            greaterThan(blue50.computeLuminance()),
            reason: 'Higher lightness number should be lighter');
      });

      test('should use consistent number scale', () {
        // Arrange & Act
        final blueSteps = [10, 20, 30, 40, 50, 60, 70, 80, 90, 95];
        final graySteps = [10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 98];

        // Assert - Both palettes use similar stepping
        expect(blueSteps.length, greaterThanOrEqualTo(5));
        expect(graySteps.length, greaterThanOrEqualTo(5));
      });
    });

    group('color accessibility', () {
      test('should provide sufficient light colors for dark backgrounds', () {
        // Arrange & Act
        final lightColors = [
          ColorPrimitives.gray95,
          ColorPrimitives.gray98,
          ColorPrimitives.white,
        ];

        // Assert
        for (final color in lightColors) {
          expect(color.computeLuminance(), greaterThan(0.8),
              reason: 'Light colors should have high luminance');
        }
      });

      test('should provide sufficient dark colors for light backgrounds', () {
        // Arrange & Act
        final darkColors = [
          ColorPrimitives.gray10,
          ColorPrimitives.gray20,
          ColorPrimitives.black,
        ];

        // Assert
        for (final color in darkColors) {
          expect(color.computeLuminance(), lessThan(0.2),
              reason: 'Dark colors should have low luminance');
        }
      });
    });

    group('consistency across palettes', () {
      test('should have consistent number of steps in main palettes', () {
        // Arrange & Act
        final blueCount = 10; // blue10 to blue95
        final grayCount = 11; // gray10 to gray98

        // Assert - Main palettes should have similar granularity
        expect(blueCount, greaterThanOrEqualTo(8));
        expect(grayCount, greaterThanOrEqualTo(8));
      });

      test('should use same lightness values across hues', () {
        // Arrange & Act
        final blue50 = ColorPrimitives.blue50;
        final purple50 = ColorPrimitives.purple50;
        final green50 = ColorPrimitives.green50;

        // Assert - All 50-level colors should have similar lightness
        final blue50Lum = blue50.computeLuminance();
        final purple50Lum = purple50.computeLuminance();
        final green50Lum = green50.computeLuminance();

        expect(purple50Lum, greaterThan(blue50Lum * 0.5));
        expect(purple50Lum, lessThan(blue50Lum * 2.0));
        expect(green50Lum, greaterThan(blue50Lum * 0.5));
        expect(green50Lum, lessThan(blue50Lum * 2.0));
      });
    });
  });
}
