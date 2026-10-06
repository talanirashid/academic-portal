import 'package:flutter/foundation.dart';

/// Local Offline Storage Service caching downloaded chapter PDFs and syllabus metadata.
class OfflineStorageService {
  static final Map<String, String> _memoryCache = {};

  /// Caches a document resource URL locally
  static Future<void> cacheResourceUrl(String key, String url) async {
    _memoryCache[key] = url;
    debugPrint('Offline Cache: Stored $key -> $url');
  }

  /// Retrieves a cached document resource URL
  static String? getCachedResourceUrl(String key) {
    return _memoryCache[key];
  }

  /// Checks if a resource is available offline
  static bool isResourceCached(String key) {
    return _memoryCache.containsKey(key);
  }
}
