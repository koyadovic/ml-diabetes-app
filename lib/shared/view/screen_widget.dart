import 'package:flutter/material.dart';

typedef ShowWidgetCallback = void Function(Widget w);


abstract class DiaRootScreenStatefulWidget extends StatefulWidget {
  final ShowWidgetCallback showWidgetCallback;

  DiaRootScreenStatefulWidget({this.showWidgetCallback});

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
  DiaChildScreenStatefulWidget();
}
