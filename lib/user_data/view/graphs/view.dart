import 'package:iDietFit/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';

class Graphs extends DiaChildScreenStatefulWidget {
  Graphs(DiaRootScreenStatefulWidget root) : super(root);

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
