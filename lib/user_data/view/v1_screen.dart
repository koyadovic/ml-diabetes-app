import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/timeline/v1_view.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaRootScreenStatefulWidget {
  UserDataScreenWidgetState _state;

  UserDataScreenWidget(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  bool hasAppBar() {
    return true;
  }

  @override
  List<Widget> getAppBarActions() {
    return [];
  }

  @override
  List<Tab> getAppBarTabs() {
    return [
      Tab(icon: Icon(Icons.directions_car)),
    ];
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Timeline(widget.navigation, widget.messages),
      ],
    );
  }

}
