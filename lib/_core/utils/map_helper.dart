class MapHelper {

  static dynamic getNestedValue(dynamic data, List<String> keys, dynamic defaultValue) {
    if (data == null) return defaultValue;
    
    dynamic currentData = data;
    for (String key in keys) {
      if (currentData is Map && currentData.containsKey(key)) {
        currentData = currentData[key];
      } else {
        return defaultValue;
      }
    }
    
    return currentData ?? defaultValue;
  }
  
  static bool hasNestedPath(dynamic data, List<String> keys) {
    if (data == null) return false;
    
    dynamic currentData = data;
    for (String key in keys) {
      if (currentData is Map && currentData.containsKey(key)) {
        currentData = currentData[key];
      } else {
        return false;
      }
    }
    
    return true;
  }
}