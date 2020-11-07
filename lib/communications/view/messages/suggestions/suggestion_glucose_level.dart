import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/user_data/model/entities/glucose.dart';
import 'package:Dia/user_data/view/shared/glucose_level_editor.dart';
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
    bool enabled = EnabledStatus.of(context);

    GlucoseLevel glucoseLevel = widget.suggestion.userDataEntity as GlucoseLevel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            widget.suggestion.details,
            softWrap: true,
            style: TextStyle(color: !enabled ? Colors.grey : Colors.black, fontSize: mediumSize(context))
          ),
        ),
        GlucoseLevelEditorWidget(
          glucoseLevelForEdition: glucoseLevel,
          onFinish: () {},
        ),
      ],
    );
  }
}
