import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/timeline/view_model.dart';
import 'package:flutter/material.dart';


class Timeline extends DiaChildScreenStatefulWidget {

  Timeline(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  State<StatefulWidget> createState() {
    return TimelineState();
  }

}


class TimelineState extends State<Timeline> {

  TimelineViewModel _viewModel;

  @override
  void initState() {
    _viewModel = TimelineViewModel(this, widget.navigation, widget.messages);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (_viewModel != null)
          ..._viewModel.entries.map((entry) => Text(entry.text))
      ],
    );
  }
}
