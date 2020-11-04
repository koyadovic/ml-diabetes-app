import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:Dia/user_data/view/shared/insulin_injection_editor.dart';
import 'package:Dia/user_data/view/shared/trait_measure_editor.dart';
import 'package:flutter/material.dart';


class TraitMeasureSuggestionWidget extends StatefulWidget {
  final Suggestion suggestion;
  final bool isIgnored;

  TraitMeasureSuggestionWidget(this.suggestion, this.isIgnored);

  @override
  State<StatefulWidget> createState() {
    return TraitMeasureSuggestionWidgetState();
  }
}

class TraitMeasureSuggestionWidgetState extends State<TraitMeasureSuggestionWidget> {

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(widget.suggestion.details),
        ),
        TraitMeasureEditorWidget(
          traitMeasureForEdition: widget.suggestion.userDataEntity as TraitMeasure,
          selfCloseCallback: () {},
        ),
      ],
    );
  }
}
