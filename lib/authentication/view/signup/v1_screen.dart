import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';
import 'view_model.dart';


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
    _viewModel = SignupViewModel(this, this.widget.requestScreenChange);
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
              onChanged: (String value) { _viewModel.password1 = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            Text(_viewModel.password1Error, style: TextStyle(color: Colors.red)),

            TextField(
              onChanged: (String value) { _viewModel.password2 = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Repeat Password',
              ),
              obscureText: true,
            ),
            Text(_viewModel.password2Error, style: TextStyle(color: Colors.red)),

            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Signup'),
                  onPressed: () {
                    _viewModel.signUp();
                  },
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text('I already have an account'),
                  onPressed: () {
                    widget.requestScreenChange(DiaScreen.LOGIN);
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
