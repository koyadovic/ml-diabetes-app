import 'dart:convert';

import 'package:Dia/shared/data/storage.dart';
import 'package:http/http.dart' as http;

class Api {
  final Storage _storage = getLocalStorage();
  String _token;
  String _refreshToken;
  int _tokenExpires;

  Api() {
    _token = _storage.get('api-token');
    _refreshToken = _storage.get('api-refresh-token');
    _tokenExpires = _storage.get('api-token-expires');
  }

  bool _isTokenExpired() {
    if(_tokenExpires == null) return true;
    return _tokenExpires > DateTime.now().millisecondsSinceEpoch;
  }

  bool _haveToken() {
    return _token != null && _token != '';
  }

  void _setNewToken(String newToken, String refreshNewToken, int expires) {
    _storage.set('api-token', newToken);
    _storage.set('api-refresh-token', refreshNewToken);
    _storage.set('api-token-expires', expires);
    _token = newToken;
    _refreshToken = refreshNewToken;
    _tokenExpires = expires;
  }

  Future<String> getToken() async {
    if(_haveToken()) {
      if(!_isTokenExpired()) return _token;
    }
    if(!_isTokenExpired() && _haveToken()) return _token;
  }

  bool isAuthenticated(){
    if(this._isTokenExpired()) return false;
    return _token != null;
  }

  Future<dynamic> decodeResponseBody(http.Response response) async {
    bool error = response.statusCode < 200 || response.statusCode > 399;
    if(error) {
      throw new Exception('Response from server was ${response.statusCode}');
    }
    dynamic content = json.decode(utf8.decode(response.bodyBytes));
    return content;
  }

}
