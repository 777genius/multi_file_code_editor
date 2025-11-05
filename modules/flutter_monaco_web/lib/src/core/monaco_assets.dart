import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' if (dart.library.html) 'path_provider_stub.dart';

import 'file_operations.dart' if (dart.library.html) 'file_operations_stub.dart';

/// Monaco asset manager - Single source of truth for all Monaco-related assets
class MonacoAssets {
  static const String _assetBaseDir = 'packages/flutter_monaco/assets/monaco';
  static const String _cacheSubDir = 'monaco_editor_cache';
  static const String _htmlFileName = 'index.html';
  static const String _relativePath = 'min/vs';
  static const String monacoVersion = '0.52.2';

  static Completer<void>? _initCompleter;

  // HTML cache to avoid regenerating the same HTML multiple times
  static final Map<int, String> _htmlCache = {};

  /// Ensures Monaco assets are ready. Thread-safe with re-entrant protection.
  static Future<void> ensureReady() {
    if (_initCompleter != null) return _initCompleter!.future;

    final c = _initCompleter = Completer<void>();

    () async {
      try {
        final targetDir = await _getTargetDir();

        if (kIsWeb) {
          // On web, assets are bundled - no extraction needed
          debugPrint('[MonacoAssets] Web platform detected - using bundled assets from: $targetDir');
          c.complete();
          return;
        }

        // Desktop/Mobile: Check and extract assets if needed
        final ok = await FileOperations.checkExtractedAssets(
          targetDir,
          monacoVersion,
        );

        if (!ok) {
          debugPrint(
              '[MonacoAssets] Monaco not found or incomplete, copying assets...');
          await FileOperations.copyAssets(
            targetDir,
            _assetBaseDir,
            monacoVersion,
          );
        } else {
          debugPrint(
              '[MonacoAssets] Monaco already extracted at: $targetDir (version $monacoVersion)');
        }

        c.complete();
      } catch (e, st) {
        c.completeError(e, st);
      }
    }();

    return c.future;
  }

  /// Get the path to the HTML file
  ///
  /// [customCss] - Custom CSS to inject into the editor
  /// [allowCdnFonts] - Whether to allow loading fonts from CDNs
  static Future<String> indexHtmlPath({
    String? customCss,
    bool allowCdnFonts = false,
  }) async {
    await ensureReady();
    final targetDir = await _getTargetDir();

    // Generate cache key based on parameters
    final cacheKey = Object.hash(customCss, allowCdnFonts);

    // Check if we already have this HTML cached
    if (_htmlCache.containsKey(cacheKey)) {
      return _htmlCache[cacheKey]!;
    }

    // Generate new HTML with custom CSS if provided
    await _ensureHtmlFile(
      targetDir,
      customCss: customCss,
      allowCdnFonts: allowCdnFonts,
      cacheKey: cacheKey,
    );

    // Cache and return the path
    final htmlPath = p.join(targetDir, 'monaco_$cacheKey.html');
    _htmlCache[cacheKey] = htmlPath;
    return htmlPath;
  }

  /// Get information about extracted Monaco assets
  static Future<Map<String, dynamic>> assetInfo() async {
    final targetDir = await _getTargetDir();
    return FileOperations.getAssetInfo(targetDir, monacoVersion);
  }

  /// Clean up all Monaco assets
  static Future<void> clearCache() async {
    if (!kIsWeb) {
      final targetDir = await _getTargetDir();
      await FileOperations.deleteAssets(targetDir);
    }

    // Reset the init completer and HTML cache
    _initCompleter = null;
    _htmlCache.clear();
    debugPrint('[MonacoAssets] Cache cleared');
  }

  // --- Private Helpers ---

  static Future<String> _getTargetDir() async {
    if (kIsWeb) {
      // On web, assets are served directly - no extraction needed
      return 'assets/$_assetBaseDir';
    } else {
      return p.join(
        (await getApplicationSupportDirectory()).path,
        _cacheSubDir,
        'monaco-$monacoVersion',
      );
    }
  }

  static Future<void> _ensureHtmlFile(
    String targetDir, {
    String? customCss,
    bool allowCdnFonts = false,
    int? cacheKey,
  }) async {
    if (kIsWeb) {
      // On web, HTML is loaded inline via srcdoc - no file needed
      debugPrint('[MonacoAssets] Web platform - HTML will be loaded inline');
      return;
    }

    // Use cache key in filename to avoid conflicts
    final fileName = cacheKey != null ? 'monaco_$cacheKey.html' : _htmlFileName;

    // Generate HTML content
    final htmlContent = FileOperations.generateHtmlContent(
      targetDir: targetDir,
      customCss: customCss,
      allowCdnFonts: allowCdnFonts,
    );

    // Write the HTML file
    await FileOperations.writeHtmlFile(targetDir, fileName, htmlContent);
  }
}
