import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';


class Timeline extends DiaChildScreenStatefulWidget {

  Timeline(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  State<StatefulWidget> createState() {
    return TimelineState();
  }

}


class TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Text('Timeline');
  }
}
