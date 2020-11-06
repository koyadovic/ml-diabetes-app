import 'package:localstorage/localstorage.dart';

class Storage {
  Future<void> set (String key, dynamic data) async {}
  Future<dynamic> get(String key) async {}
  Future<void> del(String key) async {}
}

Storage getLocalStorage() {
  return _FlutterLocalStorage();
}

class _FlutterLocalStorage implements Storage {
  final LocalStorage _storage = new LocalStorage('ml-diabetes');

  Future<void> set(String key, dynamic data) async {
    await _storage.ready;
    // print('Store set $key: $data');
    _storage.setItem(key, data);
  }

  Future<dynamic> get(String key) async {
    await _storage.ready;
    var value = _storage.getItem(key);
    // print('Store get $key: $value');
    return value;
  }

  Future<void> del(String key) async {
    await _storage.ready;
    await _storage.deleteItem(key);
  }
}
