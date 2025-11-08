import 'package:flutter/material.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// HoverInfoWidget
///
/// Tooltip-style widget that displays hover information from LSP.
///
/// Architecture (Clean Architecture):
/// ```
/// HoverInfoWidget (UI Widget)
///     ↓ receives
/// HoverInfo (Domain Entity from LSP)
///     ↓ from
/// GetHoverInfoUseCase
/// ```
///
/// Responsibilities:
/// - Displays hover information (type, documentation)
/// - Positioned near cursor
/// - Dismissible on click outside or Escape
///
/// Example:
/// ```dart
/// HoverInfoWidget(
///   hoverInfo: lspStore.hoverInfo,
///   position: Offset(100, 200),
///   onDismiss: () {
///     // Close hover
///   },
/// )
/// ```
class HoverInfoWidget extends StatelessWidget {
  final HoverInfo hoverInfo;
  final Offset position;
  final VoidCallback? onDismiss;

  const HoverInfoWidget({
    super.key,
    required this.hoverInfo,
    required this.position,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: onDismiss,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 300,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // VS Code dark
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFF3E3E42),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    final widgets = <Widget>[];

    for (final content in hoverInfo.contents) {
      if (content is MarkedString) {
        widgets.add(_buildMarkedString(content));
      } else if (content is String) {
        widgets.add(_buildPlainText(content));
      }
      widgets.add(const SizedBox(height: 8));
    }

    return widgets;
  }

  Widget _buildMarkedString(MarkedString markedString) {
    if (markedString.language != null) {
      // Code block with syntax highlighting (simplified)
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF252526),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF3E3E42)),
        ),
        child: SelectableText(
          markedString.value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Color(0xFFD4D4D4),
          ),
        ),
      );
    } else {
      // Plain marked string
      return SelectableText(
        markedString.value,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFFCCCCCC),
        ),
      );
    }
  }

  Widget _buildPlainText(String text) {
    return SelectableText(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFFCCCCCC),
      ),
    );
  }
}
