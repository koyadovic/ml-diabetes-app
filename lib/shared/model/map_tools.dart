Map<String, dynamic> mapDifferences(Map<String, dynamic> original, Map<String, dynamic> newMap) {
  Map<String, dynamic> diff = {};
  for(String key in newMap.keys) {
    if(original.containsKey(key)) {
      Type originalType = original[key].runtimeType;
      Type newMapType = newMap[key].runtimeType;
      if(originalType != newMapType) {
        diff[key] = newMap[key];
      } else {
        // aquí sabemos que son del mismo tipo
        if(newMap[key] is Map) {
          Map<String, dynamic> newMapKey = Map<String, dynamic>.from(newMap[key]);
          Map<String, dynamic> originalKey = Map<String, dynamic>.from(original[key]);

          for(var childKey in newMapKey.keys) {
            if(!originalKey.keys.contains(childKey)) {
              diff[key] = newMapKey;
            } else if (originalKey[childKey] != newMapKey[childKey]){
              diff[key] = newMapKey;
            }
          }
        } else if (original[key] != newMap[key]) {
          // simple values
          diff[key] = newMap[key];
        }
      }
    } else {
      diff[key] = newMap[key];
    }
  }
  return Map<String, dynamic>.from(diff);
}
