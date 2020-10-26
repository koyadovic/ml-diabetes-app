import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:flutter/material.dart';

class Summary extends DiaChildScreenStatefulWidget {
  Summary(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  State<StatefulWidget> createState() {
    return SummaryState();
  }
}


class SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Text('Summary');
  }
}