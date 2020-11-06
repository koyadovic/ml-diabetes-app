
Map<String, dynamic> mapDifferences(Map<String, dynamic> original, Map<String, dynamic> newMap) {
  Map<String, dynamic> diff = {};
  // print('\n');
  // print('mapDifferences\noriginal: $original\nnewMap  : $newMap');
  // recorremos el nuevo map
  for(String key in newMap.keys) {
    // print('');
    // print('key $key from newMap');
    // si el original contiene la k
    if(original.containsKey(key)) {
      // print('original contains $key');
      Type originalType = original[key].runtimeType;
      Type newMapType = newMap[key].runtimeType;
      // print('originalType: $originalType');
      // print('newMapType: $newMapType');
      // la contiene, comprobamos el tipo
      if(originalType != newMapType) {
        // print('+ Different types! adding ${newMap[key]} to differences');
        diff[key] = newMap[key];
      } else {
        // aquí sabemos que son del mismo tipo
        if(newMap[key] is Map) {
          // print('newMap[key] is Map so original[key] is a map too');
          Map<String, dynamic> newMapKey = Map<String, dynamic>.from(newMap[key]);
          Map<String, dynamic> originalKey = Map<String, dynamic>.from(original[key]);
          //if(!_mapEq(originalKey, newMapKey)) {
          if(originalKey.toString() != newMapKey.toString()) {
            // print('+ Different maps adding $newMapKey to differences');
            diff[key] = newMapKey;
          }
        } else if (original[key] != newMap[key]) {
          // print('+ Different simple types so adding ${newMap[key]}');
          // simple values
          diff[key] = newMap[key];
        }
      }
    } else {
      // print('+ Original does not contain $key so add newMap[key] ${newMap[key]}');
      diff[key] = newMap[key];
    }
  }

  // print('RESULT: $diff');
  return Map<String, dynamic>.from(diff);
}
