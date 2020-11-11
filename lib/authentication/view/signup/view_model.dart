import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class SignUpViewModel extends DiaViewModel {
  final _emailPattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String _email = '';
  String _password1 = '';
  String _password2 = '';

  String _emailError = '';
  String _password1Error = '';
  String _password2Error = '';

  bool _isValid;

  final AuthenticationServices authenticationServices = AuthenticationServices();

  SignUpViewModel(State state) : super(state);

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

  set password1(String password) {
    _password1 = password;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get password1 {
    return _password1;
  }

  String get password1Error {
    return _password1Error;
  }

  set password2(String password) {
    _password2 = password;
    if(_isValid != null) _validate();
    notifyChanges();
  }

  String get password2 {
    return _password2;
  }

  String get password2Error {
    return _password2Error;
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

    if(_password1.length < 8) {
      _password1Error = 'Error minimum length is 8 characters'.tr();
      isValid = false;
    } else {
      _password1Error = '';
      isValid = isValid && true;
    }

    if(_password2.length < 8) {
      _password2Error = 'Error minimum length is 8 characters'.tr();
      isValid = false;
    } else {
      _password2Error = '';
      isValid = isValid && true;
    }

    if(_password1 != _password2) {
      _password2Error = 'Passwords does not match'.tr();
      isValid = false;
    } else {
      _password2Error = '';
      isValid = isValid && true;
    }

    _isValid = isValid;
    notifyChanges();
  }

  Future<void> signUp() async {
    _validate();
    if (_isValid) {
      await withBackendErrorHandlersOnView(() async {
        try {
          setLoading(true);
          await authenticationServices.signUp(_email, _password1);
          DiaMessages.getInstance().showInformation('Account created successfully'.tr());
          DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
        } on AuthenticationServicesError catch (e) {
          DiaMessages.getInstance().showInformation(e.toString());
        }
        finally {
          setLoading(false);
        }
      });
    }
  }

}
