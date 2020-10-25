import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';
import 'view_model.dart';


// ignore: must_be_immutable
class LoginScreenWidget extends DiaScreenStatefulWidget {
  LoginScreenWidgetState _state;

  LoginScreenWidget(Navigation navigation, Messages messages) : super(navigation, messages);

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
    _viewModel = LoginViewModel(this, widget.navigation, widget.messages);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            TextField(
              onChanged: (String value) { _viewModel.email = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Email'
              ),
            ),
            Text(_viewModel.emailError, style: TextStyle(color: Colors.red)),
            TextField(
              onChanged: (String value) { _viewModel.password = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            Text(_viewModel.passwordError, style: TextStyle(color: Colors.red)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    _viewModel.login();
                  },
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text('I have no account yet'),
                  onPressed: () {
                    _viewModel.notHaveAccount();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
