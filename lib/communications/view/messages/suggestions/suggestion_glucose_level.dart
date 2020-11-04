import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:Dia/user_data/view/shared/glucose_level_editor.dart';
import 'package:Dia/user_data/view/shared/insulin_injection_editor.dart';
import 'package:flutter/material.dart';

class GlucoseLevelSuggestionWidget extends StatefulWidget {
  final Suggestion suggestion;
  final bool isIgnored;

  GlucoseLevelSuggestionWidget(this.suggestion, this.isIgnored);

  @override
  State<StatefulWidget> createState() {
    return GlucoseLevelSuggestionWidgetState();
  }
}

class GlucoseLevelSuggestionWidgetState extends State<GlucoseLevelSuggestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(widget.suggestion.details),
        ),
        GlucoseLevelEditorWidget(
          glucoseLevelForEdition: widget.suggestion.userDataEntity as GlucoseLevel,
          selfCloseCallback: (reload, [glucoseLevel]) {

          },
        ),
      ],
    );
  }
}
