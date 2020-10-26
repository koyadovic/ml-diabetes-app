import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:flutter/material.dart';

class Graphs extends DiaChildScreenStatefulWidget {
  Graphs(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GraphsState();
  }
}

class GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    return Text('Graphs');
  }
}