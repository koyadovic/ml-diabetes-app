// ignore: must_be_immutable
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';

import '../view_model.dart';


// ignore: must_be_immutable
class SignupScreenWidget extends DiaScreenStatefulWidget {
  SignupScreenWidgetState _state;

  SignupScreenWidget(Function(DiaScreen) requestScreenChange) : super(requestScreenChange);

  @override
  State<StatefulWidget> createState() {
    _state = SignupScreenWidgetState();
    return _state;
  }

}

class SignupScreenWidgetState extends State<SignupScreenWidget> {

  SignupViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SignupViewModel(this);
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
              onChanged: (String value) { _viewModel.password1 = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              onChanged: (String value) { _viewModel.password2 = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Repeat Password',
              ),
              obscureText: true,
            ),
            RaisedButton(
              child: Text('Signup'),
              onPressed: () {
                _viewModel.signup();
              },
            ),
          ],
        ),
      ),
    );
  }

}
