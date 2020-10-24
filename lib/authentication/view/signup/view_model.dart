import 'package:Dia/shared/view/screens.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/material.dart';


class SignupViewModel extends DiaViewModel {

  String _email = '';
  String _password1 = '';
  String _password2 = '';

  String _emailError = '';
  String _password1Error = '';
  String _password2Error = '';

  SignupViewModel(State state, Function(DiaScreen) requestScreenChange) : super(state, requestScreenChange);

  set email(String email) {
    _email = email;
    // TODO validation if has validated for first time
    notifyChanges();
  }

  String get email {
    return _email;
  }

  set password1(String password) {
    _password1 = password;
    // TODO validation if has validated for first time
    notifyChanges();
  }

  String get password1 {
    return _password1;
  }

  set password2(String password) {
    _password2 = password;
    // TODO validation if has validated for first time
    notifyChanges();
  }

  String get password2 {
    return _password2;
  }

  void signup(){
    // TODO validate
    setLoading(true);

    setLoading(false);
  }

}
