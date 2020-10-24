import 'package:Dia/authentication/view/login/v1/screen.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/material.dart';


class LoginViewModel extends DiaViewModel {

  String _email = '';
  String _password = '';

  String _emailError = '';
  String _passwordError = '';

  LoginViewModel(State state, Function(DiaScreen) requestScreenChange) : super(state, requestScreenChange);

  set email(String email) {
    _email = email;
    // TODO validation
    notifyChanges();
  }

  String get email {
    return _email;
  }

  set password(String password) {
    _password = password;
    // TODO validation
    notifyChanges();
  }

  String get password {
    return _password;
  }

  void login(){
    setLoading(true);
    setLoading(false);
    requestScreenChange(DiaScreen.USER_DATA);
  }

}
