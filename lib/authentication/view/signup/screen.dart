import 'package:iDietFit/shared/view/utils/navigation.dart';
import 'package:iDietFit/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';
import 'view_model.dart';
import 'package:easy_localization/easy_localization.dart';


// ignore: must_be_immutable
class SignupScreenWidget extends DiaRootScreenStatefulWidget {
  SignupScreenWidgetState _state;

  SignupScreenWidget(ShowWidget showWidget, HideWidget hideWidget) : super(showWidget: showWidget, hideWidget: hideWidget);

  @override
  State<StatefulWidget> createState() {
    _state = SignupScreenWidgetState();
    return _state;
  }

}

class SignupScreenWidgetState extends State<SignupScreenWidget> {

  SignUpViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SignUpViewModel(this);
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
                hintText: 'Email'.tr()
              ),
            ),
            Text(_viewModel.emailError, style: TextStyle(color: Colors.red)),

            TextField(
              onChanged: (String value) { _viewModel.password1 = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password'.tr(),
              ),
              obscureText: true,
            ),
            Text(_viewModel.password1Error, style: TextStyle(color: Colors.red)),

            TextField(
              onChanged: (String value) { _viewModel.password2 = value; },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Repeat Password'.tr(),
              ),
              obscureText: true,
            ),
            Text(_viewModel.password2Error, style: TextStyle(color: Colors.red)),

            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Signup'.tr()),
                  onPressed: () {
                    // hide keyboard
                    FocusScope.of(context).unfocus();
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
                  child: Text('I already have an account'.tr()),
                  onPressed: () {
                    DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
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
