import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/systems/app_radius.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/size_primitives.dart';

void main() {
  group('AppRadius', () {
    group('radius values', () {
      test('should define none radius', () {
        // Arrange & Act
        final radius = AppRadius.none;

        // Assert
        expect(radius, equals(0.0));
        expect(radius, equals(SizePrimitives.size0));
      });

      test('should define extra small radius', () {
        // Arrange & Act
        final radius = AppRadius.xs;

        // Assert
        expect(radius, equals(2.0));
        expect(radius, equals(SizePrimitives.size2));
      });

      test('should define small radius', () {
        // Arrange & Act
        final radius = AppRadius.s;

        // Assert
        expect(radius, equals(4.0));
        expect(radius, equals(SizePrimitives.size4));
      });

      test('should define medium radius', () {
        // Arrange & Act
        final radius = AppRadius.m;

        // Assert
        expect(radius, equals(8.0));
        expect(radius, equals(SizePrimitives.size8));
      });

      test('should define large radius', () {
        // Arrange & Act
        final radius = AppRadius.l;

        // Assert
        expect(radius, equals(12.0));
        expect(radius, equals(SizePrimitives.size12));
      });

      test('should define extra large radius', () {
        // Arrange & Act
        final radius = AppRadius.xl;

        // Assert
        expect(radius, equals(16.0));
        expect(radius, equals(SizePrimitives.size16));
      });

      test('should define extra extra large radius', () {
        // Arrange & Act
        final radius = AppRadius.xxl;

        // Assert
        expect(radius, equals(24.0));
        expect(radius, equals(SizePrimitives.size24));
      });

      test('should define fully rounded radius', () {
        // Arrange & Act
        final radius = AppRadius.round;

        // Assert
        expect(radius, equals(999.0));
      });
    });

    group('progressive scale', () {
      test('should have progressive radius scale', () {
        // Arrange & Act
        final radii = [
          AppRadius.none,
          AppRadius.xs,
          AppRadius.s,
          AppRadius.m,
          AppRadius.l,
          AppRadius.xl,
          AppRadius.xxl,
        ];

        // Assert - Each radius should be larger than or equal to the previous
        for (int i = 1; i < radii.length; i++) {
          expect(radii[i], greaterThanOrEqualTo(radii[i - 1]),
              reason: 'Radius at index $i should be >= ${i - 1}');
        }
      });

      test('should use non-negative values', () {
        // Arrange & Act
        final radii = [
          AppRadius.none,
          AppRadius.xs,
          AppRadius.s,
          AppRadius.m,
          AppRadius.l,
          AppRadius.xl,
          AppRadius.xxl,
          AppRadius.round,
        ];

        // Assert
        for (final radius in radii) {
          expect(radius, greaterThanOrEqualTo(0),
              reason: 'Radius should be non-negative');
        }
      });

      test('should have round as maximum value', () {
        // Arrange & Act
        final radii = [
          AppRadius.none,
          AppRadius.xs,
          AppRadius.s,
          AppRadius.m,
          AppRadius.l,
          AppRadius.xl,
          AppRadius.xxl,
        ];

        // Assert
        for (final radius in radii) {
          expect(radius, lessThan(AppRadius.round),
              reason: 'Round should be larger than all other radii');
        }
      });
    });

    group('primitive references', () {
      test('should reference size primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppRadius.none, equals(SizePrimitives.size0));
        expect(AppRadius.xs, equals(SizePrimitives.size2));
        expect(AppRadius.s, equals(SizePrimitives.size4));
        expect(AppRadius.m, equals(SizePrimitives.size8));
        expect(AppRadius.l, equals(SizePrimitives.size12));
        expect(AppRadius.xl, equals(SizePrimitives.size16));
        expect(AppRadius.xxl, equals(SizePrimitives.size24));
      });

      test('should use custom value for round', () {
        // Arrange & Act
        final round = AppRadius.round;

        // Assert
        expect(round, equals(999.0));
        expect(round, isNot(equals(SizePrimitives.size0)));
      });
    });

    group('real-world use cases', () {
      test('should provide suitable radius for sharp corners', () {
        // Arrange & Act
        final borderRadius = BorderRadius.circular(AppRadius.none);

        // Assert
        expect(borderRadius.topLeft.x, equals(0.0));
        expect(borderRadius.topLeft.y, equals(0.0));
      });

      test('should provide suitable radius for subtle rounding', () {
        // Arrange & Act
        final borderRadius = BorderRadius.circular(AppRadius.xs);

        // Assert
        expect(borderRadius.topLeft.x, equals(2.0));
      });

      test('should provide suitable radius for buttons', () {
        // Arrange & Act
        final buttonRadius = AppRadius.s; // 4px

        // Assert
        expect(buttonRadius, equals(4.0),
            reason: 'Buttons typically use subtle rounding');
      });

      test('should provide suitable radius for cards', () {
        // Arrange & Act
        final cardRadius = AppRadius.m; // 8px

        // Assert
        expect(cardRadius, equals(8.0),
            reason: 'Cards typically use medium rounding');
      });

      test('should provide suitable radius for dialogs', () {
        // Arrange & Act
        final dialogRadius = AppRadius.l; // 12px

        // Assert
        expect(dialogRadius, equals(12.0),
            reason: 'Dialogs typically use larger rounding');
      });

      test('should provide suitable radius for modals', () {
        // Arrange & Act
        final modalRadius = AppRadius.xl; // 16px

        // Assert
        expect(modalRadius, equals(16.0),
            reason: 'Modals can use extra large rounding');
      });

      test('should provide suitable radius for pills', () {
        // Arrange & Act
        final pillRadius = AppRadius.round; // 999px

        // Assert
        expect(pillRadius, equals(999.0),
            reason: 'Pills need fully rounded corners');
      });

      test('should work with BorderRadius.circular', () {
        // Arrange & Act
        final borderRadius = BorderRadius.circular(AppRadius.m);

        // Assert
        expect(borderRadius.topLeft.x, equals(8.0));
        expect(borderRadius.topRight.x, equals(8.0));
        expect(borderRadius.bottomLeft.x, equals(8.0));
        expect(borderRadius.bottomRight.x, equals(8.0));
      });

      test('should work with BorderRadius.only', () {
        // Arrange & Act
        final borderRadius = BorderRadius.only(
          topLeft: Radius.circular(AppRadius.l),
          topRight: Radius.circular(AppRadius.l),
          bottomLeft: Radius.circular(AppRadius.none),
          bottomRight: Radius.circular(AppRadius.none),
        );

        // Assert
        expect(borderRadius.topLeft.x, equals(12.0));
        expect(borderRadius.topRight.x, equals(12.0));
        expect(borderRadius.bottomLeft.x, equals(0.0));
        expect(borderRadius.bottomRight.x, equals(0.0));
      });

      test('should work with RoundedRectangleBorder', () {
        // Arrange & Act
        final shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        );

        // Assert
        expect(shape.borderRadius, equals(BorderRadius.circular(8.0)));
      });

      test('should support code editor tabs', () {
        // Arrange & Act
        final tabRadius = AppRadius.s; // 4px

        // Assert
        expect(tabRadius, equals(4.0),
            reason: 'Editor tabs need subtle rounding');
      });

      test('should support file tree items', () {
        // Arrange & Act
        final itemRadius = AppRadius.xs; // 2px

        // Assert
        expect(itemRadius, equals(2.0),
            reason: 'File tree items need minimal rounding');
      });

      test('should support popup menus', () {
        // Arrange & Act
        final menuRadius = AppRadius.m; // 8px

        // Assert
        expect(menuRadius, equals(8.0),
            reason: 'Popup menus need medium rounding');
      });

      test('should support tooltips', () {
        // Arrange & Act
        final tooltipRadius = AppRadius.s; // 4px

        // Assert
        expect(tooltipRadius, equals(4.0),
            reason: 'Tooltips need small rounding');
      });
    });

    group('integration with Flutter widgets', () {
      test('should work with Container decoration', () {
        // Arrange & Act
        final container = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        );

        // Assert
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(8.0)));
      });

      test('should work with Card shape', () {
        // Arrange & Act
        final card = Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        );

        // Assert
        final shape = card.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, equals(BorderRadius.circular(8.0)));
      });

      test('should work with ClipRRect', () {
        // Arrange & Act
        final clipRRect = ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.l),
        );

        // Assert
        expect(clipRRect.borderRadius, equals(BorderRadius.circular(12.0)));
      });

      test('should work with Material shape', () {
        // Arrange & Act
        final material = Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        );

        // Assert
        final shape = material.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, equals(BorderRadius.circular(8.0)));
      });

      test('should work with TextButton style', () {
        // Arrange & Act
        final buttonStyle = TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s),
          ),
        );

        // Assert
        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder?;
        expect(shape?.borderRadius, equals(BorderRadius.circular(4.0)));
      });

      test('should work with ElevatedButton style', () {
        // Arrange & Act
        final buttonStyle = ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        );

        // Assert
        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder?;
        expect(shape?.borderRadius, equals(BorderRadius.circular(8.0)));
      });
    });

    group('radius ratios', () {
      test('should double at key breakpoints', () {
        // Arrange & Act
        final sToM = AppRadius.m / AppRadius.s;
        final mToXl = AppRadius.xl / AppRadius.m;

        // Assert
        expect(sToM, equals(2.0)); // 8 / 4 = 2
        expect(mToXl, equals(2.0)); // 16 / 8 = 2
      });

      test('should maintain reasonable ratios between adjacent sizes', () {
        // Arrange & Act
        final xsToS = AppRadius.s / AppRadius.xs;
        final sToM = AppRadius.m / AppRadius.s;
        final mToL = AppRadius.l / AppRadius.m;

        // Assert
        expect(xsToS, equals(2.0)); // 4 / 2 = 2
        expect(sToM, equals(2.0)); // 8 / 4 = 2
        expect(mToL, equals(1.5)); // 12 / 8 = 1.5
      });
    });

    group('border radius combinations', () {
      test('should support mixed radius corners', () {
        // Arrange & Act
        final borderRadius = BorderRadius.only(
          topLeft: Radius.circular(AppRadius.l),
          topRight: Radius.circular(AppRadius.l),
          bottomLeft: Radius.circular(AppRadius.s),
          bottomRight: Radius.circular(AppRadius.s),
        );

        // Assert
        expect(borderRadius.topLeft.x, equals(12.0));
        expect(borderRadius.topRight.x, equals(12.0));
        expect(borderRadius.bottomLeft.x, equals(4.0));
        expect(borderRadius.bottomRight.x, equals(4.0));
      });

      test('should support top-only rounded corners', () {
        // Arrange & Act
        final borderRadius = BorderRadius.vertical(
          top: Radius.circular(AppRadius.m),
          bottom: Radius.circular(AppRadius.none),
        );

        // Assert
        expect(borderRadius.topLeft.x, equals(8.0));
        expect(borderRadius.topRight.x, equals(8.0));
        expect(borderRadius.bottomLeft.x, equals(0.0));
        expect(borderRadius.bottomRight.x, equals(0.0));
      });

      test('should support horizontal rounded corners', () {
        // Arrange & Act
        final borderRadius = BorderRadius.horizontal(
          left: Radius.circular(AppRadius.l),
          right: Radius.circular(AppRadius.none),
        );

        // Assert
        expect(borderRadius.topLeft.x, equals(12.0));
        expect(borderRadius.bottomLeft.x, equals(12.0));
        expect(borderRadius.topRight.x, equals(0.0));
        expect(borderRadius.bottomRight.x, equals(0.0));
      });
    });

    group('visual consistency', () {
      test('should provide consistent rounding across UI elements', () {
        // Arrange & Act
        final buttonRadius = AppRadius.s;
        final cardRadius = AppRadius.m;
        final dialogRadius = AppRadius.l;

        // Assert - Each should be progressively larger
        expect(cardRadius, greaterThan(buttonRadius));
        expect(dialogRadius, greaterThan(cardRadius));
      });

      test('should support theme-consistent rounding', () {
        // Arrange & Act
        final allRadii = [
          AppRadius.none,
          AppRadius.xs,
          AppRadius.s,
          AppRadius.m,
          AppRadius.l,
          AppRadius.xl,
          AppRadius.xxl,
        ];

        // Assert - All standard radii should be reasonable (< 50px)
        for (final radius in allRadii) {
          expect(radius, lessThanOrEqualTo(50.0),
              reason: 'Standard radii should be reasonable for UI elements');
        }
      });
    });
  });
}
