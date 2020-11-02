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
          for(var childKey in newMap[key]) {
            if(!original[key].contains(childKey)) {
              diff[key] = newMap[key];
            } else if (original[key][childKey] != newMap[key][childKey]){
              diff[key] = newMap[key];
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
  return diff;
}
