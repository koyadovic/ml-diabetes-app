import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'view_model.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaScreenStatefulWidget {
  UserDataScreenWidgetState _state;

  UserDataScreenWidget(Function(DiaScreen) requestScreenChange) : super(requestScreenChange);

  @override
  bool hasAppBar() {
    return true;
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
    _state = UserDataScreenWidgetState();
    return _state;
  }

}


class UserDataScreenWidgetState extends State<UserDataScreenWidget> {

  UserDataViewModel _viewModel;

  @override
  void initState() {
    _viewModel = UserDataViewModel(this, this.widget.requestScreenChange);
    _viewModel.addOnChangeListener(onViewModelChange);
    super.initState();
  }

  onViewModelChange() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('UserDataScreenWidget');
  }

}
