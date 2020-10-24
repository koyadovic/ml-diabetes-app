import 'package:Dia/shared/model/api_rest_backend.dart';

class AuthenticationServices {
  ApiRestBackend _backend;

  AuthenticationServices() {
    _backend = ApiRestBackend();
  }

  Future<void> login(String email, String password) async {
    await _backend.initialize();

    dynamic responseBody = await _backend.post(
        '/api/v1/auth/new-token/',
        {email: email, password: password},
        withAuth: false
    );
    await _backend.saveToken(responseBody['token'], responseBody['refresh_token'], responseBody['expires']);
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
