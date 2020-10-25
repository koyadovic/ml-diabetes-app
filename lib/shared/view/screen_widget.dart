import 'package:flutter/material.dart';

import 'messages.dart';
import 'navigation.dart';

abstract class DiaRootScreenStatefulWidget extends StatefulWidget {
  final Navigation navigation;
  final Messages messages;

  DiaRootScreenStatefulWidget(this.navigation, this.messages);

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
  final Navigation navigation;
  final Messages messages;

  DiaChildScreenStatefulWidget(this.navigation, this.messages);

}