import 'dart:convert';

import 'package:Dia/shared/data/storage.dart';
import 'package:http/http.dart' as http;

class Api {
  final Storage _storage = getLocalStorage();
  String _token;
  String _refreshToken;
  double _tokenExpires;

  String _baseUrl = 'http://192.168.1.250:5000/';

  Future<void> initialize() async {
    await _loadToken();
  }

  bool isAuthenticated(){
    return _haveToken() && !_isTokenExpired();
  }

  void saveToken(String newToken, String refreshNewToken, double expires) {
    _storage.set('api-token', newToken);
    _storage.set('api-refresh-token', refreshNewToken);
    _storage.set('api-token-expires', expires);
    _token = newToken;
    _refreshToken = refreshNewToken;
    _tokenExpires = expires;
  }

  void removeToken() {
    _storage.set('api-token', null);
    _storage.set('api-refresh-token', null);
    _storage.set('api-token-expires', null);
    _token = null;
    _refreshToken = null;
    _tokenExpires = null;
  }

  Future<dynamic> get(String endpoint, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = _fixURI(_baseUrl + endpoint);
    print('GET $uri');
    http.Response response = await http.get(uri, headers: headers);
    return _decodeResponseBody(response);
  }

  Future<dynamic> post(String endpoint, dynamic data, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = _fixURI(_baseUrl + endpoint);
    print('POST $uri');
    http.Response response = await http.post(uri, headers: headers, body: json.encode(data));
    return _decodeResponseBody(response);
  }

  Future<dynamic> patch(String endpoint, dynamic data, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = _fixURI(_baseUrl + endpoint);
    print('PATCH $uri');
    http.Response response = await http.patch(uri, headers: headers, body: json.encode(data));
    return _decodeResponseBody(response);
  }

  Future<Map<String, String>> _getHeaders(bool withAuth, Map<String, String> additionalHeaders) async {
    Map<String, String> headers;
    if (additionalHeaders == null) {
      headers = {};
    } else {
      headers = additionalHeaders;
    }
    headers['Content-Type'] = 'application/json';
    if (withAuth) {
      String token = await _getToken();
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  String _fixURI(String uri) {
    return uri.replaceAll('//', '/').replaceAll(':/', '://');
  }

  dynamic _decodeResponseBody(http.Response response) {
    bool error = response.statusCode < 200 || response.statusCode > 399;
    if(error) {
      print('${response.statusCode}: ${response.body}');
      throw new Exception('Response from server was ${response.statusCode}');
    }
    dynamic content = json.decode(utf8.decode(response.bodyBytes));
    return content;
  }

  Future<void> _loadToken() async {
    _token = await _storage.get('api-token');
    _refreshToken = await _storage.get('api-refresh-token');
    _tokenExpires = await _storage.get('api-token-expires');
  }

  Future<String> _getToken() async {
    if(_haveToken()) {
      if(!_isTokenExpired()) {
        return _token;
      } else {
        dynamic data = await post('/api/v1/auth/renew-token/', {'refresh_token': _refreshToken}, withAuth: false);
        if (data == null) {
          removeToken();
        } else {
          String token = data['token'];
          String refreshToken = data['refresh_token'];
          double expires = data['expires'] * 1000.0;
          saveToken(token, refreshToken, expires);
          return token;
        }
      }
    }
    return null;
  }

  bool _isTokenExpired() {
    if(_tokenExpires == null) return true;
    return _tokenExpires > DateTime.now().millisecondsSinceEpoch;
  }

  bool _haveToken() {
    return _token != null && _token != '';
  }

}
