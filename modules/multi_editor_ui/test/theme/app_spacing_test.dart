import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/systems/app_spacing.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/size_primitives.dart';

void main() {
  group('AppSpacing', () {
    group('spacing values', () {
      test('should define none spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.none;

        // Assert
        expect(spacing, equals(0.0));
        expect(spacing, equals(SizePrimitives.size0));
      });

      test('should define extra extra small spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.xxs;

        // Assert
        expect(spacing, equals(2.0));
        expect(spacing, equals(SizePrimitives.size2));
      });

      test('should define extra small spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.xs;

        // Assert
        expect(spacing, equals(4.0));
        expect(spacing, equals(SizePrimitives.size4));
      });

      test('should define small spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.s;

        // Assert
        expect(spacing, equals(8.0));
        expect(spacing, equals(SizePrimitives.size8));
      });

      test('should define medium spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.m;

        // Assert
        expect(spacing, equals(12.0));
        expect(spacing, equals(SizePrimitives.size12));
      });

      test('should define large spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.l;

        // Assert
        expect(spacing, equals(16.0));
        expect(spacing, equals(SizePrimitives.size16));
      });

      test('should define extra large spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.xl;

        // Assert
        expect(spacing, equals(24.0));
        expect(spacing, equals(SizePrimitives.size24));
      });

      test('should define extra extra large spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.xxl;

        // Assert
        expect(spacing, equals(32.0));
        expect(spacing, equals(SizePrimitives.size32));
      });

      test('should define extra extra extra large spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.xxxl;

        // Assert
        expect(spacing, equals(48.0));
        expect(spacing, equals(SizePrimitives.size48));
      });

      test('should define huge spacing', () {
        // Arrange & Act
        final spacing = AppSpacing.huge;

        // Assert
        expect(spacing, equals(64.0));
        expect(spacing, equals(SizePrimitives.size64));
      });
    });

    group('8pt grid system', () {
      test('should follow 8pt grid for core sizes', () {
        // Arrange & Act
        final coreSpacings = [
          AppSpacing.s, // 8
          AppSpacing.l, // 16
          AppSpacing.xl, // 24
          AppSpacing.xxl, // 32
          AppSpacing.xxxl, // 48
          AppSpacing.huge, // 64
        ];

        // Assert - All core spacings should be multiples of 8
        for (final spacing in coreSpacings) {
          expect(spacing % 8, equals(0),
              reason: '$spacing should be a multiple of 8');
        }
      });

      test('should have refinements for granular control', () {
        // Arrange & Act
        final refinements = [
          AppSpacing.xxs, // 2
          AppSpacing.xs, // 4
          AppSpacing.m, // 12
        ];

        // Assert - These are refinements, not following strict 8pt grid
        expect(refinements[0], equals(2.0));
        expect(refinements[1], equals(4.0));
        expect(refinements[2], equals(12.0));
      });
    });

    group('progressive scale', () {
      test('should have progressive spacing scale', () {
        // Arrange & Act
        final spacings = [
          AppSpacing.none,
          AppSpacing.xxs,
          AppSpacing.xs,
          AppSpacing.s,
          AppSpacing.m,
          AppSpacing.l,
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xxxl,
          AppSpacing.huge,
        ];

        // Assert - Each spacing should be larger than or equal to the previous
        for (int i = 1; i < spacings.length; i++) {
          expect(spacings[i], greaterThanOrEqualTo(spacings[i - 1]),
              reason: 'Spacing at index $i should be >= ${i - 1}');
        }
      });

      test('should use non-negative values', () {
        // Arrange & Act
        final spacings = [
          AppSpacing.none,
          AppSpacing.xxs,
          AppSpacing.xs,
          AppSpacing.s,
          AppSpacing.m,
          AppSpacing.l,
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xxxl,
          AppSpacing.huge,
        ];

        // Assert
        for (final spacing in spacings) {
          expect(spacing, greaterThanOrEqualTo(0),
              reason: 'Spacing should be non-negative');
        }
      });
    });

    group('primitive references', () {
      test('should reference size primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppSpacing.none, equals(SizePrimitives.size0));
        expect(AppSpacing.xxs, equals(SizePrimitives.size2));
        expect(AppSpacing.xs, equals(SizePrimitives.size4));
        expect(AppSpacing.s, equals(SizePrimitives.size8));
        expect(AppSpacing.m, equals(SizePrimitives.size12));
        expect(AppSpacing.l, equals(SizePrimitives.size16));
        expect(AppSpacing.xl, equals(SizePrimitives.size24));
        expect(AppSpacing.xxl, equals(SizePrimitives.size32));
        expect(AppSpacing.xxxl, equals(SizePrimitives.size48));
        expect(AppSpacing.huge, equals(SizePrimitives.size64));
      });
    });

    group('real-world use cases', () {
      test('should provide suitable spacing for compact UI', () {
        // Arrange & Act
        final iconPadding = AppSpacing.xxs; // 2px
        final buttonPadding = AppSpacing.xs; // 4px
        final listItemPadding = AppSpacing.s; // 8px

        // Assert
        expect(iconPadding, equals(2.0));
        expect(buttonPadding, equals(4.0));
        expect(listItemPadding, equals(8.0));
      });

      test('should provide suitable spacing for standard UI', () {
        // Arrange & Act
        final inputPadding = AppSpacing.m; // 12px
        final cardPadding = AppSpacing.l; // 16px
        final sectionMargin = AppSpacing.xl; // 24px

        // Assert
        expect(inputPadding, equals(12.0));
        expect(cardPadding, equals(16.0));
        expect(sectionMargin, equals(24.0));
      });

      test('should provide suitable spacing for large layouts', () {
        // Arrange & Act
        final containerSpacing = AppSpacing.xxl; // 32px
        final pageMargin = AppSpacing.xxxl; // 48px
        final sectionGap = AppSpacing.huge; // 64px

        // Assert
        expect(containerSpacing, equals(32.0));
        expect(pageMargin, equals(48.0));
        expect(sectionGap, equals(64.0));
      });

      test('should work with EdgeInsets.all', () {
        // Arrange & Act
        final padding = EdgeInsets.all(AppSpacing.m);

        // Assert
        expect(padding.left, equals(12.0));
        expect(padding.top, equals(12.0));
        expect(padding.right, equals(12.0));
        expect(padding.bottom, equals(12.0));
      });

      test('should work with EdgeInsets.symmetric', () {
        // Arrange & Act
        final padding = EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.s,
        );

        // Assert
        expect(padding.left, equals(16.0));
        expect(padding.right, equals(16.0));
        expect(padding.top, equals(8.0));
        expect(padding.bottom, equals(8.0));
      });

      test('should work with EdgeInsets.only', () {
        // Arrange & Act
        final padding = EdgeInsets.only(
          left: AppSpacing.m,
          top: AppSpacing.s,
          right: AppSpacing.m,
          bottom: AppSpacing.xl,
        );

        // Assert
        expect(padding.left, equals(12.0));
        expect(padding.top, equals(8.0));
        expect(padding.right, equals(12.0));
        expect(padding.bottom, equals(24.0));
      });

      test('should work with SizedBox width', () {
        // Arrange & Act
        final spacer = SizedBox(width: AppSpacing.l);

        // Assert
        expect(spacer.width, equals(16.0));
      });

      test('should work with SizedBox height', () {
        // Arrange & Act
        final spacer = SizedBox(height: AppSpacing.m);

        // Assert
        expect(spacer.height, equals(12.0));
      });

      test('should support code editor spacing', () {
        // Arrange & Act
        final lineNumberPadding = AppSpacing.xs; // 4px
        final editorPadding = AppSpacing.s; // 8px
        final tabPadding = AppSpacing.m; // 12px

        // Assert
        expect(lineNumberPadding, equals(4.0),
            reason: 'Line numbers need minimal padding');
        expect(editorPadding, equals(8.0),
            reason: 'Editor needs comfortable padding');
        expect(tabPadding, equals(12.0), reason: 'Tabs need medium padding');
      });

      test('should create consistent gaps in layouts', () {
        // Arrange & Act
        final smallGap = AppSpacing.s;
        final mediumGap = AppSpacing.m;
        final largeGap = AppSpacing.l;

        // Assert - Gaps should follow predictable progression
        expect(mediumGap - smallGap, equals(4.0));
        expect(largeGap - mediumGap, equals(4.0));
      });

      test('should support responsive spacing adjustments', () {
        // Arrange & Act
        final mobileSpacing = AppSpacing.s; // 8px
        final tabletSpacing = AppSpacing.m; // 12px
        final desktopSpacing = AppSpacing.l; // 16px

        // Assert
        expect(desktopSpacing, greaterThan(tabletSpacing));
        expect(tabletSpacing, greaterThan(mobileSpacing));
      });
    });

    group('integration with Flutter widgets', () {
      test('should work with Container padding', () {
        // Arrange & Act
        final container = Container(
          padding: EdgeInsets.all(AppSpacing.m),
        );

        // Assert
        expect(container.padding, equals(EdgeInsets.all(12.0)));
      });

      test('should work with Padding widget', () {
        // Arrange & Act
        final padding = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
        );

        // Assert
        expect(
            padding.padding,
            equals(EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            )));
      });

      test('should work with ListTile contentPadding', () {
        // Arrange & Act
        final listTile = ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.xs,
          ),
        );

        // Assert
        expect(
            listTile.contentPadding,
            equals(EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            )));
      });

      test('should create consistent vertical spacing', () {
        // Arrange & Act
        final spacers = [
          SizedBox(height: AppSpacing.s),
          SizedBox(height: AppSpacing.m),
          SizedBox(height: AppSpacing.l),
        ];

        // Assert
        expect(spacers[0].height, equals(8.0));
        expect(spacers[1].height, equals(12.0));
        expect(spacers[2].height, equals(16.0));
      });

      test('should create consistent horizontal spacing', () {
        // Arrange & Act
        final spacers = [
          SizedBox(width: AppSpacing.s),
          SizedBox(width: AppSpacing.m),
          SizedBox(width: AppSpacing.l),
        ];

        // Assert
        expect(spacers[0].width, equals(8.0));
        expect(spacers[1].width, equals(12.0));
        expect(spacers[2].width, equals(16.0));
      });
    });

    group('spacing ratios', () {
      test('should maintain reasonable ratios between sizes', () {
        // Arrange & Act
        final smallToMedium = AppSpacing.m / AppSpacing.s;
        final mediumToLarge = AppSpacing.l / AppSpacing.m;

        // Assert
        expect(smallToMedium, equals(1.5)); // 12 / 8 = 1.5
        expect(mediumToLarge, closeTo(1.33, 0.01)); // 16 / 12 ≈ 1.33
      });

      test('should double at key breakpoints', () {
        // Arrange & Act
        final sToL = AppSpacing.l / AppSpacing.s;
        final lToXl = AppSpacing.xl / AppSpacing.l;

        // Assert
        expect(sToL, equals(2.0)); // 16 / 8 = 2
        expect(lToXl, equals(1.5)); // 24 / 16 = 1.5
      });
    });
  });
}
