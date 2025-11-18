import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/manifest_dto.dart';

/// Manifest Data Source
/// Fetches runtime manifest from CDN/server
class ManifestDataSource {
  final Dio _dio;
  final String _manifestUrl;

  ManifestDataSource({
    required String manifestUrl,
    Dio? dio,
  })  : _manifestUrl = manifestUrl,
        _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  /// Fetch manifest from remote server
  Future<ManifestDto> fetchManifest() async {
    try {
      final response = await _dio.get(_manifestUrl);

      if (response.statusCode == 200) {
        final json = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        return ManifestDto.fromJson(json);
      }

      throw Exception('Failed to fetch manifest: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error fetching manifest: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch manifest: $e');
    }
  }

  /// Check if a new manifest version is available
  Future<bool> hasUpdate(String currentVersion) async {
    try {
      final manifest = await fetchManifest();
      return manifest.version != currentVersion;
    } catch (e) {
      return false;
    }
  }
}
