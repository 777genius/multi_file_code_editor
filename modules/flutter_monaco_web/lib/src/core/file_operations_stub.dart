import 'dart:async';

/// Stub implementation for web platform
/// All file operations are no-ops on web since assets are bundled
class FileOperations {
  static Future<bool> checkExtractedAssets(
    String targetDir,
    String monacoVersion,
  ) async {
    // On web, assets are always "ready" (bundled)
    return true;
  }

  static Future<void> copyAssets(
    String targetDir,
    String assetBaseDir,
    String monacoVersion,
  ) async {
    // No-op on web
  }

  static Future<void> writeHtmlFile(
    String targetDir,
    String fileName,
    String htmlContent,
  ) async {
    // No-op on web
  }

  static String generateHtmlContent({
    required String targetDir,
    String? customCss,
    bool allowCdnFonts = false,
  }) {
    // For web in blob URL context, we need to use parent window's location
    // Get the current origin from parent
    final loaderPath = '/$targetDir/min/vs/loader.js';
    final vsPath = '/$targetDir/min/vs';

    // Return Monaco HTML template for web platform
    return '''<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { height: 100%; overflow: hidden; }
        #editor-container { width: 100%; height: 100%; }
        ${customCss ?? ''}
    </style>
    ${allowCdnFonts ? '<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono&display=swap" rel="stylesheet">' : ''}
</head>
<body>
    <div id="editor-container"></div>

    <script>
        console.log('[Monaco Web] Starting initialization...');

        // Get the parent origin for loading assets
        const parentOrigin = window.parent.location.origin;
        const loaderPath = parentOrigin + '$loaderPath';
        const vsPath = parentOrigin + '$vsPath';

        console.log('[Monaco Web] Parent origin:', parentOrigin);
        console.log('[Monaco Web] Loader path:', loaderPath);
        console.log('[Monaco Web] VS path:', vsPath);

        // Setup Flutter channel for communication
        window.flutterChannel = {
            postMessage: function(message) {
                console.log('[flutterChannel] Sending to parent:', message);
                window.parent.postMessage({
                    type: 'channel',
                    channel: 'flutterChannel',
                    message: message
                }, '*');
            }
        };

        // Dynamically load the loader script
        const script = document.createElement('script');
        script.src = loaderPath;
        script.onload = function() {
            console.log('[Monaco Web] Loader.js loaded, configuring require...');

            require.config({
                paths: {
                    'vs': vsPath
                }
            });

            console.log('[Monaco Web] Loading Monaco editor...');
            require(['vs/editor/editor.main'], function() {
                console.log('[Monaco Web] Monaco loaded successfully!');
                window.parent.postMessage({type: 'ready'}, '*');
                console.log('[Monaco Web] Ready signal sent to parent');
            }, function(err) {
                console.error('[Monaco Web] Failed to load Monaco:', err);
                window.parent.postMessage({
                    type: 'error',
                    error: 'Failed to load Monaco: ' + err
                }, '*');
            });
        };
        script.onerror = function(err) {
            console.error('[Monaco Web] Failed to load loader.js from:', loaderPath, err);
            window.parent.postMessage({
                type: 'error',
                error: 'Failed to load loader.js'
            }, '*');
        };

        document.head.appendChild(script);
    </script>
</body>
</html>''';
  }

  static Future<Map<String, dynamic>> getAssetInfo(
    String targetDir,
    String monacoVersion,
  ) async {
    return {
      'exists': true,
      'path': targetDir,
      'version': monacoVersion,
      'platform': 'web',
      'bundled': true,
    };
  }

  static Future<void> deleteAssets(String targetDir) async {
    // No-op on web
  }
}
