import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/model/entities/glucose.dart';
import 'package:flutter/material.dart';

class GlucoseLevelEditorWidget extends StatefulWidget {
  final GlucoseLevel glucoseLevelForEdition;
  final Function() onFinish;

  GlucoseLevelEditorWidget({this.onFinish, this.glucoseLevelForEdition});

  @override
  State<StatefulWidget> createState() {
    return GlucoseLevelEditorWidgetState();
  }
}


class GlucoseLevelEditorWidgetState extends State<GlucoseLevelEditorWidget> {
  TextEditingController _externalController;
  GlucoseLevel _glucoseLevel;

  @override
  void initState() {
    if(widget.glucoseLevelForEdition != null) {
      _glucoseLevel = widget.glucoseLevelForEdition;
    } else {
      _glucoseLevel = GlucoseLevel(eventDate: DateTime.now());
    }
    _externalController = TextEditingController(text: _glucoseLevel.level.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UnitTextField(
                externalController: _externalController,
                unit: 'mg/dL',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                autoFocus: false,
                onChange: (value) {
                  _glucoseLevel.level = value.toInt();
                  setState(() {
                    _glucoseLevel.validate();
                  });
                }
              ),
              if(editable)
              ...[
                Spacer(),
                if(_glucoseLevel.hasChanged)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    _glucoseLevel.reset();
                    _externalController.text = _glucoseLevel.level.toString();
                    setState(() {
                      _glucoseLevel.validate();
                    });
                  },
                ),
              ]
            ],
          ),
          if(!_glucoseLevel.isValid)
            Column(
              children: [
                Text(_glucoseLevel.getFullValidationText(includePropertyNames: false), style: TextStyle(color: enabled ? Colors.red : Colors.grey)),
              ],
            )
        ],
      ),

    );
  }
}