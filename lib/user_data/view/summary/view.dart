import 'package:Dia/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';

class Summary extends DiaChildScreenStatefulWidget {
  Summary(DiaRootScreenStatefulWidget root) : super(root);

  @override
  State<StatefulWidget> createState() {
    return SummaryState();
  }
}


class SummaryState extends State<Summary> with AutomaticKeepAliveClientMixin<Summary> {
  @override
  Widget build(BuildContext context) {
    return Text('Summary');
  }

  @override
  bool get wantKeepAlive => true;
}