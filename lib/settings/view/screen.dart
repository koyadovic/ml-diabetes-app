import 'package:Dia/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsScreenWidget extends DiaRootScreenStatefulWidget {
  SettingsScreenWidgetState _state;

  SettingsScreenWidget(ShowWidget showWidget, HideWidget hideWidget) : super(showWidget: showWidget, hideWidget: hideWidget);

  @override
  bool hasAppBar() {
    return true;
  }

  @override
  bool hasDrawer() {
    return true;
  }

  @override
  String getAppBarTitle() {
    return 'Settings';
  }

  @override
  List<Widget> getAppBarActions() {
    return [];
  }

  @override
  State<StatefulWidget> createState() {
    _state = SettingsScreenWidgetState();
    return _state;
  }

}


class SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Text('Settings');
  }
}
