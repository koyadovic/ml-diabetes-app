import 'package:flutter/material.dart';

class ParentEditorWidget extends StatelessWidget {
  final Widget child;
  final List<MaterialButton> actionButtons;

  ParentEditorWidget({this.child, this.actionButtons});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        child,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actionButtons,
        )
      ],
    );
  }
}