import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/utils/context_menu_stub.dart';

void main() {
  group('ContextMenuStub Tests', () {
    test('should be no-op on non-web platforms', () {
      // Arrange
      final event = PointerDownEvent(
        buttons: kSecondaryButton,
      );

      // Act & Assert - should do nothing and not throw
      expect(() => preventNativeContextMenu(event), returnsNormally);
    });

    test('should handle any pointer event', () {
      // Arrange
      final event = PointerDownEvent(
        buttons: kPrimaryButton,
      );

      // Act & Assert
      expect(() => preventNativeContextMenu(event), returnsNormally);
    });

    test('should handle multiple calls', () {
      // Arrange
      final events = List.generate(
        5,
        (i) => PointerDownEvent(buttons: kSecondaryButton),
      );

      // Act & Assert
      expect(() {
        for (final event in events) {
          preventNativeContextMenu(event);
        }
      }, returnsNormally);
    });

    group('Use Cases', () {
      test('UC1: Desktop platform context menu', () {
        // Arrange
        final event = PointerDownEvent(
          buttons: kSecondaryButton,
        );

        // Act & Assert - stub does nothing on desktop
        expect(() => preventNativeContextMenu(event), returnsNormally);
      });

      test('UC2: Mobile platform touch events', () {
        // Arrange
        final event = PointerDownEvent(
          buttons: kPrimaryButton,
        );

        // Act & Assert - stub does nothing on mobile
        expect(() => preventNativeContextMenu(event), returnsNormally);
      });
    });
  });
}
