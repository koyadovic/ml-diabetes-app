import 'dart:convert';
import 'dart:io';
import 'package:Dia/shared/model/storage.dart';
import 'package:http/http.dart' as http;


class BackendError implements Exception {
  final String _message;
  const BackendError(this._message);
  String toString() => "$_message";
}


class BackendUnavailable extends BackendError {
  const BackendUnavailable() : super('');
  String toString() => "BackendUnavailable";
}

class BackendUnauthorized extends BackendError {
  const BackendUnauthorized(String message) : super(message);
}

class BackendForbidden extends BackendError {
  const BackendForbidden(String message) : super(message);
}

class BackendBadRequest extends BackendError {
  const BackendBadRequest(String message) : super(message);
}


class ApiRestBackend {
  final Storage _storage = getLocalStorage();
  String _token;
  String _refreshToken;
  double _tokenExpiresMilliseconds;

  String _baseUrl = 'http://192.168.1.250:5000';

  Future<void> initialize() async {
    if(_token == null || _refreshToken == null || _tokenExpiresMilliseconds == null) {
      await _loadToken();
    }
  }

  bool isAuthenticated(){
    return _haveToken();
  }

  Future<void> saveToken(String newToken, String refreshNewToken, double expiresMilliseconds) async {
    await _storage.set('api-token', newToken);
    await _storage.set('api-refresh-token', refreshNewToken);
    await _storage.set('api-token-expires', expiresMilliseconds);
    _token = newToken;
    _refreshToken = refreshNewToken;
    _tokenExpiresMilliseconds = expiresMilliseconds;
  }

  Future<void> removeToken() async {
    await _storage.set('api-token', null);
    await _storage.set('api-refresh-token', null);
    await _storage.set('api-token-expires', null);
    _token = null;
    _refreshToken = null;
    _tokenExpiresMilliseconds = null;
  }

  Future<dynamic> get(String endpoint, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = _fixURI(_baseUrl + endpoint);
    print('GET $uri | headers: $headers');
    try {
      http.Response response = await http.get(uri, headers: headers);
      print('Response headers');
      print(response.headers.toString());
      return _decodeResponseBody(response);
    } on SocketException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    } on HttpException catch (e) {
      print(e.toString());
      throw BackendUnavailable();
    }
  }

  Future<dynamic> post(String endpoint, dynamic data, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = _fixURI(_baseUrl + endpoint);
    var body = json.encode(data);
    // TODO fix IOClient.send / ClientException(error.message, error.uri)
    print('POST $uri | body: $body | headers: $headers');
    try {
      http.Response response = await http.post(uri, headers: headers, body: body);
      print('Response headers');
      print(response.headers.toString());
      return _decodeResponseBody(response);
    } on SocketException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    } on HttpException catch (e) {
      print(e.toString());
      throw BackendUnavailable();
    }
  }

  Future<dynamic> patch(String endpoint, dynamic data, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = _fixURI(_baseUrl + endpoint);
    var body = json.encode(data);
    print('PATCH $uri | body: $body | headers: $headers');
    try {
      http.Response response = await http.patch(uri, headers: headers, body: body);
      print('Response headers');
      print(response.headers.toString());
      return _decodeResponseBody(response);
    } on SocketException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    } on HttpException catch (e) {
      print(e.toString());
      throw BackendUnavailable();
    }
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
    dynamic content = json.decode(utf8.decode(response.bodyBytes));
    if(error) {
      String message = content['message'];
      if(response.statusCode == 401){
        throw BackendUnauthorized(message);
      }
      else if(response.statusCode == 400) {
        throw BackendBadRequest(message);
      }
      else if(response.statusCode == 403) {
        throw BackendForbidden(message);
      }
      print('${response.statusCode}: ${response.body}');
      throw BackendError('${response.statusCode}: ' + message);
    }
    return content;
  }

  Future<void> _loadToken() async {
    _token = await _storage.get('api-token');
    _refreshToken = await _storage.get('api-refresh-token');
    _tokenExpiresMilliseconds = await _storage.get('api-token-expires');
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
    } else {
      print('We don\'t have token. Returning null');
      return null;
    }

  }

  bool _isTokenExpired() {
    if(_tokenExpiresMilliseconds == null) return true;
    int now = DateTime.now().millisecondsSinceEpoch;
    return _tokenExpiresMilliseconds < now;
  }

  bool _haveToken() {
    return _token != null && _token != '';
  }

}
