import 'package:flutter/material.dart';

/// SettingsDialog
///
/// Dialog for configuring IDE settings.
///
/// Architecture (Clean Architecture):
/// - Presentation layer UI component
/// - Uses Material Dialog
/// - Settings stored in shared_preferences (future)
///
/// Responsibilities:
/// - Display editor settings (theme, font size, etc.)
/// - Display LSP settings (server URLs, timeouts)
/// - Save/cancel settings
///
/// Example:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => SettingsDialog(
///     onSave: (settings) {
///       // Apply settings
///     },
///   ),
/// );
/// ```
class SettingsDialog extends StatefulWidget {
  final Map<String, dynamic>? initialSettings;
  final void Function(Map<String, dynamic>)? onSave;

  const SettingsDialog({
    super.key,
    this.initialSettings,
    this.onSave,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Editor settings
  double _fontSize = 14.0;
  bool _showLineNumbers = true;
  bool _wordWrap = false;
  String _theme = 'dark';

  // LSP settings
  String _lspBridgeUrl = 'ws://localhost:9999';
  int _connectionTimeout = 10;
  int _requestTimeout = 30;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load initial settings
    if (widget.initialSettings != null) {
      _loadSettings(widget.initialSettings!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadSettings(Map<String, dynamic> settings) {
    setState(() {
      _fontSize = settings['fontSize'] ?? 14.0;
      _showLineNumbers = settings['showLineNumbers'] ?? true;
      _wordWrap = settings['wordWrap'] ?? false;
      _theme = settings['theme'] ?? 'dark';
      _lspBridgeUrl = settings['lspBridgeUrl'] ?? 'ws://localhost:9999';
      _connectionTimeout = settings['connectionTimeout'] ?? 10;
      _requestTimeout = settings['requestTimeout'] ?? 30;
    });
  }

  Map<String, dynamic> _collectSettings() {
    return {
      'fontSize': _fontSize,
      'showLineNumbers': _showLineNumbers,
      'wordWrap': _wordWrap,
      'theme': _theme,
      'lspBridgeUrl': _lspBridgeUrl,
      'connectionTimeout': _connectionTimeout,
      'requestTimeout': _requestTimeout,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Container(
        width: 700,
        height: 600,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Tabs
            _buildTabs(),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEditorSettings(),
                  _buildLspSettings(),
                  _buildAbout(),
                ],
              ),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D30),
        border: Border(
          bottom: BorderSide(color: Color(0xFF3E3E42), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, color: Color(0xFFCCCCCC)),
          const SizedBox(width: 12),
          const Text(
            'Settings',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: const Color(0xFFCCCCCC),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF252526),
        border: Border(
          bottom: BorderSide(color: Color(0xFF3E3E42), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF007ACC),
        labelColor: const Color(0xFFFFFFFF),
        unselectedLabelColor: const Color(0xFFCCCCCC).withOpacity(0.6),
        tabs: const [
          Tab(text: 'Editor'),
          Tab(text: 'LSP'),
          Tab(text: 'About'),
        ],
      ),
    );
  }

  Widget _buildEditorSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editor Settings',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Font Size
          _buildSettingItem(
            'Font Size',
            Slider(
              value: _fontSize,
              min: 10,
              max: 24,
              divisions: 14,
              label: _fontSize.toStringAsFixed(0),
              activeColor: const Color(0xFF007ACC),
              onChanged: (value) => setState(() => _fontSize = value),
            ),
            trailing: Text(
              '${_fontSize.toStringAsFixed(0)}px',
              style: const TextStyle(color: Color(0xFFCCCCCC)),
            ),
          ),

          const SizedBox(height: 16),

          // Show Line Numbers
          _buildSwitchSetting(
            'Show Line Numbers',
            _showLineNumbers,
            (value) => setState(() => _showLineNumbers = value),
          ),

          const SizedBox(height: 16),

          // Word Wrap
          _buildSwitchSetting(
            'Word Wrap',
            _wordWrap,
            (value) => setState(() => _wordWrap = value),
          ),

          const SizedBox(height: 16),

          // Theme
          _buildSettingItem(
            'Theme',
            DropdownButton<String>(
              value: _theme,
              dropdownColor: const Color(0xFF252526),
              style: const TextStyle(color: Color(0xFFCCCCCC)),
              items: const [
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _theme = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLspSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LSP Bridge Settings',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // LSP Bridge URL
          _buildTextFieldSetting(
            'LSP Bridge URL',
            _lspBridgeUrl,
            (value) => setState(() => _lspBridgeUrl = value),
            hint: 'ws://localhost:9999',
          ),

          const SizedBox(height: 16),

          // Connection Timeout
          _buildTextFieldSetting(
            'Connection Timeout (seconds)',
            _connectionTimeout.toString(),
            (value) {
              final parsed = int.tryParse(value);
              if (parsed != null) {
                setState(() => _connectionTimeout = parsed);
              }
            },
            hint: '10',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Request Timeout
          _buildTextFieldSetting(
            'Request Timeout (seconds)',
            _requestTimeout.toString(),
            (value) {
              final parsed = int.tryParse(value);
              if (parsed != null) {
                setState(() => _requestTimeout = parsed);
              }
            },
            hint: '30',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildAbout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Flutter IDE',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Version: 1.0.0',
            style: TextStyle(color: Color(0xFFCCCCCC)),
          ),
          const SizedBox(height: 16),
          const Text(
            'A cross-platform code editor with LSP support',
            style: TextStyle(color: Color(0xFFCCCCCC)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Architecture:',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Clean Architecture\n'
            '• Domain-Driven Design (DDD)\n'
            '• SOLID Principles\n'
            '• Hexagonal Architecture (Ports & Adapters)',
            style: TextStyle(color: Color(0xFFCCCCCC)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tech Stack:',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Flutter + Dart\n'
            '• Rust (native editor, LSP bridge)\n'
            '• MobX (state management)\n'
            '• GetIt + Injectable (DI)',
            style: TextStyle(color: Color(0xFFCCCCCC)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D30),
        border: Border(
          top: BorderSide(color: Color(0xFF3E3E42), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFCCCCCC)),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              widget.onSave?.call(_collectSettings());
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007ACC),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String label,
    Widget child, {
    Widget? trailing,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFCCCCCC)),
          ),
        ),
        Expanded(
          flex: 3,
          child: child,
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing,
        ],
      ],
    );
  }

  Widget _buildSwitchSetting(
    String label,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFCCCCCC)),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF007ACC),
        ),
      ],
    );
  }

  Widget _buildTextFieldSetting(
    String label,
    String value,
    void Function(String) onChanged, {
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFCCCCCC)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          style: const TextStyle(color: Color(0xFFCCCCCC)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFFCCCCCC).withOpacity(0.4),
            ),
            filled: true,
            fillColor: const Color(0xFF252526),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3E3E42)),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3E3E42)),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF007ACC)),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
