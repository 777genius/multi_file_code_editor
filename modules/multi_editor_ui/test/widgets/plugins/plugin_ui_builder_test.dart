import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/plugins/plugin_ui_builder.dart';

void main() {
  group('PluginUIBuilder Widget Tests', () {
    Widget createWidget({
      required PluginUIDescriptor descriptor,
      Function(String action, Map<String, dynamic> data)? onItemAction,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PluginUIBuilder.build(
            descriptor,
            onItemAction: onItemAction ?? (_, __) {},
          ),
        ),
      );
    }

    group('List Type', () {
      testWidgets('should render empty list message', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.list.codePoint,
          tooltip: 'Test',
          uiData: const {
            'type': 'list',
            'items': [],
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('No items'), findsOneWidget);
      });

      testWidgets('should render list with items', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.list.codePoint,
          tooltip: 'Test',
          uiData: const {
            'type': 'list',
            'items': [
              {
                'id': 'item1',
                'title': 'Item 1',
                'subtitle': 'Description',
              },
            ],
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('should render list item with icon', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.list.codePoint,
          tooltip: 'Test',
          uiData: {
            'type': 'list',
            'items': [
              {
                'id': 'item1',
                'title': 'File',
                'iconCode': Icons.insert_drive_file.codePoint,
              },
            ],
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('File'), findsOneWidget);
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });

      testWidgets('should handle item tap', (tester) async {
        String? tappedId;
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.list.codePoint,
          tooltip: 'Test',
          uiData: const {
            'type': 'list',
            'items': [
              {
                'id': 'item1',
                'title': 'Tap Me',
                'onTap': 'select',
              },
            ],
          },
        );

        await tester.pumpWidget(
          createWidget(
            descriptor: descriptor,
            onItemAction: (action, data) {
              tappedId = data['id'] as String?;
            },
          ),
        );

        await tester.tap(find.text('Tap Me'));
        await tester.pumpAndSettle();

        expect(tappedId, equals('item1'));
      });

      testWidgets('should render multiple list items', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.list.codePoint,
          tooltip: 'Test',
          uiData: const {
            'type': 'list',
            'items': [
              {'id': '1', 'title': 'Item 1'},
              {'id': '2', 'title': 'Item 2'},
              {'id': '3', 'title': 'Item 3'},
            ],
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });
    });

    group('Custom Type', () {
      testWidgets('should show not implemented message', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.widgets.codePoint,
          tooltip: 'Test',
          uiData: const {
            'type': 'custom',
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('Custom UI type not yet implemented'), findsOneWidget);
      });
    });

    group('Unknown Type', () {
      testWidgets('should show error for unknown type', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'test',
          iconCode: Icons.error.codePoint,
          tooltip: 'Test',
          uiData: const {
            'type': 'unknown',
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('Unknown UI type: unknown'), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Recent files list', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'recent-files',
          iconCode: Icons.history.codePoint,
          tooltip: 'Recent Files',
          uiData: {
            'type': 'list',
            'items': [
              {
                'id': 'file1',
                'title': 'main.dart',
                'subtitle': 'lib/',
                'iconCode': Icons.code.codePoint,
                'onTap': 'openFile',
              },
              {
                'id': 'file2',
                'title': 'pubspec.yaml',
                'subtitle': 'root/',
                'iconCode': Icons.description.codePoint,
                'onTap': 'openFile',
              },
            ],
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));

        expect(find.text('main.dart'), findsOneWidget);
        expect(find.text('lib/'), findsOneWidget);
        expect(find.text('pubspec.yaml'), findsOneWidget);
        expect(find.text('root/'), findsOneWidget);
      });

      testWidgets('UC2: Empty search results', (tester) async {
        final descriptor = PluginUIDescriptor(
          pluginId: 'search',
          iconCode: Icons.search.codePoint,
          tooltip: 'Search',
          uiData: const {
            'type': 'list',
            'items': [],
          },
        );

        await tester.pumpWidget(createWidget(descriptor: descriptor));
        expect(find.text('No items'), findsOneWidget);
      });

      testWidgets('UC3: Clickable list items trigger actions', (tester) async {
        var actionCalled = false;
        String? actionType;

        final descriptor = PluginUIDescriptor(
          pluginId: 'actions',
          iconCode: Icons.bolt.codePoint,
          tooltip: 'Actions',
          uiData: const {
            'type': 'list',
            'items': [
              {
                'id': 'action1',
                'title': 'Run Tests',
                'onTap': 'runTests',
              },
            ],
          },
        );

        await tester.pumpWidget(
          createWidget(
            descriptor: descriptor,
            onItemAction: (action, data) {
              actionCalled = true;
              actionType = action;
            },
          ),
        );

        await tester.tap(find.text('Run Tests'));
        await tester.pumpAndSettle();

        expect(actionCalled, isTrue);
        expect(actionType, equals('runTests'));
      });
    });
  });
}
