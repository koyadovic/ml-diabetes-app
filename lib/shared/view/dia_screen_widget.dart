import 'package:flutter/material.dart';

abstract class DiaScreenStatefulWidget extends StatefulWidget {
  List<Widget> getAppBarActions() {
    throw UnimplementedError();
  }

  Widget getFloatingActionButton() {
    throw UnimplementedError();
  }

  bool hasDrawer() {
    throw UnimplementedError();
  }

  bool hasAppBar() {
    throw UnimplementedError();
  }

}
