import 'package:iDietFit/shared/view/theme.dart';
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
      child: Center(
        child: Container(
          width: 300,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return false;
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 50.0),
                  child: Center(child: Image.asset('assets/images/logo.png', width: 150)),
                ),

                TextField(
                  onChanged: (String value) { _viewModel.email = value; },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email'.tr(),
                    isDense: true,
                  ),
                ),
                Text(_viewModel.emailError, style: TextStyle(color: Colors.red)),

                TextField(
                  onChanged: (String value) { _viewModel.password1 = value; },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password'.tr(),
                    isDense: true,
                  ),
                  obscureText: true,
                ),
                Text(_viewModel.password1Error, style: TextStyle(color: Colors.red)),

                TextField(
                  onChanged: (String value) { _viewModel.password2 = value; },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Repeat Password'.tr(),
                    isDense: true,
                  ),
                  obscureText: true,
                ),
                Text(_viewModel.password2Error, style: TextStyle(color: Colors.red)),

                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                        elevation: 3,
                        color: DiaTheme.primaryColor,
                        child: Text('Signup'.tr(), style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          // hide keyboard
                          FocusScope.of(context).unfocus();
                          _viewModel.signUp();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text('I already have an account'.tr(), style: TextStyle(color: DiaTheme.primaryColor)),
                      onPressed: () {
                        DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
