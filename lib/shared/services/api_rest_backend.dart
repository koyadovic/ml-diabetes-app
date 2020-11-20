import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:iDietFit/shared/services/storage.dart';
import 'package:iDietFit/shared/tools/uris.dart';
import 'package:http/http.dart' as http;
import 'package:mutex/mutex.dart';


class ApiRestBackend {
  final Storage _storage = getLocalStorage();

  static String _token;
  static String _refreshToken;
  static double _tokenExpiresMilliseconds;

  //static String _baseUrl = 'http://192.168.1.250:5000';
  static String _baseUrl = 'https://idiet.fit';

  Function(List<String>) _rolesListener;

  void setOnNewRolesListener(Function(List<String>) rolesListener) {
    _rolesListener = rolesListener;
  }

  // Singleton
  static final ApiRestBackend _instance = ApiRestBackend._internal();
  factory ApiRestBackend() {
    return _instance;
  }
  ApiRestBackend._internal() {
    initialize();
  }

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

  final Mutex mutex = Mutex();

  Future<dynamic> get(String endpoint, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    await initialize();
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = fixURI(_baseUrl + endpoint);
    try {
      http.Response response = await http.get(uri, headers: headers);
      print('GET $uri | Response status: ${response.statusCode}');
      return await _decodeResponseBody(response);
    } on SocketException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    } on HttpException catch (e) {
      print(e.toString());
      throw BackendUnavailable();
    } on http.ClientException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    }
  }

  Future<dynamic> post(String endpoint, dynamic data, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    await initialize();
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = fixURI(_baseUrl + endpoint);
    var body = json.encode(data);
    try {
      http.Response response = await http.post(uri, headers: headers, body: body);
      print('POST $uri | Response status: ${response.statusCode} | body: $body');
      return await _decodeResponseBody(response);
    } on SocketException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    } on HttpException catch (e) {
      print(e.toString());
      throw BackendUnavailable();
    } on http.ClientException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    }
  }

  Future<dynamic> patch(String endpoint, dynamic data, {bool withAuth = true, Map<String, String> additionalHeaders}) async {
    await initialize();
    var headers = await _getHeaders(withAuth, additionalHeaders);
    var uri = fixURI(_baseUrl + endpoint);
    var body = json.encode(data);
    try {
      http.Response response = await http.patch(uri, headers: headers, body: body);
      print('PATCH $uri | Response status: ${response.statusCode} | body: $body');
      return await _decodeResponseBody(response);
    } on SocketException catch(e) {
      print(e.toString());
      throw BackendUnavailable();
    } on HttpException catch (e) {
      print(e.toString());
      throw BackendUnavailable();
    } on http.ClientException catch(e) {
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

  Future<dynamic> _decodeResponseBody(http.Response response) async {
    bool error = response.statusCode < 200 || response.statusCode > 399;
    dynamic content = json.decode(utf8.decode(response.bodyBytes));
    if(error) {
      String message = content['message'];
      if(response.statusCode == 401){
        await removeToken();
        throw BackendUnauthorized(message);
      }
      else if(response.statusCode == 400) {
        throw BackendBadRequest(message);
      }
      else if(response.statusCode == 403) {
        throw BackendForbidden(message);
      }
      else if(response.statusCode == 500) {
        throw BackendCriticalError();
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
    await mutex.acquire();
    String currentToken;
    try{
      if(_haveToken()) {
        if(!_isTokenExpired()) {
          currentToken = _token;
        } else {
          try{
            dynamic data = await post('/api/v1/auth/renew-token/', {'refresh_token': _refreshToken}, withAuth: false);
            if (data == null) {
              await removeToken();
            } else {
              String token = data['token'];
              String refreshToken = data['refresh_token'];
              double expires = data['expires'] * 1000.0;
              await saveToken(token, refreshToken, expires);
              currentToken = token;

              // get refreshed roles!
              if(_rolesListener != null) {
                _rolesListener(List<String>.from(data['account']['roles']));
              }
            }
          } on BackendBadRequest catch (err) {
            await removeToken();
            // error 400, bad request when refreshing the token, means that need to log in again with user/password
            throw NotLoggedIn('Need to log in again with user/password');
          }
        }
      }
    } finally {
      mutex.release();
    }
    return currentToken;
  }

  bool _isTokenExpired() {
    if(_tokenExpiresMilliseconds == null) return true;
    int nowMillis = DateTime.now().millisecondsSinceEpoch;
    return _tokenExpiresMilliseconds < nowMillis + 1000;
  }

  bool _haveToken() {
    return _token != null && _token != '';
  }

}


class BackendError implements Exception {
  final String _message;
  const BackendError(this._message);
  String toString() => "$_message";
}


class BackendUnavailable extends BackendError {
  const BackendUnavailable() : super('');
  String toString() => "BackendUnavailable";
}

class BackendCriticalError extends BackendError {
  const BackendCriticalError() : super('');
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

class NotLoggedIn extends BackendError {
  const NotLoggedIn(String message) : super(message);
}
