import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/utils/context_menu_web.dart';

void main() {
  group('ContextMenuWeb Tests', () {
    test('should prevent native context menu on web', () {
      // Arrange
      final event = PointerDownEvent(
        buttons: kSecondaryButton,
      );

      // Act & Assert - should not throw
      expect(() => preventNativeContextMenu(event), returnsNormally);
    });

    test('should handle multiple calls without error', () {
      // Arrange
      final event = PointerDownEvent(
        buttons: kSecondaryButton,
      );

      // Act & Assert
      expect(() {
        preventNativeContextMenu(event);
        preventNativeContextMenu(event);
        preventNativeContextMenu(event);
      }, returnsNormally);
    });

    test('should handle primary button events', () {
      // Arrange
      final event = PointerDownEvent(
        buttons: kPrimaryButton,
      );

      // Act & Assert
      expect(() => preventNativeContextMenu(event), returnsNormally);
    });

    group('Use Cases', () {
      test('UC1: Right-click on file tree item', () {
        // Arrange
        final event = PointerDownEvent(
          buttons: kSecondaryButton,
        );

        // Act & Assert
        expect(() => preventNativeContextMenu(event), returnsNormally);
      });

      test('UC2: Multiple right-clicks in session', () {
        // Arrange
        final events = List.generate(
          10,
          (i) => PointerDownEvent(buttons: kSecondaryButton),
        );

        // Act & Assert
        expect(() {
          for (final event in events) {
            preventNativeContextMenu(event);
          }
        }, returnsNormally);
      });
    });
  });
}
