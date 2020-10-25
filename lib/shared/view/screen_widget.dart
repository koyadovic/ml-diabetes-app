import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';

import 'messages.dart';
import 'navigation.dart';

abstract class DiaScreenStatefulWidget extends StatefulWidget {
  final Navigation navigation;
  final Messages messages;

  DiaScreenStatefulWidget(this.navigation, this.messages);

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
