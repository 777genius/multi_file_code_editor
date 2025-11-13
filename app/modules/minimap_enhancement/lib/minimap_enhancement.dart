/// High-performance code minimap visualization
///
/// This module provides a visual overview of code files similar to VSCode's minimap.
///
/// ## Features
///
/// - **Visual Overview**: See entire file structure at a glance
/// - **Color Coding**: Different colors for code, comments, empty lines
/// - **Indentation Visualization**: Visual indent levels
/// - **Viewport Indicator**: Shows current scroll position
/// - **Click to Navigate**: Click minimap to jump to location
/// - **High Performance**: Rust WASM backend for large files
/// - **Responsive**: Updates in real-time as code changes
///
/// ## Architecture
///
/// ```
/// Dart UI (MinimapWidget)
///     ↓
/// Dart Service (MinimapService)
///     ↓ (optional)
/// Rust WASM (minimap_wasm) ← Performance layer
/// ```
///
/// ## Usage
///
/// ### Basic Example
///
/// ```dart
/// import 'package:minimap_enhancement/minimap_enhancement.dart';
///
/// // Generate minimap data
/// final service = MinimapService();
/// final result = await service.generateMinimap(
///   sourceCode: mySourceCode,
///   config: MinimapConfig(
///     sampleRate: 1, // Process every line
///     detectComments: true,
///   ),
/// );
///
/// // Display minimap
/// result.fold(
///   (error) => print('Error: $error'),
///   (data) => MinimapWidget(
///     data: data,
///     width: 120,
///     scrollPosition: currentScrollPos,
///     viewportFraction: 0.1,
///     onNavigate: (position) {
///       // Jump to position in editor
///       editor.scrollToPosition(position);
///     },
///   ),
/// );
/// ```
///
/// ### With Editor Integration
///
/// ```dart
/// class EditorWithMinimap extends StatefulWidget {
///   @override
///   State<EditorWithMinimap> createState() => _EditorWithMinimapState();
/// }
///
/// class _EditorWithMinimapState extends State<EditorWithMinimap> {
///   final _minimapService = MinimapService();
///   MinimapData _minimapData = MinimapData.empty;
///   double _scrollPosition = 0.0;
///
///   @override
///   void initState() {
///     super.initState();
///     _generateMinimap();
///   }
///
///   Future<void> _generateMinimap() async {
///     final result = await _minimapService.generateMinimap(
///       sourceCode: currentFileContent,
///     );
///
///     result.fold(
///       (error) => print('Minimap error: $error'),
///       (data) => setState(() => _minimapData = data),
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Row(
///       children: [
///         // Main editor
///         Expanded(
///           child: CodeEditor(
///             onScroll: (position) {
///               setState(() => _scrollPosition = position);
///             },
///             onContentChange: (_) => _generateMinimap(),
///           ),
///         ),
///         // Minimap
///         MinimapWidget(
///           data: _minimapData,
///           scrollPosition: _scrollPosition,
///           viewportFraction: 0.1,
///           onNavigate: (position) {
///             editor.scrollToPosition(position);
///           },
///         ),
///       ],
///     );
///   }
/// }
/// ```
///
/// ## Performance
///
/// ### Pure Dart Fallback
/// - **Small files** (<1000 lines): ~5-10ms
/// - **Medium files** (1000-5000 lines): ~20-50ms
/// - **Large files** (5000-10000 lines): ~50-100ms
///
/// ### Rust WASM (when available)
/// - **Small files** (<1000 lines): ~1-2ms ⚡
/// - **Medium files** (1000-5000 lines): ~3-10ms ⚡
/// - **Large files** (5000-50000 lines): ~10-50ms ⚡
///
/// ## Configuration
///
/// ### Sample Rate
/// For very large files, use sample rate to improve performance:
/// ```dart
/// MinimapConfig(
///   sampleRate: 2, // Process every 2nd line
/// )
/// ```
///
/// ### Max Lines
/// Limit processing for extreme cases:
/// ```dart
/// MinimapConfig(
///   maxLines: 10000, // Stop after 10k lines
/// )
/// ```
///
/// ## Theming
///
/// ```dart
/// MinimapWidget(
///   theme: MinimapTheme(
///     backgroundColor: Colors.black,
///     codeColor: Colors.white,
///     commentColor: Colors.green,
///     viewportColor: Colors.blue,
///   ),
/// )
/// ```
///
/// Or use presets:
/// ```dart
/// theme: MinimapTheme.defaultTheme() // Dark theme
/// theme: MinimapTheme.light()        // Light theme
/// ```
library minimap_enhancement;

// Models
export 'src/models/minimap_data.dart';

// Services
export 'src/services/minimap_service.dart';

// Widgets
export 'src/widgets/minimap_widget.dart';
