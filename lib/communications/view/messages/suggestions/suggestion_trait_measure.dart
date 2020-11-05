import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/user_data/model/entities/traits.dart';
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
    TraitMeasure traitMeasure = widget.suggestion.userDataEntity as TraitMeasure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(widget.suggestion.details),
        ),
        TraitMeasureEditorWidget(
          traitTypes: [traitMeasure.traitType],
          traitMeasureForEdition: traitMeasure,
          onFinish: () {},
        ),
      ],
    );
  }
}
