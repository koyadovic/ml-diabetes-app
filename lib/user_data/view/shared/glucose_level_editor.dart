import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class GlucoseLevelEditorWidget extends StatefulWidget {
  final GlucoseLevel glucoseLevelForEdition;
  final Function(bool, [GlucoseLevel glucoseLevel]) selfCloseCallback;

  GlucoseLevelEditorWidget({this.selfCloseCallback, this.glucoseLevelForEdition});

  @override
  State<StatefulWidget> createState() {
    return GlucoseLevelEditorWidgetState();
  }
}


class GlucoseLevelEditorWidgetState extends State<GlucoseLevelEditorWidget> {
  GlucoseLevel _glucoseLevel;

  @override
  void initState() {
    if(widget.glucoseLevelForEdition != null) {
      _glucoseLevel = widget.glucoseLevelForEdition;
    } else {
      _glucoseLevel = GlucoseLevel(eventDate: DateTime.now());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          UnitTextField(
            unit: 'mg/dL',
            processors: [
              (value) => value < 0.0 ? 0.0 : value,
              (value) => value > 600 ? 600.0 : value,
            ],
            autoFocus: true,
            onChange: (value) {
              setState(() {
                _glucoseLevel.level = value.toInt();
              });
            }
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: enabled ? DiaTheme.secondaryColor : Colors.grey),
            onPressed: () {
              _glucoseLevel.reset();
              widget.selfCloseCallback(false);
            },
          ),
          IconButton(
            icon: Icon(Icons.done, color: !enabled || !_glucoseLevel.hasChanged ? Colors.grey : DiaTheme.primaryColor),
            onPressed: !enabled || !_glucoseLevel.hasChanged ? null : () async {
              widget.selfCloseCallback(true, _glucoseLevel);
            },
          ),
        ],
      ),
    );
  }
}