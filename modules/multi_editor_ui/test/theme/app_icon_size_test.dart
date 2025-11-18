import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/systems/app_icon_size.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/size_primitives.dart';

void main() {
  group('AppIconSize', () {
    group('icon size values', () {
      test('should define extra small icon size', () {
        // Arrange & Act
        final size = AppIconSize.xs;

        // Assert
        expect(size, equals(16.0));
        expect(size, equals(SizePrimitives.size16));
      });

      test('should define small icon size', () {
        // Arrange & Act
        final size = AppIconSize.s;

        // Assert
        expect(size, equals(20.0));
        expect(size, equals(SizePrimitives.size20));
      });

      test('should define medium icon size', () {
        // Arrange & Act
        final size = AppIconSize.m;

        // Assert
        expect(size, equals(24.0));
        expect(size, equals(SizePrimitives.size24));
      });

      test('should define large icon size', () {
        // Arrange & Act
        final size = AppIconSize.l;

        // Assert
        expect(size, equals(32.0));
        expect(size, equals(SizePrimitives.size32));
      });

      test('should define extra large icon size', () {
        // Arrange & Act
        final size = AppIconSize.xl;

        // Assert
        expect(size, equals(48.0));
        expect(size, equals(SizePrimitives.size48));
      });

      test('should define extra extra large icon size', () {
        // Arrange & Act
        final size = AppIconSize.xxl;

        // Assert
        expect(size, equals(64.0));
        expect(size, equals(SizePrimitives.size64));
      });
    });

    group('progressive scale', () {
      test('should have progressive icon size scale', () {
        // Arrange & Act
        final sizes = [
          AppIconSize.xs,
          AppIconSize.s,
          AppIconSize.m,
          AppIconSize.l,
          AppIconSize.xl,
          AppIconSize.xxl,
        ];

        // Assert - Each size should be larger than the previous
        for (int i = 1; i < sizes.length; i++) {
          expect(sizes[i], greaterThan(sizes[i - 1]),
              reason: 'Icon size at index $i should be > ${i - 1}');
        }
      });

      test('should use positive values', () {
        // Arrange & Act
        final sizes = [
          AppIconSize.xs,
          AppIconSize.s,
          AppIconSize.m,
          AppIconSize.l,
          AppIconSize.xl,
          AppIconSize.xxl,
        ];

        // Assert
        for (final size in sizes) {
          expect(size, greaterThan(0), reason: 'Icon size should be positive');
        }
      });
    });

    group('Material Design compliance', () {
      test('should follow Material Design icon size recommendations', () {
        // Arrange & Act
        final sizes = [
          AppIconSize.xs, // 16px
          AppIconSize.s, // 20px
          AppIconSize.m, // 24px - Material Design standard
          AppIconSize.l, // 32px
          AppIconSize.xl, // 48px
          AppIconSize.xxl, // 64px
        ];

        // Assert - Material Design recommends 18, 24, 36, 48
        // Our system uses 16, 20, 24, 32, 48, 64
        expect(sizes[2], equals(24.0),
            reason: 'Medium should be 24px (Material Design standard)');
      });

      test('should use medium as default size', () {
        // Arrange & Act
        final defaultSize = AppIconSize.m;

        // Assert
        expect(defaultSize, equals(24.0),
            reason: 'Default icon size should be 24px');
      });
    });

    group('primitive references', () {
      test('should reference size primitives correctly', () {
        // Arrange & Act & Assert
        expect(AppIconSize.xs, equals(SizePrimitives.size16));
        expect(AppIconSize.s, equals(SizePrimitives.size20));
        expect(AppIconSize.m, equals(SizePrimitives.size24));
        expect(AppIconSize.l, equals(SizePrimitives.size32));
        expect(AppIconSize.xl, equals(SizePrimitives.size48));
        expect(AppIconSize.xxl, equals(SizePrimitives.size64));
      });
    });

    group('real-world use cases', () {
      test('should provide suitable size for inline text icons', () {
        // Arrange & Act
        final inlineSize = AppIconSize.xs; // 16px

        // Assert
        expect(inlineSize, equals(16.0),
            reason: 'Inline icons should match small text size');
      });

      test('should provide suitable size for toolbar icons', () {
        // Arrange & Act
        final toolbarSize = AppIconSize.s; // 20px

        // Assert
        expect(toolbarSize, equals(20.0),
            reason: 'Toolbar icons should be compact');
      });

      test('should provide suitable size for standard UI icons', () {
        // Arrange & Act
        final standardSize = AppIconSize.m; // 24px

        // Assert
        expect(standardSize, equals(24.0),
            reason: 'Standard UI icons should be 24px');
      });

      test('should provide suitable size for app bar icons', () {
        // Arrange & Act
        final appBarSize = AppIconSize.m; // 24px

        // Assert
        expect(appBarSize, equals(24.0),
            reason: 'App bar icons should be standard size');
      });

      test('should provide suitable size for navigation icons', () {
        // Arrange & Act
        final navSize = AppIconSize.l; // 32px

        // Assert
        expect(navSize, equals(32.0),
            reason: 'Navigation icons should be prominent');
      });

      test('should provide suitable size for feature icons', () {
        // Arrange & Act
        final featureSize = AppIconSize.xl; // 48px

        // Assert
        expect(featureSize, equals(48.0),
            reason: 'Feature icons should be large');
      });

      test('should provide suitable size for hero icons', () {
        // Arrange & Act
        final heroSize = AppIconSize.xxl; // 64px

        // Assert
        expect(heroSize, equals(64.0),
            reason: 'Hero icons should be extra large');
      });
    });

    group('integration with Flutter Icon widget', () {
      test('should work with Icon widget size', () {
        // Arrange & Act
        final icon = Icon(Icons.home, size: AppIconSize.m);

        // Assert
        expect(icon.size, equals(24.0));
      });

      test('should work with IconButton iconSize', () {
        // Arrange & Act
        final iconButton = IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          iconSize: AppIconSize.m,
        );

        // Assert
        expect(iconButton.iconSize, equals(24.0));
      });

      test('should work with IconTheme data', () {
        // Arrange & Act
        final iconTheme = IconThemeData(size: AppIconSize.s);

        // Assert
        expect(iconTheme.size, equals(20.0));
      });
    });

    group('code editor use cases', () {
      test('should provide suitable size for file tree icons', () {
        // Arrange & Act
        final fileIconSize = AppIconSize.xs; // 16px

        // Assert
        expect(fileIconSize, equals(16.0),
            reason: 'File tree icons should be compact');
      });

      test('should provide suitable size for editor toolbar icons', () {
        // Arrange & Act
        final toolbarIconSize = AppIconSize.s; // 20px

        // Assert
        expect(toolbarIconSize, equals(20.0),
            reason: 'Editor toolbar icons should be readable');
      });

      test('should provide suitable size for tab close buttons', () {
        // Arrange & Act
        final tabIconSize = AppIconSize.xs; // 16px

        // Assert
        expect(tabIconSize, equals(16.0),
            reason: 'Tab close icons should be small');
      });

      test('should provide suitable size for syntax icons', () {
        // Arrange & Act
        final syntaxIconSize = AppIconSize.s; // 20px

        // Assert
        expect(syntaxIconSize, equals(20.0),
            reason: 'Syntax icons should be visible but not intrusive');
      });

      test('should provide suitable size for autocomplete icons', () {
        // Arrange & Act
        final autocompleteIconSize = AppIconSize.xs; // 16px

        // Assert
        expect(autocompleteIconSize, equals(16.0),
            reason: 'Autocomplete icons should match text height');
      });
    });

    group('icon size ratios', () {
      test('should have reasonable ratios between adjacent sizes', () {
        // Arrange & Act
        final xsToS = AppIconSize.s / AppIconSize.xs;
        final sToM = AppIconSize.m / AppIconSize.s;
        final mToL = AppIconSize.l / AppIconSize.m;

        // Assert
        expect(xsToS, equals(1.25)); // 20 / 16 = 1.25
        expect(sToM, equals(1.2)); // 24 / 20 = 1.2
        expect(mToL, closeTo(1.33, 0.01)); // 32 / 24 ≈ 1.33
      });

      test('should approximately double at key breakpoints', () {
        // Arrange & Act
        final xsToL = AppIconSize.l / AppIconSize.xs;
        final mToXl = AppIconSize.xl / AppIconSize.m;

        // Assert
        expect(xsToL, equals(2.0)); // 32 / 16 = 2
        expect(mToXl, equals(2.0)); // 48 / 24 = 2
      });
    });

    group('accessibility considerations', () {
      test('should meet minimum touch target size', () {
        // Arrange & Act
        final smallestInteractiveSize = AppIconSize.m;

        // Assert - Minimum touch target is 48x48, but icon can be 24x24 with padding
        expect(smallestInteractiveSize, greaterThanOrEqualTo(24.0),
            reason: 'Interactive icons should be at least 24px');
      });

      test('should provide large enough sizes for visibility', () {
        // Arrange & Act
        final smallestSize = AppIconSize.xs;

        // Assert - Even smallest icons should be visible
        expect(smallestSize, greaterThanOrEqualTo(16.0),
            reason: 'Icons should be at least 16px for visibility');
      });

      test('should support large icons for accessibility', () {
        // Arrange & Act
        final largeSize = AppIconSize.xl;

        // Assert
        expect(largeSize, greaterThanOrEqualTo(48.0),
            reason: 'Large icons should be clearly visible');
      });
    });

    group('visual hierarchy', () {
      test('should create clear size hierarchy', () {
        // Arrange & Act
        final secondary = AppIconSize.xs;
        final standard = AppIconSize.m;
        final primary = AppIconSize.l;
        final hero = AppIconSize.xxl;

        // Assert - Each level should be larger
        expect(standard, greaterThan(secondary));
        expect(primary, greaterThan(standard));
        expect(hero, greaterThan(primary));
      });

      test('should support emphasis through size', () {
        // Arrange & Act
        final normalEmphasis = AppIconSize.m;
        final highEmphasis = AppIconSize.l;

        // Assert
        expect(highEmphasis, greaterThan(normalEmphasis),
            reason: 'Larger icons should indicate higher emphasis');
      });
    });

    group('consistency with touch targets', () {
      test('should work with Material Design touch target', () {
        // Arrange & Act
        final iconSize = AppIconSize.m; // 24px
        final touchTarget = 48.0; // Material Design minimum

        // Assert
        expect(touchTarget, greaterThanOrEqualTo(iconSize * 2),
            reason: 'Touch target should accommodate icon with padding');
      });

      test('should leave room for padding in buttons', () {
        // Arrange & Act
        final iconSize = AppIconSize.m;
        final buttonPadding = (48.0 - iconSize) / 2;

        // Assert
        expect(buttonPadding, greaterThanOrEqualTo(12.0),
            reason: 'Should have adequate padding around icon');
      });
    });

    group('theme consistency', () {
      test('should provide consistent icon sizes across themes', () {
        // Arrange & Act
        final sizes = [
          AppIconSize.xs,
          AppIconSize.s,
          AppIconSize.m,
          AppIconSize.l,
          AppIconSize.xl,
          AppIconSize.xxl,
        ];

        // Assert - All sizes should be defined and consistent
        for (final size in sizes) {
          expect(size, isNotNull);
          expect(size, isA<double>());
        }
      });

      test('should work across light and dark themes', () {
        // Arrange & Act
        final size = AppIconSize.m;

        // Assert - Icon sizes are theme-independent
        expect(size, equals(24.0),
            reason: 'Icon sizes are theme-independent');
      });
    });

    group('icon density', () {
      test('should support compact layouts', () {
        // Arrange & Act
        final compactSize = AppIconSize.xs;

        // Assert
        expect(compactSize, equals(16.0),
            reason: 'Compact layouts need smaller icons');
      });

      test('should support standard density', () {
        // Arrange & Act
        final standardSize = AppIconSize.m;

        // Assert
        expect(standardSize, equals(24.0),
            reason: 'Standard density uses 24px icons');
      });

      test('should support comfortable density', () {
        // Arrange & Act
        final comfortableSize = AppIconSize.l;

        // Assert
        expect(comfortableSize, equals(32.0),
            reason: 'Comfortable density uses larger icons');
      });
    });
  });
}
