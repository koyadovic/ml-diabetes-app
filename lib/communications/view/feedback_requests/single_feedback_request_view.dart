import 'package:Dia/communications/model/entities.dart';
import 'package:flutter/material.dart';

// TODO queda terminarlo
class FeedbackRequestWidget extends StatefulWidget {
  final FeedbackRequest request;
  final Function onDismiss;

  FeedbackRequestWidget({@required this.request, @required this.onDismiss});

  @override
  State<StatefulWidget> createState() {
    return FeedbackRequestWidgetState();
  }
}


class FeedbackRequestWidgetState extends State<FeedbackRequestWidget> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
