import 'dart:convert';

import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/services/storage.dart';


class AuthenticationServicesError implements Exception {
  final String _message;
  const AuthenticationServicesError(this._message);
  String toString() => "$_message";
}


class AuthenticationServices {
  ApiRestBackend _backend;
  final Storage _storage = getLocalStorage();
  List<String> _accountRoles;

  static const String ROLE_DIABETIC = 'diabetic';
  static const String ROLE_DIABETIC_PREMIUM = 'diabetic_premium';
  static const String ROLE_DIET_AND_EXERCISE = 'diet_and_exercise';

  // Singleton
  static final AuthenticationServices _instance = AuthenticationServices._internal();
  factory AuthenticationServices() {
    return _instance;
  }
  AuthenticationServices._internal() {
    if (_accountRoles == null) {
      _storage.get('account_roles').then((roles) {
        _accountRoles = roles != null ? List<String>.from(roles) : [];
      });
    }
    _backend = ApiRestBackend();
    _backend.setOnNewRolesListener(onNewRolesReceiver);
  }

  Future onNewRolesReceiver(List<String> refreshedRoles) async {
    print('Get refreshed roles: ${refreshedRoles.toString()}');
    _accountRoles = refreshedRoles;
    await _storage.set('account_roles', _accountRoles);
  }

  Future<void> login(String email, String password) async {
    String basicAuth = base64.encode(latin1.encode('$email:$password'));
    try {
      dynamic responseBody = await _backend.post(
          '/api/v1/auth/new-token/', {},
          withAuth: false,
          additionalHeaders: {'Authorization': 'Basic $basicAuth'}
      );
      await _backend.saveToken(responseBody['token'], responseBody['refresh_token'], responseBody['expires'] * 1000.0);

      // set roles!
      _accountRoles = List<String>.from(responseBody['account']['roles']);
      await onNewRolesReceiver(_accountRoles);
    } on BackendUnauthorized catch (e) {
      throw AuthenticationServicesError('Email/Password combination are wrong.');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _backend.post(
          '/api/v1/auth/new-account/',
          {'email': email, 'password': password},
          withAuth: false
      );
    } on BackendBadRequest catch (e) {
      throw AuthenticationServicesError(e.toString());
    }

  }

  Future<void> logout() async {
    await _backend.removeToken();
  }

  bool isAuthenticated() {
    return _backend.isAuthenticated();
  }

  bool haveIRole(String role) {
    return _accountRoles.contains(role);
  }

  bool haveIAnyRole(List<String> roles) {
    for(String role in roles){
      if(_accountRoles.contains(role)) return true;
    }
    return false;
  }

}
