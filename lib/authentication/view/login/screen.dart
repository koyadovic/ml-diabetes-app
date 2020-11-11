import 'package:Dia/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';
import 'view_model.dart';
import 'package:easy_localization/easy_localization.dart';


// ignore: must_be_immutable
class LoginScreenWidget extends DiaRootScreenStatefulWidget {
  LoginScreenWidgetState _state;

  LoginScreenWidget(ShowWidget showWidget, HideWidget hideWidget) : super(showWidget: showWidget, hideWidget: hideWidget);

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            TextField(
              onChanged: (String value) { _viewModel.email = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Email'.tr()
              ),
            ),
            Text(_viewModel.emailError, style: TextStyle(color: Colors.red)),
            TextField(
              onChanged: (String value) { _viewModel.password = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password'.tr(),
              ),
              obscureText: true,
            ),
            Text(_viewModel.passwordError, style: TextStyle(color: Colors.red)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Login'.tr()),
                  onPressed: () {
                    // hide keyboard
                    FocusScope.of(context).unfocus();
                    _viewModel.login();
                  },
                ),
              ],
            ),
            if(_viewModel.isLoading())
              Center(child: CircularProgressIndicator()),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text('I have no account yet'.tr()),
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
