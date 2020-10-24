// ignore: must_be_immutable
import 'package:Dia/shared/view/dia_screen_widget.dart';
import 'package:flutter/material.dart';

import '../login_view_model.dart';


class LoginScreenWidget extends StatefulWidget implements DiaScreenStatefulWidget {
  LoginScreenWidgetState _state;

  @override
  bool hasAppBar() {
    return false;
  }

  @override
  List<Widget> getAppBarActions() {
    return [];
  }

  @override
  Widget getFloatingActionButton() {
    return null;
  }

  @override
  bool hasDrawer() {
    return true;
  }

  @override
  String getAppBarTitle() {
    return 'User Data';
  }

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
    _viewModel.addOnChangeListener(onViewModelChange);
    super.initState();
  }

  onViewModelChange() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('LoginScreenWidget');
  }

}
