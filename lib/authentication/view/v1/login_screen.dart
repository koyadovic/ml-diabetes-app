// ignore: must_be_immutable
import 'package:Dia/shared/view/dia_screen_widget.dart';
import 'package:flutter/material.dart';

import '../login_view_model.dart';


class LoginScreenWidget extends DiaScreenStatefulWidget {
  LoginScreenWidgetState _state;

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
          ],
        ),
      ),
    );
  }

}
