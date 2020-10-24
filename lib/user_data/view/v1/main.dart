import 'package:Dia/shared/view/dia_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';


class UserDataScreenWidget extends StatefulWidget implements DiaScreenStatefulWidget {
  State<StatefulWidget> _state;

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

  @override
  Widget build(BuildContext context) {
    return Text('UserDataScreenWidget');
  }

}
