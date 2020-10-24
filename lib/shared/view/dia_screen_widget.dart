import 'package:flutter/material.dart';

abstract class DiaScreenStatefulWidget extends StatefulWidget {

  bool hasAppBar() {
    throw UnimplementedError();
  }

  String getAppBarTitle() {
    // ignored if hasAppBar() returns false
    throw UnimplementedError();
  }

  List<Widget> getAppBarActions() {
    // ignored if hasAppBar() returns false
    throw UnimplementedError();
  }

  Widget getFloatingActionButton() {
    throw UnimplementedError();
  }

  bool hasDrawer() {
    throw UnimplementedError();
  }

}
