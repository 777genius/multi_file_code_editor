import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/plugin_header_button.dart';

void main() {
  group('PluginHeaderButton Widget Tests', () {
    late PluginUIDescriptor testDescriptor;

    setUp(() {
      testDescriptor = PluginUIDescriptor(
        pluginId: 'test-plugin',
        iconCode: Icons.star.codePoint,
        tooltip: 'Test Plugin',
        uiData: const {
          'type': 'list',
          'items': [],
        },
      );
    });

    Widget createWidget({
      required PluginUIDescriptor descriptor,
      Function(String action, Map<String, dynamic> data)? onItemAction,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PluginHeaderButton(
            descriptor: descriptor,
            onItemAction: onItemAction ?? (_, __) {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should display plugin icon', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('should have tooltip', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));
        expect(find.byTooltip('Test Plugin'), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should open dialog on tap', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));

        await tester.tap(find.byIcon(Icons.star));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('Test Plugin'), findsOneWidget);
      });

      testWidgets('should close dialog on close button tap', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));

        await tester.tap(find.byIcon(Icons.star));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsNothing);
      });
    });

    group('Dialog Content', () {
      testWidgets('should show empty message for empty list', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));

        await tester.tap(find.byIcon(Icons.star));
        await tester.pumpAndSettle();

        expect(find.text('No items'), findsOneWidget);
      });

      testWidgets('should show plugin icon in dialog header', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));

        await tester.tap(find.byIcon(Icons.star));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.star), findsNWidgets(2)); // Button + dialog
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User opens plugin popup', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));

        await tester.tap(find.byIcon(Icons.star));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('Test Plugin'), findsOneWidget);
      });

      testWidgets('UC2: User closes plugin popup', (tester) async {
        await tester.pumpWidget(createWidget(descriptor: testDescriptor));

        await tester.tap(find.byIcon(Icons.star));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsNothing);
      });
    });
  });
}
