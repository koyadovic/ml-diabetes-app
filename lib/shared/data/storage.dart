// isolate here the concrete plugin used for storage
import 'package:localstorage/localstorage.dart';

class Storage {
  void set(String key, dynamic data){}
  dynamic get(String key){}
}

Storage getLocalStorage() {
  return _FlutterLocalStorage();
}


class _FlutterLocalStorage implements Storage {
  final LocalStorage _storage = new LocalStorage('ml-diabetes');
  void set(String key, dynamic data){
    _storage.setItem(key, data);
  }
  dynamic get(String key){
    return _storage.getItem(key);
  }
}
