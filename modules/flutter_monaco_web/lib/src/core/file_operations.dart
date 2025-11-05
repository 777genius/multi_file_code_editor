import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

/// File operations for desktop/mobile platforms
class FileOperations {
  /// Check if Monaco assets are extracted and valid
  static Future<bool> checkExtractedAssets(
    String targetDir,
    String monacoVersion,
  ) async {
    final loader = File(p.join(targetDir, 'min', 'vs', 'loader.js'));
    final sentinel = File(p.join(targetDir, '.monaco_complete'));

    return loader.existsSync() &&
        sentinel.existsSync() &&
        (await sentinel.readAsString()).trim() == monacoVersion;
  }

  /// Copy all Monaco assets from Flutter assets to filesystem
  static Future<void> copyAssets(
    String targetDir,
    String assetBaseDir,
    String monacoVersion,
  ) async {
    debugPrint('[FileOperations] Copying Monaco assets to: $targetDir');

    final dir = Directory(targetDir);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);

    // Load asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap =
        const JsonDecoder().convert(manifestContent);

    final monacoAssets = manifestMap.keys
        .where((String key) => key.startsWith(assetBaseDir))
        .toList();

    debugPrint('[FileOperations] Found ${monacoAssets.length} Monaco assets');

    for (final assetPath in monacoAssets) {
      final bytes = await rootBundle.load(assetPath);
      final relativePath = assetPath.substring('$assetBaseDir/'.length);
      final targetFile = File(p.join(targetDir, relativePath));

      await targetFile.parent.create(recursive: true);
      await targetFile.writeAsBytes(bytes.buffer.asUint8List());
    }

    // Write sentinel file
    final sentinelFile = File(p.join(targetDir, '.monaco_complete'));
    await sentinelFile.writeAsString(monacoVersion);

    debugPrint('[FileOperations] Monaco assets copied successfully');
  }

  /// Write HTML file to filesystem
  static Future<void> writeHtmlFile(
    String targetDir,
    String fileName,
    String htmlContent,
  ) async {
    final htmlFile = File(p.join(targetDir, fileName));

    // Skip if file already exists (cached)
    if (htmlFile.existsSync()) {
      debugPrint('[FileOperations] Using cached HTML file: ${htmlFile.path}');
      return;
    }

    await htmlFile.writeAsString(htmlContent);
    debugPrint('[FileOperations] HTML file created: ${htmlFile.path}');
  }

  /// Generate platform-specific HTML content
  static String generateHtmlContent({
    required String targetDir,
    String? customCss,
    bool allowCdnFonts = false,
  }) {
    if (Platform.isWindows) {
      // Windows needs absolute paths since we load from file://
      final absolutePath = p.absolute(targetDir);
      return _generateHtmlTemplate(
        loaderPath: 'file:///$absolutePath/min/vs/loader.js',
        customCss: customCss,
        allowCdnFonts: allowCdnFonts,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS/macOS use relative paths
      return _generateHtmlTemplate(
        loaderPath: 'min/vs/loader.js',
        customCss: customCss,
        allowCdnFonts: allowCdnFonts,
      );
    } else {
      // Android and others use relative paths
      return _generateHtmlTemplate(
        loaderPath: 'min/vs/loader.js',
        customCss: customCss,
        allowCdnFonts: allowCdnFonts,
      );
    }
  }

  /// Count files and get asset information
  static Future<Map<String, dynamic>> getAssetInfo(
    String targetDir,
    String monacoVersion,
  ) async {
    final directory = Directory(targetDir);

    if (!directory.existsSync()) {
      return {
        'exists': false,
        'path': targetDir,
        'version': monacoVersion,
      };
    }

    var fileCount = 0;
    var totalSize = 0;
    var hasHtmlFile = false;

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        fileCount++;
        totalSize += await entity.length();

        if (p.basename(entity.path) == 'index.html') {
          hasHtmlFile = true;
        }
      }
    }

    return {
      'exists': true,
      'path': targetDir,
      'version': monacoVersion,
      'fileCount': fileCount,
      'totalSize': totalSize,
      'totalSizeMB': (totalSize / 1024 / 1024).toStringAsFixed(2),
      'hasHtmlFile': hasHtmlFile,
      'htmlPath': p.join(targetDir, 'index.html'),
    };
  }

  /// Delete extracted assets
  static Future<void> deleteAssets(String targetDir) async {
    final directory = Directory(targetDir);

    if (directory.existsSync()) {
      await directory.delete(recursive: true);
      debugPrint('[FileOperations] Monaco assets deleted');
    }
  }

  static String _generateHtmlTemplate({
    required String loaderPath,
    String? customCss,
    bool allowCdnFonts = false,
  }) {
    return '''<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { height: 100%; overflow: hidden; }
        #container { width: 100%; height: 100%; }
        ${customCss ?? ''}
    </style>
    ${allowCdnFonts ? '<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono&display=swap" rel="stylesheet">' : ''}
</head>
<body>
    <div id="container"></div>
    <script src="$loaderPath"></script>
    <script>
        require.config({ paths: { 'vs': '${loaderPath.replaceAll('/loader.js', '')}' }});
        require(['vs/editor/editor.main'], function() {
            window.flutterChannel?.postMessage('ready');
        });
    </script>
</body>
</html>''';
  }
}
