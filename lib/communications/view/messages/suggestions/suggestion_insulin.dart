import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:Dia/user_data/view/shared/insulin_injection_editor.dart';
import 'package:flutter/material.dart';

class InsulinSuggestionWidget extends StatefulWidget {
  final Suggestion suggestion;
  final bool isIgnored;

  InsulinSuggestionWidget(this.suggestion, this.isIgnored);

  @override
  State<StatefulWidget> createState() {
    return InsulinSuggestionWidgetState();
  }
}

class InsulinSuggestionWidgetState extends State<InsulinSuggestionWidget> {
  TextEditingController _controller;
  InsulinInjection _insulinInjection;

  @override
  void initState() {
    _insulinInjection = widget.suggestion.userDataEntity as InsulinInjection;
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(widget.suggestion.details, style: TextStyle(color: !enabled ? Colors.grey : Colors.black)),
        ),
        InsulinInjectionEditorWidget(
          insulinTypes: [_insulinInjection.insulinType],
          insulinInjectionForEdition: _insulinInjection,
          onFinish: () {},
        ),
      ],
    );
  }
}
