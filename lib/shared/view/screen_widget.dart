import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';

abstract class DiaScreenStatefulWidget extends StatefulWidget {
  final Function(DiaScreen) requestScreenChange;

  DiaScreenStatefulWidget(this.requestScreenChange);

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

  Widget getFloatingActionButton() {
    return null;
  }

  bool hasDrawer() {
    return false;
  }

}
