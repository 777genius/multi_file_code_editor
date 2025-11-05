import 'dart:io';

class PlatformDetector {
  static bool get isWindows => Platform.isWindows;
  static bool get isIOS => Platform.isIOS;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isLinux => Platform.isLinux;
}
