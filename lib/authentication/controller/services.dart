import 'dart:convert';

import 'package:Dia/shared/model/api_rest_backend.dart';

class AuthenticationServices {
  ApiRestBackend _backend;

  AuthenticationServices() {
    _backend = ApiRestBackend();
  }

  Future<void> login(String email, String password) async {
    await _backend.initialize();

    String basicAuth = base64.encode(latin1.encode('$email:$password'));

    // TODO y si es non authorized ??
    dynamic responseBody = await _backend.post(
      '/api/v1/auth/new-token/', {},
      withAuth: false,
      additionalHeaders: {'Authorization': 'Basic $basicAuth'}
    );
    await _backend.saveToken(responseBody['token'], responseBody['refresh_token'], responseBody['expires'] * 1000.0);
  }

  Future<void> signUp(String email, String password) async {
    await _backend.initialize();
    await _backend.post(
        '/api/v1/auth/new-account/',
        {email: email, password: password},
        withAuth: false
    );
  }

  Future<void> logout() async {
    await _backend.initialize();
    await _backend.removeToken();
  }

  bool isAuthenticated() {
    return _backend.isAuthenticated();
  }

}
