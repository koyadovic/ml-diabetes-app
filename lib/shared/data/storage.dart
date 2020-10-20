import 'package:localstorage/localstorage.dart';

class Storage {
  Future<void> set (String key, dynamic data) async {}
  Future<dynamic> get(String key) async {}
}

Storage getLocalStorage() {
  return _FlutterLocalStorage();
}


class _FlutterLocalStorage implements Storage {
  final LocalStorage _storage = new LocalStorage('ml-diabetes');
  Future<void> set(String key, dynamic data) async {
    _storage.setItem(key, data);
  }
  Future<dynamic> get(String key) async {
    return _storage.getItem(key);
  }
}
