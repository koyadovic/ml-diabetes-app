import 'dart:ui';

import 'package:iDietFit/shared/view/screen_widget.dart';
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
                  selectionHeightStyle: BoxHeightStyle.tight,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email'.tr(),
                    isDense: true,
                  ),
                ),
                Text(_viewModel.emailError, style: TextStyle(color: Colors.red)),
                TextField(
                  onChanged: (String value) { _viewModel.password = value; },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password'.tr(),
                    isDense: true,
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
                SizedBox(height: 20),
                // TODO this is disabled by now
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     FlatButton(
                //       child: Text('I have no account yet'.tr()),
                //       onPressed: () {
                //         _viewModel.notHaveAccount();
                //       },
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
