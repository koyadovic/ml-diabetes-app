import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class LoginViewModel extends DiaViewModel {
  final _emailPattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  String _email = '';
  String _emailError = '';

  String _password = '';
  String _passwordError = '';

  bool _isValid;

  final AuthenticationServices authenticationServices = AuthenticationServices();

  LoginViewModel(State state) : super(state);

  set email(String email) {
    _email = email;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get email {
    return _email;
  }

  String get emailError {
    return _emailError;
  }

  set password(String password) {
    _password = password;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get password {
    return _password;
  }

  String get passwordError {
    return _passwordError;
  }

  void _validate() {
    bool isValid = true;
    if(!_emailPattern.hasMatch(_email)) {
      _emailError = 'This is not an email address'.tr();
      isValid = false;
    } else {
      _emailError = '';
      isValid = isValid && true;
    }
    if(_password.length < 8) {
      _passwordError = 'Error minimum length is 8 characters'.tr();
      isValid = false;
    } else {
      _passwordError = '';
      isValid = isValid && true;
    }
    _isValid = isValid;
    notifyChanges();
  }

  Future<void> login() async {
    _validate();
    if (_isValid) {
      await withBackendErrorHandlersOnView(() async {
        try {
          setLoading(true);
          await authenticationServices.login(email, password);
        } on AuthenticationServicesError catch (e) {
          DiaMessages.getInstance().showInformation(e.toString());
        } finally {
          setLoading(false);
        }
        if(authenticationServices.isAuthenticated()) {
          DiaNavigation.getInstance().requestScreenChange(DiaScreen.USER_DATA);
        }
      }, unauthorizedToLogin: false);
    }
  }

  void notHaveAccount() {
    DiaNavigation.getInstance().requestScreenChange(DiaScreen.SIGNUP);
  }

}
