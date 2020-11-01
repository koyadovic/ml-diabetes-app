import 'package:flutter/material.dart';


typedef ShowWidget = Future<void> Function(Widget w);
typedef HideWidget = Future<void> Function();


abstract class DiaRootScreenStatefulWidget extends StatefulWidget {
  final ShowWidget showWidget;
  final HideWidget hideWidget;

  DiaRootScreenStatefulWidget({
    @required this.showWidget,
    @required this.hideWidget
  });

  bool hasAppBar() {
    return false;
  }

  String getAppBarTitle() {
    // ignored if hasAppBar() returns false
    return '';
  }

  List<Widget> getAppBarActions() {
    // ignored if hasAppBar() returns false
    return [];
  }

  List<Tab> getAppBarTabs() {
    // ignored if hasAppBar() returns false
    // if returns List<Tab>, the build method of the Widget must return a TabBarView
    return null;
  }

  Widget getFloatingActionButton() {
    return null;
  }

  bool hasDrawer() {
    return false;
  }

}


abstract class DiaChildScreenStatefulWidget extends StatefulWidget {
  final DiaRootScreenStatefulWidget diaRootScreen;
  DiaChildScreenStatefulWidget(this.diaRootScreen);

  void refresh() {}
}
