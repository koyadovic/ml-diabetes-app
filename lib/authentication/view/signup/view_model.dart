import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/material.dart';


class SignupViewModel extends DiaViewModel {
  final _emailPattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String _email = '';
  String _password1 = '';
  String _password2 = '';

  String _emailError = '';
  String _password1Error = '';
  String _password2Error = '';

  bool _isValid;

  final AuthenticationServices authenticationServices = AuthenticationServices();

  SignupViewModel(State state, Function(DiaScreen) requestScreenChange) : super(state, requestScreenChange);

  set email(String email) {
    _email = email;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get email {
    return _email;
  }

  set password1(String password) {
    _password1 = password;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get password1 {
    return _password1;
  }

  set password2(String password) {
    _password2 = password;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get password2 {
    return _password2;
  }

  void _validate() {
    bool isValid = true;
    if(!_emailPattern.hasMatch(_email)) {
      _emailError = 'This is not an email address';
      isValid = false;
    } else {
      _emailError = '';
      isValid = isValid && true;
    }

    if(_password1.length < 8) {
      _password1Error = 'Error minimum length is 8 characters';
      isValid = false;
    } else {
      _password1Error = '';
      isValid = isValid && true;
    }

    if(_password2.length < 8) {
      _password2Error = 'Error minimum length is 8 characters';
      isValid = false;
    } else {
      _password2Error = '';
      isValid = isValid && true;
    }

    if(_password1 != _password2) {
      _password2Error = 'Passwords does not match';
      isValid = false;
    } else {
      _password2Error = '';
      isValid = isValid && true;
    }

    _isValid = isValid;
    notifyChanges();
  }

  Future<void> signUp() async{
    _validate();
    print('view_model login()');
    if (_isValid) {
      try {
        await authenticationServices.signUp(email, password1);
      } catch (err) {
        throw err;
      } finally {
        setLoading(false);
      }
    }
  }

}
