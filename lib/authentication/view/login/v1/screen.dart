// ignore: must_be_immutable
import 'package:Dia/authentication/view/signup/v1/screen.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';

import '../view_model.dart';


class LoginScreenWidget extends DiaScreenStatefulWidget {
  LoginScreenWidgetState _state;

  LoginScreenWidget(Function(DiaScreen) requestScreenChange) : super(requestScreenChange);

  @override
  State<StatefulWidget> createState() {
    _state = LoginScreenWidgetState();
    return _state;
  }

}

class LoginScreenWidgetState extends State<LoginScreenWidget> {

  LoginViewModel _viewModel;

  @override
  void initState() {
    _viewModel = LoginViewModel(this);
    _viewModel.addOnChangeListener(() {
      print('onViewModelChange');
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (String value) { _viewModel.email = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Email'
              ),
            ),
            TextField(
              onChanged: (String value) { _viewModel.password = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {
                _viewModel.login();
              },
            ),
            FlatButton(
              child: Text('I have no account yet'),
              onPressed: () {
                widget.requestScreenChange(DiaScreen.SIGNUP);
              },
            )
          ],
        ),
      ),
    );
  }

}
