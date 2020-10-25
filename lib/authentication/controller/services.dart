import 'dart:convert';

import 'package:Dia/shared/model/api_rest_backend.dart';


class AuthenticationServicesError implements Exception {
  final String _message;
  const AuthenticationServicesError(this._message);
  String toString() => "$_message";
}


class AuthenticationServices {
  ApiRestBackend _backend;

  AuthenticationServices() {
    _backend = ApiRestBackend();
  }

  Future<void> login(String email, String password) async {
    await _backend.initialize();

    String basicAuth = base64.encode(latin1.encode('$email:$password'));

    try {
      dynamic responseBody = await _backend.post(
          '/api/v1/auth/new-token/', {},
          withAuth: false,
          additionalHeaders: {'Authorization': 'Basic $basicAuth'}
      );
      await _backend.saveToken(responseBody['token'], responseBody['refresh_token'], responseBody['expires'] * 1000.0);
    } on BackendUnauthorized catch (e) {
      throw AuthenticationServicesError('Email/Password combination are wrong.');
    } on BackendUnavailable catch (e) {
      throw AuthenticationServicesError('Dia services are unavailable. Try again later.');
    }
  }

  Future<void> signUp(String email, String password) async {
    await _backend.initialize();
    try {
      await _backend.post(
          '/api/v1/auth/new-account/',
          {'email': email, 'password': password},
          withAuth: false
      );
    } on BackendBadRequest catch (e) {
      throw AuthenticationServicesError(e.toString());
    } on BackendUnavailable catch (e) {
      throw AuthenticationServicesError('Dia services are unavailable. Try again later.');
    }

  }

  Future<void> logout() async {
    await _backend.initialize();
    await _backend.removeToken();
  }

  bool isAuthenticated() {
    return _backend.isAuthenticated();
  }

}
