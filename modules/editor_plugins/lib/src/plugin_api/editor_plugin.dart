import 'package:editor_core/editor_core.dart';
import 'package:flutter/widgets.dart';
import 'plugin_context.dart';
import 'plugin_manifest.dart';

abstract class EditorPlugin {
  PluginManifest get manifest;

  Future<void> initialize(PluginContext context);

  Future<void> dispose();

  void onFileOpen(FileDocument file) {}

  void onFileClose(String fileId) {}

  void onFileSave(FileDocument file) {}

  void onFileContentChange(String fileId, String content) {}

  void onFileCreate(FileDocument file) {}

  void onFileDelete(String fileId) {}

  void onFolderCreate(Folder folder) {}

  void onFolderDelete(String folderId) {}

  Widget? buildToolbarAction(BuildContext context) => null;

  Widget? buildContextMenuItem(
    BuildContext context,
    FileDocument file,
  ) => null;

  Widget? buildSidebarPanel(BuildContext context) => null;

  List<String> getSupportedLanguages() => [];

  bool supportsLanguage(String language) =>
      getSupportedLanguages().isEmpty ||
      getSupportedLanguages().contains(language);
}
