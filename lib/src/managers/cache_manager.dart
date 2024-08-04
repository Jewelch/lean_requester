abstract class CacheManager {
  Future<bool> setString(String key, String value);
  String? getString(String key);
}
