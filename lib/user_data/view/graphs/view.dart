import 'package:Dia/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';

class Graphs extends DiaChildScreenStatefulWidget {
  // Graphs() : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GraphsState();
  }
}

class GraphsState extends State<Graphs> with AutomaticKeepAliveClientMixin<Graphs> {
  @override
  Widget build(BuildContext context) {
    return Text('Graphs');
  }

  @override
  bool get wantKeepAlive => true;
}
